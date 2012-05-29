" .vimrc
" Author: Carl Boettiger
" About: this is my vimrc custom configuration file.  

" Syntax Highlighting
syntax on


" Spelling Highlighting
" Key mapping F2 to toggle spelling check in Vim 7
"setlocal spell spelllang=en_us
nmap <silent> <F2>:setlocal spell!<CR>
imap <silent> <F2> <C-O>:setlocal spell!<CR>
set spellfile=~/.vim/spellfile.add
set spelllang=en_us


" vim-r-plugin shouldn't map _ to <- 
let vimrplugin_underscore = 0

"git commit
map \gc : call GitCommit()<CR>
func! GitCommit()
exec "w"
exec "! git commit -a"
endfunc

" Word-wrapping
:set formatoptions=l "Make sure not to add line-breaks when editing middle of a paragraph
:set lbr  "visual word wrapping


"""""""""""" General """"""""""""""""
 set nocompatible	" get out of horrible vi-compatible mode
 filetype on		" detect the type of file
 set history=10000	" How many lines of history to remember
 set cf				" enable error files and error jumping

 " yanked text can be pasted into another vim file using shift+insert 
  set clipboard+=unnamed " shares windows clipboard
 " set clipboard=autoselect,unnamed,exclude:cons\|linux


 set ffs=unix,mac,dos " support all three filetypes, in this order

 filetype plugin on " load filetype plugins
 set viminfo+=! " make sure it can save viminfo
 set isk+=_,$,@,%,#,- " none of these should be word dividers, so make it so
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " Files/Backups
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set backup " make backup file
"" set backupdir=$VIM\vimfiles\backup " where to put backup file
" set directory=$VIM\vimfiles\temp " directory is the directory for temp file
" set makeef=error.err " When using make, where should it dump the file
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Vim UI
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
 set lsp=0			" space it out a little more (easier to read)
 set wildmenu		" turn on wild menu
 set ruler			" Always show current positions along the bottom 
 set cmdheight=2	" the command bar is 2 high
" set number		" turn on line numbers
 set lz				" do not redraw while running macros (much faster) (LazyRedraw)
 set backspace=2	" make backspace work normal

 set whichwrap+=<,>,h,l " backspace and cursor keys wrap too
 set mouse=a			" use mouse everywhere
" set shortmess=atI		" shortens messages to avoid 'press a key' prompt 
 set report=0			" tell us when anything is changed via :...
 set noerrorbells		" don't make noise

" " make the splitters between windows be blank
" set fillchars=vert:\ ,stl:\ ,stlnc:\ 
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Visual Cues
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set showmatch " show matching brackets
" set mat=5 " how many tenths of a second to blink matching brackets for
 let loaded_matchparen = 1 " don't match parens (too slow)
 set nohlsearch " do not highlight searched for phrases
 set incsearch " BUT do highlight as you type you search phrase
 set noerrorbells " no noises


" set listchars=tab:\|\ ,trail:.,extends:>,precedes:<,eol:$ " what to show when I hit :set list
 set columns=80 " 80 cols wide
" set novisualbell " don't blink
 set statusline=%f%m%r%h%w\ [line=%l,col=%v]\ [%p%%]\ [length=%L]\ [FORMAT=%{&ff}]\ [TYPE=%Y]  
 set laststatus=2 " always show the status line
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Text Formatting/Layout
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set fo=tcrqn		" See Help (complex)
 set ai				    " autoindent
 set si				    " smartindent 
 set tabstop=2		" tab spacing (settings below are just to unify it)
 set softtabstop=2	" unify
 set shiftwidth=2	" unify 
" set noexpandtab	" real tabs please!
 set expandtab		" I think this turns tabs into spaces
" set nowrap		  " do not wrap lines  
" set smarttab		" use tabs at the start of a line, spaces elsewhere
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " Latex-suite
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" REQUIRED. This makes vim invoke Latex-Suite when you open a tex file.
filetype plugin on

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a single file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: This enables automatic indentation as you type.
filetype plugin indent on

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Completion 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType c set omnifunc=ccomplete#Complete

""" DoxygenToolkit
let g:DoxygenToolkit_authorName="Carl Boettiger <cboettig@gmail.com>"
let g:DoxygenToolkit_licenseTag="CC0 To the extent possible under law, the author(s) have dedicated all copyright \n and related and neighboring rights to this software to the public domain worldwide. \n\n This software is distributed without any warranty. For a copy of the CC0 Public Domain Dedication,\n see <http://creativecommons.org/publicdomain/zero/1.0/>."
let g:DoxygenToolkit_commentType = "Python"

""" https://github.com/tpope/vim-pathogen
call pathogen#infect()
