call plug#begin('~/.vim/plugged')
  Plug 'itchyny/lightline.vim'
  Plug 'spf13/PIV', {'for': 'php'}
  Plug 'fatih/vim-go', {'for': 'go'}
  Plug 'mileszs/ack.vim'
"  Disable it for now until I find out why is it messing up hitting space.
"  Plug 'Shougo/neocomplcache.vim'
  Plug 'scrooloose/nerdtree', {'on':  'NERDTreeToggle'}
  Plug 'scrooloose/syntastic'
  Plug 'altercation/vim-colors-solarized', {'dir': '~/.vim/plugged/vim-colors-solarized', 'do': 'cp solarized.vim ~/.vim/colors/'}
  Plug 'airblade/vim-gitgutter'
  Plug 'bronson/vim-visual-star-search'
  Plug 'majutsushi/tagbar', {'on': 'TagbarToggle'}
  Plug 'scrooloose/nerdcommenter',
  Plug 'kien/ctrlp.vim'
call plug#end()

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

" For jQuery
au BufRead,BufNewFile *.js set ft=javascript.jquery

" For drupal modules
au BufRead,BufNewFile *.module set syn=php
au BufRead,BufNewFile *.module set omnifunc=phpcomplete#CompletePHP
au BufRead,BufNewFile *.install set syn=php
au BufRead,BufNewFile *.install set omnifunc=phpcomplete#CompletePHP
au BufRead,BufNewFile *.profile set syn=php
au BufRead,BufNewFile *.profile set omnifunc=phpcomplete#CompletePHP

" Set filetype for less
au BufNewFile,BufRead *.less set filetype=less

"remove whitespaces from the end of all lines at saving
autocmd BufWritePre * :%s/\s\+$//e

" + opens up the tag definition - closes it
map + :pta <C-R><C-W><CR>
map - :pc<CR>

let SVNCommandEnableBufferSetup=1
let SVNCommandEdit='split'

" Set code completion on
autocmd FileType c set omnifunc=ccomplete#Complete
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType markdown set omnifunc=htmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType xml setomnifunc=xmlcomplete#CompleteTags

let g:lightline = {
  \ 'colorscheme': 'default',
  \ }

colorscheme solarized
set background=dark

if has("gui_running")
	" modify toolbar
	set tbis=tiny
  set guifont=Monaco:h13.00
  set guioptions-=T  " Noo toolbar
endif

" autocomplete
let g:AutoComplPop_BehaviorKeywordLength=4

" php abbrevs
ab fnc function() {<CR><CR>}<ESC>kk$3hi
ab pst $_POST['']<LEFT><LEFT>

" highlight cursor more
set cursorline

" visualize tabs
set list
exe "set listchars=tab:>-,trail:\xb7,eol:$,nbsp:\xb7"
map <C-TAB> :set invlist<CR>
set invlist

" fast terminal
set tf

" for smart code competition
set showfulltag

vmap " :s/\%V/"/<CR><ESC>:s/\%#/"/<CR>i

set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [%p%%]\ [LEN=%L]\ [POS=%l,%v]
set laststatus=2

imap <C-BS> <C-W>

" enable spellcheck
set spell

set smartcase

" delete all trailing whitespaces for \w
nnoremap <leader>w :%s/\s\+$//<cr>:let @/=''<CR>
set backupdir=/tmp
nnoremap <F5> :GundoToggle<CR>
nnoremap <F2> :TlistToggle<CR>

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

let g:DisableAutoPHPFolding = 1

" Disable arrows in NERDTree
" https://github.com/scrooloose/nerdtree/issues/108
set encoding=utf-8

if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

" Enable mouse support
set mouse=a
