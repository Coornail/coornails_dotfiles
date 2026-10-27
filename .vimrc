call plug#begin('~/.vim/plugged')
 " Plug 'Coornail/vim-go-conceal', {'for': 'go'}

  Plug 'Raimondi/delimitMate'
  Plug 'mhinz/vim-signify'
  Plug 'ap/vim-css-color'
  Plug 'haya14busa/vim-asterisk'
  Plug 'chriskempson/base16-vim'
  Plug 'ervandew/supertab'
  Plug 'fatih/vim-go', {'for': 'go'}
  Plug 'itchyny/lightline.vim'
  Plug 'jeffkreeftmeijer/vim-numbertoggle'
  Plug 'justinmk/vim-sneak'
  Plug 'kshenoy/vim-signature'
  Plug 'majutsushi/tagbar', {'on': 'TagbarToggle'}
  Plug 'junegunn/fzf.vim'
  Plug 'rhysd/committia.vim'
  Plug 'romainl/vim-qf', {'for': 'qf'}
  Plug 'scrooloose/nerdcommenter'
  Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
  Plug 'terryma/vim-expand-region'
  Plug 'unblevable/quick-scope'
  Plug 'itchyny/vim-cursorword'
  Plug 'rust-lang/rust.vim', {'for': 'rust'}
  Plug 'wincent/loupe'
  Plug 'nathanaelkane/vim-indent-guides'
  Plug 'w0rp/ale'
  Plug 'jceb/vim-orgmode'
  Plug 'tpope/vim-speeddating'

  if has('nvim')
    set inccommand=split
  else
    Plug 'tpope/vim-sensible'
    if v:version > 703
      if has('python3')
        Plug 'SirVer/ultisnips'
      endif
    endif
  endif
call plug#end()

let mapleader=" "

set backupdir=/tmp
set backupskip=/tmp/*,/private/tmp/*
set cursorline
set directory=/tmp
set expandtab
set hlsearch
set mouse=a
set nu
set shiftwidth=2
set showfulltag
set smartcase
"set spell
set tabstop=2

" Use persistent history.
" From https://advancedweb.hu/2017/09/19/vim-persistent-undo/
let s:undodir = "/tmp/.vim-undo-dir"
if !isdirectory(s:undodir)
    call mkdir(s:undodir, "", 0700)
endif
set undofile
let &undodir = s:undodir

if $VIM_CRONTAB == "true"
  set nowritebackup
endif


" Jump to the last known line
autocmd BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\   exe "normal g`\"" |
\ endif

" + opens up the tag definition - closes it
map + :pta <C-R><C-W><CR>
map - :pc<CR>

" Replace things in selection.
" From http://howivim.com/2016/damian-conway/
nmap <expr>  <leader>m  ':%s/' . @/ . '//g<LEFT><LEFT>'

let g:lightline = {
\ 'colorscheme': 'default',
\ 'component': {
\   'readonly': '%{&readonly?"🔒":""}',
\   }
\ }

silent! colorscheme base16-mocha
set background=dark

if has("gui_running")
	set tbis=tiny
  set cole=0 " No conceal
  "set guifont=ProggySquareTT:h16
  set macligatures
  set guifont=Fira\ Code:h12
  "set guifont=Fira \ Code\ Light:h12
  set guioptions-=L  " No Left scrollbar
  set guioptions-=R  " No Right scrollbar
  set guioptions-=T  " No toolbar
  "set noantialias
endif

" visualize tabs
exe "set listchars=tab:>-,trail:\xb7,eol:$,nbsp:\xb7"
map <leader>t :set invlist<CR>

vmap " :s/\%V/"/<CR><ESC>:s/\%#/"/<CR>i

imap <C-BS> <C-W>

let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
let g:SuperTabContextDefaultCompletionType = "<c-x><c-o>"

map <leader>o :Tags<CR>
map <leader>l :BLines<CR>
nnoremap <C-p> :Files<CR>

"let g:go_fmt_command = "goimports"
au FileType go nnoremap <buffer> <leader>t <Plug>(go-test)
au FileType go nnoremap <buffer> <leader>c <Plug>(go-coverage)
au FileType go nnoremap <buffer> <Leader>ds <Plug>(go-def-split)
au FileType go nnoremap <buffer> <Leader>dv <Plug>(go-def-vertical)
au FileType go nnoremap <buffer> <Leader>dt <Plug>(go-def-tab)
au FileType go nnoremap <buffer> <Leader>gd :GoDef<CR>
au FileType go nnoremap <buffer> <Leader>gi :GoImports<CR>:w<CR>
au FileType go nnoremap <buffer> <Leader>gv <Plug>(go-doc-vertical)
au FileType go nnoremap <buffer> <Leader>gb <Plug>(go-doc-browser)
au FileType go nnoremap <buffer> <Leader>s <Plug>(go-implements)
au FileType go nnoremap <buffer> <Leader>i <Plug>(go-info)
au FileType go nnoremap <buffer> <Leader>e <Plug>(go-rename)

nmap <Leader>w :w<CR>

vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" ALE (Asynchronous Lint Engine) configuration
let g:ale_linters = {
\   'go': ['gopls', 'golangci-lint'],
\   'javascript': ['eslint'],
\   'rust': ['rustc', 'analyzer'],
\}
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'go': ['gofmt', 'goimports'],
\   'javascript': ['eslint'],
\   'rust': ['rustfmt'],
\}
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'normal'
let g:ale_sign_error = "✖"
let g:ale_sign_warning = "✕"
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_fix_on_save = 1

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
let g:indent_guides_enable_on_vim_startup = 1

if exists('$ITERM_PROFILE')
  if exists('$TMUX')
    let &t_SI = "\<Esc>[3 q"
    let &t_EI = "\<Esc>[0 q"
  else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
  endif
end

set foldmethod=indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=2         "this is just what i use"
let g:signify_vcs_list = [ "git" ]
"let g:signify_line_highlight = 1

if has('nvim')
  tnoremap <Esc> <C-\><C-n>
  tnoremap <A-h> <C-\><C-n><C-w>h
  tnoremap <A-j> <C-\><C-n><C-w>j
  tnoremap <A-k> <C-\><C-n><C-w>k
  tnoremap <A-l> <C-\><C-n><C-w>l
  nnoremap <A-h> <C-w>h
  nnoremap <A-j> <C-w>j
  nnoremap <A-k> <C-w>k
  nnoremap <A-l> <C-w>l
end

let g:netrw_banner=0
