set shell=/bin/sh
set nocompatible

scripte utf-8
" set fencs=ucs-bom,cp949,utf-8

call plug#begin('~/.vim/plugged')
Plug 'christoomey/vim-tmux-navigator'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-obsession'
Plug 'bling/vim-airline'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'kshenoy/vim-signature'
Plug 'raichoo/purescript-vim'
Plug 'wavded/vim-stylus'
Plug 'dag/vim-fish'
Plug 'chrisbra/Recover.vim'
Plug 'pangloss/vim-javascript'
Plug 'tpope/vim-vinegar'
Plug 'elmcast/elm-vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tikhomirov/vim-glsl'
Plug 'sirtaj/vim-openscad'
Plug 'leafgarland/typescript-vim'
Plug 'altercation/vim-colors-solarized'
Plug 'morhetz/gruvbox'
Plug 'vim-scripts/synic.vim'
Plug 'endel/vim-github-colorscheme'
Plug 'simnalamburt/vim-mundo'
" Plug 'jiangmiao/auto-pairs'
" local plugins
if filereadable($HOME . "/.vim/plugin.vim")
    source ~/.vim/plugin.vim
endif
call plug#end()

" use space for leader
let mapleader=" "

filetype plugin indent on
filetype indent on
filetype on

set title

set ruler
set showcmd
set number
hi clear SpellBad
hi SpellBad cterm=bold ctermbg=lightmagenta

" Restore the last editing position
au BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$")  && &filetype != "gitcommit"
\ | exe "norm g`\""
\ | endif

set hlsearch
set incsearch
set nowrapscan
set backspace=indent,eol,start
set autoindent
set ve=onemore " enable moving to the end of the line

sy enable
set tabstop=2
set shiftwidth=2
set softtabstop=2
" set smarttab
set expandtab

" hide certain file types in netrw
let g:netrw_list_hide= '.*\.swp$,.*\.pyc$'

" :w!! to save with sudo
cmap w!! %!sudo tee > /dev/null %

" Highlight EOL whitespace, http://vim.wikia.com/wiki/Highlight_unwanted_spaces
highlight ExtraWhitespace ctermbg=darkred guibg=#382424
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/

" The above flashes annoyingly while typing, be calmer in insert mode
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/

function! s:FixWhitespace(line1,line2)
    let l:save_cursor = getpos(".")
    silent! execute ':' . a:line1 . ',' . a:line2 . 's/\s\+$//'
    call setpos('.', l:save_cursor)
endfunction

" Run :FixWhitespace to remove end of line white space
command! -range=% FixWhitespace call <SID>FixWhitespace(<line1>,<line2>)

set fillchars+=vert:│
hi VertSplit ctermfg=White ctermbg=Black term=NONE

" local.vim example:
" set fencs=ucs-bom,utf-8,cp949
" autocmd BufReadPre *.aes set nobackup
" autocmd BufReadPre *.aes set nowritebackup
" autocmd BufReadPre *.aes set noswapfile
" nnoremap <C-v> "+P
" vnoremap <C-v> "+P
" vnoremap <C-c> "+ygv

" airline settings
set laststatus=2
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_section_b=''

hi Search ctermbg=LightYellow ctermfg=Black
hi Constant ctermfg=DarkBlue
hi Comment ctermfg=Red cterm=italic
hi Visual ctermbg=LightMagenta
" color of matching parenthesis
hi MatchParen cterm=bold ctermbg=lightblue ctermfg=black

hi clear SignColumn
hi GitGutterAdd ctermfg=Green
hi GitGutterChange ctermfg=DarkYellow
hi GitGutterDelete ctermfg=Red
hi GitGutterChangeDelete ctermfg=Red

autocmd BufNewFile,BufReadPost *.md set filetype=markdown

"" ctrl+c to copy
"vmap <C-c> "*y

augroup rainbow
    autocmd!
    autocmd FileType haskell,python,javascript RainbowParentheses
augroup END

set ttimeoutlen=0
set wildmenu

set swapfile
set dir=~/tmp

nnoremap <C-s> :w<CR>
inoremap <C-s> <ESC>:w<CR>

" Curlier (mostly for OpenSCAD)

:command! Curlier
    \ execute ':w'
    \ | execute ':silent !curlier %'
    \ | execute ':redraw!'

autocmd FileType openscad
    \ nnoremap <buffer> <C-s> :Curlier<CR>
    \ | inoremap <buffer> <C-s> <ESC>:Curlier<CR>
    \ | setlocal commentstring=//\ %s

