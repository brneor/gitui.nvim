local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local action_set = require("telescope.actions.set")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values
local gitui_utils = require("gitui.utils")


local function open_gitui(prompt_buf)
    local entry = action_state.get_selected_entry()
    vim.fn.execute('cd ' .. entry.value)

    local cmd = [[lua require"gitui".gitui(nil)]]
    vim.api.nvim_command(cmd)

    vim.cmd('stopinsert')
    vim.cmd([[execute "normal i"]])
    vim.fn.feedkeys('j')
    vim.api.nvim_buf_set_keymap(0, 't', '<Esc>', '<Esc>', {noremap = true, silent = true})
end


local gitui_repos = function(opts)
    local displayer = require("telescope.pickers.entry_display").create {
        separator = "",
        -- TODO: make use of telescope geometry
        items = {
            {width = 4},
            {width = 55},
            {remaining = true},
        },
    }

    local repos = {}
    for _, v in pairs(gitui_utils.gitui_visited_git_repos) do
        if v == nil then
            goto skip
        end

        local index = #repos + 1
        local entry =
        {
            idx = index,
            value = v:gsub("%s", ""),
            -- retrieve git repo name
            repo_name= v:gsub("%s", ""):match("^.+/(.+)$"),
        }

        table.insert(repos, index, entry)

        ::skip::
    end

    pickers.new(opts or {}, {
        prompt_title = "gitui repos",
        finder = finders.new_table {
            results = repos,
            entry_maker = function(entry)
                local make_display = function()
                    return displayer
                    {
                        {entry.idx},
                        {entry.repo_name},
                    }
                end

                return {
                    value = entry.value,
                    ordinal = string.format("%s %s", entry.idx, entry.repo_name),
                    display = make_display,
                }
            end,
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(_, _)
            action_set.select:replace(open_gitui)
            return true
        end
    }):find()
end

return require("telescope").register_extension({
    exports = {
        gitui = gitui_repos,
    }
})
