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

    extraConfigVim = ''
      command! SortByLen :%!python3 -c 'import sys; print("".join(sorted(sys.stdin.readlines(), key=len)))'
    '';

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
        action = "<cmd>Telescope lsp_definitions<CR>";
        options.desc = "[G]oto [D]efinition";
        key = "gd";
        mode = [ "n" ];
        options = {
          silent = true;
        };
      }
      {
        action = "<cmd>Telescope lsp_references<CR>";
        options.desc = "[G]oto [R]eferences";
        key = "gr";
        mode = [ "n" ];
        options = {
          silent = true;
        };
      }
      {
        action = "<cmd>Telescope lsp_implementations<CR>";
        options.desc = "[G]oto [I]mplementations";
        key = "gI";
        mode = [ "n" ];
        options = {
          silent = true;
        };
      }
      {
        action = "<cmd>Telescope lsp_type_definitions<CR>";
        options.desc = "Type [D]efinitions";
        key = "<leader>D";
        mode = [ "n" ];
        options = {
          silent = true;
        };
      }
      {
        action = "<cmd>Telescope lsp_document_symbols<CR>";
        options.desc = "[D]ocument [S]ymbols";
        key = "<leader>ds";
        mode = [ "n" ];
        options = {
          silent = true;
        };
      }
      {
        action = "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>";
        options.desc = "[W]orkspace [S]ymbols";
        key = "<leader>ws";
        mode = [ "n" ];
        options = {
          silent = true;
        };
      }
      {
        action = "<cmd>lua vim.lsp.buf.hover()<CR>";
        options.desc = "Hover Documentation";
        key = "K";
        mode = [ "n" ];
        options = {
          silent = true;
        };
      }
      {
        action = "<cmd>lua vim.lsp.buf.signature_help()<CR>";
        options.desc = "Signature Documentation";
        key = "<C-k>";
        mode = [ "n" ];
        options = {
          silent = true;
        };
      }
      {
        action = "<cmd>lua require('dap').toggle_breakpoint()<CR>";
        key = "<leader>db";
        mode = [ "n" ];
        options = {
          desc = "Toggle Breakpoint";
          silent = true;
        };
      }
      {
        action = "<cmd>lua require('dap').continue()<CR>";
        key = "<leader>dc";
        mode = [ "n" ];
        options = {
          desc = "Continue";
          silent = true;
        };
      }
      {
        action = "<cmd>lua require('dap').repl.open()<CR>";
        key = "<leader>dr";
        mode = [ "n" ];
        options = {
          desc = "Open REPL";
          silent = true;
        };
      }
      {
        action = "<cmd>lua require('dap').step_over()<CR>";
        key = "<leader>do";
        mode = [ "n" ];
        options = {
          desc = "Step Over";
          silent = true;
        };
      }
      {
        action = "<cmd>lua require('dap').step_into()<CR>";
        key = "<leader>di";
        mode = [ "n" ];
        options = {
          desc = "Step Into";
          silent = true;
        };
      }
      {
        action = "<cmd>lua require('dap').step_out()<CR>";
        key = "<leader>du";
        mode = [ "n" ];
        options = {
          desc = "Step Out";
          silent = true;
        };
      }
      {
        action = "<cmd>lua require('dap').terminate()<CR>";
        key = "<leader>dq";
        mode = [ "n" ];
        options = {
          desc = "Terminate debugger";
          silent = true;
        };
      }
      {
        action = "<cmd>lua require('dap.ui.widgets').hover()<CR>";
        key = "<leader>de";
        mode = [ "n" ];
        options = {
          desc = "Evaluate Expression";
          silent = true;
        };
      }
      {
        action = "<cmd>lua require('dap.ui.widgets').hover()<CR>";
        key = "<leader>dv";
        mode = [ "n" ];
        options = {
          desc = "Inspect Variables";
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
            #{ name = "calc"; }
            { name = "path"; }
          ];
        };
      };

      cmp-nvim-lsp.enable = true;
      cmp-path.enable = true;

      cmp-cmdline.enable = true;
      cmp-cmdline-history.enable = true;

      # Only press tab once!
      intellitab.enable = true;

      # Show colors in-place for hex codes
      colorizer.enable = true;

      # Friendly Snippets
      friendly-snippets.enable = true;

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
        settings = {
          lsp.signature.enabled = false;
        };
      };

      lsp = {
        enable = true;
        
        servers = {
          # Lua LSP
          lua_ls.enable = true;

          # Nix LSP
          nixd = {
            enable = true;
            extraOptions = {
              # https://github.com/nix-community/nixvim/issues/2390
              offset_encoding = "utf-8";
            };
          };

          # Python LSP
          pyright = {
            enable = true;
            autostart = true;
          };

          # C LSP
          ccls = {
            enable = true;
            autostart = true;
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
          };

          # Zig LSP
          zls = {
            enable = true;
            autostart = true;
          };

          asm_lsp = {
            enable = true;
            autostart = true;

            settings = {
              cmd = ["asm-lsp"];
              filetypes = ["asm" "s" "S"];
              root_markers = [".git" ".asm-lsp.toml"];
            };
          };
        };
      };

      # LSP Additions (automatically sets up rust_analyzer setup, + DAP for debugging)
      rustaceanvim = {
        enable = true;
        settings = {
          dap.autoloadConfigurations = true;
          dap.adapter = 
            let
              code-lldb = channels.nixpkgs-unstable.vscode-extensions.vadimcn.vscode-lldb;
            in {
              executable.command = "${code-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
              executable.args = [
                "--liblldb"
                "${code-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/lldb/lib/liblldb.so"
                "--port"
                "31337"
              ];
              type = "server";
              port = "31337";
              host = "127.0.0.1";
            };

          server = {
            cmd = [
              "rustup"
              "run"
              "stable"
              "rust-analyzer"
            ];
            standalone = false;
          };

          rust-analyzer = {
            check = {
              command = "clippy";
            };
            inlayHints = {
              lifetimeElisionHints = {
                enable = "always";
              };
            };
          };
        };
      };

      dap = {
        enable = true;

        extensions = {};
      };

      dap-ui = {
        enable = true;
        settings = {
          layouts = [
            {
              elements = [
                {
                  id = "console";
                  size = 1.0;
                }
              ];
              position = "left";
              size = 80;
            }
            {
              elements = [
                {
                  id = "scopes";
                  size = 0.5;
                }
                {
                  id = "breakpoints";
                  size = 0.5;
                }
              ];
              position = "bottom";
              size = 20;
            }
          ];
        };
      };

      dap-virtual-text.enable = true;

      lz-n.enable = true;

      # Highlight, edit, and navigate code
      treesitter = {
        enable = true;
        
        lazyLoad.settings = {
          cmd = [
            "TSInstall"
            "TSUpdate"
            "TSUpdateSync"
          ];

          event = [
            "BufNewFile"
            "BufReadPost"
            "BufWritePost"
            "DeferredUIEnter"
          ];

          lazy.__raw = "vim.fn.argc(-1) == 0";
        };

        settings = {
          auto_install = true;

          highlight = {
            enable = true;
          };

          incremental_selection.enable = false;

          indent = {
            enable = true;
          };

          parser_install_dir = "${homeDirectory}/.nvim/treesitter";
          sync_install = false;
        };

        nixvimInjections = true;
      };

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
        lazyLoad.settings.cmd = "Telescope";
        keymaps = {
          "<leader>ff" = "find_files";
          "<leader>fg" = "live_grep";
          "<leader>fb" = "buffers";
          "<leader>fh" = "help_tags";
          "<leader>fs" = "grep_string";
        };
      };

      # Web devicons, required for Telescope
      web-devicons.enable = true;

      # Show possible next keypress based on currently pressed key
      which-key = {
        enable = true;

        lazyLoad.settings = {
          cmd = "WhichKey";
          event = "DeferredUIEnter";
        };
      };
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
            rev = "62cadce83aaceed677ffe7a2d6a57141af7131ea";
            hash = "sha256-Dr3rU/Heqb3crYGVI86xhfZ89Fs0M62zD6tI5fZANIw=";
          };
        });
      } 
      {
        plugin = (channels.nixpkgs-unstable.vimUtils.buildVimPlugin {
          name = "nvim-lspimport";
          src = channels.nixpkgs-unstable.fetchFromGitHub {
            owner = "stevanmilic";
            repo = "nvim-lspimport";
            rev = "9c1c61a5020faeb1863bb66eb4b2a9107e641876";
            hash = "sha256-GIeuvGltgilFkYnKvsVYSogqQhDo1xcORy5jVtTz2cE=";
          };
        });
      } 
      {
        plugin = (channels.nixpkgs-unstable.vimUtils.buildVimPlugin {
          name = "markview";
          src = channels.nixpkgs-unstable.fetchFromGitHub {
            owner = "OXY2DEV";
            repo = "markview.nvim";
            rev = "72cd34279e94ee96ee33bdf30a87b00e6d45319d";
            hash = "sha256-4D4jB9CmamMAdpEodw4MdDyJVU6EMsh8P4gLs7p4E40=";
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
      {
        plugin = (channels.nixpkgs-unstable.vimUtils.buildVimPlugin {
          name = "nvim-nio";
          src = channels.nixpkgs-unstable.fetchFromGitHub {
            owner = "nvim-neotest";
            repo = "nvim-nio";
            rev = "21f5324bfac14e22ba26553caf69ec76ae8a7662";
            hash = "sha256-eDbzJAGdUBhTwuD0Nt9FihZj1MmVdQfn/GKIybuu5a8=";
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

      -- DAP
      local dap, dapui = require('dap'), require('dapui')

      -- Automatically open and close dap-ui
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    '';
  };
}
