set nocompatible              " be iMproved, required
filetype off                  " required

"""" Vundle Settings

" set the runtime path to include Vundle and initialize
" for default
set rtp+=~/.vim/bundle/Vundle.vim
" for dev machine
" set rtp+=~/sunzhenkai/VimConfig/Vundle.vim

"" for default
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"" for dev machine
" call vundle#begin('~/sunzhenkai/VimConfig/VimPlugins')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
Plugin 'wincent/command-t.git'

" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

"""" personal plugins
Plugin 'scrooloose/nerdtree'
Plugin 'artur-shaik/vim-javacomplete2'
Plugin 'junegunn/fzf.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'scrooloose/syntastic'
Plugin 'ervandew/supertab'
Plugin 'davidhalter/jedi-vim'


"" themes
Plugin 'altercation/vim-colors-solarized'
Plugin 'altercation/solarized'
Plugin 'chriskempson/base16-vim'
Plugin 'chriskempson/base16-iterm2'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line


"""" plugin settings
"" command-t
let g:CommandTMaxFiles=20000000


"" NERDTree
" hot key
map <C-n> :NERDTreeToggle<CR>

"" vim-colors-solarized
set background=dark
colorscheme solarized


" 不显示隐藏文件
let g:NERDTreeHidden=0
let g:NERDTreeWinSize=42
" 过滤: 所有指定文件和文件夹不显示
let NERDTreeIgnore = ['\.pyc$', '\.swp', '\.swo', '\.vscode', '__pycache__']  

"" vim-javacomplete2
autocmd FileType java setlocal omnifunc=javacomplete#Complete



"""" Personal Settings
set nocompatible
set backspace=indent,eol,start
" set mouse=a
set tabstop=4
set softtabstop=4
set guifont=consolas
set shiftwidth=4
set expandtab
set autoindent
set smartindent
set laststatus=2
set history=5000
syntax on
set number

" 设置{回车自动补全并缩进
inoremap { {}<ESC>i
inoremap {<CR> {<CR>}<ESC>O

"" 设置热键
inoremap jj <ESC>
