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
      lang = 'rust',
      cn = {
        enabled = true,
        translator = false,
        translate_problems = false,
      },
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

  -- neotest-go
  {
    'nvim-neotest/neotest-go',
  },
}
