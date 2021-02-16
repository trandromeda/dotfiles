"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
"                                                                              "
"                       __   _ _ _ __ ___  _ __ ___                            "
"                       \ \ / / | '_ ` _ \| '__/ __|                           "
"                        \ V /| | | | | | | | | (__                            "
"                         \_/ |_|_| |_| |_|_|  \___|                           "
"                                                                              "
"                                                                              "
"++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

" be iMproved
set nocompatible

" Set leader
let mapleader= ","

" Use GUI colors in truecolor terminals
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
" set termguicolors

" Attempt to fix cursor shape
let &t_EI = "\<Esc>[1 q"
let &t_SR = "\<Esc>[3 q"
let &t_SI = "\<Esc>[5 q"
autocmd BufEnter * execute 'silent !echo -ne "' . &t_EI . '"'

"=====================================================
"" Vundle settings
"=====================================================

filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

    "-------------------=== Code/Project navigation ===-------------
    Plugin 'preservim/nerdtree'                 " File navigation
    Plugin 'tpope/vim-fugitive'                 " Git wrapper
    Plugin 'tpope/vim-rhubarb'                  " Github wrapper
    Plugin 'mhinz/vim-signify'                  " Show git file changes in gutter
    Plugin 'tpope/vim-unimpaired'               " Useful [] mappings
    Plugin 'stsewd/fzf-checkout.vim'            " Fzf + git branches and tags management

    "-------------------=== Other ===-------------------------------
    Plugin 'dracula/vim', { 'name': 'dracula' } " Add dracula theme
    Plugin 'junegunn/limelight.vim'             " Limelight
    Plugin 'vim-airline/vim-airline'            " Status bar plugin
    Plugin 'vim-airline/vim-airline-themes'     " Status bar plugin themes
    Plugin 'ryanoasis/vim-devicons'             " Adds icons to vim plugins
    Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plugin 'junegunn/fzf.vim'                   " Fuzzy finder plugins

    "-------------------=== Languages support ===-------------------
    Plugin 'tpope/vim-surround'                 " Parentheses, brackets, quotes, XML tags, and more
    Plugin 'tpope/vim-repeat'                   " Repeat plugin-enabled actions
    Plugin 'ycm-core/YouCompleteMe'             " Code completion, comprehension, refactoring engine
    Plugin 'tpope/vim-commentary'               " Comment stuff out
    Plugin 'plasticboy/vim-markdown'            " Markdown support
    Plugin 'JamshedVesuna/vim-markdown-preview' " Markdown preview
    Plugin 'honza/vim-snippets'                 " Useful snippet files for various programming languages
    Plugin 'lervag/vimtex'                      " LaTeX support
    Plugin 'KeitaNakamura/tex-conceal.vim'      " LaTeX concealment
    Plugin 'SirVer/ultisnips'                   " Snippet tool

    "-------------------=== Code linting/syntax ===-------------------
    Plugin 'dense-analysis/ale'                 " General purpose linter and fixer framework
    Plugin 'sheerun/vim-polyglot'               " General purpose language syntax highlighter
    Plugin 'godlygeek/tabular'                  " Tool for visual alignment

    "-------------------=== Tmux/terminal interaction ===-------------
    Plugin 'jpalardy/vim-slime'                 " Turn vim + tmux into REPL
    Plugin 'hanschen/vim-ipython-cell'          " Slime wrapper for iPython dev


" All of your Plugins must be added before the following line
call vundle#end()

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

filetype plugin indent on

" To ignore plugin indent changes, instead use:
" filetype plugin on


"=====================================================
"" YouCompleteMe settings
"=====================================================

" Virtualenv support
python3 << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  exec(open(activate_this).read(), dict(__file__=activate_this))
EOF

" Pipenv support
let pipenv_venv_path = system('pipenv --venv')
if shell_error == 0
  let venv_path = substitute(pipenv_venv_path, '\n', '', '')
  let g:ycm_python_interpreter_path = venv_path . '/bin/python'
else
  let g:ycm_python_interpreter_path = 'python'
