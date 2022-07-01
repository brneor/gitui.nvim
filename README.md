# THIS IS A WORK IN PROGRESS

This is a fork from [lazygit.nvim](https://github.com/kdheepak/lazygit.nvim).
# gitui.nvim

Plugin for calling [gitui](https://github.com/extrawurst/gitui) from within neovim.

See [akinsho/nvim-toggleterm](https://github.com/akinsho/nvim-toggleterm.lua#custom-terminals) or [voldikss/vim-floaterm](https://github.com/voldikss/vim-floaterm) as an alternative to this package.

### Install

Install using [`vim-plug`](https://github.com/junegunn/vim-plug):

```vim
" nvim v0.5.0
Plug 'brneor/gitui.nvim'
```

Feel free to use any plugin manager.
### Usage

The following are configuration options and their defaults.

```vim
let g:gitui_floating_window_winblend = 0 " transparency of floating window
let g:gitui_floating_window_scaling_factor = 0.9 " scaling factor for floating window
let g:gitui_floating_window_corner_chars = ['╭', '╮', '╰', '╯'] " customize gitui popup window corner characters
let g:gitui_floating_window_use_plenary = 0 " use plenary.nvim to manage floating window if available
let g:gitui_use_neovim_remote = 1 " fallback to 0 if neovim-remote is not installed
```

Call `:GitUi` to start a floating window with `gitui`.
And set up a mapping to call `:GitUi`:

```vim
" setup mapping to call :GitUi
nnoremap <silent> <leader>gg :GitUi<CR>
```

Open the configuration file for `gitui` directly from vim.

```vim
:GitUiConfig<CR>
```

If the file does not exist it'll load the defaults for you.

![](https://user-images.githubusercontent.com/1813121/78830902-46721580-79d8-11ea-8809-291b346b6c42.gif)

Open project commits with `gitui` directly from vim in floating window.

```vim
:GitUiFilter<CR>
```

Open buffer commits with `gitui` directly from vim in floating window.

```vim
:GitUiFilterCurrentFile<CR>
```

**Using neovim-remote**

If you have [neovim-remote](https://github.com/mhinz/neovim-remote) and have configured to use it in neovim, it'll launch the commit editor inside your neovim instance when you use `C` inside `gitui`.

1. `pip install neovim-remote`

2. Add the following to your `~/.bashrc`:

```bash
if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
    alias nvim=nvr -cc split --remote-wait +'set bufhidden=wipe'
fi
```

3. Set `EDITOR` environment variable in `~/.bashrc`:

```bash
if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
    export VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
    export EDITOR="nvr -cc split --remote-wait +'set bufhidden=wipe'"
else
    export VISUAL="nvim"
    export EDITOR="nvim"
fi
```

4. Add the following to `~/.vimrc`:

```vim
if has('nvim') && executable('nvr')
  let $GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
endif
```

If you have `neovim-remote` and don't want `gitui.nvim` to use it, you can disable it using the following configuration option:

```vim
let g:gitui_use_neovim_remote = 0
```

### Telescope Plugin

The Telescope plugin is used to track all git repository visited in one nvim session.

![gituitelplugin](https://user-images.githubusercontent.com/10464534/156933468-c89abee4-6afb-457c-8b02-55b67913aef2.png)
(background image is not included :smirk:)

**Why a telescope Plugin** ?

Assuming you have one or more submodule(s) in your project and you want to commit changes in both the submodule(s)
and the main repo.
Though switching between submodules and main repo is not straight forward.
A solution at first could be:

1. open a file inside the submodule
2. open gitui
3. do commit
4. then open a file in the main repo
5. open gitui
6. do commit

That is really annoying.
Instead, you can open it with telescope.

**How to use**

Install the plugin using:

```
use({
    "nvim-telescope/telescope.nvim",
    requires = { { "nvim-lua/plenary.nvim" }, { "brneor/gitui.nvim" } },
    config = function()
        require("telescope").load_extension("gitui")
    end,
})
```

Lazy loading `gitui.nvim` for telescope functionality is not supported. Open an issue if you wish to have this feature.

If you are not using Packer, to load the telescope extension, you have to add this line to your configuration:

```lua
require('telescope').load_extension('gitui')
```

By default the paths of each repo is stored only when gitui is triggered.
Though, this may not be convenient, so it possible to do something like this:

```vim
autocmd BufEnter * :lua require('gitui.utils').project_root_dir()
```

That makes sure that any opened buffer which is contained in a git repo will be tracked.

Once you have loaded the extension, you can invoke the plugin using:

```lua
lua require("telescope").extensions.gitui.gitui()
```
