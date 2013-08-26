execute pathogen#infect()

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

" neocomplcache settings
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Enable heavy features.
" Use camel case completion.
"let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
"let g:neocomplcache_enable_underbar_completion = 1

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplcache#smart_close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplcache#close_popup() : "\<Space>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

let g:DisableAutoPHPFolding = 1

" Disable arrows in NERDTree
" https://github.com/scrooloose/nerdtree/issues/108
set encoding=utf-8

let g:lightline = {
  \ 'colorscheme': 'solarized',
  \ }
