""" GUI related settings
set guifont=WenQuanYi\ Micro\ Hei\ Mono\ 16
set winaltkeys=no
set mouse=

""" The pathogen plugin
let g:pathogen_disabled = []
call add(g:pathogen_disabled, 'some_plugin')

call pathogen#infect('plugins/{}')
call pathogen#helptags()

""" Common options
set hls ic scs is
set sts=4 sw=4 et

:let mapleader = "\\"

autocmd FileType tex,javascript,html,yaml set sts=2 sw=2
autocmd FileType rst set textwidth=79

syntax on
filetype plugin indent on

autocmd BufEnter * syntax sync fromstart
autocmd BufRead,BufNewFile *.tpl set filetype=jinja

set fileencodings^=utf8,gb18030

"set path^=~/work/**
set tags=./tags;,~/.tags.python

set completeopt-=preview
"set grepprg=ack\ -k\ --smart-case
set grepprg=ack\ --smart-case

set formatoptions-=t
set formatoptions+=aorw

set backspace=indent,eol,start

set timeoutlen=300


""" Key mappings
nnoremap <C-a> :set paste! paste?<CR>

nnoremap <C-]> g<C-]>
nnoremap g<C-]> <C-]>
vnoremap <C-]> g<C-]>
vnoremap g<C-]> <C-]>

nnoremap j gj
nnoremap gj j
nnoremap k gk
nnoremap gk k

imap <C-a> <C-o><C-a>

nnoremap <C-h> 25zh
nnoremap <C-l> 25zl

nnoremap <C-x>js :set filetype=javascript filetype?<CR>
nnoremap <C-x>cpp :set filetype=cpp filetype?<CR>
nnoremap <C-x>c :set filetype=c filetype?<CR>
nnoremap <C-x>jinja :set filetype=jinja filetype?<CR>

"nnoremap <C-x>wrap :set textwidth=79 formatoptions+=ta formatoptions-=c<CR>

nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <C-n>n :NERDTreeFind<CR>
nnoremap <C-n>t :tabe %<CR>:NERDTreeFind<CR>
nnoremap <C-n>p :tabe %<CR>:CtrlP<CR>
nnoremap <C-n>v :tabe<CR>:e $MYVIMRC<CR>
nnoremap <C-n>vv :source $MYVIMRC<CR>
nnoremap <C-n>ss :Obsession ~/.vim/sessions/default<CR>
nnoremap <C-n>s :call My_Prompt_Save_Session()<CR>
nnoremap <C-n>l :source ~/.vim/sessions/default<CR>
nnoremap <C-n>ll :call My_Prompt_Load_Session()<CR>

nnoremap <C-k> :TagbarToggle<CR>

" not necessary, but shows how to use v:count and condition in mapping...
nnoremap <expr> = (v:count == 0 ? v:count : '') . 'gt'
" the same as above, but much simpler:
"nnoremap = gt
nnoremap K gt
nnoremap + gT
nnoremap J gT
nnoremap _ :tabe<CR>

nnoremap -j :let g:NERDTreeQuitOnOpen = 1 - g:NERDTreeQuitOnOpen<CR>:let g:NERDTreeQuitOnOpen<CR>
nnoremap -p :set paste! paste?<CR>
nnoremap -n :setl nu! nu?<CR>
nnoremap -l :setl list! list?<CR>
nnoremap -s :call My_Toggle_Statusline()<CR>

" not so important ones:
"inoremap <F3> <C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR>


""" Helper functions
function! My_Prompt_Save_Session()
  call inputsave()
  let session_name = input("Save session: ")
  call inputrestore()
  redraw
  let file = '~/.vim/sessions/' . session_name
  execute 'Obsession' file
endfunction

function! My_Prompt_Load_Session()
  call inputsave()
  let session_name = input("Load session: ")
  call inputrestore()
  redraw
  let file = "~/.vim/sessions/" . session_name
  if !filereadable(expand(file))
    echo "Session file " . file . " does not exist."
  else
    execute 'source' file
  endif
endfunction

function! My_Toggle_Statusline()
  if !exists('g:show_status_line')
    let g:show_status_line = 1
  else
    let g:show_status_line = 1 - g:show_status_line
  endif
  if g:show_status_line
    set laststatus=2
    set statusline=%F
    set statusline+=%y
    set statusline+=%r
    set statusline+=%=
    set statusline+=%c,
    set statusline+=%l/%L
    set statusline+=\ \ \ \ \ \ \ %P
  else
    set laststatus=1
    set statusline=
  endif
endfunction

""" Tabline
set tabline=%!My_Tab_Line()

