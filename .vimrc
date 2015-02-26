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
  Plug 'scrooloose/nerdcommenter'
  Plug 'kien/ctrlp.vim'
  Plug 'tpope/vim-sensible/'
  Plug 'justinmk/vim-sneak'
  Plug 'Shougo/vimproc.vim'
  Plug 'Shougo/unite.vim'
  Plug 'Shougo/neomru.vim'
  Plug 'ervandew/supertab'
  Plug 'deris/vim-shot-f'
  Plug 'mxw/vim-jsx'
  Plug 'pangloss/vim-javascript'
  Plug 'SirVer/ultisnips'
  Plug 'Raimondi/delimitMate'
call plug#end()

let mapleader=" "
nmap <leader>s :Unite -buffer-name=grep grep:.::<C-r><C-w><CR>

set backspace=2
set backupdir=/tmp
set backupskip=/tmp/*,/private/tmp/*
set cursorline
set directory=/tmp
set expandtab
set hlsearch
set incsearch
set lazyredraw
set mouse=a
set nobackup
set nocompatible
set nu
set shiftwidth=2
set showfulltag
set smartcase
set spell
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [%p%%]\ [LEN=%L]\ [POS=%l,%v]
set tabstop=2
set tf

if $VIM_CRONTAB == "true"
  set nobackup
  set nowritebackup
endif


" Jump to the last known line
autocmd BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\   exe "normal g`\"" |
\ endif

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
  set guifont=Monaco:h12.00
  set guioptions-=T  " Noo toolbar
endif

" autocomplete
let g:AutoComplPop_BehaviorKeywordLength=4

" php abbrevs
ab fnc function() {<CR><CR>}<ESC>kk$3hi
ab pst $_POST['']<LEFT><LEFT>

" visualize tabs
set list
exe "set listchars=tab:>-,trail:\xb7,eol:$,nbsp:\xb7"
map <leader>t :set invlist<CR>
set invlist

vmap " :s/\%V/"/<CR><ESC>:s/\%#/"/<CR>i

imap <C-BS> <C-W>

" Show the git diff in vim when commiting
autocmd FileType gitcommit DiffGitCached | wincmd p

let g:DisableAutoPHPFolding = 1

if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

" Use Unite to navigate between buffers
"nnoremap <space>b :Unite -quick-match buffer<cr>
nnoremap <silent> <leader>b :<C-u>Unite -quick-match buffer bookmark<CR>
nnoremap <leader>/ :Unite grep:.<cr>

" Use the fuzzy matcher for everything
call unite#filters#matcher_default#use(['matcher_fuzzy'])

" Use the rank sorter for everything
call unite#filters#sorter_default#use(['sorter_rank'])

set rtp+=$GOPATH/src/github.com/golang/lint/misc/vim

let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"
