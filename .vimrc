set runtimepath+=~/.vim_runtime

source ~/.vim_runtime/vimrcs/basic.vim
source ~/.vim_runtime/vimrcs/filetypes.vim
source ~/.vim_runtime/vimrcs/plugins_config.vim
source ~/.vim_runtime/vimrcs/extended.vim

try
source ~/.vim_runtime/my_configs.vim
catch
endtry

" Switch off folding
set nofoldenable

highlight ColorColumn ctermbg=233 guibg=#2c2d27
let &colorcolumn=join(range(80,120), ",")
autocmd! BufWritePost .vimrc source ~/.vimrc
