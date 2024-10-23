{ channels, homeDirectory, ... }: {

  programs.nixvim = {
    enable = true;
    
    opts = {
      # Show line numbers and have relative-line numbers
      number = true;
      relativenumber = true;

      # Set highlight on search
      hlsearch = true;

      # Enable mouse usage
      mouse = "a";

      # Allow clipboard to yank and paste to access system clipboard by default
      # Setting this to both "unnamed" and "unnamedplus" allows for copy-pasting to the system clipboard by default
      # clipboard = [ "unnamed" "unnamedplus" ];

      # Enable break indent
      breakindent = true;

      # Enable undo history
      undofile = true;

      # Case-insensitive searching UNLESS \C or capital in search
      ignorecase = true;
      smartcase = true;

      # Decrease update time
      updatetime = 250;
      timeoutlen = 300;

      # Set completeopt to have a better completion experience
      completeopt = [ "menuone" "noinsert" "noselect" ];

    };

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    keymaps = [
      {
        action = "<cmd>Neotree toggle<CR>";
        options.desc = "Toggle NeoTree";
        key = "<leader>e";
        mode = [ "n" ];
        options = {
          silent = true;
        };
      }
      {
        action = "<cmd>lua require('telescope.builtin').lsp_definitions()<CR>";
        options.desc = "[G]oto [D]efinition";
        key = "gd";
        mode = [ "n" ];
        options = {
          silent = true;
        };
      }
      {
        action = "<cmd>lua require('telescope.builtin').lsp_references()<CR>";
        options.desc = "[G]oto [R]eferences";
        key = "gr";
        mode = [ "n" ];
        options = {
          silent = true;
        };
      }
      {
        action = "<cmd>lua require('telescope.builtin').lsp_implementations()<CR>";
        options.desc = "[G]oto [I]mplementations";
        key = "gI";
        mode = [ "n" ];
        options = {
          silent = true;
        };
      }
      {
        action = "<cmd>lua require('telescope.builtin').lsp_type_definitions()<CR>";
        options.desc = "Type [D]efinitions";
        key = "<leader>D";
        mode = [ "n" ];
        options = {
          silent = true;
        };
      }
      {
        action = "<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>";
        options.desc = "[D]ocument [S]ymbols";
        key = "<leader>ds";
        mode = [ "n" ];
        options = {
          silent = true;
        };
      }
      {
        action = "<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<CR>";
        options.desc = "[W]orkspace [S]ymbols";
        key = "<leader>ws";
        mode = [ "n" ];
        options = {
          silent = true;
        };
      }
      {
        action = "<cmd>vim.lsp.buf.hover<CR>";
        options.desc = "Hover Documentation";
        key = "K";
        mode = [ "n" ];
        options = {
          silent = true;
        };
      }
      {
        action = "<cmd>vim.lsp.buf.signature_help<CR>";
        options.desc = "Signature Documentation";
        key = "<C-k>";
        mode = [ "n" ];
        options = {
          silent = true;
        };
      }
    ];

    plugins = {
      # Nix Support for Vim
      nix.enable = true;

      # Autocompletion
      cmp = {
        enable = true;

        cmdline = {
          ":" = {
            sources = [{
              name = "cmdline"; 
              option = {
                ignore_cmds = [
                  "Man"
                  "!"
                ];
              };
            }];

            mapping = {
              __raw = "cmp.mapping.preset.cmdline()";
            };
          };
        };

        settings = {
          snippet.expand = ''
          function(args)
            require('luasnip').lsp_expand(args.body)
          end
          '';

          completion.completeopt = "menu,menuone,noinsert";
        
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-e>" = "cmp.mapping.close()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";

            "<Up>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Down>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
          sources = [
            { name = "nvim_lsp"; }
            { name = "calc"; }
            { name = "path"; }
          ];
        };
      };

      cmp-nvim-lsp.enable = true;
      cmp-path.enable = true;

      cmp-cmdline.enable = true;
      cmp-cmdline-history.enable = true;

      # cmp-calc.enable = true;

      # Navigation helper, toggle with :Navbuddy
      # Navic is required by Navbuddy.
      # navic.enable = true;
      # navbuddy = {
      #   enable = true;
      #   lsp.autoAttach = true;
      # };

      # Purposefully makes nvim harder to use by adding timeouts to the basic movement keys
      # This is in order to train to utilize faster and better movement mechanisms
      #hardtime.enable = true;

      # Only press tab once!
      intellitab.enable = true;
      
      # Show colors in-place for hex codes
      nvim-colorizer.enable = true;

      # LSP Formatter
      # lsp-format.enable = true;

      # Friendly Snippets
      friendly-snippets.enable = true;

      # Multi-cursor support
      # multicursors.enable = true;
      
      # Auto-close brackets and quotes
      autoclose.enable = true;

      # Status line
      lualine = {
        enable = true;

        settings.sections.lualine_x = [
          {
            __raw = ''
            {
              function()
                local mode = require('noice').api.statusline.mode
                if mode.has() then
                  local content = mode.get()
                  if string.match(content, "^recording @%w$") then
                    return content
                  end
                end
                return ""
              end,
              color = { fg = "#ff9e64" }
            }
            '';
          }
        ];
      };

      neo-tree = {
        enable = true;
      };

      noice = {
        enable = true;
        # Handled by custom box in additional lua
        lsp.signature.enabled = false;

        # routes = [{
        #   view = "notify";
        #   filter.event = "msg_showmode";
        # }];
      };

      # mini = {
      #   enable = true;
      #   modules = {
      #     surround = { };
      #   };
      # };

      lsp = {
        enable = true;
        
        servers = {
          # Lua LSP
          lua_ls.enable = true;

          # Nix LSP
          nixd.enable = true;

          # Rust LSP
          rust_analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
            settings.check.command = "clippy";
          };

          # Python LSP
          pyright = {
            enable = true;
            autostart = true;
            rootDir = ''
              function(fname)
                return vim.loop.cwd()
              end
            '';
          };

          # CSS LSP
          #cssls = {
          #  enable = true;
          #};

          # C LSP
          ccls = {
            enable = true;
            autostart = true;
            rootDir = ''
              function(fname)
                return vim.loop.cwd()
              end
            '';
          };

          # cmake LSP
          cmake = {
            enable = true;
            #autostart = true;
          };

          # Typescript LSP
          ts_ls = {
            enable = true;
            autostart = true;
            rootDir = ''
              function(fname)
                return vim.loop.cwd()
              end
            '';
          };

          # Zig LSP
          zls = {
            enable = true;
            autostart = true;
            rootDir = ''
              function(fname)
                return vim.loop.cwd()
              end
            '';
          };
        };
      };

      # LSP Additions to rust_analyzer
      #rustaceanvim.enable = true;

      # Highlight, edit, and navigate code
      treesitter = {
        enable = true;
        
        # folding = true;
        settings = {
          auto_install = true;

          # ensure_installed = [
          #   "all"
          # ];

          highlight = {
            enable = true;
            additional_vim_regex_highlighting = true;
            custom_captures = { };
          };

          incremental_selection = {
            enable = true;
            keymaps = {
              init_selection = "gnn";
              node_decremental = "grm";
              node_incremental = "grn";
              scope_incremental = "grc";
            };
          };

          indent = {
            enable = true;
          };

          parser_install_dir = "${homeDirectory}/.nvim/treesitter";
          sync_install = false;
        };

        nixvimInjections = true;
      };
      # treesitter-refactor.enable = true;

      # Add indentation guides even on blank lines
      indent-blankline = {
        enable = true;
        settings = {
          indent.highlight = [
            "MoonflyGrey58" 
            "MoonflyGrey39" 
            "MoonflyGrey27" 
            "MoonflyGrey23" 
            "MoonflyGrey0" 
            "MoonflyGrey15" 
            "MoonflyCrimson" 
          ];

          # Prevent using scope on certain languages
          # This can prevent them from having one massive scope
          scope.exclude.language = [ 
            "nix" 
            "lspinfo"
            "packer"
            "checkhealth"
            "help"
            "man"
            "gitcommit"
            "TelescopePrompt"
            "TelescopeResults"
          ];
        };
      };
      
      # Enable visual selection commenting with gc / gb
      comment.enable = true;

      # Fuzzy Finder (files, lsp, etc)
      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>fb" = "buffers";
          "<leader>fh" = "help_tags";
        };
      };

      # Web devicons, required for Telescope
      web-devicons.enable = true;

      # Show possible next keypress based on currently pressed key
      which-key.enable = true; 
    };

    extraPlugins = [
      # To find the hash, place the following in the field and attempt to build.
      # sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
      # The error message during building will provide the correct hash.
      # Alternatively (recommended): Use nurl <url>

      {
        # Theme
        plugin = (channels.nixpkgs-unstable.vimUtils.buildVimPlugin {
          name = "moonfly";
          src = channels.nixpkgs-unstable.fetchFromGitHub {
            owner = "bluz71";
            repo = "vim-moonfly-colors";
            rev = "3469ee3e54e676deafd9dc29beddfde3643b4d0d";
            hash = "sha256-vC1D/al/jVRyfFbTBpnvogUJsaZsQlcfRQ4j+5MmsbI=";
          };
        });
        config = ''colorscheme moonfly'';
      } 
      {
        # Show LSP Function Signature
        plugin = (channels.nixpkgs-unstable.vimUtils.buildVimPlugin {
          name = "lsp_signature";
          src = channels.nixpkgs-unstable.fetchFromGitHub {
            owner = "ray-x";
            repo = "lsp_signature.nvim";
            rev = "e92b4e7073345b2a30a56b20db3d541a9aa2771e";
            hash = "sha256-WAQ8DWjNWKYBbELC/M8ClGxU0cAqB4X1TlkWIEBqp24=";
          };
        });
      } 
      {
        plugin = (channels.nixpkgs-unstable.vimUtils.buildVimPlugin {
          name = "nvim-lspimport";
          src = channels.nixpkgs-unstable.fetchFromGitHub {
            owner = "stevanmilic";
            repo = "nvim-lspimport";
            rev = "4fef458b8853b1b90b55054ed6c3f98fff094cd1";
            hash = "sha256-JIbd4ygOGuNsg6fZnlN9iz7hfN4LQWM6VSJy4Qh9LJg=";
          };
        });
      } 
      {
        plugin = (channels.nixpkgs-unstable.vimUtils.buildVimPlugin {
          name = "markview";
          src = channels.nixpkgs-unstable.fetchFromGitHub {
            owner = "OXY2DEV";
            repo = "markview.nvim";
            rev = "9e5275f3b7507da51deab9bc985e9154d0b6af28";
            hash = "sha256-UVkNZku50DfzYRwzQbaztDOy9EnDGH41pJrZNrPb0qo=";
          };
        });
      }
      {
        plugin = (channels.nixpkgs-unstable.vimUtils.buildVimPlugin {
          name = "vim-syntax-yara";
          src = channels.nixpkgs-unstable.fetchFromGitHub {
            owner = "s3rvac";
            repo = "vim-syntax-yara";
            rev = "7f163d489bb041fe74f8788662620a0bcd3c0025";
            hash = "sha256-TEo9TV2Iexki0n1ME2ywLvkqpnq5ZosWc8di0/VNYIA=";
          };
        });
      }
      
      # Detect tabstop and shiftwidth automatically
      channels.nixpkgs-unstable.vimPlugins.vim-sleuth

      channels.nixpkgs-unstable.vimPlugins.luasnip

      channels.nixpkgs-unstable.vimPlugins.nui-nvim

      channels.nixpkgs-unstable.vimPlugins.nvim-lspconfig
      channels.nixpkgs-unstable.vimPlugins.fidget-nvim
    ];

    extraConfigLua = ''
      -- Avoid showing extra messages when using completion
      vim.opt.shortmess:append("c")

      -- Keep signcolumn on by default
      vim.wo.signcolumn = 'yes'

      require('luasnip.loaders.from_vscode').lazy_load()

      -- Custom siguature box
      local signature_cfg = {
        hint_prefix = "🤷 ",
        floating_window_off_x = 5, -- adjust float windows x position.
        floating_window_off_y = function() 
        local linenr = vim.api.nvim_win_get_cursor(0)[1] -- buf line number
          local pumheight = vim.o.pumheight
          local winline = vim.fn.winline() -- line number in the window
          local winheight = vim.fn.winheight(0)

          -- window top
          if winline - 1 < pumheight then
            return pumheight
          end

          -- window bottom
          if winheight - winline < pumheight then
            return -pumheight
          end
          return 0
        end,
      }
      require("lsp_signature").setup(signature_cfg)

      -- Make backticks work nicely in insert mode
      vim.keymap.set('i', '`', function()
        vim.api.nvim_feedkeys('``' .. vim.api.nvim_replace_termcodes('<Left>', true, false, true), 'n', true)
      end, { noremap = true })

      -- Fix Python venvs
      require('lspconfig').pyright.setup({
        root_dir = function(fname)
          return vim.loop.cwd()
        end,
        on_init = function(client)
          local venv = os.getenv("VIRTUAL_ENV")
          if venv then
            client.config.settings.python.pythonPath = venv .. "/bin/python"
          else
            client.config.settings.python.pythonPath = vim.fn.exepath("python")
          end
          client.notify("workspace/didChangeConfiguration")
        end
      })
    '';
  };
}
