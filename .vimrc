runtime! macros/matchit.vim
runtime! debian.vim

colorscheme zellner
syntax on

:highlight Normal guibg=Black guifg=White
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

if has("autocmd")
  filetype indent on
endif


filetype plugin indent on

set showcmd " Show (partial) command in status line.
set showmatch " Show matching brackets.
set ignorecase " Do case insensitive matching
set smartcase " Do smart case matching
set incsearch " Incremental search
set autowrite " Automatically save before commands like :next and :make
set hidden " Hide buffers when they are abandoned
"set mouse=a " Enable mouse usage (all modes) in terminals
set history=1000
set cindent
set tabstop=4 " By default 4 indent spaces
set shiftwidth=4 " By default 4 indent spaces
set number " linenumber
set shiftround
set expandtab
set autoindent
set title
set scrolloff=4 " Keep 4 lines above and below cursor
set laststatus=2

set smarttab
set nocompatible
set ruler
set hlsearch " highlight results of a search

nnoremap <silent> <F2> :Tlist<CR>
nnoremap <silent> <F3> :NERDTreeToggle<CR>
nnoremap <silent> <F4> :set number!<CR>

let NERDTreeIgnore          =   ['\.pyc$','\.swp$','\.o$']
let NERDTreeMouseMode       =   3                     "single-click to open files/nodes
let NERDTreeWinPos          = 'left'
let NERDTreeSplitVertical   =   1                     "and open as vsplit
let NERDTreeChDirMode       =   2                     "change working dir when I change root
let NERDTreeShowBookmarks   =   1

" Un/Indent blocks with < >
vnoremap <TAB> >gv
vnoremap <S-TAB> <gv
" Remap the tab key to do autocompletion or indentation depending on the
" context (from http://www.vim.org/tips/tip.php?tip_id=102)
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

augroup myfiletypes
  " Clear old autocmds in group
  autocmd!
  " autoindent with two spaces, always expand tabs
  autocmd FileType ruby,eruby,yaml set ts=2 sts=2 sw=2 et
  autocmd FileType cpp set ts=2 sts=2 sw=2 et
  autocmd FileType c set noet ci pi ts=8 sts=0 sw=8
  autocmd FileType objc set noet ci pi ts=8 sts=0 sw=8
  autocmd Filetype make setlocal ts=8 sts=0 sw=8
augroup END

" markdown filetype file
"if exists("did\_load\_filetypes")
"    finish
"endif
augroup markdown
    au! BufRead,BufNewFile *.mkd   setfiletype mkd
augroup END
augroup mkd
    autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:>
augroup END

" Highlight useless whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$\| \+\ze\t/
match ExtraWhitespace /[^\t]\zs\t\+/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$/

inoremap <C-s> <esc>:w<cr>a
nnoremap <C-s> :w<cr>a

nnoremap <C-h> :call<SID>LongLineHLToggle()<cr>
hi OverLength ctermbg=none cterm=none
match OverLength /\%>80v/
fun! s:LongLineHLToggle()
 if !exists('w:longlinehl')
  let w:longlinehl = matchadd('ErrorMsg', '.\%>80v', 0)
  echo "Long lines highlighted"
 else
  call matchdelete(w:longlinehl)
  unl w:longlinehl
  echo "Long lines unhighlighted"
 endif
endfunction

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event
" handler (happens when dropping a file on gvim).
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
augroup END

"autocmd BufNewFile,BufRead COMMIT_EDITMSG setlocal spell