:command! Saha
    \ execute ':w'
    \ | execute ':silent !saha compile'
    \ | execute ':redraw!'

" 79th and 80th column is colored. From
" https://github.com/simnalamburt/.dotfiles/blob/master/.vimrc
set textwidth=78
set colorcolumn=+1,+2
hi ColorColumn ctermbg=lightgray
set formatoptions-=t
set formatoptions+=c
set formatoptions+=r

autocmd FileType markdown,text
    \ nnoremap <F5> :Saha<CR>
    \ | inoremap <F5> <ESC>:Saha<CR>
    \ | setlocal formatoptions=q
    \ | setlocal formatoptions-=c
    \ | setlocal colorcolumn=
autocmd FileType gitcommit
    \ set smarttab
    \ | setlocal formatoptions+=t
    \ | setlocal textwidth=72
autocmd FileType markdown,gitcommit,haskell setlocal spell

" turn off spell checking
nnoremap <leader>` :set spell!<CR>

" visually select the last inserted text
nnoremap gV `[v`]

" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

" backspace is down
nnoremap <backspace> i<backspace>
vnoremap <backspace> "_d

" Haskell spell checking for comments only
autocmd FileType haskell
    \ syn match   hsLineComment      "---*\([^-!#$%&\*\+./<=>\?@\\^|~].*\)\?$" contains=@Spell
    " \ | syn region  hsPragma	       start="{-#" end="#-}" contains=hsBlockComment
    \ | syn region  hsBlockComment     start="{-"  end="-}" contains=hsBlockComment,@Spell
    \ | syn region  hsPragma	       start="{-#" end="#-}" contains=hsBlockComment
    " \ | syn match  hsBlockComment     "{-.*-}" contains=@Spell
    \ | setlocal spell

" vim-tmux-navigator: navigate even in insert mode
imap <C-h> <ESC><C-h>
imap <C-j> <ESC><C-j>
imap <C-k> <ESC><C-k>
imap <C-l> <ESC><C-l>

" add nix filetype
au BufNewFile,BufRead *.nix set filetype=nix

" stylus
autocmd FileType stylus
    \ setlocal nocin nosi inde=
    \ | setlocal ai

" Disable H in visual mode (I make this mistake too often)
vnoremap H h

" Disable q
nnoremap q <Nop>

" hsc is Haskell
au BufRead,BufNewFile *.hsc set filetype=haskell

" fzf
nnoremap <C-p> :FZF<CR>
let g:fzf_layout = { 'down': '~25%' }

" Reading the local conf should always be at the bottom
if filereadable($HOME . "/.vim/local.vim")
    source ~/.vim/local.vim
endif

" C-a and C-e instead of ^ and $
nnoremap <C-a> ^
vnoremap <C-a> ^
nnoremap <C-e> $
vnoremap <C-e> $

command! PasteClipboard normal! "+p

" gvim: turn off all useless stuff
set guioptions=f
set guifont=Roboto\ Mono\ 12
set mouse=
set guicursor+=n-v-c-i:blinkon0  " disable cursor blinking

" nnoremap <C-v> "+P
" vnoremap <C-v> "+P
vnoremap <C-c> "+ygv

" Haskell spell checking for comments only
syn match   hsLineComment      "---*\([^-!#$%&\*\+./<=>\?@\\^|~].*\)\?$" contains=@Spell
syn region  hsBlockComment     start="{-"  end="-}" contains=hsBlockComment,@Spell

" sort the current paragraph
nnoremap <leader>s vip:sort<CR>

" " ctrlp
" let g:ctrlp_cmd = 'CtrlPMRU'

" insert ISO 8601 timestamp
nnoremap <leader>d i<C-r>=strftime("%FT%T%z")<CR><Esc>
nnoremap <leader>t i<C-r>=strftime("%s")<CR><Esc>

" Don't add stupid extra space when joining lines that end with a period
set nojoinspaces

" jump to definition in the right split
nnoremap <leader>] :only<CR><C-w>v<C-w>L<C-]>

" paste clipboard
nnoremap <leader>p :PasteClipboard<CR>

" I don't use K
nnoremap K k

" Use 4 spaces for indentation in Python
autocmd FileType python
  \ setlocal tabstop=4
  \ | setlocal shiftwidth=4
  \ | setlocal softtabstop=4

" Prevent Vim from clearing the terminal
" set t_ti=
" set t_te=

" cursorline
set cursorline
hi CursorLine cterm=NONE ctermbg=255 ctermfg=NONE guibg=LightYellow guifg=NONE
augroup CursorLine
    au!
    au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    au WinLeave * setlocal nocursorline
augroup END
