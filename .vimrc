" Configuration file for vim

" Prevent modelines in files from being evaluated (avoids a potential
" security problem wherein a malicious user could write a hazardous
" modeline into a file) (override default value of 5)
set modelines=0

" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set nocompatible	" Use Vim defaults instead of 100% vi compatibility
set backspace=indent,eol,start	" more powerful backspacing

" Now we set some defaults for the editor 
set autoindent		" always set autoindenting on
set foldmethod=indent
set foldlevel=99
set textwidth=72	
set nobackup		" Don't keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more than
			" 50 lines of registers
set history=500		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set incsearch
set background=dark
set tabstop=4
set expandtab
set shell=/bin/bash
set cpoptions+=$ " change com limites
set vb t_vb= " visual bell 
set clipboard=unnamed " copiar e colar com o registro do sistema
set hidden
set shiftwidth=4
set cinkeys=0{,0},:,0#,!<Tab>,!^F
set virtualedit=all " espaços virtuais
set wildmenu

" mapeando as mudancas de janela
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
filetype on
filetype indent on
filetype plugin on

" Code completion from hell
au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"
set completeopt=menuone,longest,preview

let mapleader = '_'
let maplocalleader = '_'

" Abrindo a TODO list
map <leader>td <Plug>TaskList

" Abrindo a lista de revisao
map <leader>g :GundoToggle<CR>CR

" Abrindo lista de arquivos
map <leader>n :NERDTreeToggle<CR>

let g:vimrplugin_term = "xterm"
let g:vimrplugin_nosingler = 1

"aunmenu ToolBar.FindNext
"aunmenu ToolBar.FindPrev
"aunmenu ToolBar.Print
"aunmenu ToolBar.SaveAll
"aunmenu ToolBar.Undo
"aunmenu ToolBar.Redo
"aunmenu ToolBar.SaveSesn
"aunmenu ToolBar.LoadSesn
"aunmenu ToolBar.RunScript
"aunmenu ToolBar.RunCtags

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" We know xterm-debian is a color terminal
if &term =~ "xterm-debian" || &term =~ "xterm-xfree86"
  set t_Co=16
  set t_Sf=[3%dm
  set t_Sb=[4%dm
endif

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

" Well-known emacs/tcsh keys
imap <C-A> <ESC>0i
nmap <C-A> <ESC>0
cmap <C-A> <Home>
nmap <C-E> $
imap <C-E> <ESC>A
" cmap <C-E> <HOME> is builtin


" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
endif

if has("autocmd")
 " Enabled file type detection
 " Use the default filetype settings. If you also want to load indent files
 " to automatically do language-dependent indenting add 'indent' as well.
 filetype plugin indent on
 
 autocmd FileType text setlocal textwidth=72
  
 autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

endif " has ("autocmd")

" Some Debian-specific things
augroup filetype
  au BufRead reportbug.*		set ft=mail
  au BufRead reportbug-*		set ft=mail
augroup END

augroup cprog
    au!
    autocmd BufRead *       set formatoptions=tcql nocindent comments&
    autocmd BufRead *.c,*.h set formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://
augroup END

" Set paper size from /etc/papersize if available (Debian-specific)
if filereadable('/etc/papersize')
  let s:papersize = matchstr(system('/bin/cat /etc/papersize'), '\p*')
  if strlen(s:papersize)
    let &printoptions = "paper:" . s:papersize
  endif
  unlet! s:papersize
endif


" The following are commented out as they cause vim to behave a lot
" different from regular vi. They are highly recommended though.
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase		" Do case insensitive matching
set incsearch		" Incremental search
set number
set shellslash
set grepprg=grep\ -nH\ $*
set autowrite		" Automatically save before commands like :next and :make

" User specific config
"
ab #i #include <>
ab #d #define
ab #f for(;;){}
ab #w while(){}

map *<C-V>  {!}par 

function! DelEmptyLineAbove()
    if line(".") == 1
        return
    endif
    let l:line = getline(line(".") - 1)
    if l:line =~ '^\s*$'
        let l:colsave = col(".")
        .-1d
        silent normal! <c-y>
        call cursor(line("."), l:colsave)
    endif
endfunction

function! AddEmptyLineAbove()
    let l:scrolloffsave = &scrolloff
    " Avoid jerky scrolling with ^E at top of window
    set scrolloff=0
    call append(line(".") - 1, "")
    if winline() != winheight(0)
        silent normal! <c-e>
    endif
    let &scrolloff = l:scrolloffsave
endfunction

function! DelEmptyLineBelow()
    if line(".") == line("$")
        return
    endif
    let l:line = getline(line(".") + 1)
    if l:line =~ '^\s*$'
        let l:colsave = col(".")
        .+1d
        ''
        call cursor(line("."), l:colsave)
    endif
endfunction

function! AddEmptyLineBelow()
    call append(line("."), "")
endfunction

" Arrow key remapping: Up/Dn = move line up/dn; Left/Right = indent/unindent
function! SetArrowKeysAsTextShifters()
    " normal mode
    nmap <silent> <right> >> 
    nmap <silent> <left> << 
    nnoremap <silent> <up> <esc>:call DelEmptyLineAbove() <cr> 
    nnoremap <silent> <down> <esc>:call AddEmptyLineAbove() <cr> 
    nnoremap <silent> <c-up> <esc>:call DelEmptyLineBelow() <cr> 
    nnoremap <silent> <c-down> <esc>:call AddEmptyLineBelow()  <cr>  

    " visual mode
    vmap <silent> <right> >
    vmap <silent> <left> <
    vnoremap <silent> <up> <esc>:call DelEmptyLineAbove()  <cr>  gv
    vnoremap <silent> <down> <esc>:call AddEmptyLineAbove()  <cr>  gv
    vnoremap <silent> <c-up> <esc>:call DelEmptyLineBelow()  <cr>  gv
    vnoremap <silent> <c-down> <esc>:call AddEmptyLineBelow()  <cr>  gv

    " insert mode
    imap <silent> <left> <c-d>
    imap <silent> <right> <c-t>
    inoremap <silent> <up> <esc>:call DelEmptyLineAbove() <cr> a
    inoremap <silent> <down> <esc>:call AddEmptyLineAbove() <cr> a
    inoremap <silent> <c-up> <esc>:call DelEmptyLineBelow() <cr> a
    inoremap <silent> <c-down> <esc>:call AddEmptyLineBelow() <cr> a

    " disable modified versions we are not using
    nnoremap  <s-up> <nop>
    nnoremap  <s-down> <nop>
    nnoremap  <s-left> <nop>
    nnoremap  <s-right> <nop>
    vnoremap  <s-up> <nop>
    vnoremap  <s-down> <nop>
    vnoremap  <s-left> <nop>
    vnoremap  <s-right> <nop>
    inoremap  <s-up> <nop>
    inoremap  <s-down> <nop>
    inoremap  <s-left> <nop>
    inoremap  <s-right> <nop>
endfunction

call SetArrowKeysAsTextShifters()

" Single insertion
function! RepeatChar(char, count)
    return repeat(a:char, a:count)
endfunction
nnoremap s :<C-U>exec "normal i".RepeatChar(nr2char(getchar()), v:count1)<cr>
nnoremap S :<C-U>exec "normal a".RepeatChar(nr2char(getchar()), v:count1)<cr>

" Add the virtualenv's site-packages to vim path
py << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
   project_base_dir = os.environ['VIRTUAL_ENV']
   sys.path.insert(0, project_base_dir)
   activate_this = os.path.join(project_base_dir,
   'bin/activate_this.py')
   execfile(activate_this, dict(__file__=activate_this))
EOF
