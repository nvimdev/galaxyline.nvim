set rtp+=~/workstation/vim/galaxyline.nvim
set rtp+=~/.local/share/nvim/site/pack/packer/start/nvim-web-devicons

" usage norcalli/profiler.nvim
" run with env AK_PROFILER=1 nvim -u min.vim 2>&1 >/dev/null | less
" core of galaxyline startup time: 0.7 ms
" load with eviline config time : 2.1ms

lua <<EOF
local profiler = require('profiler')
--require('internal.eviline')
profiler.wrap(require('galaxyline').load_galaxyline)
EOF
