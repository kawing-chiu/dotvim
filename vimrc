" GUI related settings
set guifont=WenQuanYi\ Micro\ Hei\ Mono\ 16
set winaltkeys=no
set mouse=

" The pathogen plugin
let g:pathogen_disabled = []
call add(g:pathogen_disabled, 'some_plugin')

call pathogen#infect('plugins/{}')
call pathogen#helptags()

" Common options
set hls ic scs is
set sts=4 sw=4 et

autocmd FileType tex,javascript,html set sts=2 sw=2
autocmd FileType rst set textwidth=79

syntax on
filetype plugin indent on

autocmd BufEnter * :syntax sync fromstart

set fileencodings^=utf8,gb18030

"set path^=~/work/**
set tags=./tags;,~/.tags.python

set completeopt-=preview
set grepprg=ack\ -k\ --smart-case

set formatoptions-=t
set formatoptions+=aorw

" Key mappings
nnoremap <C-a> :set paste! paste?<CR>

" not so important ones:
nnoremap <C-x>d :set filetype=htmldjango<CR>
nnoremap <C-x>j :set filetype=javascript<CR>

inoremap <F3> <C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR>


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
function Ultisnips_Try_Expand()
  call UltiSnips#ExpandSnippet()
  return g:ulti_expand_res
endfunction

function Neocomplete_Select_Candidate()
  if pumvisible()
    return neocomplete#close_popup()
  else
    return "\<Tab>"
  endif
endfunction

inoremap <silent> <Tab> <C-r>=(Ultisnips_Try_Expand() > 0) ? "" : Neocomplete_Select_Candidate()<CR>
" Interestingly, the following will not work:
" inoremap <expr> <Tab> (Ultisnips_Try_Expand() > 0) ? "" : Neocomplete_Select_Candidate()

" ctrlp
let g:ctrlp_working_path_mode = 'a'

" nerdtree
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <C-h> :NERDTreeFind<CR>

nnoremap <C-j> :let g:NERDTreeQuitOnOpen = 1 - g:NERDTreeQuitOnOpen<CR>

let g:NERDTreeQuitOnOpen = 1

" tagbar
nnoremap <C-k> :TagbarToggle<CR>
let g:tagbar_sort = 0

" vim-jsx
let g:jsx_ext_required = 0

" jedi
" don't forget to run `git submodule update --init` inside jedi's directory
let g:jedi#auto_vim_configuration = 0
let g:jedi#completions_enabled = 0

autocmd FileType python setlocal omnifunc=jedi#completions

let g:neocomplete#force_omni_input_patterns.python = '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'

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

let g:clang_c_options = '-std=gnu99'
let g:clang_cpp_options = '-std=c++11'

let g:neocomplete#force_omni_input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)\w*'
let g:neocomplete#force_omni_input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'


" other plugins

" The taglist plugin
let g:tlist_tex_settings = 'latex;s:sections;g:graphics;l:labels'
let g:tlist_php_settings = 'php;c:class;f:function'

" tern not quite working
" The tern_for_vim plugin
"autocmd FileType javascript nnoremap <buffer> <C-]> :TernDef<CR>
"autocmd FileType javascript nnoremap <buffer> <C-t> <C-o>


" 快捷键

" Run Python interpreter
":vnoremap <F5> :!python<Enter>

"" 下面以Alt键开头的快捷键还不能在terminal下使用，需要改进
"" xelatex编译快捷键
"nnoremap <M-x> :silent !(atril %:p:h/pdf/%:t.pdf &)<CR>
"nnoremap <M-c> :silent !(cd %:p:h; xelatex -output-directory=pdf %:t &)<CR>
"" 在insert mode下开新行/跳到下一个词的输入位置
"inoremap <M-o> <C-[>o
"inoremap <M-j> <C-[>Ea<Space>
"" \myitem系列快捷键
"inoremap <M-i> \myitem[]<C-o>h<C-o>l
"inoremap <M-I> \myitem<C-[>o
"" \lstlisting系列快捷键
"inoremap <M-l> \begin{lstlisting}<Enter>
"inoremap <M-L> \end{lstlisting}<Enter>
"inoremap <M-k> \lst<Bar><Bar><C-[>i
"nnoremap <M-k> i\lst<Bar><Esc>Ea<Bar><Esc>
"" 增加toc高亮快捷键
"nnoremap <M-d> mt$a-d-<C-[>`t
"nnoremap <M-t> mt$a-t-<C-[>`t
"nnoremap <M-r> mt$xxx`t


" vim: set sts=2 sw=2 et:
