
"""settings

set nocompatible
"behave mswin

set tabstop=4
set expandtab
set shiftwidth=4
 
"set indent shit
set autoindent
set smartindent
set smarttab
set cindent
 
set number
set cursorline
set laststatus=2
set backspace=2
set encoding=utf8
set lazyredraw
set magic
set hidden
"set autochdir
 
"bracket matching
set showmatch
set mat=2
 
"search shit
set hlsearch
set incsearch
set ignorecase
set smartcase

"mouse
set mouse=a
 
"disable the ~ backup saving bullshit
set nobackup
set nowb
set noswapfile
 
"disable the windows GUI shit
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

"fileheader
function InsertCHeader()
	"gives path relative to pwd
	"let filename = @%
	"gives just the filename
	let filename = expand('%:t')
	let projectname = ""
	let author = "Oskar Taubert"
	"strftime is not portable!
	let createdate = strftime("%c")
	let lastmod = ""

    execute "normal! i//"
	execute "normal! o/*************************************"
	execute "normal! o*"
	execute "normal! o* Filename : " . filename
	execute "normal! o*"
	execute "normal! o* Projectname : " . projectname
	execute "normal! o*"
	execute "normal! o* Author : " . author
	execute "normal! o*"
	execute "normal! o* Creation Date : " . createdate
	execute "normal! o*"
	execute "normal! o* Last Modified : " . lastmod
	execute "normal! o*"
	execute "normal! o*************************************/"
	execute "normal! o"
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

    execute "normal! i#!/usr/bin/env python"
	execute "normal! o#####################################"
	execute "normal! o#"
	execute "normal! o# Filename : " . filename
	execute "normal! o#"
	execute "normal! o# Projectname : " . projectname
	execute "normal! o#"
	execute "normal! o# Author : " . author
	execute "normal! o#"
	execute "normal! o# Creation Date : " . createdate
	execute "normal! o#"
	execute "normal! o# Last Modified : " . lastmod
	execute "normal! o#"
	execute "normal! o#####################################"
	execute "normal! o"
endfunction


autocmd BufNewFile *.{c,cpp,h,hpp} call InsertCHeader()
autocmd BufNewFile *.{py} call InsertPythonHeader()
"autocmd BufNewFile *.{sh} call InsertBashHeader()

autocmd Bufwritepre,filewritepre *.{c,cpp,h,hpp,py,sh} exe "1," . 13 . "g/Last Modified :.*/s/Last Modified :.*/Last Modified : " .strftime("%c")

"headerfileguards
function! s:insert_gates()
  let gatename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
  execute "normal! i#ifndef _" . gatename . "_"
  execute "normal! o#define _" . gatename . "_ "
  execute "normal! Go#endif /* _" . gatename . "_ */"
  normal! kk
endfunction
autocmd BufNewFile *.{h,hpp} call <SID>insert_gates()


"reindent
"autocmd BufWritePre *.{c,cpp,h,hpp} :normal gg=G
 
"better intenting in visual mode
"vnoremap <Tab> > gv
"vnoremap <S-Tab> < gv
 
"font and colour shit
highlight cursorline cterm=none
"set guifont=Courier:h18:cDEFAULT
set guifont=consolas=Consolas:h11:cDEFAULT

syntax enable
set background=dark
"colorscheme	darkblue 

"fix ctrl-backspace
inoremap <C-BS> <C-\><C-o>db
 
"setup status bar and wildmenu
set wildmenu
set wildmode=list:longest,full
set wildignore=*.o,*.sb
set clipboard=unnamed
"set statusline=%F\ %y\ %l/%L\:%c\ %P
 

"extra C++ shit
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
" dear anyone who listens to my whining: this is fucking retarded
"nnoremap <c-F5> :vnew | !build.bat <CR>
nnoremap <F5> :r!build<CR>
nnoremap <F6> :vnew<CR>
"nnoremap <c-F5> :vnew | r !dir #<CR>
"set makeprg = "build"
                
