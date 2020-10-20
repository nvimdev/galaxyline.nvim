set rtp+=~/workstation/vim/galaxyline.nvim
set rtp+=~/.cache/vim/dein/repos/github.com/mhinz/vim-signify
set rtp+=~/.cache/vim/dein/repos/github.com/kyazdani42/nvim-web-devicons

set laststatus=2
set updatetime=100
set termguicolors

au BufReadPost,BufNewFile * lua require('lsp.lspinit').start_lsp_server()
