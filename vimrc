" All system-wide defaults are set in $VIMRUNTIME/debian.vim and sourced by
" the call to :runtime you can find below.  If you wish to change any of those
" settings, you should do it in this file (/etc/vim/vimrc), since debian.vim
" will be overwritten everytime an upgrade of the vim packages is performed.
" It is recommended to make changes after sourcing debian.vim since it alters
" the value of the 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
if has("syntax")
  syntax on
endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
"set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
"if has("autocmd")
"  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
"endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
"if has("autocmd")
"  filetype plugin indent on
"endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
"set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
"set incsearch		" Incremental search
set autowrite		" Automatically save before commands like :next and :make
"set hidden		" Hide buffers when they are abandoned
set mouse=a		" Enable mouse usage (all modes)

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

set number
set smartindent
set autoindent
"set cindent
set tabstop=4
set shiftwidth=4

set guifont=Consolas:h10
colorscheme darkblue

set ruler
set incsearch

autocmd cursorhold * set nohlsearch
noremap n :set hlsearch<cr>n
noremap N :set hlsearch<cr>N
noremap / :set hlsearch<cr>/
noremap ? :set hlsearch<cr>?
noremap * :set hlsearch<cr>*

inoremap ( ()<LEFT>
inoremap [ []<LEFT>
inoremap { {}<ESC>i<CR><ESC>V<O
inoremap " ""<LEFT>
inoremap ' ''<LEFT>


fun! CompileGcc()
	exec "w"
	let compilecmd="!gcc -Wall -ansi -pedantic -std=c99 "
	let compileflag="-o %<"
	if search("mpi\.h") != 0
		let compilecmd = "!mpicc "
	endif
	if search("glut\.h") != 0
		let compileflag .= " -lglut -lGLU -lGL "
	endif
	if search("cv\.h") != 0
		let compileflag .= " -lcv -lhighgui -lcvaux "
	endif
	if search("omp\.h") != 0
		let compileflag .= " -fopenmp "
	endif
	if search("math\.h") != 0
		let compileflag .= " -lm "
	endif
	exec compilecmd." % ".compileflag
endfunc

fun! CompileCpp()
	exec "w"
	let compilecmd="!g++ -g -Wall -pedantic -std=c++11 "
	let compileflag="-o %<"
	if search("mpi\.h") != 0
		let compilecmd = "!mpic++ "
	endif
	if search("glut\.h") != 0
		let compileflag .= " -lglut -lGLU -lGL "
	endif
	if search("cv\.h") != 0
		let compileflag .= " -lcv -lhighgui -lcvaux "
	endif
	if search("omp\.h") != 0
		let compileflag .= " -fopenmp "
	endif
	if search("math\.h") != 0
		let compileflag .= " -lm "
	endif

	exec compilecmd." % ".compileflag
endfunc

func! CompileCode()
	exec "w"
	if &filetype == "c"
		exec "call CompileGcc()"
	elseif &filetype == "cpp"
		exec "call CompileCpp()"
	endif
endfunc

func! RunResult()
	exec "w"
	if &filetype == "c"
		exec "call CompileGcc()"
		exec "! ./%<"
	elseif &filetype == "cpp"
		exec "call CompileCpp()"
		exec "! ./%<"
	endif
endfunc

map <F7> : call CompileCode()<CR>
imap <F7> <ESC>:call CompileCode()<CR>
vmap <F7> <ESC>:CompileCode()<CR>


map <F5> : call RunResult()<CR>
imap <F5> <ESC>:call RunResult()<CR>
vmap <F5> <ESC>:call RunResult()<CR>

