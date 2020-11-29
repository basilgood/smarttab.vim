function! SmartIndent(to)
	let line = getline('.')
	let tabs = matchstr(line, '^\t*')
	if(line =~? '^\t* \+')
		" Continue smart-indenting
		let nspaces = strlen(matchstr(line, '^\t* \+')) - strlen(tabs)
	else
		let line = matchstr(line, '[^\t]*$')
		let nspaces = -1
		for char in a:to
			let nspaces = nspaces == -1? strridx(line, char) + 1: nspaces
		endfor
		if(nspaces == -1) | return "\<CR>" | endif
	endif
	let spaces = ''
	for space in range(nspaces)
		let spaces = spaces . ' '
	endfor
	return "\<CR>\<C-W>".tabs.spaces
endfunction

function! SmartIndentOn(chars, to)
	let lastchar = strpart(getline('.'), col('.')-2)
	for char in a:chars
		if(lastchar == char) | return SmartIndent(a:to) | endif
	endfor
	return "\<CR>"
endfunction

function! SmartIndentUnless(chars, to)
	let lastchar = strpart(getline('.'), col('.')-2)
	for char in a:chars
		if (lastchar == char) | return "\<CR>" | endif
	endfor
	return SmartIndent(a:to)
endfunction

function! CSmartIndent()
	return SmartIndentUnless([')', '{'], ['('])
endfunction

function! PySmartIndent()
	return SmartIndentOn([','], ['(', '[', '{'])
endfunction

function! SmartTab()
	let before = strpart(getline('.'), 0, col('.')-1)
	if before =~? '^\t*$' | return '	' | endif
	let sts=exists('b:insidetabs')?(b:insidetabs):((&softtabstop==0)?&shiftwidth:&softtabstop)
	let sp=(virtcol('.') % sts)
	if sp==0 | let sp=sts | endif
	return strpart('                                     ',0,1+sts-sp)
endfunction

function! SmartDelete()
	return "\<BS>"
endfunction

augroup file_types
	au!
	autocmd BufEnter *.c,*.cpp inoremap <CR> <C-R>=CSmartIndent()<CR>
	autocmd BufEnter *.py inoremap <CR> <C-R>=PySmartIndent()<CR>
augroup END

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<C-R>=SmartTab()<CR>"