endif

" Use Vim to configure interpreter and paths to add to sys.path
let g:ycm_python_sys_path = []
let g:ycm_extra_conf_vim_data = [
  \  'g:ycm_python_interpreter_path',
  \  'g:ycm_python_sys_path'
  \]
let g:ycm_global_ycm_extra_conf = '~/.global_ycm_extra_config.py'

" Custom mappings and settings
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_key_list_select_completion=[]
let g:ycm_key_list_previous_completion=[]

" GoToDefinition
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

" Toggle popup window
nmap <leader>D <plug>(YCMHover)

"=====================================================
"" ALE settings
"=====================================================

" Set linters
let g:ale_linters = {
\   'python': ['flake8'],
\   'markdown': ['markdownlint'],
\   'json': ['jq'],
\   'yaml': ['yamllint'],
\}

" Set fixers
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'python': ['black', 'isort'],
\   'markdown': ['prettier'],
\   'json': ['jq'],
\   'yaml': ['prettier'],
\}

" Set lint and fix occasions
let g:ale_linters_explicit = 1
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1
let g:ale_open_list = 1

" Customize linter feedback visuals
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️ '
highlight clear ALEErrorSign
highlight clear ALEWarningSign
let g:ale_set_highlights = 0

" Keybindings
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Language/env-specific settings
let g:ale_python_black_auto_pipenv = 1

"=====================================================
"" Airline settings
"=====================================================

let g:airline_theme = 'dracula'
let g:get_airline_powerline_fonts = 1
let g:airline_right_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_left_alt_sep= ''
let g:airline_left_sep = ''
let g:airline#extensions#branch#format = 2
let g:airline#extensions#branch#enabled = 1

" Enable ALE extensions in Airline
let g:airline#extensions#ale#enabled = 1

"=====================================================
"" Fugitive / Rhubarb settings
"=====================================================

" Point Fugitive to Flexport's GH instance
let g:github_enterprise_urls = ['https://github.flexport.io']

" Make going up a level easier for buffers with tree or blob
autocmd User fugitive
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif

" Autoclean buffer when traversing git repo
autocmd BufReadPost fugitive://* set bufhidden=delete


"=====================================================
"" Fugitive / Rhubarb settings
"=====================================================

" Define a diff of two branches with Fugitive
let g:fzf_branch_actions = {
      \ 'diff': {
      \   'prompt': 'Diff> ',
      \   'execute': 'Git diff {branch}',
      \   'multiple': v:false,
      \   'keymap': 'ctrl-f',
      \   'required': ['branch'],
      \   'confirm': v:false,
      \ },
      \}


"=====================================================
"" fzf settings
"=====================================================

" Enabling fzf (installed using Homebrew)
set rtp+=/usr/local/opt/fzf

" Add namespace for fzf.vim exported commands
let g:fzf_command_prefix = 'Fzf'

" Use preview when FzfFiles runs in fullscreen
command! -nargs=? -bang -complete=dir Files
  \ call fzf#vim#files(<q-args>,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" Make Ripgrep ONLY search file contents
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --hidden --ignore-case --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
  \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
  \   <bang>0)

