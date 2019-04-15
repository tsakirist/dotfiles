"---------------------------------------------------------------------------------------------------
" These are common keyboard shortcuts to remind myself
" <C-n> multiple cursors, <C-n> again to go to next, <C-x> to remove current cursor
" <Shift+i> toggle hidden files in NERDTree
" [count]\cc, comments out current line or count lines
" [count]\cu, uncomments the current line or count lines
"---------------------------------------------------------------------------------------------------

" Automate the process of installing vim-plug when required
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
     \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC 
endif

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'joshdick/onedark.vim'
Plug 'sjl/badwolf'
Plug 'sheerun/vim-polyglot'
Plug 'vim-python/python-syntax'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'scrooloose/nerdcommenter'
Plug 'terryma/vim-multiple-cursors'
Plug 'scrooloose/nerdtree'
Plug 'ervandew/supertab'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" Change linenumber coloring to white
augroup colorset
    autocmd!
    let s:white = { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" }
    autocmd ColorScheme * call onedark#set_highlight("LineNr", { "fg": s:white }) 
  augroup END

" Coloring configurations
syntax on
silent! colorscheme onedark

"highlight LineNr term=bold cterm=None ctermfg=Red ctermbg=None

" This displays the line numbers and controls the number of columns used for the line number
set number
set numberwidth=1

" This is used to control the Ctrl + C command and copy to the system's clipboard
set clipboard=unnamedplus

" This is used to preserve the clipboard when vim exits
autocmd VimLeave * call system("xclip -selection clipboard -i", getreg("+"))

" This inserts spaces when <Tab> is pressed. With this option set, if you want to enter a real tab character use Ctrl-V<Tab> key sequence
set expandtab

" This controls the number of space characters inserted when pressing the tab key
set tabstop=4

" This controls the number of space characeters inserted for identation
set shiftwidth=4

" These are required to enable powerline
set rtp+=/home/tsakiris/.local/lib/python2.7/site-packages/powerline/bindings/vim
set laststatus=2
set t_Co=256

" Open NERDTree automatically when vim starts
"autocmd vimenter * NERDTree

" Close NERDTree automatically when it is the only window left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Set this keyboard combination to toggle NERDTree, it's the same as Sublime Text 3
map <silent> <C-k><C-b> :NERDTreeToggle<CR>

" Set a ruler at column:120
set colorcolumn=120
highlight colorcolumn ctermbg=black

" Add space after commenting with NerdCommenter
let g:NERDSpaceDelims=1

" Keybinds to move lines like sublime text 3
nnoremap <silent> <C-S-Up> :m-2<CR>
nnoremap <silent> <C-S-Down> :m+<CR>
inoremap <C-S-Up> <Esc>:m-2<CR>
inoremap <C-S-Down> <Esc>:m+<CR>

" This is to hit ESC when inside a :term to get into normal mode
tnoremap <Esc> <C-\><C-N>

" This is to open windows always below or right
set splitbelow
set splitright

" Always highlight the line being edited
set cursorline
