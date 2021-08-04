" vim: et sw=2

" Function that checks if a plugin has been loaded or not
" Returns 1 if the plugin is loaded 0 otherwise
function! functions#PluginLoaded(plugin) abort
  return match(&rtp, a:plugin) != -1
endfunction

" Returns whether the supplied colorscheme is active
function! functions#ColorschemeActive(colorscheme) abort
  return exists('g:colors_name') && (g:colors_name == a:colorscheme)
endfunction

" Function to zoom-in and zoom-out from a window
function! functions#ZoomToggle() abort
  if exists('t:zoomed') && t:zoomed
    execute t:zoom_winrestcmd
    let t:zoomed = 0
  else
    let t:zoom_winrestcmd = winrestcmd()
    resize
    vertical resize
    let t:zoomed = 1
  endif
endfunction

" Function to trim trailing whitespace
" https://vi.stackexchange.com/a/456
function! functions#TrimTrailingWhitespace() abort
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfunction

" Function to make a whole word search faster
function! functions#SearchWord(word) abort
  " Write to the search pattern register '@/'
  let @/ = '\<' . a:word . '\>'
  normal n
endfunction

" Fills the current line with a double quote, a space and then adds the provided character 'c'
" as many times as needed to align the line with the previous one.
function! functions#Fill(c) abort
  exec 'norm  cc" '
  exec 'norm '.(strlen(getline(line('.') - 1)) - 2).'A'.nr2char(a:c)
endfunction

" Function to toggle either quickfix or location list
function! functions#ToggleList(list) abort
  if a:list == 'qf'
    call s:toggleQuickfixList()
  elseif a:list == 'loc'
    call s:toggleLocationList()
  else
    echoerr "Supplied argument '" . a:list . "' is invalid. Valid options ['qf', 'loc']."
  endif
endfunction

function! s:toggleQuickfixList() abort
  if getqflist({'winid': 0}).winid
    cclose
  else
    copen
  endif
endfunction

function! s:toggleLocationList() abort
  if getloclist(0, {'winid': 0}).winid
    lclose
  else
    lopen
  endif
endfunction

" When jumping to a diff hunk, print the hunk number in statusline
function! functions#ShowCurrentHunk() abort
  let h = sy#util#get_hunk_stats()
  if !empty(h)
    echo printf('[Hunk %d/%d]', h.current_hunk, h.total_hunks)
  endif
endfunction
