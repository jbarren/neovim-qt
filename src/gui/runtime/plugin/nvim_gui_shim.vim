" A Neovim plugin that implements GUI helper commands
if !has('nvim') || exists('g:GuiLoaded')
  finish
endif
let g:GuiLoaded = 1

" A replacement for foreground()
function! GuiForeground() abort
  call rpcnotify(0, 'Gui', 'Foreground')
endfunction

" Set maximized state for GUI window (1 is enabled, 0 disabled)
function! GuiWindowMaximized(enabled) abort
  call rpcnotify(0, 'Gui', 'WindowMaximized', a:enabled)
endfunction

" Set fullscreen state for GUI window (1 is enabled, 0 disabled)
function! GuiWindowFullScreen(enabled) abort
  call rpcnotify(0, 'Gui', 'WindowFullScreen', a:enabled)
endfunction

" Set GUI font
function! GuiFont(fname, ...) abort
  let force = get(a:000, 0, 0)
  call rpcnotify(0, 'Gui', 'Font', a:fname, force)
endfunction

" Set additional linespace
function! GuiLinespace(height) abort
  call rpcnotify(0, 'Gui', 'Linespace', a:height)
endfunction

" The GuiFont command. For compatibility there is also Guifont
function s:GuiFontCommand(fname, bang) abort
  if a:fname ==# ''
    if exists('g:GuiFont')
      echo g:GuiFont
    else
      echo 'No GuiFont is set'
    endif
  else
    call GuiFont(a:fname, a:bang ==# '!')
  endif
endfunction
command! -nargs=? -bang Guifont call s:GuiFontCommand("<args>", "<bang>")
command! -nargs=? -bang GuiFont call s:GuiFontCommand("<args>", "<bang>")

function s:GuiLinespaceCommand(height) abort
  if a:height ==# ''
    if exists('g:GuiLinespace')
      echo g:GuiLinespace
    else
      echo 'No GuiLinespace is set'
    endif
  else
    call GuiLinespace(a:height)
  endif
endfunction
command! -nargs=? GuiLinespace call s:GuiLinespaceCommand("<args>")

" GuiDrop('file1', 'file2', ...) is similar to :drop file1 file2 ...
" but it calls fnameescape() over all arguments
function GuiDrop(...)
	let l:fnames = deepcopy(a:000)
	let l:args = map(l:fnames, 'fnameescape(v:val)')
	exec 'drop '.join(l:args, ' ')
	doautocmd BufEnter
endfunction
