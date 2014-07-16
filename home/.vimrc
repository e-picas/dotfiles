"
" .vimrc <http://vimdoc.sourceforge.net/htmldoc/starting.html#.vimrc>
" by @pierowbmstr (me at e-piwi dot fr)
" <http://github.com/piwi/dotfiles.git>
" (personal) file licensed under CC BY-NC-SA 4.0 <http://creativecommons.org/licenses/by-nc-sa/4.0/>
"

" Sets how many lines of history VIM has to remember
set history=700

" show line numbers
set number
set numberwidth=4

" Set to auto read when a file is changed from the outside
set autoread

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc

" Always show current position
set ruler

" Height of the command bar
set cmdheight=2

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Enable syntax highlighting
syntax enable

colorscheme desert
set background=dark

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions+=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
" set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai " Auto indent
set si " Smart indent
set wrap " Wrap lines

" Always show the status line
set laststatus=2

" Format the status line
set statusline=
set statusline+=%#error#\                                           " error highlighting
set statusline+=%1*[%n]%*                                           " buffer number
set statusline+=%#error#\                                           " error highlighting
set statusline+=%F%m%r%h\ %w\                                       " file flags and path 
set statusline+=[%{strlen(&ft)?&ft:'none'},                         " file type
set statusline+=%{strlen(&fenc)?&fenc:&enc},                        " file encoding
set statusline+=%{&fileformat}]\                                    " file format
set statusline+=%*                                                  " stop highlighting
set statusline+=\ CWD:\ %r%{getcwd()}%h                             " current working dir
set statusline+=%=                                                  " right align
set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}\   " current line type
set statusline+=%#todo#\                                            " todo highlighting
set statusline+=line:\ %l\ \|\                                      " line number
set statusline+=column:\ %c\ \|\                                    " column number
set statusline+=%<%P\                                               " position percentage
set statusline+=%*                                                  " stop highlighting

" Remap VIM 0 to first non-blank character
map 0 ^

" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX files.
function! AppendModeline()
  let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
        \ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

" Endfile
" vim: autoindent tabstop=4 shiftwidth=4 expandtab softtabstop=4 filetype=off
