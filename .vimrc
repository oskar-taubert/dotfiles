set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

"c/c++ code completion
Plugin 'Valloric/YouCompleteMe'
"syntax highlighting
Plugin 'scrooloose/syntastic'
"file explorer
Plugin 'scrooloose/nerdtree'

"linter
Plugin 'w0rp/ale'

"multiple cursors
Plugin 'terryma/vim-multiple-cursors'

"Unix file operations
"Plugin 'tpope/vim-eunuch'

"status line
"Plugin 'bling/vim-airline'
"Plugin 'bling/vim-airline-themes'
Plugin 'itchyny/lightline.vim'

"git integration
Plugin 'airblade/vim-gitgutter'
"Plugin 'tpope/vim-fugitive'
"Plugin 'tpope/vim-unimpaired'

"per buffer customized indentation /// this is horrible fuckery
"Plugin 'tpope/vim-sleuth'

"brackets and stuff
Plugin 'tpope/vim-surround'

"GDB plugin 
"Plugin 'vim-scripts/Conque-GDB'

"indent guides for space indentation
Plugin 'Yggdroot/indentLine'

"python things
Plugin 'nvie/vim-flake8'

" go things
"Plugin 'fatih/vim-go'

call vundle#end()
filetype plugin indent on

"set time locale for strftime() to english to avoid umlauts in dates
language time en_US.utf8

set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4
set fileformat=unix

"set indent
set autoindent
set smartindent
set smarttab
set cindent
" TODO put in retab/reindent on read for some filetypes
" set list listchars=eol:$,trail:.,precedes:.,extends:>,tab:| 
set list listchars=tab:>-,precedes:<,extends:>,eol:$

"line wrapping
set wrap
set linebreak
set nolist
set textwidth=0
set wrapmargin=0

set number
set cursorline
set laststatus=2
set backspace=2
set encoding=utf8
set lazyredraw
set magic
set hidden

"set path for finding files 
set path+=../../../include/,../include,./include,

"bracket matching
set showmatch
set mat=2

"search
set hlsearch
set incsearch
set ignorecase
set smartcase

"mouse
set mouse=a

"disable the ~ backup
set nobackup
set nowb
set noswapfile

"disable the windows GUI
set guioptions-=m
set guioptions-=T
set guioptions-=r
set guioptions-=L

"turn off sounds
set noerrorbells
set novisualbell
set noeb vb t_vb=
set vb t_vb=

"auto completion
set completeopt=menu,menuone,longest,preview
:inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
:inoremap <C-tab> <C-n>

""autocommands
"should use augroups with autocmd! later, when resourcing the vimrc since au's are not named all the stuff will be doubled
" only works for command line
augroup gui_enter
    autocmd!
	au GUIEnter * set vb t_vb=
augroup END

" Return to last edit position when opening files
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

"C headerfileguards
function! s:insert_gates()
  let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
  execute "normal! Go#ifndef " . gatename
  execute "normal! o#define " . gatename
  execute "normal! Go#endif /* " . gatename . " */"
  normal! kk
endfunction
autocmd BufNewFile *.{h,hpp} call <SID>insert_gates()

"flag whitespace
function ShowWS()
   exe "normal mz"
   %s/\s\+$//ge
   exe "normal 'z"
endfunction

function DeleteTrailingWS()
   exe "normal mz"
   %s/\s\+$//ge
   exe "normal 'z"
endfunction

autocmd BufWritePre *.py :call DeleteTrailingWS()

syntax enable
set background=dark
set t_Co=256

"setup status bar and wildmenu
set wildmenu
set wildmode=list:longest,full
set wildignore=*.o,*.sb

set clipboard=unnamed

"size
if has("gui_running")
	set lines=999 columns=999
endif


"exit insert mode
inoremap jk <esc>

""abreviations
autocmd FileType cpp :iabbrev <buffer> iff if()<CR>{<CR>}<up><up><left>
inoremap "aee ä
inoremap "oee ö
inoremap "uee ü
inoremap "Aee Ä
inoremap "Oee Ö
inoremap "Uee Ü
inoremap ssz ß

""mappings

"save with ctrl+s
nnoremap <C-s> :w<CR>

"navigating views
nnoremap <C-l> <C-w>l
nnoremap <C-k> <C-w>k
nnoremap <C-j> <C-w>j
nnoremap <C-h> <C-w>h

"copy and paste from clipboard

vnoremap <C-c> "*y
nnoremap <C-p> "*p

" build
" TODO make building better (under windows)
"nnoremap <c-F5> :vnew | !build.bat <CR>
nnoremap <F5> :r!build<CR>
nnoremap <F6> :vnew<CR>

" Plugin settings
" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_cpp_compiler = 'g++'
let g:syntastic_cpp_compiler_options = ' -std=c++11'
let g:syntastic_cpp_include_dirs = ['../../include/', '../include', 'include']
" TODO remove these again and add proper python indent
let g:syntastic_python_python_exec='/usr/bin/python3'
" disable lacheck
let g:syntastic_tex_checkers=['']

" YCM
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_python_binary_path = 'python3'

let g:indentLine_conceallevel = 2
let g:indentLine_concealcursor = ''
