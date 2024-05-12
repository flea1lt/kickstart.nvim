-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
vim.cmd [[ let g:neo_tree_remove_legacy_commands = 1 ]]

vim.o.relativenumber = true

return {
  -- leetcode
  {
    'kawre/leetcode.nvim',
    build = ':TSUpdate html',
    lazy = 'leetcode.nvim' ~= vim.fn.argv()[1],
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim', -- required by telescope
      'MunifTanjim/nui.nvim',

      -- optional
      'nvim-treesitter/nvim-treesitter',
      'rcarriga/nvim-notify',
      'nvim-tree/nvim-web-devicons',
    },
    keys = {
      { '<leader>ld', '<cmd>Leet desc<cr>', desc = '[L]eetcode [D]escription' },
      { '<leader>lr', '<cmd>Leet run<cr>', desc = '[L]eetcode [R]un' },
      { '<leader>ls', '<cmd>Leet submit<cr>', desc = '[L]eetcode [S]ubmit' },
      { '<leader>ll', '<cmd>Leet lang<cr>', desc = '[L]eetcode [L]anguage' },
    },
    opts = {
      arg = 'leetcode.nvim',
      lang = 'golang',
      cn = {
        enabled = true,
        translator = false,
        translate_problems = false,
      },
      injector = {
        ['golang'] = {
          before = { 'package main' },
        },
      },
      hooks = {
        ---@type fun(question: lc.ui.Question)[]
        -- FIXME:
        -- lsp report `go.mod file not found in current directory or any parent directory` error even the lsp is running single file mode.
        -- maybe some config for lspconfig could fix this
        ['question_enter'] = {
          function(q)
            if q.lang == 'golang' then
              if vim.fn.filereadable(vim.fn.stdpath 'data' .. '/leetcode/go.mod') == 0 then
                -- automatically create go mod file before enter go question
                vim.fn.system 'go mod init leetcode'
              end
            end
          end,
        },
      },
    },
  },

  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
  -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  -- symbols outline
  {
    'hedyhli/outline.nvim',
    lazy = true,
    cmd = { 'Outline', 'OutlineOpen' },
    keys = { -- Example mapping to toggle outline
      { '<leader>o', '<cmd>Outline<CR>', desc = 'Toggle outline' },
    },
    opts = {
      -- Your setup opts here
    },
  },

  -- lazygit
  {
    'kdheepak/lazygit.nvim',
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
  },

  -- markdownPreview
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    ft = { 'markdown' },
    build = function()
      vim.fn['mkdp#util#install']()
    end,
  },

  -- rustaceanvim
  {
    'mrcjkb/rustaceanvim',
    version = '^4',
    dependencies = {
      {
        'lvimuser/lsp-inlayhints.nvim',
        opts = {},
      },
    },
    ft = { 'rust' },
    keys = {
      {
        '<leader>dr',
        '<cmd>RustLsp debuggables<cr>',
        desc = 'Rust debuggables',
        ft = 'rust',
      },
    },
    opts = {
      inlay_hints = {
        highlight = 'NonText',
      },
      tools = {
        hover_actions = {
          auto_focus = true,
        },
      },
      server = {
        on_attach = function(client, bufnr)
          require('lsp-inlayhints').on_attach(client, bufnr)
        end,
        default_settings = {
          ['rust-analyzer'] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              runBuildScripts = true,
            },
            -- Add clippy lints for Rust
            checkOnSave = {
              allFeatures = true,
              command = 'clippy',
              extraArgs = { '--no-deps' },
            },
            procMacro = {
              enable = true,
              ignored = {
                ['async-trait'] = { 'async_trait' },
                ['napi-derive'] = { 'napi' },
                ['async-recursion'] = { 'async_recursion' },
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend('keep', vim.g.rustaceanvim or {}, opts or {})
    end,
  },

  -- crates.nvim
  {
    'Saecki/crates.nvim',
    event = { 'BufRead Cargo.toml' },
    opts = {
      src = {
        cmp = { enabled = true },
      },
    },
    keys = {
      { '<leader>cv', '<cmd>Crates show_versions_popup<cr>', desc = 'crates show_versions_popup', silent = true, ft = 'toml' },
      { '<leader>cf', '<cmd>Crates show_features_popup<cr>', desc = 'crates show_features_popup', silent = true, ft = 'toml' },
      { '<leader>cd', '<cmd>Crates show_dependencies_popup<cr>', desc = 'crates show_dependencies_popup', silent = true, ft = 'toml' },

      { '<leader>cD', '<cmd>Crates open_documentation<cr>', desc = 'crates open_documentation', silent = true },
    },
  },
  -- bufferline
  {
    'akinsho/bufferline.nvim',
    version = '*',
    -- `BufReadPre` event to prevent show a `No Name` buffer when open a directory use nvim directly
    event = 'BufReadPre',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    keys = {
      { '[b', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev buffer' },
      { ']b', '<cmd>BufferLineCycleNext<cr>', desc = 'Next buffer' },
    },
    opts = {
      options = {
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'Neo-tree',
            highlight = 'Directory',
            text_align = 'left',
          },
        },
      },
    },
  },

  -- go.nvim
  {
    'ray-x/go.nvim',
    dependencies = { -- optional packages
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('go').setup()
    end,
    event = { 'CmdlineEnter' },
    ft = { 'go', 'gomod' },
    build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
  },

  -- neotest
  {
    'nvim-neotest/neotest',
    optional = true,
    dependencies = {
      'nvim-neotest/neotest-go',
      'nvim-neotest/neotest-python',
    },
    opts = {
      adapters = {
        ['neotest-go'] = {
          -- Here we can set options for neotest-go, e.g.
          -- args = { "-tags=integration" }
          recursive_run = true,
        },
        ['neotest-python'] = {
          -- Here you can specify the settings for the adapter, i.e.
          -- runner = "pytest",
          -- python = ".venv/bin/python",
        },
      },
    },
  },

  -- venv-selector
  {
    'linux-cultist/venv-selector.nvim',
    cmd = 'VenvSelect',
    opts = function(_, opts)
      return vim.tbl_deep_extend('force', opts, {
        name = {
          'venv',
          '.venv',
          'env',
          '.env',
        },
      })
    end,
    keys = { { '<leader>cv', '<cmd>:VenvSelect<cr>', desc = 'Select VirtualEnv' } },
  },
}