function! My_Tab_Line()
  let s = '' " complete tabline goes here

  let columns = &columns
  let total_length = 0

  let cur_tab = tabpagenr()
  let cur_tab_begin = 0
  let cur_tab_end = 0

  let tabs = []

  for t in range(tabpagenr('$'))
    " set tab number for mouse click (copied from the doc)
    let tab = {}
    let prefix = ''
    let body = ''

    let prefix .= '%' . (t+1) . 'T'
    if (t+1) == cur_tab
      let prefix .= '%#TabLineSel#'
      let cur_tab_begin = total_length
    else
      let prefix .= '%#TabLine#'
    endif

    let s .= prefix
    let tab.prefix = prefix
    let tab.begin = total_length

    let body .= ' ' . (t+1)

    " get buffer infos
    let bf_names = ''
    let n_modified = 0
    let bf_list = tabpagebuflist(t+1)
    let bf_num = len(bf_list)
    let i = 0
    for b in bf_list
      if getbufvar(b, "&modified")
        let n_modified += 1
      endif

      let name_to_add = ''
      let btype = getbufvar(b, "&buftype")
      let bname = bufname(b)
      "echom 'num:' b 'name:' bufname(b) 'buftype:' btype
      if btype == 'help'
        let name_to_add .= ':h-' . fnamemodify(bname, ':t:s/.txt$//')
      elseif btype == 'quickfix'
        continue
      elseif bname == ''
        let name_to_add .= '[New]'
      elseif bname =~# 'NERD_tree'
        let name_to_add .= '[N]'
      elseif bname =~# '__Tagbar__'
        let name_to_add .= '[K]'
      elseif bname =~# 'ControlP'
        let name_to_add .= '[P]'
      elseif bname =~# '__init__\.py$'
        let tmp = fnamemodify(bname, ':h:t')
        if len(tmp) > 5
          let tmp = substitute(tmp, '^\([^_ .]\{,5}\).*$', '\1', '')
        endif
        let tmp .= '/[init]'
        let name_to_add .= tmp
      else
        let known_exts = ['py', 'js', 'jsx']
        let ext = fnamemodify(bname, ':e')
        if index(known_exts, ext) >= 0
          let show_ext = 0
          let tmp = fnamemodify(bname, ':t:r')
        else
          let show_ext = 1
          let tmp = fnamemodify(bname, ':t')
        endif
        if len(tmp) > 10
          let oldtmp = tmp
          let tmp = substitute(oldtmp, '^\([^_ .]\{,5}\).*$', '\1', '')
          if len(tmp) <= 3
            let tmp = substitute(oldtmp, '^\([^ .]\{,7}\).*$', '\1', '')
          elseif len(tmp) == 4
            let tmp = substitute(oldtmp, '^\([^ .]\{,8}\).*$', '\1', '')
          endif
          if show_ext
            let tmp .= '.' . ext
          endif
        endif
        let name_to_add .= tmp
      endif

      let i += 1
      let bf_names .= ' ' . name_to_add
    endfor

    "echom bf_names
    if n_modified > 0
      let body .= '+'
      let total_length += len(bf_names) + 4
    else
      let total_length += len(bf_names) + 3
    endif
    if (t+1) == cur_tab
      let cur_tab_end = total_length
    endif
    "echom total_length cur_tab_begin cur_tab_end
    let body .= bf_names
    let body .= ' '

    let s .= body
    let tab.body = body
    let tab.end = total_length
    call add(tabs, tab)
  endfor

  "echom string(tabs)

  if total_length > columns
    let cur_tab_length = cur_tab_end - cur_tab_begin
    let tmp = (columns - cur_tab_length) * 1.0 / 2
    let show_range_begin = float2nr(ceil(cur_tab_begin - tmp))
    let show_range_end = float2nr(ceil(cur_tab_end + tmp))
    "echom total_length string(show_range_begin) string(show_range_end)
    if show_range_begin < 0
      let delta = 0 - show_range_begin
      let show_range_begin = 0
      let show_range_end = show_range_end + delta
    elseif show_range_end > total_length
      let delta = show_range_end - total_length
      let show_range_end = total_length
      let show_range_begin = show_range_begin - delta
    endif
    "echom total_length string(show_range_begin) string(show_range_end)

    " reassemble the tabs
    let s = ''
    for tab in tabs
      "echom string(tab)
      if tab.end <= show_range_begin || tab.begin >= show_range_end
        "echom 1
        continue
      elseif (tab.begin+1) < show_range_begin && tab.end > show_range_begin
        let delta = tab.end - show_range_begin
        let new_body = tab.body[(delta+2):]
        let tab.body = new_body
        "tab.body[0] = '<'
        "echom 2 delta new_body
      elseif tab.begin < show_range_end && tab.end > show_range_end
        let delta = show_range_end - tab.begin
        let new_body = tab.body[:(delta-1)]
        let tab.body = new_body
        "echom 3 delta new_body
      endif
      "echom string(tab)
      let s .= tab.prefix
      let s .= tab.body
    endfor
  endif

  let s .= '%#TabLineFill#%T'
  " right-align the label to close the current tab page
  "if tabpagenr('$') > 1
  "  let s .= '%=%#TabLine#%999Xclose'
  "endif

  return s
