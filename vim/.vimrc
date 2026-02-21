" ─── 기본 설정 ───
set nocompatible
set encoding=utf-8
set fileencoding=utf-8

" ─── UI ───
set number
set relativenumber
set cursorline
set showcmd
set showmode
set wildmenu
set laststatus=2
set signcolumn=yes
set scrolloff=8
set sidescrolloff=8

" ─── 검색 ───
set hlsearch
set incsearch
set ignorecase
set smartcase

" ─── 들여쓰기 ───
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set smartindent
set autoindent

" ─── 동작 ───
set backspace=indent,eol,start
set mouse=a
set clipboard=unnamedplus
set hidden
set updatetime=300
set timeoutlen=500

" ─── 파일 ───
set noswapfile
set nobackup
set nowritebackup
set undofile
set undodir=~/.vim/undodir

" ─── 테마 ───
syntax on
set termguicolors
set background=dark

" ─── 키바인딩 ───
let mapleader = " "

" 윈도우 이동
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" 인덴트 유지
vnoremap < <gv
vnoremap > >gv

" 검색 하이라이트 해제
nnoremap <leader>h :nohlsearch<CR>

" 버퍼 이동
nnoremap <S-h> :bprevious<CR>
nnoremap <S-l> :bnext<CR>
