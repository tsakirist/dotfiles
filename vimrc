" Automate the process of installing vim-plug when required
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
     \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC 
endif

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'sheerun/vim-polyglot'
Plug 'vim-python/python-syntax'
"Plug 'vim-jp/vim-cpp'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'joshdick/onedark.vim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" Change linenumber coloring to white
augroup colorset
    autocmd!
    let s:white = { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" }
    autocmd ColorScheme * call onedark#set_highlight("LineNr", { "fg": s:white }) " `bg` will not be styled since there is no `bg` setting
  augroup END

syntax on
colorscheme onedark
"highlight LineNr term=bold cterm=None ctermfg=Red ctermbg=None
set number
set numberwidth=1
set clipboard=unnamedplus
"set background=dark
set tabstop=4
set shiftwidth=4
set expandtab

" these are required to enable powerline
set rtp+=/home/tsakiris/.local/lib/python2.7/site-packages/powerline/bindings/vim
set laststatus=2
set t_Co=256
