" GUI related settings
set guifont=WenQuanYi\ Micro\ Hei\ Mono\ 16
set winaltkeys=no
set mouse=

" The pathogen plugin
call pathogen#infect('plugins/{}')
call pathogen#helptags()

" Common options
set hls ic scs is et
set sts=4 sw=4

syntax on
filetype plugin indent on

set fileencodings^=utf8,gb18030

" Set search paths
set path^=~/work/**
set path^=~/exercise/**
set path^=~/notes/**/original/**
set tags=./tags;,~/.ctags.std

" Helper programs
set grepprg=egrep\ -n\ -s\ -irI\ --exclude-dir=\".svn\"\ --exclude-dir=\"doc\"\ $*\ /dev/null


" 下面以Alt键开头的快捷键还不能在terminal下使用，需要改进
" xelatex编译快捷键
nnoremap <M-x> :silent !(atril %:p:h/pdf/%:t.pdf &)<CR>
nnoremap <M-c> :silent !(cd %:p:h; xelatex -output-directory=pdf %:t &)<CR>
" 在insert mode下开新行/跳到下一个词的输入位置
inoremap <M-o> <C-[>o
inoremap <M-j> <C-[>Ea<Space>
" \myitem系列快捷键
inoremap <M-i> \myitem[]<C-o>h<C-o>l
inoremap <M-I> \myitem<C-[>o
" \lstlisting系列快捷键
inoremap <M-l> \begin{lstlisting}<Enter>
inoremap <M-L> \end{lstlisting}<Enter>
inoremap <M-k> \lst<Bar><Bar><C-[>i
" 增加toc高亮快捷键
nnoremap <M-d> mt$a-d-<C-[>`t
nnoremap <M-t> mt$a-t-<C-[>`t
nnoremap <M-r> mt$xxx`t
" C++输入快捷键
inoremap <M-s> std::
