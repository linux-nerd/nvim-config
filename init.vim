
echo '>^.^<'
let mapleader=";"
" <Leader> => \
" Example <Leader>sv => \sv
" {{{initialize vim plug
call plug#begin('~/.vim/plugged')

" ===============================
" add theme
" ===============================
Plug 'rakr/vim-one'
let g:airline_theme='one'

" nerdTree
Plug 'scrooloose/nerdtree'

" FZF Plugin
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" vim auto close
Plug 'townk/vim-autoclose'

" Code style {{{
Plug 'prettier/vim-prettier'
Plug 'editorconfig/editorconfig-vim'
" }}}

" tsx syntax highlight
Plug 'ianks/vim-tsx'

" ludovicchabant/vim-gutentags
Plug 'ludovicchabant/vim-gutentags'

" styled-components
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }

" import-js
Plug 'Galooshi/vim-import-js'

" pangloss/vim-javascript
Plug 'pangloss/vim-javascript'

" vim-json
Plug 'elzr/vim-json'

" vim-node
Plug 'moll/vim-node'

" yats
Plug 'HerringtonDarkholme/yats.vim'

" git {{{
Plug 'tpope/vim-fugitive'
Plug 'rhysd/git-messenger.vim'
" }}}

"css
Plug 'hail2u/vim-css3-syntax'

" Elm
Plug 'andys8/vim-elm-syntax'

" GraphQl
Plug 'jparise/vim-graphql'

" Code completion {{{
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete-buffer.vim'
Plug 'prabirshrestha/asyncomplete-file.vim'
" }}}

Plug 'scrooloose/syntastic'
Plug 'leafgarland/typescript-vim'

" ctrlsf.vim
Plug 'dyng/ctrlsf.vim'
Plug 'craigemery/vim-autotag'
" devicons for nerdtree
Plug 'ryanoasis/vim-devicons'
call plug#end()
" }}}


" ==============================
" initialize theme
" ==============================
colorscheme one
let g:one_allow_italics = 1
set background=light

"===============================
" nerdTree
" ==============================
let NERDTreeShowHidden=1
nnoremap <silent> <Space> :NERDTreeToggle<CR>

"===============================
" devicons
" ==============================
" set encoding=utf8
set guifont=Fira\ Code:h12
let g:airline_powerline_fonts = 1
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_conceal_nerdtree_brackets = 1

"==============================
" FZF
"==============================
nnoremap <expr> <C-p> (len(system('git rev-parse')) ? ':Files' : ':GFiles --exclude-standard --others --cached')."\<cr>"

"============================================================
" prettier/vim-prettier
"============================================================
let g:prettier#autoformat = 0
let g:prettier#config#print_width = 100
let g:prettier#config#tab_width = 4
let g:prettier#config#semi = 'false'
let g:prettier#config#single_quote = 'false'
let g:prettier#config#bracket_spacing = 'true'
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue PrettierAsync

"============================================================
" ludovicchabant/vim-gutentags
"============================================================
set statusline+=%{gutentags#statusline()}
let g:gutentags_ctags_tagfile = '.git/tags'
let g:gutentags_ctags_extra_args = ['--tag-relative'] " ensure these args are in sync with .git_template/hooks/ctags

"============================================================
" prabirshrestha/vim-lsp
"============================================================
let g:lsp_fold_enabled = 0
let g:lsp_virtual_text_prefix='‣ '

let g:lsp_signs_enabled = 1
let g:lsp_signs_error = {'text': '▎'}
let g:lsp_signs_warning = {'text': '▎'}
let g:lsp_signs_hint = {'text': '▎'}
let g:lsp_signs_information = {'text': '▎'}

let g:lsp_highlight_references_enabled = 0

nmap <Leader>t :LspHover<CR>
nmap <Leader>f :LspCodeAction<CR>
nmap <Leader>d :LspDefinition<CR>
nmap <Leader>r :LspRename<CR>
nmap <Leader>p :LspPeekDefinition<CR>
nmap ]e :LspNextError<CR>
nmap [e :LspPreviousError<CR>

"============================================================
" prabirshrestha/asyncomplete.vim
"============================================================
let g:asyncomplete_auto_popup = 0

autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

function! s:deduplicate_asyncomplete_preprocessor(options, matches) abort
    let l:visited = {}
    let l:items = []
    " deprioritize the buffer source since it's so noisy
    for [l:source_name, l:matches] in sort(items(a:matches), { i1, i2 -> i1[0] == 'buffer' ? 1 : 0 })
        for l:item in l:matches['items']
            if stridx(l:item['word'], a:options['base']) == 0
                if !has_key(l:visited, l:item['word'])
                    call add(l:items, l:item)
                    let l:visited[l:item['word']] = 1
                endif
            endif
        endfor
    endfor

    call asyncomplete#preprocess_complete(a:options, l:items)
endfunction

let g:asyncomplete_preprocessor = [function('s:deduplicate_asyncomplete_preprocessor')]

inoremap <expr> <Tab>      pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<Tab>" : asyncomplete#force_refresh()
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
"inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
"inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <S-Tab>    pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"

"============================================================
" vim-lsp setup
"============================================================
autocmd BufWritePre *.elm :silent LspDocumentFormatSync

if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'typescript (javascript-typescript-langserver)',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
        \ 'whitelist': ['typescript', 'typescriptreact'],
        \ })

endif

if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
      \ 'name': 'javascript (javascript-typescript-langserver)',
      \ 'cmd': { server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
      \ 'root_uri': { server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_directory(lsp#utils#get_buffer_path(), '.git/..'))},
      \ 'whitelist': ['javascript', 'javascriptreact']
      \ })
endif

if executable('elm-language-server')
    au User lsp_setup call lsp#register_server({
      \ 'name': 'elm (elm-language-server)',
      \ 'cmd': { server_info->[&shell, &shellcmdflag, 'elm-language-server --stdio']},
      \ 'root_uri': { server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'elm.json'))},
      \ 'whitelist': ['elm']
      \ })
endif

if executable('docker-langserver')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'docker-langserver',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'docker-langserver --stdio']},
        \ 'whitelist': ['dockerfile'],
        \ })
endif

if executable('pyls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->[&shell, $shellcmdflag, 'pyls']},
        \ 'whitelist': ['python'],
        \ })
endif

if executable('solargraph')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'solargraph',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'solargraph stdio']},
        \ 'initialization_options': {"diagnostics": "true"},
        \ 'whitelist': ['ruby'],
        \ })
endif

if executable('css-languageserver')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'css-languageserver',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'css-languageserver --stdio']},
        \ 'whitelist': ['css', 'less', 'sass'],
        \ })
endif

if executable(expand('~/lsp/kotlin-language-server/server/bin/kotlin-language-server'))
    au User lsp_setup call lsp#register_server({
        \ 'name': 'kotlin-language-server',
        \ 'cmd': {server_info->[
        \     &shell,
        \     &shellcmdflag,
        \     expand('~/lsp/kotlin-language-server/server/bin/kotlin-language-server')
        \ ]},
        \ 'whitelist': ['kotlin']
        \ })
endif

if executable('bash-language-server')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'bash-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'bash-language-server start']},
        \ 'whitelist': ['sh'],
        \ })
endif

au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
    \ 'name': 'file',
    \ 'whitelist': ['*'],
    \ 'priority': 10,
    \ 'completor': function('asyncomplete#sources#file#completor')
    \ }))

au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'buffer',
    \ 'whitelist': ['*'],
    \ 'blacklist': ['go'],
    \ 'completor': function('asyncomplete#sources#buffer#completor'),
    \ 'config': {
    \    'max_buffer_size': 5000000,
    \  },
    \ }))


set nogdefault

let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('~/vim-lsp.log')

"==============================
" syntastic
"==============================
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_enable_signs=1     " enables error reporting in the gutter
let g:syntastic_auto_loc_list=1    " when there are errors, show the quickfix window that lists those errors

"==============================
" system
" =============================

" Source nvimrc file
nnoremap <Leader>sv :source ~/.config/nvim/init.vim<CR>
nnoremap <Leader>pl :PlugInstall<CR>
nnoremap <Leader>pc :PlugClean<CR>

" set tab width to 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab

" ignore directories
set wildignore=*/node_modules,*/bower_components

" Enable line numbers
set number

" Enable syntax highlighting
syntax on

" Highlight current line
set cursorline

" Delete whole line in insert mode
imap <c-d> <esc>ddi

" Enable copy to clipboard
set clipboard=unnamed
