#!/usr/bin/env python3
import json
import os
import subprocess
import urllib.request
import urllib.error
from datetime import datetime
from pathlib import Path


STATUS_TIMEOUT_SEC = 4
COLLECTOR_URL = os.environ.get("COLLECTOR_URL", "http://127.0.0.1:3001")
DEFAULT_ROOT = Path("/home/chaji/src/pocket-chrome-extension")
STATE_FILE = Path(os.environ.get("XDG_RUNTIME_DIR", "/tmp")) / "pocket-monitor-state.json"
# tick count가 이전 폴링 대비 증가하면 수집 활성
# 3회 연속 변화 없으면 비활성으로 판단 (일시적 갭 허용)
STALE_MISS_LIMIT = 3


def _load_state() -> dict:
    try:
        return json.loads(STATE_FILE.read_text())
    except Exception:
        return {}


def _save_state(state: dict) -> None:
    try:
        STATE_FILE.write_text(json.dumps(state))
    except Exception:
        pass


def find_project_root() -> Path | None:
    env_root = os.environ.get("POCKET_PROJECT_ROOT", "").strip()
    if env_root:
        candidate = Path(env_root).expanduser()
        if (candidate / "scripts/forward.sh").is_file():
            return candidate

    if (DEFAULT_ROOT / "scripts/forward.sh").is_file():
        return DEFAULT_ROOT

    return None


def run_forward_status(project_root: Path) -> dict:
    proc = subprocess.run(
        ["bash", "scripts/forward.sh", "status", "--json"],
        cwd=project_root,
        capture_output=True,
        text=True,
        timeout=STATUS_TIMEOUT_SEC,
        check=False,
    )
    if proc.returncode != 0:
        stderr = (proc.stderr or "").strip()
        raise RuntimeError(stderr or f"forward.sh exited with {proc.returncode}")

    return json.loads(proc.stdout)


def bool_label(value: bool, true_label: str, false_label: str) -> str:
    return true_label if value else false_label


def fetch_dashboard_status() -> dict:
    """Collector control API에서 kill-switch, FT 상태, DB 통계를 가져온다."""
    result = {"api_ok": False, "kill_switch": False, "ft_running": False, "ft_status": None, "db_stats": None}
    try:
        req = urllib.request.Request(f"{COLLECTOR_URL}/api/ctl/kill-switch/state", method="GET")
        with urllib.request.urlopen(req, timeout=2) as resp:
            data = json.loads(resp.read())
            result["api_ok"] = True
            result["kill_switch"] = bool(data.get("isHalted"))
    except Exception:
        pass

    try:
        req = urllib.request.Request(f"{COLLECTOR_URL}/api/ctl/ft/status", method="GET")
        with urllib.request.urlopen(req, timeout=2) as resp:
            data = json.loads(resp.read())
            result["api_ok"] = True
            result["ft_running"] = bool(data.get("running"))
            result["ft_status"] = data.get("status")
    except Exception:
        pass

    try:
        req = urllib.request.Request(f"{COLLECTOR_URL}/api/ctl/db/stats", method="GET")
        with urllib.request.urlopen(req, timeout=2) as resp:
            result["db_stats"] = json.loads(resp.read())
    except Exception:
        pass

    return result


def fetch_today_profit(limit: int = 200) -> dict:
    """오늘(로컬 날짜) FT 결과의 순손익 합계를 반환한다."""
    result = {"ok": False, "net_profit": 0.0, "total_trades": 0, "runs": 0}
    try:
        req = urllib.request.Request(f"{COLLECTOR_URL}/api/forward-test/results?limit={limit}", method="GET")
        with urllib.request.urlopen(req, timeout=2) as resp:
            rows = json.loads(resp.read())
            if not isinstance(rows, list):
                return result

            today = datetime.now().date()
            net_profit = 0.0
            total_trades = 0
            runs = 0

            for row in rows:
                if not isinstance(row, dict):
                    continue
                created_at = row.get("created_at")
                if created_at is None:
                    continue
                try:
                    created_ts = int(created_at)
                except Exception:
                    continue

                if datetime.fromtimestamp(created_ts).date() != today:
                    continue

                net_profit += float(row.get("net_profit", 0) or 0)
                total_trades += int(row.get("total_trades", 0) or 0)
                runs += 1

            result.update({"ok": True, "net_profit": net_profit, "total_trades": total_trades, "runs": runs})
    except Exception:
        pass

    return result


