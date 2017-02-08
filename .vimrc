

" TODO vundle autocomplete etc.
"""settings

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

Plugin 'Valloric/YouCompleteMe'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim'
"status line
Plugin 'bling/vim-airline'
"Plugin 'bling/vim-airline-themes'
"Plugin 'edsono/vim-matchit'
"motions
"Plugin 'justinmk/vim-sneak'
"syntax highlighting
"Plugin 'plasticboy/vim-markdown'
"git integration
Plugin 'tpope/vim-fugitive'
"per buffer customized indentation /// this is horrible fuckery
"Plugin 'tpope/vim-sleuth'
"brackets and stuff
Plugin 'tpope/vim-surround'
"file switching
Plugin 'vim-scripts/a.vim'

"python things
"this screws with the python fileheader.
"Plugin 'vim-scripts/indentpython.vim'
Plugin 'nvie/vim-flake8'

"GDB plugin 
Plugin 'vim-scripts/Conque-GDB'

"Colorschemes
Plugin 'tomasr/molokai'
Plugin 'flazz/vim-colorschemes'
Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'


call vundle#end()
filetype plugin indent on

if has("win32")
    behave mswin
endif

set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4
set textwidth=79
set fileformat=unix

"set indent
set autoindent
set smartindent
set smarttab
set cindent
"code folding
"set foldmethod
"set foldlevel = 99

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

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

"exit insert mode
inoremap jk <esc>

" TODO insert copyright notice into header
" TODO now it inserts an additional * -.- in the C header
" TODO insert some sort of project identifier into headerguards??

"fileheader
function InsertCHeader()
    "prevent the double comment thing from happening

    filetype off
	"gives path relative to pwd
	"let filename = @%
	"gives just the filename
	let filename = expand('%:t')
	let projectname = ""
	let author = "Oskar Taubert"
	"strftime is not portable!
	let createdate = strftime("%c")
	let lastmod = ""

    "TODO fix this fucking thing, or make it properly
	execute "normal! o/*************************************"
	execute "normal! o"
	execute "normal! o Filename : " . filename
	execute "normal! o"
	execute "normal! o Projectname : " . projectname
	execute "normal! o"
	execute "normal! o Author : " . author
	execute "normal! o"
	execute "normal! o Creation Date : " . createdate
	execute "normal! o"
	execute "normal! o Last Modified : " . lastmod
	execute "normal! o"
	execute "normal! o*************************************/"
	execute "normal! o"
    filetype plugin indent on

endfunction

function InsertPythonHeader()
	"gives path relative to pwd
	"let filename = @%
	"gives just the filename
	let filename = expand('%:t')
	let projectname = ""
	let author = "Oskar Taubert"
	"strftime is not portable!
	let createdate = strftime("%c")
	let lastmod = ""

    filetype off
    execute "normal! i#!/usr/bin/env python"
	execute "normal! o#####################################"
	execute "normal! o#"
	execute "normal! o# Filename : " . filename
	execute "normal! o#"
	execute "normal! o# Projectname :" . projectname
	execute "normal! o#"
	execute "normal! o# Author : " . author
	execute "normal! o#"
	execute "normal! o# Creation Date : " . createdate
	execute "normal! o#"
	execute "normal! o# Last Modified : " . lastmod
	execute "normal! o#"
	execute "normal! o#####################################"
	execute "normal! o"
    filetype plugin indent on
endfunction


autocmd BufNewFile *.{c,cpp,h,hpp} call InsertCHeader()
autocmd BufNewFile *.{py} call InsertPythonHeader()
"autocmd BufNewFile *.{sh} call InsertBashHeader()

autocmd Bufwritepre,filewritepre *.{c,cpp,h,hpp,py} call UpdateLMD()

"update last modified date
function! UpdateLMD()
    call SaveWinView()
    exe "1," . 13 . "g/Last Modified :.*/s/Last Modified :.*/Last Modified : " .strftime("%c")
    call RestWinView()
endfunction

"save current view settings perwindow perbuffer
function! SaveWinView()
    if !exists("w:SavedBufView")
        let w:SavedBufView = {}
    endif
    let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction

"restore window
function! RestWinView()
    let buf = bufnr("%")
    if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
        call winrestview(w:SavedBufView[buf])
        unlet w:SavedBufView[buf]
    endif
endfunction


"headerfileguards
function! s:insert_gates()
  let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
  execute "normal! Go#ifndef " . gatename
  execute "normal! o#define " . gatename
  execute "normal! Go#endif /* " . gatename . " */"
  normal! kk
endfunction
autocmd BufNewFile *.{h,hpp} call <SID>insert_gates()


"reindent
"autocmd BufWritePre *.{c,cpp,h,hpp} :normal gg=G

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

"font and colour
highlight cursorline cterm=none
"set guifont=Courier:h18:cDEFAULT
set guifont=consolas=Consolas:h11:cDEFAULT

syntax enable
set background=dark
colorscheme	matrix
set t_Co=256

"fix ctrl-backspace
inoremap <C-BS> <C-\><C-o>db

"setup status bar and wildmenu
set wildmenu
set wildmode=list:longest,full
set wildignore=*.o,*.sb
set clipboard=unnamed
"set statusline=%F\ %y\ %l/%L\:%c\ %P


"extra C++ keywords
syn keyword cppType local_persist internal_var internal_function global_var constant_var r32 r64 ubyte uint ulong i8 u8 i32 u32 i64 u64 i16 u16 b32
"au BufNewFile,BufRead,BufEnter *.cpp,*.h set omnifunc=omni#cpp#complete#Main

"size
if has("gui_running")
	set lines=999 columns=999
endif


""abreviations
autocmd FileType cpp :iabbrev <buffer> iff if()<CR>{<CR>}<up><up><left>
inoremap aee ä
inoremap oee ö
inoremap uee ü
inoremap Aee Ä
inoremap Oee Ö
inoremap Uee Ü
inoremap ssz ß
"autocmd FileType tex :iabbrev <buffer> ae ä
"autocmd FileType tex :iabbrev <buffer> oe ö
"autocmd FileType tex :iabbrev <buffer> ue ü
"autocmd FileType tex :iabbrev <buffer> Ae Ä
"autocmd FileType tex :iabbrev <buffer> Oe Ö
"autocmd FileType tex :iabbrev <buffer> Ue Ü

"auto brackets
autocmd FileType cpp inoremap { {<CR>}<Esc>O
autocmd FileType cpp inoremap ( ()<Left>
autocmd FileType cpp inoremap [ []<Left>

autocmd FileType python inoremap { {}<Left>
autocmd FileType python inoremap ( ()<Left>
autocmd FileType python inoremap [ []<Left>

""mappings

"save with ctrl+s
nnoremap <C-s> :w<CR>

"navigating views
nnoremap <C-l> <C-w>l
nnoremap <C-k> <C-w>k
nnoremap <C-j> <C-w>j
nnoremap <C-h> <C-w>h

"copy and paste from clipboard

if has("win32")
    vnoremap <C-c> "*y
    nnoremap <C-p> "*p
else
    vnoremap <C-c> "+y
    nnoremap <C-p> "+p
endif


"shift select
nnoremap <S-l> vl
nnoremap <S-k> vk
nnoremap <S-j> vj
nnoremap <S-h> vh

vnoremap <S-l> l
vnoremap <S-k> k
vnoremap <S-j> j
vnoremap <S-h> h

" build
" TODO make building better (under windows)
"nnoremap <c-F5> :vnew | !build.bat <CR>
nnoremap <F5> :r!build<CR>
nnoremap <F6> :vnew<CR>
"nnoremap <c-F5> :vnew | r !dir #<CR>
"set makeprg = "build"

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
let g:syntastic_python_flake8_args='--ignore=E501'

" YCM
let g:ycm_autoclose_preview_window_after_completion = 1
" TODO there has to be a portable way like: /usr/bin/env python
let g:ycm_server_python_interpreter = '/usr/bin/python2'