" Mappings
nnoremap <silent> <leader>o :FzfFiles<CR>
nnoremap <silent> <leader>O :FzfFiles!<CR>
nnoremap <silent> <leader>b  :FzfBuffers<CR>
nnoremap <silent> <leader>rg  :FzfRg<CR>
nnoremap <silent> <leader>RG  :FzfRg!<CR>
nnoremap <silent> <leader>bl :FzfBLines<CR>
nnoremap <silent> <leader>S :FzfSnippets<CR>
nnoremap <silent> <leader>`  :FzfMarks<CR>
nnoremap <silent> <leader>p :FzfCommands<CR>
" nnoremap <silent> <leader>t :FzfFiletypes<CR>
nnoremap <silent> <F1> :FzfHelptags<CR>
inoremap <silent> <F1> <ESC>:FzfHelptags<CR>
cnoremap <silent> <expr> <C-p> getcmdtype() == ":" ? "<C-u>:FzfHistory:\<CR>" : "\<ESC>:FzfHistory/\<CR>"
cnoremap <silent> <C-_> <C-u>:FzfCommands<CR>


"=====================================================
"" vim-markdown, vim-markdown-preview settings
"=====================================================

let vim_markdown_preview_hotkey='<C-M>'
let vim_markdown_preview_github=1
let vim_markdown_preview_browser='Google Chrome'
let vim_markdown_preview_pandoc=1

let g:vim_markdown_folding_level = 2
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_new_list_item_indent = 0

" Avoid overwriting [c, ]c maps
let g:vim_markdown_no_default_key_mappings = 1

"=====================================================
"" vimtex, settings
"=====================================================

let g:tex_flavor='latex'
let g:vimtex_view_method='skim'
let g:vimtex_view_general_options = '-r @line @pdf @tex'
let g:vimtex_quickfix_mode=0
let g:vimtex_fold_enabled=1


"=====================================================
"" UltiSnips settings
"=====================================================

let g:UltiSnipsEnableSnipMate = 0
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
let g:UltiSnipsSnippetDirectories = [$HOME.'/.vim/bundle/vim-snippets/UltiSnips', $HOME.'/.vim/UltiSnips']


"=====================================================
"" Tex-conceal settings
"=====================================================

set conceallevel=1
let g:tex_conceal='abdmg'
hi Conceal ctermbg=none


"=====================================================
"" NERDTree settings
"=====================================================

" Open NERDTree
map <leader>nt :NERDTreeToggle<cr>
map <leader>ntb :NERDTreeFromBookmark<Space>
map <leader>ntf :NERDTreeFind<cr>

" Automatically close NERDTree on opening file
let NERDTreeQuitOnOpen = 1

" Automatically delete file buffer of deleted file in NERDTree
let NERDTreeAutoDeleteBuffer = 1

" NERDTree shows dotfiles by default
let NERDTreeShowHidden = 1

" Autoclose VIM if NERDTree is only window open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


"=====================================================
"" Limelight settings
"=====================================================

let g:limelight_conceal_ctermfg = 238
let g:limelight_paragraph_span = 1


"=====================================================
"" vim-slime settings
"=====================================================

let g:slime_target = "tmux"
let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}
let g:slime_python_ipython = 1


"=====================================================
"" File-specific settings
"=====================================================

" Automatically reread file if changed outside of vim
set autoread
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
  \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" Python settings
augroup Python
    au BufNewFile,BufRead *.py
      \ set tabstop=4 shiftwidth=4 expandtab textwidth=79 fileformat=unix
      \ autoindent smartindent
augroup END

" SQL settings
augroup SQL
    au BufNewFile,BufRead *.sql
      \ set tabstop=2 shiftwidth=2 expandtab textwidth=119 autoindent fileformat=unix
      \ commentstring=--\ %s
augroup END

" Textfile settings
let g:markdown_folding=1
let g:markdown_enable_folding = 1
augroup Textfiles
  autocmd BufNewFile,BufRead *.{md,markdown,mdown,mkd,mdtxt,Rmd,mkdn,tex,latex}
    \ set spell conceallevel=2 linebreak spelllang=en_us

  " Proper syntax highlighting for math mode
  autocmd FileType latex,tex,md,markdown syn region match start=/\\$\\$/ end=/\\$\\$/
  autocmd FileType latex,tex,md,markdown syn match math '\\$[^$].\{-}\$'

  " For markdown, hardwrap text at 80 characters
  autocmd FileType md,markdown set textwidth=80 formatoptions+=t

  " Fix spelling mistakes on fly
  autocmd FileType latex,tex,md,markdown inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

  " Change SpellBad format (ALE uses SpellBad for lint highlighting)
  autocmd FileType latex,tex,md,markdown highlight SpellBad ctermbg=None cterm=underline,bold ctermfg=9
augroup END

" YAML settings
augroup YAML
    autocmd BufNewFile,BufRead *.{yaml,yml}
      \ set filetype=yaml sts=2 sw=2 expandtab
augroup END


"=====================================================
"" General settings
"=====================================================

" Use ripgrep as default grep
set grepprg=rg\ --vimgrep


" Set no wrapping
set nowrap

" Set allow modified buffers to be hidden
set hidden

" Lower updatetime
set updatetime=500

" Syntax highlighting
syntax on

" Set color schemes
let g:dracula_colorterm = 0
colorscheme dracula
set cursorline
hi CursorLine cterm=underline term=underline ctermbg=NONE

" Ensure that changing background doesn't reset cursorline settings
au Colorscheme * hi CursorLine cterm=underline term=underline ctermbg=NONE

" Make gutter blend in with line numbers
highlight clear SignColumn

" Clean up vertical window separator
set fillchars+=vert:│

" Show invisible characters; toggle with F5
set list listchars=tab:▷⋅,trail:⋅,nbsp:⋅
noremap <F5> :set list!<CR>
inoremap <F5> <C-o>:set list!<CR>
cnoremap <F5> <C-c>:set list!<CR>

" Set line numbers
set number
set relativenumber

" 80 character ruler
set ruler
set colorcolumn=89

" Show [], (), {} matched pair
set showmatch

" Enable enhanced tab autocompletion for menu (e.g., :e)
set wildmenu
set wildmode=list:longest,full
set wildignore+=**/.git/**

" Search down into subfolders
set path+=**

" Easier split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Vertical split opens on right
" Horizontal split opens on bottom
set splitbelow
set splitright

" Search settings
set shortmess-=S
set incsearch
augroup vimrc-incsearch-highlight
                  autocmd!
                  autocmd CmdlineEnter /,\? :set hlsearch
                  autocmd CmdlineLeave /,\? :set nohlsearch
                augroup END
set ignorecase
set smartcase

" Shortcut for search and replace a word
nnoremap <leader>sw :%s/\<<C-r><C-w>\>//g<Left><Left>

" Set UTF-8 by default
set enc=utf-8
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set ttyfast

" Scroll let for 5 lines
set scrolloff=5

" ESC mappings
inoremap jk <Esc>
inoremap JK <Esc>
xnoremap jk <Esc>
cnoremap jk <C-c>
noremap <C-C> <ESC>
xnoremap <C-C> <ESC>

" Write/Quit mappings
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

" Italicize comments
highlight Comment cterm=italic gui=italic

" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

" Opens an edit command with the path of the currently edited file filled in
noremap <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Opens a tab edit command with the path of the currently edited file filled
noremap <leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

"" Move visual block
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Mouse scroll behavior
set mouse=a


"=====================================================
"" dbt development settings
"=====================================================

" Add .sql when typing gf (go to file under cursor if file is in same
" directory)
au BufNewFile,BufRead *.sql set suffixesadd+=.sql
au BufNewFile,BufRead *.md set suffixesadd+=.sql
au BufNewFile,BufRead *.yml set suffixesadd+=.sql

" Make sure you update the paths with the location of dbt in your environment!
" update path to look for files in dbt directories
au BufNewFile,BufRead *.sql set path+=$DBT_PROFILES_DIR/dbt/macros/**
au BufNewFile,BufRead *.sql set path+=$DBT_PROFILES_DIR/dbt/models/**

" yml and md are for opening files from dbt docs files
au BufNewFile,BufRead *.yml set path+=$DBT_PROFILES_DIR/dbt/macros/**
au BufNewFile,BufRead *.yml set path+=$DBT_PROFILES_DIR/dbt/models/**

au BufNewFile,BufRead *.md set path+=$DBT_PROFILES_DIR/dbt/macros/**
au BufNewFile,BufRead *.md set path+=$DBT_PROFILES_DIR/dbt/models/**


"=====================================================
"" Miscellaneous settings
"=====================================================

" Write daily note on exit
autocmd BufWritePost *dailynote-*.md silent! execute "!bash buildnote.sh %:p" | redraw!
