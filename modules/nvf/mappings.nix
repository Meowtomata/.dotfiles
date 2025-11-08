{ ... }:
{

  programs.nvf.settings.vim = {

    # Display mappings when typing them out to assist for longer mappings
    binds.whichKey.enable = true;

    /*
      I find it more readable (and potentially concise) to set my keymaps in lua
      So I will set them in native lua here
    */
    luaConfigRC.mappings = # lua
      ''
        -- function to swap opts and rhs for improved readability
        -- Mainly used for maps that require a long function() body
        local function set_keymap(mode, lhs, opts, rhs)
          if rhs == nil then
            rhs = opts
            opts = {} 
          end
          vim.keymap.set(mode, lhs, rhs, opts)
        end

        -- Create user commands to more easily run as a bash option 
        local excluded_results = {
            '.bash_history',
            '.local',
            '.cache',
        }

        vim.api.nvim_create_user_command('SmartFind', function()
            require('snacks').picker.smart({
                cwd = '/home/meowster',
                hidden = true,
                exclude = excluded_results
            })
        end, {
            desc = 'Smart Find Files in /home/meowster'
        })

        vim.api.nvim_create_user_command('GrepFind', function()
            require('snacks').picker.grep({
                cwd = '/home/meowster',
                hidden = true,
                exclude = excluded_results
            })
        end, {
            desc = 'Grep Find Files in /home/meowster'
        })

        -- Snacks stuff
        set_keymap('n', '<M-f>', { desc = 'Smart Find Files' }, '<cmd>SmartFind<CR>')
        set_keymap('n', '<M-g>', { desc = 'Grep' }, '<cmd>GrepFind<CR>')

        set_keymap('n', '<M-b>', { desc = 'Buffers Find' },
            function() Snacks.picker.buffers() end) 
        set_keymap('n', '<leader>sk', { desc = 'Keymaps' },
            function() Snacks.picker.keymaps() end) 

        -- Buffer navigation
        vim.keymap.set('n', '<Tab>', '<cmd>bn<cr>', { silent = true })
        vim.keymap.set('n', '<S-Tab>', '<cmd>bp<cr>', { silent = true })

        -- Oil file explorer
        vim.keymap.set('n', '-', '<cmd>Oil<cr>', { silent = true })

        -- Tmux navigator
        vim.keymap.set('n', '<M-l>', '<cmd>TmuxNavigateRight<cr>', { silent = true })
        vim.keymap.set('n', '<M-k>', '<cmd>TmuxNavigateUp<cr>', { silent = true })
        vim.keymap.set('n', '<M-j>', '<cmd>TmuxNavigateDown<cr>', { silent = true })
        vim.keymap.set('n', '<M-h>', '<cmd>TmuxNavigateLeft<cr>', { silent = true })

        -- Obsidian Links
        --
        -- Search links & files
        --
        vim.keymap.set("n", "<M-s>", "<cmd>Obsidian backlinks<cr>", {
          desc = "Obsidian: Show backlinks for the current note",
        })

        vim.keymap.set("n", "<M-d>", "<cmd>Obsidian links<cr>", {
          desc = "Obsidian: Show all outgoing links from the current note",
        })

        vim.keymap.set("n", "<M-o>", "<cmd>Obsidian search<cr>", {
          desc = "Obsidian: Search all notes",
        })

        -- Create files/links
        vim.keymap.set("n", "<C-n>", "<cmd>Obsidian new<cr>", {
          desc = "Obsidian: Create new note",
        })

        -- Better Markdown Navigation
        vim.keymap.set("n", "j", "gj", { silent = true })
        vim.keymap.set("n", "k", "gk", { silent = true })
      '';

  };

}
