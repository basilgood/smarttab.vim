function! SmartTab()
  let before = strpart(getline('.'), 0, col('.')-1)
  if before =~? '^\t*$' | return "\<Tab>" | endif
  let l:sts=(&l:softtabstop > 0) ? &l:softtabstop : ((&l:shiftwidth > 0) ? &l:shiftwidth : &l:tabstop)
  let l:sp=(virtcol('.') % l:sts)
  if l:sp==0 | let l:sp=l:sts | endif
  return strpart('                  ',0,1+l:sts-l:sp)
endfunction

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<C-R>=SmartTab()<CR>"
