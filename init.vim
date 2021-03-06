" vim-plug settings
call plug#begin('~/.vim/plugged')

" Installed addons
Plug 'chriskempson/base16-vim'
Plug 'airblade/vim-gitgutter'
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'Shougo/vimfiler.vim'
Plug 'jeffkreeftmeijer/vim-numbertoggle'
Plug 'mattn/emmet-vim'
Plug 'Lokaltog/vim-easymotion'
Plug 'raimondi/delimitMate'
Plug 'tmux-plugins/vim-tmux'
Plug 'christoomey/vim-tmux-navigator'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-endwise'
Plug 'othree/yajs.vim'
Plug 'gerw/vim-HiLinkTrace'
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
Plug 'neomake/neomake'
Plug 'Shougo/denite.nvim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'fatih/vim-go'


call plug#end()

" General settings
set shell=/usr/local/bin/fish
imap jk <Esc>
set termguicolors
set lazyredraw
set mouse=a
set mousehide
set showcmd
set complete-=i
set smarttab
scriptencoding utf-8
set shortmess+=filmnrxoOtT
set viewoptions=folds,options,cursor,unix,slash
set virtualedit=onemore
set history=1000
set spell
set hidden
set iskeyword-=.
set iskeyword-=#
set iskeyword-=-
set nrformats-=octal
set autoread
set fileformats+=mac
set wildignore+=*/tmp/*,*.so,*.swp,*.zip

set backup
set backupdir=~/.vim/backup
set dir=~/.vim/swap
set clipboard=unnamed

set ttimeout
set ttimeoutlen=100

" Useful defaults
" Trim whitespace when saving
autocmd BufWritePre * %s/\s\+$//e
" Return to last location when loading
autocmd BufReadPost * normal `"
" set colorcolumn=80

" Keybindings
" Make <space> the leader button
let mapleader="\<Space>"
" Change the command key for vim
nnoremap ; :
" Make vim scroll line-by-line, not around wrapped lines
:nmap j gj
:nmap k gk
" <Leader>o to open a new file
nnoremap <Leader>o :Files<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>w :w<CR>

" Easier moving between windows
" Skips having to press C-w first
nnoremap <silent> <C-l> <c-w>l
nnoremap <silent> <C-h> <c-w>h
nnoremap <silent> <C-k> <c-w>k
nnoremap <silent> <C-j> <c-w>j

" Clear searches automatically
nmap <silent> ,/ :nohlsearch<CR>

" Interface
let base16colorspace=256
set background=dark
colorscheme base16-solarized-dark

" Sensible defaults from Tpope
if !&scrolloff
  set scrolloff=1
endif
if !&sidescrolloff
  set sidescrolloff=5
endif
set display+=lastline

inoremap <C-U> <C-G>u<C-U>

:let g:vimfiler_as_default_explorer = 1

set tabpagemax=50
set showmode

set cursorline

set ruler
set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)

set backspace=indent,eol,start
set linespace=0
set nu
set showmatch
set incsearch
set hlsearch
set winminheight=0
set ignorecase
set wildignorecase
set smartcase
set wildmenu
set wildmode=list:longest,full
set whichwrap=b,s,h,l,<,>,[,]
set scrolljump=5
set scrolloff=3
set foldenable
set nolist

" Formatting
set nowrap
set autoindent
set shiftwidth=2 tabstop=2 softtabstop=2
set expandtab
set nojoinspaces
set splitright
set splitbelow
set pastetoggle=<F12>

" Syntax
let g:syntastic_javascript_eslint_generic = 1
let g:syntastic_javascript_eslint_exec = 'xo'
let g:syntastic_javascript_eslint_args = '--reporter=compact'
let g:syntastic_javascript_checkers = ['eslint']

" Markdown
au BufRead,BufNewFile *.md setlocal textwidth=80
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
let g:vim_markdown_folding_disabled=1
let g:vim_markdown_frontmatter=1

" Airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''

" delmitMate
let delimitMate_expand_cr = 2

" nvim plugins
let g:neomake_javascript_enabled_makers = ['eslint']
let g:deoplete#enable_at_startup = 1
