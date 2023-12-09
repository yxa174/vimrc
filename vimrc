filetype off                 " required
autocmd BufRead,BufNewFile *.kv set filetype=python
"set filetype python
set shiftwidth=22
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
call plug#begin('~/.vim/plugged')
"Plug 'preservim/nerdtree'
"Plug 'VundleVim/Vundle.vim'
"Plug 'vim-airline/vim-airline'
"Plug 'tpope/vim-surround'
"Plug 'scrooloose/nerdcommenter' " cс закоментировать cu раскоментировать
call vundle#end()            " required
filetype plugin indent on    " required
call plug#end()
nnoremap <F2> :NERDTreeToggle<CR>
set number relativenumber
set autowrite
colorscheme desert
set background=dark
map <F5> :w<CR>:!python %<CR>
map <F2> :NERDTreeToggle<CR>
syntax on
inoremap <Tab> <C-n>
let g:ycm_python_binary_path = '/Library/Frameworks/Python.framework/Versions/3.10/bin/python3'
let g:ycm_server_python_interpreter = '/Library/Frameworks/Python.framework/Versions/3.10/bin/$

" Включение подсветки текущей строки
"set cursorline

" Включение подсветки совпадений при поиске
set hlsearch

" Включение автоматического переноса строк
set wrap

" Установка размера табуляции
set tabstop=4
set shiftwidth=4
set softtabstop=4

" Включение отображения пробелов и табуляций
set list
set listchars=tab:»·,trail:·

" Отключение создания файловых резервных копий
set nobackup
set nowritebackup

" Отключение создания резервных копий при использовании sudo
set noswapfile

" Сохранение файла при выходе из Vim
autocmd VimLeave * :wa
