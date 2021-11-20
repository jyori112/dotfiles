" https://qiita.com/sugamondo/items/fcaf210ca86d65bcaca8
" を参照

" dein.vimインストール時に指定したディレクトリをセット
let s:dein_dir = expand('~/.cache/dein')

" dein.vimの実体があるディレクトリをセット
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vimが存在していない場合はgithubからclone
if &runtimepath !~# '/dein.vim'
    if !isdirectory(s:dein_repo_dir)
        execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
    endif
    execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)

    " dein.toml, dein_layz.tomlファイルのディレクトリをセット
    let s:toml_dir = expand('~/.config/nvim')

    " 起動時に読み込むプラグイン群
    call dein#load_toml(s:toml_dir . '/dein.toml', {'lazy': 0})

    " 遅延読み込みしたいプラグイン群
    call dein#load_toml(s:toml_dir . '/dein_lazy.toml', {'lazy': 1})

    call dein#end()
    call dein#save_state()
endif

filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif


" Theme
syntax enable
colorscheme gruvbox
set background=dark

"""""""""" Editor """"""""""
set encoding=utf8
set nobackup
set nowb
set noswapfile

" How many lines always to show below and above cursor
set scrolloff=7

" Show line number for each line
set number

" Height of command window
set cmdheight=2

" Show matching bracket when inserted
set showmatch

" Surpress bells
set noerrorbells
set novisualbell

" Configure cursor line
set cursorline
highlight CursorLine gui=underline cterm=underline
set cursorcolumn

" Tab
set expandtab   " Use spaces instead of tab
set autoindent  " Automatically insert indent for a new line
set tabstop=4   " Show <TAB> as 4 spaces
set shiftwidth=4    " How many spaces are inserted in autoindent

" Search
set ignorecase  " Ignore casing un search
set smartcase   " Ignore 'ignorecase' when query contains upper case
set hlsearch    " Highlight search result
set incsearch   " Show results while searching
" Remove (Do I need this?)
noremap <silent> <leader><cr> :noh<cr>

" NERDTree
nnoremap <C-e> :NERDTreeToggle<CR>

"""""""""" Move Around """"""""""
" Move around faster
nnoremap J 8j
nnoremap K 10k

" Move around in insert mode
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

" Move around in command mode
cnoremap <C-h> <Left>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-l> <Right>

" Editing
nnoremap <C-s> o<ESC>
nnoremap <C-d> O<ESC>
nnoremap <C-a> ea
nnoremap ; :

"""""""""" Folding """"""""""
set foldmethod=indent   " Fold according to indent (good for python?)
set foldlevelstart=20   " Set fold level when opened
nnoremap "a za
nnoremap "A zA

"""""""""" Windows """"""""""
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

"""""""""" Tabs """"""""""
nnoremap gr :tabr<CR>
nnoremap gl :tabl<CR>
nnoremap gm :tabm
nnoremap gc :tabclose<CR>

"""""""""" NERDTree """"""""""
nnoremap <C-e> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

"""""""""" Plugin: Deoplete """"""""""
let g:deoplete#enable_at_startup = 1
let g:python_host_prog = $NVIM_PYTHON2
let g:python3_host_prog = $NVIM_PYTHON3

