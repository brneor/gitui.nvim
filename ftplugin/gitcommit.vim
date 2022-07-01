if exists("g:gitui_opened") && g:gitui_opened && g:gitui_use_neovim_remote && executable("nvr")
    augroup gitui_neovim_remote
      autocmd!
      autocmd BufUnload <buffer> :lua local root = require('gitui').project_root_dir(); vim.schedule(function() require('gitui').gitui(root) end)
      autocmd BufUnload <buffer> :let g:gitui_opened=0
    augroup END
end
