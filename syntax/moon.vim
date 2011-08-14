" Language:    MoonScript
" Maintainer:  leafo <leafot@gmail.com>
" Based On:    CoffeeScript by Mick Koch <kchmck@gmail.com>
" URL:         http://github.com/leafo/moonscript-vim
" License:     WTFPL

" Bail if our syntax is already loaded.
if exists('b:current_syntax') && b:current_syntax == 'moon'
  finish
endif

if version < 600
  syn clear
endif

" Highlight long strings.
syn sync minlines=100

" These are `matches` instead of `keywords` because vim's highlighting
" priority for keywords is higher than matches. This causes keywords to be
" highlighted inside matches, even if a match says it shouldn't contain them --
" like with moonAssign and moonDot.
syn match moonStatement /\<\%(return\|break\)\>/ display
hi def link moonStatement Statement

syn match moonRepeat /\<\%(for\|while\)\>/ display
hi def link moonRepeat Repeat

syn match moonConditional /\<\%(if\|else\|elseif\|then\)\>/
\                           display
hi def link moonConditional Conditional

" syn match moonException /\<\%(try\|catch\|finally\)\>/ display
" hi def link moonException Exception

syn match moonKeyword /\<\%(export\|import\|from\|with\|in\|and\|or\|not\|class\|extends\|super\|do\)\>/
\                       display
hi def link moonKeyword Keyword

" bifs
syntax match moonBif /\<\%(table\.insert\|table\.concat\|module\|package\.seeall\|require\|print\|pairs\|ipairs\|rawset\|rawget\)\>/

" The first case matches symbol operators only if they have an operand before.
" need to put \ here
syn match moonExtendedOp /\%(\S\s*\)\@<=[+\-*/%&|\^=!<>?]\+\|\.\|\\\|!/
\                          display
hi def link moonExtendedOp moonOperator
hi def link moonOperator Operator

" This is separate from `moonExtendedOp` to help differentiate commas from
" dots.
syn match moonSpecialOp /[,;]/ display
hi def link moonSpecialOp SpecialChar

syn match moonBoolean /\<\%(true\|false\)\>/ display
hi def link moonBoolean Boolean

syn match moonGlobal /\<\%(nil\)\>/ display
hi def link moonGlobal Type

" A special variable
syn match moonSpecialVar /\<\%(self\)\>/ display
" An @-variable
syn match moonSpecialVar /@\%(\I\i*\)\?/ display
hi def link moonSpecialVar Special

" A class-like name that starts with a capital letter
syn match moonObject /\<\u\w*\>/ display
hi def link moonObject Structure

" A constant-like name in SCREAMING_CAPS
syn match moonConstant /\<\u[A-Z0-9_]\+\>/ display
hi def link moonConstant Constant

" A variable name
syn cluster moonIdentifier contains=moonSpecialVar,moonObject,
\                                     moonConstant

" A non-interpolated string
syn cluster moonBasicString contains=@Spell,moonEscape
" An interpolated string
syn cluster moonInterpString contains=@moonBasicString,moonInterp

" Regular strings
syn region moonString start=/"/ skip=/\\\\\|\\"/ end=/"/
\                       contains=@moonInterpString
syn region moonString start=/'/ skip=/\\\\\|\\'/ end=/'/
\                       contains=@moonBasicString
hi def link moonString String

" A integer, including a leading plus or minus
syn match moonNumber /\i\@<![-+]\?\d\+\%([eE][+-]\?\d\+\)\?/ display
" A hex number
syn match moonNumber /\<0[xX]\x\+\>/ display
hi def link moonNumber Number

" A floating-point number, including a leading plus or minus
syn match moonFloat /\i\@<![-+]\?\d*\.\@<!\.\d\+\%([eE][+-]\?\d\+\)\?/
\                     display
hi def link moonFloat Float

" An error for reserved keywords
if !exists("moon_no_reserved_words_error")
  syn match moonReservedError /\<\%(end\|function\|local\|repeat\)\>/
  \                             display
  hi def link moonReservedError Error
endif

" This is separate from `moonExtendedOp` since assignments require it.
syn match moonAssignOp /:/ contained display
hi def link moonAssignOp moonOperator

