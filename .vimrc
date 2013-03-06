set nocompatible
set nobackup		" do not keep a backup file
set history=50		" keep 50 lines of command line history
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set hlsearch
syntax on
filetype plugin indent on

" Jump to the last known line
autocmd BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\   exe "normal g`\"" |
\ endif

set autoindent
set tabstop=2
set expandtab
set shiftwidth=2
set nu

" colors
"hi Comment ctermfg=DarkGreen
"hi String ctermfg=DarkMagenta
"hi pythonPreCondit ctermfg=Green


" For jquey
au BufRead,BufNewFile *.js set ft=javascript.jquery

" For drupal modules
au BufRead,BufNewFile *.module set syn=php
au BufRead,BufNewFile *.module set omnifunc=phpcomplete#CompletePHP
au BufRead,BufNewFile *.install set syn=php
au BufRead,BufNewFile *.install set omnifunc=phpcomplete#CompletePHP

"remove whitespaces from the end of all lines at saving
autocmd BufWritePre * :%s/\s\+$//e

" + opens up the tag definition - closes it
map + :pta <C-R><C-W><CR>
map - :pc<CR>

set tags+=~/.vim/drupal_include
set tags+=~/.vim/drual_modules

let SVNCommandEnableBufferSetup=1
let SVNCommandEdit='split'

" Set code completion on
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete

if has("gui_running")
	" modify toolbar
	set tbis=tiny
	"colorscheme solarized
  set guifont=Monaco:h13.00
  colorscheme xoria256
  set guioptions-=T  " Noo toolbar
else
	"colorscheme solarized
endif

" autocomplete
let g:AutoComplPop_BehaviorKeywordLength=4

" php abbrevs
ab fnc function() {<CR><CR>}<ESC>kk$3hi
ab pst $_POST['']<LEFT><LEFT>

" highlight cursor more
set cursorline
"highlight CursorLine guibg=lightblue ctermbg=136 cterm=bold
"hi CursorLine guibg=#252525 ctermbg=236 cterm=none
" TODO: Set colors right
"

" baloons
"@set ballooneval
"et balloondelay=400
"set balloonexpr="test"

" visualize tabs
set list
exe "set listchars=tab:>-,trail:\xb7,eol:$,nbsp:\xb7"
map <C-TAB> :set invlist<CR>
set invlist

" fast terminal
set tf

" for smart code competition
set showfulltag
"set path=/var/www/d6/includes/*.php

vmap " :s/\%V/"/<CR><ESC>:s/\%#/"/<CR>i

set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [%p%%]\ [LEN=%L]\ [POS=%l,%v]
set laststatus=2

set showcmd

imap <C-BS> <C-W>

" enable spellcheck
set spell

set smartcase

" delete all trailing whitespaces for \w
nnoremap <leader>w :%s/\s\+$//<cr>:let @/=''<CR>
set backupdir=/tmp
nnoremap <F5> :GundoToggle<CR>
nnoremap <F2> :TlistToggle<CR>

au BufNewFile,BufRead *.less set filetype=less

" swapfiles
set directory=/tmp

" backspace fix
set backspace=2

if $VIM_CRONTAB == "true"
  set nobackup
  set nowritebackup
endif

set backupskip=/tmp/*,/private/tmp/*

" Show the git diff in vim when commiting
autocmd FileType gitcommit DiffGitCached | wincmd p

execute pathogen#infect()
