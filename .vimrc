" Handy vim commands and their break down
" qa0f'yi'_Pa = <Esc>_guiwjq3@a
" qa - start recording a macro named 'a'
" 0 - Move cursor to first column
" f' - Find first occurence of ' moving forwards
" y iw' - Yank the inner word ignoring the '
" a = <Esc> - Append ' = ' and enter command mode
" _ -  Move cursor to the first non-blank character from start of line
" gu iw - uncapitalize inner word selection
" j - go down one line
" q - stop recording macro
" 3@a - perform macro a 3 times
"
" search and replace across files with confirmation
" :args app/models/*
" :argdo %s/, :accessible => true//gec | update
"
" :wall - write all buffers
"
filetype off

call pathogen#runtime_append_all_bundles() 
call pathogen#helptags() 

" Settings from http://biodegradablegeek.com/2007/12/using-vim-as-a-complete-ruby-on-rails-ide/#configClaudia
" ====================================================================================================
filetype on  " Automatically detect file types.
filetype plugin on
filetype indent on
set nocompatible  " We don't want vi compatibility.
compiler ruby

"set ffs=unix

" Add recently accessed projects menu (project plugin)
set viminfo^=!

" Activate spelling
" set spell

set keywordprg=qri

" From http://www.mrkirkland.com/vim-japanese-os-x/
set enc=utf-8
set fenc=utf-8
set fencs=iso-2022-jp,euc-jp,cp932

" Minibuffer Explorer Settings
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1

" alt+n or alt+p to navigate between entries in QuickFix
map <silent> <m-p> :cp <cr>
map <silent> <m-n> :cn <cr>

" Change which file opens after executing :Rails command
let g:rails_default_file='config/database.yml'

syntax enable

" Additional settings from http://biodegradablegeek.com/2007/12/using-vim-as-a-complete-ruby-on-rails-ide/#config
" ===============================================================================================================

set cf  " Enable error files & error jumping.
set clipboard+=unnamed  " Yanks go on clipboard instead.
set history=1000 " Number of things to remember in history.
set autowrite  " Writes on make/shell commands
set ruler  " Ruler on
set nu  " Line numbers on
set nowrap  " Line wrapping off
set timeoutlen=250  " Time to wait after ESC (default causes an annoying delay)
" colorscheme vividchalk  " Uncomment this to set a default theme
" Easy access to paste mode
:map <F10> :set paste<CR>
:map <F11> :set nopaste<CR>
:imap <F10> <C-O>:set paste<CR>
:imap <F11> <nop>
:set pastetoggle=<F11>

" Formatting (some of these are for coding in C and C++)
set bs=2  " Backspace over everything in insert mode
set tabstop=2
set softtabstop=2
set shiftwidth=2
set nocp incsearch
set cinoptions=:0,p0,t0
set cinwords=if,else,while,do,for,switch,case
set formatoptions=tcqr
set cindent
set autoindent
set smarttab
set expandtab

nmap <D-{> <<
nmap <D-}> >>
vmap <D-{> <gv
vmap <D-}> >gv

" Visual
set showmatch  " Show matching brackets.
set mat=5  " Bracket blinking.
" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>

" Use the same symbols as TextMate for tabstops and EOLs
" Show $ at end of line and trailing space as ~
set listchars=tab:▸\ ,eol:¬,trail:~,extends:>,precedes:<
set list
"Invisible character colors
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59

set novisualbell  " No blinking .
set noerrorbells  " No noise.
set laststatus=2  " Always show status line.

" gvim specific
set mousehide  " Hide mouse after chars typed
set mouse=a  " Mouse in all modes

" Backups & Files
set backup                     " Enable creation of backup file.
set backupdir=~/.vim/backups " Where backups will go.
set directory=~/.vim/tmp     " Where temporary files will go.


" From Jamis Buck's config: http://weblog.jamisbuck.org/2008/11/17/vim-follow-up
let mapleader = ","
" set grepprg=ack
set grepformat=%f:%l:%m
set hlsearch
set backspace=start,indent
autocmd FileType make     set noexpandtab

" From http://github.com/twerth/dotfiles/blob/master/etc/vim/vimrc
" colorscheme ir_black

nmap <C-p>  :set paste<CR>:r !pbpaste<CR>:set nopaste<CR>
imap <C-p>  <Esc>:set paste<CR>:r !pbpaste<CR>:set nopaste<CR>
nmap <C-c>  :.w !pbcopy<CR><CR>
vmap <C-c>  :w !pbcopy<CR><CR>

nnoremap CC :!bundle exec cucumber features

" Toggle Scratch pad
function! ToggleScratch()
  if expand('%') == g:ScratchBufferName
      quit
  else
      Sscratch
  endif
endfunction

map <leader>s :call ToggleScratch()<CR>

" map Nerdtree toggle
nnoremap <leader>d :NERDTreeToggle<cr>

"============================================================
" From  http://items.sjbach.com/319/configuring-vim-right
set hidden "Manage multiple buffers -  current buffer to background etc

" Typing 'a will jump to the line and column marked with ma.
nnoremap ' `
nnoremap ` '

" show tab completion options
set wildchar=<Tab> wildmenu wildmode=full
" set wildmenu
" set wildmode=list:longest
" set wildignore+=media

" set terminal title
set notitle

"
" From http://dancingpenguinsoflight.com/2009/02/code-navigation-completion-snippets-in-vim/
" Taglist variables
" Display function name in status bar:
let Tlist_Ctags_Cmd = '/opt/local/bin/ctags'
let g:ctags_statusline=1
" Automatically start script
let generate_tags=1
" Displays taglist results in a vertical window:
let Tlist_Use_Horiz_Window=0
" Shorter commands to toggle Taglist display
nnoremap TT :TlistToggle<CR>
map <F4> :TlistToggle<CR>
" Various Taglist diplay config:
let Tlist_Use_Right_Window = 1
let Tlist_Compact_Format = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_File_Fold_Auto_Close = 1

" gist plugin
let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1

" autocmd BufWritePre FileType ruby,javascript,html :%s/\\\\\\\\s\\\\\\\\+$//


"ruby
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
"improve autocomplete menu color
highlight Pmenu ctermbg=238 gui=bold

" git blame selected line
" vmap <Leader>g :<C-U>!git blame <C-R>=expand("%:p") <CR> \\| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>
"
" Cheat!
command! -complete=file -nargs=+ Chit call Chit()
function! Chit(command)
botright new
setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
execute 'silent $read !chit @'.escape(a:command,'%#')
setlocal nomodifiable
1
endfunction