" Strings used in string assignments, which can't have interpolations
syn region moonAssignString start=/"/ skip=/\\\\\|\\"/ end=/"/ contained
\                             contains=@moonBasicString
syn region moonAssignString start=/'/ skip=/\\\\\|\\'/ end=/'/ contained
\                             contains=@moonBasicString
hi def link moonAssignString String

" A normal object assignment
syn match moonObjAssign /@\?\I\i*\s*:\@<!::\@!/
\                         contains=@moonIdentifier,moonAssignOp
hi def link moonObjAssign Identifier

" An object-string assignment
syn match moonObjStringAssign /\("\|'\)[^\1]*\1\s*;\@<!::\@!'\@!/
\                               contains=moonAssignString,moonAssignOp
" An object-integer assignment
syn match moonObjNumberAssign /\d\+\%(\.\d\+\)\?\s*:\@<!::\@!/
\                               contains=moonNumber,moonAssignOp

syn keyword moonTodo TODO FIXME XXX contained
hi def link moonTodo Todo

syn match moonComment /--.*/ contains=@Spell,moonTodo
hi def link moonComment Comment

" syn region moonBlockComment start=/####\@!/ end=/###/
" \                             contains=@Spell,moonTodo
" hi def link moonBlockComment moonComment

" syn region moonInterp matchgroup=moonInterpDelim start=/#{/ end=/}/ contained
" \                       contains=@moonAll
" hi def link moonInterpDelim PreProc

" A string escape sequence
syn match moonEscape /\\\d\d\d\|\\x\x\{2\}\|\\u\x\{4\}\|\\./ contained display
hi def link moonEscape SpecialChar

" Heredoc strings
" syn region moonHeredoc start=/"""/ end=/"""/ contains=@moonInterpString
" \                        fold
" syn region moonHeredoc start=/'''/ end=/'''/ contains=@moonBasicString
" \                        fold
" hi def link moonHeredoc String

" An error for trailing whitespace, as long as the line isn't just whitespace
if !exists("moon_no_trailing_space_error")
  syn match moonSpaceError /\S\@<=\s\+$/ display
  hi def link moonSpaceError Error
endif

" An error for trailing semicolons, for help transitioning from JavaScript
if !exists("moon_no_trailing_semicolon_error")
  syn match moonSemicolonError /;$/ display
  hi def link moonSemicolonError Error
endif

" Ignore reserved words in dot accesses.
syn match moonDotAccess /\.\@<!\.\s*\I\i*/he=s+1 contains=@moonIdentifier
hi def link moonDotAccess moonExtendedOp

" Ignore reserved words in prototype accesses.
syn match moonProtoAccess /::\s*\I\i*/he=s+2 contains=@moonIdentifier
hi def link moonProtoAccess moonExtendedOp

" This is required for interpolations to work.
syn region moonCurlies matchgroup=moonCurly start=/{/ end=/}/
\                        contains=@moonAll
syn region moonBrackets matchgroup=moonBracket start=/\[/ end=/\]/
\                         contains=@moonAll
syn region moonParens matchgroup=moonParen start=/(/ end=/)/
\                       contains=@moonAll

" These are highlighted the same as commas since they tend to go together.
hi def link moonBlock moonSpecialOp
hi def link moonBracket moonBlock
hi def link moonCurly moonBlock
hi def link moonParen moonBlock

" This is used instead of TOP to keep things moon-specific for good
" embedding. `contained` groups aren't included.
syn cluster moonAll contains=moonStatement,moonRepeat,moonConditional,
\                              moonKeyword,moonOperator,
\                              moonExtendedOp,moonSpecialOp,moonBoolean,
\                              moonGlobal,moonSpecialVar,moonObject,
\                              moonConstant,moonString,moonNumber,
\                              moonFloat,moonReservedError,moonObjAssign,
\                              moonObjStringAssign,moonObjNumberAssign,
\                              moonComment,
\                              moonSpaceError,moonSemicolonError,
\                              moonDotAccess,moonProtoAccess,
\                              moonCurlies,moonBrackets,moonParens

if !exists('b:current_syntax')
  let b:current_syntax = 'moon'
endif