def make_payload(status: dict, project_root: Path) -> dict:
    forward = status.get("forward") or {}
    server = status.get("server") or {}
    watch = status.get("watch") or {}
    health = status.get("health") or {}
    latest = status.get("latestResult")
    unsafe = status.get("unsafeBacktestPids") or []
    locks = status.get("locks") or []

    forward_running = bool(forward.get("running"))
    server_running = bool(server.get("running"))
    watch_running = bool(watch.get("running"))
    collector_ok = isinstance(health, dict) and health.get("status") == "ok"

    # Dashboard control API 상태
    dash = fetch_dashboard_status()
    dash_api_ok = dash["api_ok"]
    kill_switch = dash["kill_switch"]
    dash_ft_running = dash["ft_running"]
    today_profit = fetch_today_profit()
    today_net_profit = float(today_profit.get("net_profit", 0) or 0)

    # Worker 실행 힌트: runtime lock/forward pid 기준
    collect_lock_running = any(isinstance(lock, dict) and lock.get("workload") == "collect" for lock in locks)
    forward_lock_running = any(isinstance(lock, dict) and lock.get("workload") == "forward" for lock in locks)
    worker_running = bool(forward_running or collect_lock_running or forward_lock_running)

    # Worker 활성 판단: tick count가 이전 폴링 대비 증가했는지
    # 우선순위: dashboard db_stats -> /health.totalTicks
    worker_active = False
    tick_count = 0
    prev = _load_state()
    if dash.get("db_stats"):
        tick_count = dash["db_stats"].get("ticks", {}).get("count", 0)
    elif isinstance(health, dict):
        tick_count = int(health.get("totalTicks") or 0)
    prev_tick_count = prev.get("tick_count", 0)
    miss_count = prev.get("miss_count", 0)

    if tick_count > prev_tick_count:
        worker_active = True
        miss_count = 0
    else:
        miss_count = miss_count + 1
        # STALE_MISS_LIMIT 이내면 아직 활성으로 간주 (일시적 갭 허용)
        worker_active = miss_count < STALE_MISS_LIMIT

    _save_state({"tick_count": tick_count, "miss_count": miss_count})

    # tick 변화가 없어도 프로세스가 살아있으면 즉시 down으로 보지 않는다.
    worker_ok = bool(worker_active or worker_running)

    # Kill switch가 활성이면 최우선 critical
    if kill_switch:
        css_class = "critical"
        overall = "HALTED"
    elif forward_running and worker_ok and watch_running:
        css_class = "ok"
        overall = "RUNNING"
    elif forward_running and worker_ok:
        css_class = "warn"
        overall = "RUNNING (watch off)"
    elif forward_running and not worker_ok:
        css_class = "critical"
        overall = "FORWARD ONLY (no ticks)"
    elif worker_ok and not forward_running:
        css_class = "warn"
        overall = "COLLECTOR ONLY"
    elif collector_ok and not worker_ok:
        css_class = "warn"
        overall = "SERVER ONLY (no ticks)"
    elif server_running or forward_running or watch_running:
        css_class = "warn"
        overall = "PARTIAL"
    else:
        css_class = "critical"
        overall = "DOWN"

    # tick delta 표시용
    tick_delta = tick_count - prev_tick_count if prev_tick_count > 0 else 0

    # 텍스트 구성
    parts = ["PO"]
    if kill_switch:
        parts.append("HALT")
    parts.append(f"FT:{bool_label(forward_running or dash_ft_running, 'on', 'off')}")
    parts.append(f"COL:{bool_label(worker_ok, 'ok', 'down')}")
    parts.append(f"API:{bool_label(dash_api_ok, 'ok', 'off')}")
    parts.append(f"TOD:{today_net_profit:+.2f}")
    parts.append(f"TG:{bool_label(watch_running, 'on', 'off')}")
    text = " ".join(parts)

    tooltip = [
        f"Pocket Monitor: {overall}",
        "",
        f"Forward  : {bool_label(forward_running, 'running', 'stopped')} (pid={forward.get('pid', 'n/a')})",
        f"Worker   : {bool_label(worker_running, 'running', 'stopped')} / "
        f"{bool_label(worker_active, 'active', 'idle')} (+{tick_delta} ticks/poll, miss={miss_count})",
        f"Server   : {bool_label(collector_ok, 'healthy', 'down')} (pid={server.get('pid', 'n/a')})",
        f"Watch    : {bool_label(watch_running, 'running', 'stopped')} (pid={watch.get('pid', 'n/a')})",
        f"Ctrl API : {bool_label(dash_api_ok, 'online', 'offline')}",
        f"Kill SW  : {bool_label(kill_switch, 'HALTED', 'normal')}",
        f"Today P/L: ${today_net_profit:+.2f} "
        f"(runs={today_profit.get('runs', 0)}, trades={today_profit.get('total_trades', 0)})",
    ]

    if dash_ft_running and dash["ft_status"]:
        st = dash["ft_status"]
        tooltip.append(f"Dash FT  : running (WR={st.get('winRate', 0):.1f}%, trades={st.get('totalTrades', 0)})")

    if isinstance(health, dict) and health:
        ticks = health.get("totalTicks", "n/a")
        candles = health.get("totalCandles1m", "n/a")
        tooltip.append(f"Data     : ticks={ticks}, candles_1m={candles}")

    if dash.get("db_stats"):
        db = dash["db_stats"]
        ticks_count = db.get("ticks", {}).get("count", "n/a")
        candles_count = db.get("candles_1m", {}).get("count", "n/a")
        tooltip.append(f"DB       : ticks={ticks_count}, candles_1m={candles_count}")

    if latest:
        tooltip.append(f"Latest   : {latest}")

    if unsafe:
        tooltip.append("Unsafe backtest pids: " + ", ".join(str(x) for x in unsafe))

    if locks:
        tooltip.append(f"Active locks: {len(locks)}")

    tooltip.append(f"Dashboard: {COLLECTOR_URL}/dashboard")
    tooltip.append(f"Root     : {project_root}")
    tooltip.append(f"Updated  : {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")

    return {"text": text, "tooltip": "\n".join(tooltip), "class": css_class}


def main() -> None:
    project_root = find_project_root()
    if not project_root:
        print(
            json.dumps(
                {
                    "text": "PO unavailable",
                    "tooltip": "forward.sh not found. Set POCKET_PROJECT_ROOT if needed.",
                    "class": "error",
                }
            )
        )
        return

    try:
        status = run_forward_status(project_root)
        print(json.dumps(make_payload(status, project_root)))
    except Exception as exc:
        print(
            json.dumps(
                {
                    "text": "PO error",
                    "tooltip": f"{type(exc).__name__}: {exc}",
                    "class": "error",
                }
            )
        )


if __name__ == "__main__":
    main()
