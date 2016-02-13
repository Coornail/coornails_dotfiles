call plug#begin('~/.vim/plugged')
  Plug 'Coornail/vim-go-conceal', {'for': 'go'}

  Plug 'Raimondi/delimitMate'
  Plug 'Shougo/neocomplete.vim'
  "Plug 'Shougo/neomru.vim'
  Plug 'Shougo/unite.vim'
  "Plug 'Shougo/vimproc.vim'
  Plug 'SirVer/ultisnips'
  Plug 'airblade/vim-gitgutter'
  Plug 'ap/vim-css-color'
  Plug 'bronson/vim-visual-star-search'
  Plug 'chriskempson/base16-vim'
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'ervandew/supertab'
  Plug 'fatih/vim-go', {'for': 'go'}
  Plug 'ihacklog/HiCursorWords'
  Plug 'itchyny/lightline.vim'
  Plug 'jaxbot/syntastic-react', {'for': 'javascript'}
  Plug 'jeffkreeftmeijer/vim-numbertoggle'
  Plug 'justinmk/vim-sneak'
  Plug 'kshenoy/vim-signature'
  Plug 'majutsushi/tagbar', {'on': 'TagbarToggle'}
  Plug 'mephux/vim-jsfmt', {'for': 'javascript'}
  Plug 'mileszs/ack.vim'
  Plug 'mxw/vim-jsx', {'for': 'javascript'}
  Plug 'pangloss/vim-javascript'
  Plug 'rhysd/committia.vim'
  Plug 'romainl/vim-qf'
  Plug 'scrooloose/nerdcommenter'
  Plug 'scrooloose/nerdtree', {'on':  'NERDTreeToggle'}
  Plug 'scrooloose/syntastic'
  Plug 'spf13/PIV', {'for': 'php'}
  Plug 'terryma/vim-expand-region'
  Plug 'terryma/vim-multiple-cursors'
  Plug 'tpope/vim-sensible/'
  Plug 'unblevable/quick-scope'
  Plug 'vim-scripts/Indent-Highlight'
  Plug 'wakatime/vim-wakatime'
call plug#end()

let mapleader=" "
nmap <leader>s :Unite -buffer-name=grep grep:.::<C-r><C-w><CR>

set backupdir=/tmp
set backupskip=/tmp/*,/private/tmp/*
set cursorline
set directory=/tmp
set expandtab
set hlsearch
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
\ 'component': {
\   'readonly': '%{&readonly?"🔒":""}',
\   }
\ }

let base16colorspace=256
colorscheme base16-mocha
set background=dark

if has("gui_running")
	set tbis=tiny
  set cole=0 " No conceal
  set guifont=ProggySquareTT:h16
  set guioptions-=L  " No Left scrollbar
  set guioptions-=R  " No Right scrollbar
  set guioptions-=T  " No toolbar
  set noantialias
endif

" autocomplete
let g:AutoComplPop_BehaviorKeywordLength=4

" visualize tabs
set list
exe "set listchars=tab:>-,trail:\xb7,eol:$,nbsp:\xb7"
map <leader>t :set invlist<CR>
set invlist

vmap " :s/\%V/"/<CR><ESC>:s/\%#/"/<CR>i

imap <C-BS> <C-W>

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

let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"

let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
      \ --ignore .git
      \ --ignore .svn
      \ --ignore .hg
      \ --ignore .DS_Store
      \ --ignore "**/*.pyc"
      \ -g ""'

map <leader>o :CtrlPTag<CR>
map <leader>l :CtrlPLine<CR>

let g:go_fmt_command = "goimports"
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)
au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>dt <Plug>(go-def-tab)
au FileType go nmap <Leader>gd :GoDef<CR>
au FileType go nmap <Leader>gi :GoImports<CR>:w<CR>
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
au FileType go nmap <Leader>gb <Plug>(go-doc-browser)
au FileType go nmap <Leader>s <Plug>(go-implements)
au FileType go nmap <Leader>i <Plug>(go-info)
au FileType go nmap <Leader>e <Plug>(go-rename)

nmap <Leader>w :w<CR>

vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_go_checkers = ['go', 'gometalinter']
let g:syntastic_go_gometalinter_args = "-D gotype --fast -j 3"
let g:syntastic_error_symbol = "✖"
let g:syntastic_warning_symbol = "✕"
let g:syntastic_style_error_symbol = "△"
let g:syntastic_style_warning_symbol = "△"

" Toggle -fast flag for gometalinter.
nnoremap <leader>f :call FastGoLint()<cr>
let g:golintfast = 1
function! FastGoLint()
  if g:golintfast
    let g:golintfast = 0
    let g:syntastic_go_gometalinter_args = "-D gotype --deadline=30s -j 3"
    echo "Gometalinter: Slow"
    SyntasticCheck
  else
    let g:golintfast = 1
    let g:syntastic_go_gometalinter_args = "-D gotype --fast -j 3"
    echo "Gometalinter: Fast"
    SyntasticCheck
  endif
endfunction

" Gotags support
" Requires https://github.com/jstemmer/gotags
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

if exists('$ITERM_PROFILE')
  if exists('$TMUX')
    let &t_SI = "\<Esc>[3 q"
    let &t_EI = "\<Esc>[0 q"
  else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  endif
end

" autocomplete
let g:AutoComplPop_BehaviorKeywordLength=4
"
let g:neocomplete#enable_at_startup = 1

let g:js_fmt_autosave = 0

