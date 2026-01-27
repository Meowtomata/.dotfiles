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
        vim.keymap.set('n', '<M-a>', function() Snacks.picker.projects() end) 
        vim.keymap.set('n', '<M-s>', function() Snacks.picker.files() end) 
        vim.keymap.set('n', '<M-d>', function() Snacks.lazygit() end) 
        vim.keymap.set('n', '<M-f>', '<cmd>SmartFind<CR>')
        vim.keymap.set('n', '<M-g>', '<cmd>GrepFind<CR>')

        vim.keymap.set('n', '<M-b>', function() Snacks.picker.buffers() end) 
        vim.keymap.set('n', '<M-n>', function() Snacks.picker.gh_issue({state = "all"}) end) 
        vim.keymap.set('n', '<M-m>', function() Snacks.picker.gh_pr({state = "all"}) end) 

        vim.keymap.set('n', ';', function() Snacks.bufdelete() end) 

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
        vim.keymap.set("n", "<M-y>", "<cmd>Obsidian new<cr>")
        vim.keymap.set("n", "<M-u>", "<cmd>Obsidian backlinks<cr>")
        vim.keymap.set("n", "<M-i>", "<cmd>Obsidian links<cr>")
        vim.keymap.set("n", "<M-o>", "<cmd>Obsidian search<cr>")
        vim.keymap.set("n", "<M-p>", "<cmd>Obsidian paste_img<cr>")

        -- Create files/links
        vim.keymap.set("n", "<C-n>", "<cmd>Obsidian new<cr>", {
            desc = "Obsidian: Create new note",
        })

        -- Better Markdown Navigation
        vim.keymap.set("n", "j", "gj", { silent = true })
        vim.keymap.set("n", "k", "gk", { silent = true })

        -- Resize Splits Inside Neovim
        vim.keymap.set('n', '<M-S-l>', ':vertical resize +20<cr>')
        vim.keymap.set('n', '<M-S-h>', ':vertical resize -20<cr>')
        vim.keymap.set('n', '<M-S-k>', ':resize +20<cr>') 
        vim.keymap.set('n', '<M-S-j>', ':resize -20<cr>')

        --- LSP Mapppings
        ---
        vim.api.nvim_create_autocmd('LspAttach', {
          group = vim.api.nvim_create_augroup('UserLspConfig', {}),
          callback = function(ev)
            -- Enable completion triggered by <c-x><c-o>
            vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

            -- Helper function to make mapping easier
            local map = function(mode, keys, func, desc)
              vim.keymap.set(mode, keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
            end

            -- --- NAVIGATION (Using Snacks.picker) ---
            -- definition: Jump to definition (or list if multiple)
            map('n', 'gd', function()
              Snacks.picker.lsp_definitions()
            end, 'Go to Definition')

            -- references: Find usages of symbol
            map('n', 'gr', function()
              Snacks.picker.lsp_references()
            end, 'Go to References')

            -- implementation: Find implementations of interface/trait
            map('n', 'gI', function()
              Snacks.picker.lsp_implementations()
            end, 'Go to Implementation')

            -- type_definition: Find the struct/interface type
            map('n', 'gy', function()
              Snacks.picker.lsp_type_definitions()
            end, 'Go to Type Definition')

            -- symbols: Fuzzy find symbols in current file (Functions, Variables)
            map('n', '<leader>ss', function()
              Snacks.picker.lsp_symbols()
            end, 'LSP Document Symbols')

            -- workspace symbols: Fuzzy find symbols in entire project
            map('n', '<leader>sS', function()
              Snacks.picker.lsp_workspace_symbols()
            end, 'LSP Workspace Symbols')

            -- --- ACTION ---
            -- Rename: Relies on Snacks.input for a nice UI
            map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename')

            -- Code Action: "Fix it" menu
            map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, 'Code Action')

            -- --- INFORMATION ---
            -- Hover: Documentation popup (hit K twice to jump into it)
            map('n', 'K', vim.lsp.buf.hover, 'Hover Documentation')

            -- --- DIAGNOSTICS ---
            -- Jump between errors
            map('n', ']d', vim.diagnostic.goto_next, 'Next Diagnostic')
            map('n', '[d', vim.diagnostic.goto_prev, 'Prev Diagnostic')

            -- List errors in a picker
            map('n', '<leader>x', function()
              Snacks.picker.diagnostics()
            end, 'Diagnostics Picker')
          end,
        })

        -- Leetcode.nvim mappings
        local leetcode_maps = function()
          vim.keymap.set("n", "<M-r>", ":Leet run<cr>", { desc = "LeetCode: Run" })
          vim.keymap.set("n", "<M-w>", ":Leet submit<cr>", { desc = "LeetCode: Submit" })
          vim.keymap.set("n", "<M-q>", ":Leet info<cr>", { desc = "LeetCode: Info" })
        end

        -- LeetCode binds are automatically loaded when entering this directory
        vim.api.nvim_create_autocmd("BufEnter", {
          pattern = vim.fn.expand("~/.local/share/nvf/leetcode/*"),
          callback = function()
            print("LeetCode Environment Detected")
            leetcode_maps()
          end,
        })

        -- Molten.nvim mappings
        local molten_maps = function()
            local runner = require('quarto.runner')
            vim.keymap.set('n', '<M-r>', runner.run_cell,  { desc = "Run Cell", buffer = true })
            vim.keymap.set('n', '<M-e>', runner.run_all,   { desc = "Run All", buffer = true })
            vim.keymap.set('n', '<M-t>', runner.run_line,  { desc = "Run Line", buffer = true })
            vim.keymap.set('v', '<M-r>',  runner.run_range, { desc = "Run Visual Range", buffer = true })
            vim.keymap.set('n', '<M-q>', function() require('quarto').quartoPreview() end, { desc = "Quarto Preview", buffer = true })
        end

        -- Create :MagmaStart command to initialize Magma and its binds
        vim.api.nvim_create_user_command("MoltenStart", function()
          vim.cmd("MoltenInit") 
          molten_maps()
          print("Molten Initialized & Keymaps Set")
        end, {})

        vim.keymap.set("n", "<M-z>", ":MoltenStart<cr>", { desc = "Initialize Molten + Keys" })

        local function obsidian_search_and_create()

          local vault_path = vim.fn.expand("~/Obsidian")

          Snacks.picker.pick("files", {
            cwd = vault_path,
            title = "Search Notes (<M-n> to create)", 
            
            actions = {
              create_note = function(picker)
                picker:close()
                local query = picker.input.filter.search or picker.input.filter.pattern
                if query and query ~= "" then
                  vim.schedule(function()
                    vim.cmd("Obsidian new " .. query)
                  end)
                else
                  vim.notify("Obsidian: Search query is empty!", vim.log.levels.WARN)
                end
              end,
            },
            win = {
              input = {
                keys = {
                  ["<M-n>"] = { "create_note", mode = { "n", "i" }, desc = "Create new note" },
                },
              },
            },
          })
        end

        vim.api.nvim_create_user_command("SmartObsidianSearch", obsidian_search_and_create, {})
        vim.keymap.set("n", "<M-o>", obsidian_search_and_create, { desc = "Obsidian Search" })

        function _G.set_terminal_keymaps()
          local opts = {buffer = 0}
          
          -- Map Esc to exit terminal mode (go to Normal mode)
          vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], opts)
          
          -- Map Alt-h/j/k/l to navigate out of the terminal
          vim.keymap.set('t', '<M-h>', [[<Cmd>wincmd h<CR>]], opts)
          vim.keymap.set('t', '<M-j>', [[<Cmd>wincmd j<CR>]], opts)
          vim.keymap.set('t', '<M-k>', [[<Cmd>wincmd k<CR>]], opts)
          vim.keymap.set('t', '<M-l>', [[<Cmd>wincmd l<CR>]], opts)
        end

        vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

            ---Checks if a given string represents an image file based on its suffix.
        ---
        ---@param s string: The input string to check.
        ---@return boolean: Returns true if the string ends with a supported image suffix, false otherwise.
        -- local obsidian = require("obsidian")
        -- local util = require("obsidian.util")
        -- local api = require("obsidian.api")
        --
        -- -- 1. PATCH `is_img`: Allow it to recognize PDFs even if they have an anchor (e.g., .pdf#page=10)
        -- local orig_is_img = util.is_img
        -- util.is_img = function(loc)
        --   -- Clean the location (remove #anchor) to check the extension
        --   local clean_loc = loc:match("^(.-)#") or loc
        --   if clean_loc:match("%.pdf$") then return true end
        --   return orig_is_img(loc)
        -- end
        --
        -- -- 2. PATCH `resolve_image_path`: Handle the anchor preservation
        -- local orig_resolve = api.resolve_image_path
        -- api.resolve_image_path = function(loc)
        --   -- Split the path and the anchor
        --   local anchor = loc:match("#(.+)$")
        --   local clean_loc = loc:match("^(.-)#") or loc
        --
        --   -- Resolve the absolute path of the clean filename
        --   local resolved_path = orig_resolve(clean_loc)
        --
        --   -- If found, re-attach the anchor so it gets passed to follow_img_func
        --   if resolved_path and anchor then
        --     return tostring(resolved_path) .. "#" .. anchor
        --   end
        --   return resolved_path
        -- end
        --
        -- --- Resolve a basename to full path inside the vault.
        -- ---
        -- ---@param src string
        -- ---@return string
        -- require("obsidian.api").resolve_image_path = function(src)
        --   local img_folder = Obsidian.opts.attachments.img_folder
        --   ---@cast img_folder -nil
        --   if vim.startswith(img_folder, ".") then
        --       vim.notify("we've infiltrated", vim.log.levels.WARN)
        --       vim.notify("we've infiltrated", vim.log.levels.WARN)
        --       vim.notify("we've infiltrated", vim.log.levels.WARN)
        --       vim.notify("we've infiltrated", vim.log.levels.WARN)
        --
        --
        --     local dirname = Path.new(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
        --     return tostring(dirname / img_folder / src)
        --   else
        --       vim.notify("NOOO", vim.log.levels.WARN)
        --       vim.notify("NOOO", vim.log.levels.WARN)
        --       vim.notify("NOOO", vim.log.levels.WARN)
        --       vim.notify("NOOO", vim.log.levels.WARN)
        --
        --
        --
        --     return tostring(Obsidian.dir / img_folder / src)
        --   end
        -- end
      '';

  };

}