endfunction


""" Plugins

" netrw
let g:netrw_liststyle = 3
let g:netrw_winsize = 25
let g:netrw_browse_split = 4
let g:netrw_banner = 0

" neocomplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#enable_auto_select = 1
let g:neocomplete#auto_completion_start_length = 2

if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
"let g:neocomplete#force_omni_input_patterns.javascript = '[^. \t]\.\w*'

inoremap <expr> <C-g> neocomplete#undo_completion()
inoremap <expr> <C-l> neocomplete#complete_common_string()

"inoremap <expr> <S-Tab> pumvisible() ? neocomplete#close_popup() : "\<S-Tab>"
inoremap <expr> <CR> pumvisible() ? neocomplete#cancel_popup()."\<CR>" : "\<CR>"

" ultisnips
let g:UltiSnipsEditSplit = 'vertical'
let g:UltiSnipsSnippetsDir = '~/.vim/ultisnips'
let g:UltiSnipsSnippetDirectories = [$HOME.'/.vim/ultisnips']
let g:UltiSnipsExpandTrigger = "<C-Tab>"

let g:ulti_expand_res = 0
function! My_Ultisnips_Try_Expand()
  call UltiSnips#ExpandSnippet()
  return g:ulti_expand_res
endfunction

function! My_Neocomplete_Select_Candidate()
  if pumvisible()
    return neocomplete#close_popup()
  else
    return "\<Tab>"
  endif
endfunction

inoremap <silent> <Tab> <C-r>=(My_Ultisnips_Try_Expand() > 0) ? "" : My_Neocomplete_Select_Candidate()<CR>
" Interestingly, the following will not work:
" inoremap <expr> <Tab> (My_Ultisnips_Try_Expand() > 0) ? "" : 
" My_Neocomplete_Select_Candidate()

" ctrlp
let g:ctrlp_working_path_mode = 'a'

" nerdtree
let g:NERDTreeQuitOnOpen = 1

" tagbar
let g:tagbar_sort = 0

" vim-jsx
let g:jsx_ext_required = 0

" jedi
" don't forget to run `git submodule update --init` inside jedi's directory
let g:jedi#auto_vim_configuration = 0
let g:jedi#completions_enabled = 0

autocmd FileType python setlocal omnifunc=jedi#completions

let g:neocomplete#sources#omni#input_patterns.python = '\h\w*\|[^. \t]\.\w*'
" 'force' mode
let g:neocomplete#force_omni_input_patterns.python =
  \ '\%(^\s*@\|^\s*from .\+import \|^\s*from .\+import .*, \|^\s*from \|^\s*import \)\w*'

let g:jedi#goto_command = "<leader>]"
let g:jedi#goto_assignments_command = "<leader>["
let g:jedi#usages_command = "<leader>p"
let g:jedi#documentation_command = "<leader>d"
let g:jedi#rename_command = "<leader>r"


" when using vim-python3, the following is not needed
"py << EOF
"import sys
"import os
"sys.path[:0] = [
"    os.path.expanduser('~/.local/lib/python3.4/site-packages'),
"    '/usr/lib/python3.4/site-packages'
"]
"EOF

" vim-clang
" don't forget to install clang
let g:clang_auto = 0
let g:clang_c_completeopt = 'menuone'
let g:clang_cpp_completeopt = 'menuone'

let g:clang_c_options = '-std=gnu99 -Wall -Wextra -Wno-unused-parameter -Wno-unused-variable -Wno-unused-private-field'
let g:clang_cpp_options = '-std=c++11 -Wall -Wextra -Wno-unused-parameter -Wno-unused-variable -Wno-unused-private-field'

let g:neocomplete#force_omni_input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)\w*'
"let g:neocomplete#force_omni_input_patterns.cpp = '[^.[:digit:] 
"*\t]\%(\.\|->\)\w*\|\h\w*::\w*'
let g:neocomplete#force_omni_input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\w\+\|\h\w*::\w*'







" vim: set sts=2 sw=2 et:
