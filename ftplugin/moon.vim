" Language:    MoonScript
" Maintainer:  leafo <leafot@gmail.com>
" Based On:    CoffeeScript by Mick Koch <kchmck@gmail.com>
" URL:         http://github.com/leafo/moonscript-vim
" License:     WTFPL

if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

setlocal formatoptions-=t
setlocal comments=:--
setlocal commentstring=--\ %s

let b:undo_ftplugin = "setlocal commentstring< comments< formatoptions<"

if !has("ruby")
  echohl WarningMsg
  echo "Coffee auto tag requires Vim to be compiled with Ruby support"
  echohl none
  finish
endif

let s:CoffeeAutoTagFile="./tags"
let s:CoffeeAutoTagIncludeVars=0
let s:CoffeeAutoTagTagRelative=1

if !exists("g:CoffeeAutoTagDisabled")
  let g:CoffeeAutoTagDisabled = 0
endif

if exists("g:CoffeeAutoTagFile")
  let s:CoffeeAutoTagFile = g:CoffeeAutoTagFile
endif

if exists("g:CoffeeAutoTagIncludeVars")
  let s:CoffeeAutoTagIncludeVars = g:CoffeeAutoTagIncludeVars
endif

if exists("g:CoffeeAutoTagTagRelative")
  let s:CoffeeAutoTagTagRelative = g:CoffeeAutoTagTagRelative
endif

if s:CoffeeAutoTagIncludeVars
  let s:raw_args="--include-vars"
else
  let s:raw_args=""
endif

let g:tagbar_type_moon = {
      \   'ctagsbin' : 'coffeetags',
      \   'ctagsargs' : s:raw_args,
      \   'kinds' : [
      \     'f:functions',
      \     'o:object',
      \   ],
      \   'sro' : ".",
      \   'kind2scope' : {
      \     'f' : 'object',
      \     'o' : 'object',
      \   }
      \ }


function! CoffeeAutoTag()
  if g:CoffeeAutoTagDisabled
    finish
  endif

  let cmd = 'coffeetags --append -f ' . s:CoffeeAutoTagFile . ' '

  if s:CoffeeAutoTagIncludeVars
    let cmd .= '--include-vars '
  endif

  if s:CoffeeAutoTagTagRelative
    let cmd .= '--tag-relative '
  endif

  let cmd .= expand("%:p")

  let output = system(cmd)

  if exists(":TlistUpdate")
    TlistUpdate
  endif
endfunction

augroup CoffeeAutoTag
  au!
  autocmd BufWritePost,FileWritePost *.moon call CoffeeAutoTag()
augroup END



