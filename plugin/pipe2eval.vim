com! -nargs=+ Pipe2 call Pipe2eval(<f-args>)

let s:map_key_default = "<Space>"
let g:pipe2eval = expand('<sfile>:p:h') . '/pipe2eval.sh'

function! Pipe2eval(lang)
  let l:map_key = exists('g:pipe2eval_map_key') ? g:pipe2eval_map_key : s:map_key_default
  execute "vm <buffer> ". l:map_key ." :!". g:pipe2eval ." ". a:lang . " " . expand('%:p') . "<CR><CR>"
endfunction

au FileType * call Pipe2eval(&filetype)
