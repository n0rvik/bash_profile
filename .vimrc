syntax enable
colorscheme xoria256
"------------------------------------------------------------------------------
set number
set laststatus=2
set showmode
set showcmd
set ruler 
"------------------------------------------------------------------------------
set tabstop=4 
set softtabstop=4
set autoindent
set smartindent
set shiftwidth=4
set smarttab
set expandtab
"------------------------------------------------------------------------------
" Configure 256 colors for xterm mode
if &term =~ "xterm"
  let &t_Co=256
endif
