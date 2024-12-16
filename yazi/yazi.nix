{ channels, config, colorscheme, workConfig, nixGLPrefix, ... }: 
let
  # To get a SHA-256 for a GitHub repo:
  # Use nurl <url>
  # i.e. for the Hexyl repo, use:
  # nurl https://github.com/Reledia/hexyl.yazi
  
  # This will return the following:
  # fetchFromGitHub {
  #   owner = "Reledia";
  #   repo = "hexyl.yazi";
  #   rev = "64daf93a67d75eff871befe52d9013687171ffad";
  #   hash = "sha256-B2L3/Q1g0NOO6XEMIMGBC/wItbNgBVpbaMMhiXOYcrI=";
  # }
  # Alternatively, simply leave the sha256 field blank
  # and copy the correct hash during rebuild
in {

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    package = channels.nixpkgs-unstable.yazi;

    initLua = ''
      require("relative-motions"):setup({ show_numbers="relative", show_motion = true })
    '';

    plugins = {
      # Preview Markdown files
      "glow" = channels.nixpkgs-unstable.fetchFromGitHub {
        owner = "Reledia";
        repo = "glow.yazi";
        rev = "c2ed51ed8c4ba965b793adab5868a307ab375c8a";
        sha256 = "sha256-hY390F6/bkQ6qN2FZEn0k+j+XfaERJiAo/E3xXYRB70=";
      };

      # Preview archives as a tree
      "ouch" = channels.nixpkgs-unstable.fetchFromGitHub {
        owner = "ndtoan96";
        repo = "ouch.yazi";
        rev = "b8698865a0b1c7c1b65b91bcadf18441498768e6";
        sha256 = "sha256-eRjdcBJY5RHbbggnMHkcIXUF8Sj2nhD/o7+K3vD3hHY=";
      };

      # Search with fg / ff (content, fzf)
      "fg" = channels.nixpkgs-unstable.fetchFromGitHub {
        owner = "lpnh";
        repo = "fg.yazi";
        rev = "a7e1a828ef4dfb01ace5b03fe0691c909466a645";
        hash = "sha256-QxtWyp91XcW8+PSYtER47Pcc1Y9i3LplJyTzeC5Gp2s=";
      };

      # Vim-like relative motions
      "relative-motions" = channels.nixpkgs-unstable.fetchFromGitHub {
        owner = "dedukun";
        repo = "relative-motions.yazi";
        rev = "df97039a04595a40a11024f321a865b3e9af5092";
        sha256 = "sha256-csX8T2a5f7k6g2mlR+08rm0qBeWdI4ABuja+klIvwqw=";
      };

      # Preview media metadata information
      "mediainfo" = channels.nixpkgs-unstable.fetchFromGitHub {
        owner = "Ape";
        repo = "mediainfo.yazi";
        rev = "c69314e80f5b45fe87a0e06a10d064ed54110439";
        sha256 = "sha256-8xdBPdKSiwB7iRU8DJdTHY+BjfR9D3FtyVtDL9tNiy4=";
      };

      # "projects" = channels.nixpkgs-unstable.fetchFromGitHub {
      #   owner = "MasouShizuka";
      #   repo = "projects.yazi";
      #   rev = "7a1dc3729f0bc3f0d62214683117d490113c3007";
      #   hash = "sha256-ANDO+BgC9hb6bfq4pc/jTVBL/camUMtYZ0r6gbwHe6M=";
      # };
    };

    keymap = {
      manager = {
        prepend_keymap = [
          # Relative motions
          { on = [ "1" ]; run = "plugin relative-motions --args=1"; desc = "Move in relative steps"; }
          { on = [ "2" ]; run = "plugin relative-motions --args=2"; desc = "Move in relative steps"; }
          { on = [ "3" ]; run = "plugin relative-motions --args=3"; desc = "Move in relative steps"; }
          { on = [ "4" ]; run = "plugin relative-motions --args=4"; desc = "Move in relative steps"; }
          { on = [ "5" ]; run = "plugin relative-motions --args=5"; desc = "Move in relative steps"; }
          { on = [ "6" ]; run = "plugin relative-motions --args=6"; desc = "Move in relative steps"; }
          { on = [ "7" ]; run = "plugin relative-motions --args=7"; desc = "Move in relative steps"; }
          { on = [ "8" ]; run = "plugin relative-motions --args=8"; desc = "Move in relative steps"; }
          { on = [ "9" ]; run = "plugin relative-motions --args=9"; desc = "Move in relative steps"; }

          # Project management; not working at the moment?
          # { on = [ "P" "s" ]; run = "plugin projects --args=save"; desc = "Save current project"; }
          # { on = [ "P" "l" ]; run = "plugin projects --args=load"; desc = "Load project"; }
          # { on = [ "P" "P" ]; run = "plugin projects --args=load_last"; desc = "Load last project"; }
          # { on = [ "P" "d" ]; run = "plugin projects --args=delete"; desc = "Delete project"; }
          # { on = [ "P" "D" ]; run = "plugin projects --args=delete_all"; desc = "Delete all projects"; }
          # { on = [ "P" "m" ]; run = "plugin projects --args='merge current'"; desc = "Merge current tab to other projects"; }
          # { on = [ "P" "M" ]; run = "plugin projects --args='merge all'"; desc = "Merge current project to other projects"; }
          # { on = [ "q" ]; run = "plugin projects --args=quit"; desc = "Quit and save projects"; }

          # Tab management
          { on = [ "!" ]; run = "tab_switch 0"; desc = "Switch to tab"; }
          { on = [ "@" ]; run = "tab_switch 1"; desc = "Switch to tab"; }
          { on = [ "#" ]; run = "tab_switch 2"; desc = "Switch to tab"; }
          { on = [ "$" ]; run = "tab_switch 3"; desc = "Switch to tab"; }
          { on = [ "%" ]; run = "tab_switch 4"; desc = "Switch to tab"; }
          { on = [ "^" ]; run = "tab_switch 5"; desc = "Switch to tab"; }
          { on = [ "&" ]; run = "tab_switch 6"; desc = "Switch to tab"; }
          { on = [ "*" ]; run = "tab_switch 7"; desc = "Switch to tab"; }
          { on = [ "(" ]; run = "tab_switch 8"; desc = "Switch to tab"; }

          { on = [ "<C-1>" ]; run = "tab_swap 0"; desc = "Swap with tab"; }
          { on = [ "<C-2>" ]; run = "tab_swap 1"; desc = "Swap with tab"; }
          { on = [ "<C-3>" ]; run = "tab_swap 2"; desc = "Swap with tab"; }
          { on = [ "<C-4>" ]; run = "tab_swap 3"; desc = "Swap with tab"; }
          { on = [ "<C-5>" ]; run = "tab_swap 4"; desc = "Swap with tab"; }
          { on = [ "<C-6>" ]; run = "tab_swap 5"; desc = "Swap with tab"; }
          { on = [ "<C-7>" ]; run = "tab_swap 6"; desc = "Swap with tab"; }
          { on = [ "<C-8>" ]; run = "tab_swap 7"; desc = "Swap with tab"; }
          { on = [ "<C-9>" ]; run = "tab_swap 8"; desc = "Swap with tab"; }

          # File finding
          { on = [ "f" "g" ]; run = "plugin fg";              desc = "Find file by Content"; }
          { on = [ "f" "f" ]; run = "plugin fg --args='fzf'"; desc = "Find file by Name";    }

          # Navigation
          { on = [ "K" ];     run = "seek -5";  desc = "Seek up 5 units in the preview";   }
          { on = [ "J" ];     run = "seek 5";   desc = "Seek down 5 units in the preview"; }
          { on = [ "<C-k>" ]; run = "arrow -5"; desc = "Move cursor up 5 lines";           }
          { on = [ "<C-j>" ]; run = "arrow 5";  desc = "Move cursor down 5 lines";         }

          # Go to directories
          { on = [ "g" "~" ];       run = "cd ~";                      desc = "[ G ]o to the [ ~ ]home directory";               }
          { on = [ "g" "c" ];       run = "cd ~/.config";              desc = "[ G ]o to the [ c ]onfig directory";              }
          { on = [ "g" "h" ];       run = "cd ~/.config/home-manager"; desc = "[ G ]o to the config [ h ]ome-manager directory"; }
          { on = [ "g" "d" ];       run = "cd ~/Downloads";            desc = "[ G ]o to the [ d ]ownloads directory";           }
          { on = [ "g" "D" ];       run = "cd ~/Documents";            desc = "[ G ]o to the [ d ]ocuments directory";           }
          { on = [ "g" "t" ];       run = "cd ~/tickets";              desc = "[ G ]o to the [ t ]ickets directory";             }
          { on = [ "g" "T" ];       run = "cd /tmp";                   desc = "[ G ]o to the [ t ]emporary directory";           }
          { on = [ "g" "w" ];       run = "cd ~/work";                 desc = "[ G ]o to the [ w ]ork directory";                }
          { on = [ "g" "b" ];       run = "cd ~/bin";                  desc = "[ G ]o to the [ b ]in directory (PATH)";          }
          { on = [ "g" "<Space>" ]; run = "cd --interactive";          desc = "[ G ]o to a [   ] directory interactively";       }

          # Drag-and-drop
          { on = [ "b" "o" ]; run = "shell 'dragon -x -i -T \"$1\"' --confirm"; desc = "Drag file OUT of yazi"; }
          { on = [ "b" "i" ]; run = "shell DRAG_TO_VM --confirm"; desc = "Drag file INTO yazi"; }

          # Copy
          { on = [ "c" "h" ]; run = "shell --confirm 'ef \"$@\" [| cfmt \"{sha256}  {path}\n\" ]| xsel -psb'"; desc = "Copy SHA256 and filename of selected files"; }
          { on = [ "c" "H" ]; run = "shell --confirm 'ef \"$@\" [| cfmt \"{sha256}\n\" ]| xsel -psb'"; desc = "Copy SHA256 of selected files"; }
          { on = [ "c" "p" ]; run = "shell --confirm 'echo $PWD | xsel -psb'"; desc = "Copy the current folder path"; }
          # ' - Common Aliases
          # 1 - Reserved
          # 2 - Reserved

          # 3 - Files
          # Compression
          { on = [ "'" "3" "c" ]; run = "shell --interactive --block '7z a -pinfected -mhe=on \"$1\".7z \"$@\"'"; desc = "Compress seleted files with password=infected"; }
          { on = [ "'" "3" "e" ]; run = "shell --interactive --block '7z x \"$@\" -pinfected'";                   desc = "Extract with password=infected";         }
          { on = [ "'" "3" "r" ]; run = "shell --interactive --block 'unar $@'"; desc = "Decompress with unar"; }

          # 4 - Tools
          { on = [ "'" "4" "j" ]; run = "shell --interactive --orphan 'jadx-gui \"$@\"'"; desc = "Launch Jadx-GUI with the selected file"; }
          { on = [ "'" "4" "g" ]; run = "shell --confirm 'GoReSym $@ | dump $@_info/goresym'"; desc = "Run GoReSym"; }
          { on = [ "'" "4" "w" ]; run = "shell --confirm 'wireshark $@'"; desc = "Run Wireshark"; }
          { on = [ "'" "4" "c" ]; run = "shell --confirm 'capa -j $@ | dump $@_info/capa'"; desc = "Run Capa"; }
          { on = [ "'" "4" "f" ]; run = "shell --confirm 'floss -j $@ | dump $@_info/floss'"; desc = "Run Floss"; }
          { on = [ "'" "4" "d" "d" ]; run = "shell --confirm 'ilspycmd -p -d -usepdb --no-dead-code --no-dead-stores -o $@_info/decompiled/ $@'"; desc = "[D]otNet [D]ecompile"; }
          { on = [ "'" "4" "h" ]; run = "shell --confirm --orphan '${nixGLPrefix}imhex $@'"; desc = "Open in ImHex"; }
          { on = [ "'" "4" "b" ]; run = "shell --confirm --orphan 'binaryninja $@'"; desc = "Open in Binary Ninja"; }


          { on = [ "'" "9" "y" ]; run = "shell --confirm 'cp ${config.xdg.configHome}/home-manager/yara/skeleton.yara .'"; }


        ] ++ (workConfig.programs.yazi.keymap.manager.prepend_keymap or []);
      };
    };

    settings = {
      log = {
        enabled = true;
      };        

      manager = {
        ratio = [ 1 3 4 ];
        show_hidden = true;
        sort_by = "natural";
        sort_dir_first = true;
        sort_reverse = false;
      };

      plugin = {
        append_previewers = [
          { name = "*"; run = "previewer"; }
        ];
        prepend_previewers = [
          { name = "*.md";                        run = "glow"; }
          { mime = "application/*zip";            run = "ouch"; }
          { mime = "application/tar";           run = "ouch"; }
          { mime = "application/bzip2";         run = "ouch"; }
          { mime = "application/7z-compressed"; run = "ouch"; }
          { mime = "application/rar";           run = "ouch"; }
          { mime = "application/xz";            run = "ouch"; }
          { mime = "{image,audio,video}/*";       run = "mediainfo"; }
          { mime = "application/subrip";        run = "mediainfo"; }
        ];
      };

      opener = {
        edit = [
          { run = "${nixGLPrefix}${channels.nixpkgs-unstable.contour}/bin/contour nvim \"$@\""; orphan = true; }
        ];

        # Open directories with nautilus (backup file manager)
        directory = [
          { run = "nautilus \"$0\""; desc = "Open directory in Nautilus"; }
        ];

        # View JSON files with jless
        json = [
          { run = "${channels.nixpkgs-unstable.jless}/bin/jless $0"; desc = "View JSON with jless"; block = true; }
        ];

        # Automatically triage PE files
        triage_pe = [
          { run = "ef $@ [| pemeta -cI | dump $@_info/imports ];
                   ef $@ [| pemeta -cE | dump $@_info/exports ];
                   ef $@ [| pemeta -DNSTVH | dump $@_info/pemeta ];
                   ef $@ [| vsect [| dump $@_info/sections/{path} ]];
                   ef $@ [| perc [| dump $@_info/resources/{path} ]];
                   ef $@ [| peoverlay [| dump $@_info/peoverlay ]];
                   strings --encoding=s $@ | dump $@_info/strings_utf8;
                   strings --encoding=b $@ | dump $@_info/strings_unicode;
                   diec -dbru $@ | dump $@_info/peinfo"; }
        ];

        triage_msi = [
          { run = "ef $@ [| xtmsi [| dump $@_info/extracted/{path} ]]
                   strings --encoding=s $@ | dump $@_info/strings_utf8;
                   strings --encoding=b $@ | dump $@_info/strings_unicode;
                   diec -dbru $@ | dump $@_info/msiinfo"; }
        ];

        triage_cab = [
          { run = "ef $@ [| xtcab [| dump $@_extracted/{path} ]]"; }
        ];

        triage_elf = [
          { run = "ef $@ [| vsect [| dump $@_info/sections/{path} ]];
                   strings --encoding=s $@ | dump $@_info/strings_utf8;
                   strings --encoding=b $@ | dump $@_info/strings_unicode;
                   diec -dbru $@ | dump $@_info/elfinfo"; }
        ];

        triage_macho = [
          { run = "ef $@ [| machometa -cI | dump $@_info/imports ];
                   ef $@ [| machometa -cE | dump $@_info/exports ];
                   ef $@ [| machometa | dump $@_info/machometa ];
                   ef $@ [| vsect [| dump $@_info/sections/{path} ]];
                   ef $@ [| xtmacho [| dump $@_info/executables/{path} ]];
                   strings --encoding=s $@ | dump $@_info/strings_utf8;
                   strings --encoding=b $@ | dump $@_info/strings_unicode;
                   diec -dbru $@ | dump $@_info/machoinfo"; }
        ];

        extract_rar = [
          { run = "unar $@"; }
        ];
      };

      open = {
        prepend_rules = [
          { mime = "inode/directory"; use = [ "directory" ]; }
          { mime = "application/json"; use = [ "json" ]; }

          { mime = "application/microsoft.portable-executable"; use = [ "triage_pe" ]; }
          { mime = "application/msi"; use = [ "triage_msi" ]; }
          { mime = "application/ms-cab-compressed"; use = [ "triage_cab" ]; }

          { mime = "application/executable"; use = [ "triage_elf" ]; }
          { mime = "application/pie-executable"; use = [ "triage_elf" ]; }
          { mime = "application/sharedlib"; use = [ "triage_elf" ]; }

          { mime = "application/mach-binary"; use = [ "triage_macho" ]; }

          { mime = "application/rar"; use = [ "extract_rar" ]; }
        ];
      };
    };

    theme = {
      manager = {
        cwd = { fg = colorscheme.colors.n_purple_1; };
        hovered = { fg = colorscheme.colors.n_pink_5; reversed = true; };
        preview_hovered = { underline = true; };

        find_keyword = {
          fg = colorscheme.colors.n_pink_5;
          italic = true;
          underline = true;
        };

        find_position = { 
          fg = colorscheme.colors.n_pink_1;
          bg = "reset";
          italic = true;
        };

        marker_copied = {
          fg = colorscheme.colors.n_pink_1;
          bg = colorscheme.colors.blue;
        };

        marker_cut = {
          fg = colorscheme.colors.n_pink_1;
          bg = colorscheme.colors.bright_red;
        };

        marker_marked = {
          fg = colorscheme.colors.n_pink_1;
          bg = colorscheme.colors.n_purple_6;
        };

        marker_selected = {
          fg = colorscheme.colors.n_pink_1;
          bg = colorscheme.colors.n_pink_4;
        };

        tab_active = {
          fg = colorscheme.colors.background;
          bg = colorscheme.colors.bright_white;
        };

        tab_inactive = {
          fg = colorscheme.colors.bright_white;
          bg = colorscheme.colors.black;
        };

        tab_width = 1;
        count_copied = {
          fg = colorscheme.colors.background;
          bg = colorscheme.colors.blue;
        };

        count_cut = {
          fg = colorscheme.colors.background;
          bg = colorscheme.colors.bright_red;
        };

        count_selected = {
          fg = colorscheme.colors.background;
          bg = colorscheme.colors.n_pink_4;
        };

        border_symbol = "│";
        border_style = { fg = colorscheme.colors.bright_black; };
      };

      mode = {
        normal_main = {
          fg = colorscheme.colors.background;
          bg = colorscheme.colors.n_pink_4;
          bold = true;
        };

        normal_alt = {
          fg = colorscheme.colors.n_pink_4;
          bg = colorscheme.colors.background;
          bold = true;
        };

        select_main = {
          fg = colorscheme.colors.background;
          bg = colorscheme.colors.bright_green;
          bold = true;
        };

        select_alt = {
          fg = colorscheme.colors.bright_green;
          bg = colorscheme.colors.background;
          bold = true;
        };

        unset_main = {
          fg = colorscheme.colors.background;
          bg = colorscheme.colors.bright_red;
          bold = true;
        };

        unset_alt = {
          fg = colorscheme.colors.bright_red;
          bg = colorscheme.colors.background;
          bold = true;
        };
      };

      status = {
        separator_open = "";
        separator_close = "";

        progress_label = {
          fg = colorscheme.colors.bright_white;
          bold = true;
        };

        progress_normal = {
          fg = colorscheme.colors.n_pink_4;
          bg = colorscheme.colors.black;
        };

        progress_error = {
          fg = colorscheme.colors.bright_red;
          bg = colorscheme.colors.black;
        };

        perm_type = { fg = colorscheme.colors.n_pink_4; };
        perm_read = { fg = colorscheme.colors.bright_yellow; };
        perm_write = { fg = colorscheme.colors.bright_red; };
        perm_exec = { fg = colorscheme.colors.bright_green; };
        perm_sep = { fg = colorscheme.colors.bright_black; };
      };

      input = {
        border = { fg = colorscheme.colors.n_pink_4; };
        title = {};
        value = {};
        selected = { reversed = true; };
      };

      select = {
        border = { fg = colorscheme.colors.n_pink_4; };
        active = { fg = colorscheme.colors.bright_purple; };
        inactive = {};
      };

      tasks = {
        border = { fg = colorscheme.colors.n_pink_4; };
        title = {};
        hovered = { underline = true; };
      };

      which = {
        mask = { bg = colorscheme.colors.black; };
        cand = { fg = colorscheme.colors.n_pink_5; };
        rest = { fg = colorscheme.colors.foreground; };
        desc = { fg = colorscheme.colors.white; };
        separator = "  ";
        separator_style = { fg = colorscheme.colors.bright_black; };
      };

      help = {
        on = { fg = colorscheme.colors.bright_purple; };
        run = { fg = colorscheme.colors.bright_cyan; };
        desc = { fg = colorscheme.colors.foreground; };
        hovered = {
          bg = colorscheme.colors.black;
          bold = true;
        };
        footer = {
          fg = colorscheme.colors.black;
          bg = colorscheme.colors.bright_white;
        };
      };

      filetype = {
        rules = [
          { mime = "image/*"; fg = colorscheme.colors.bright_cyan; }
          { mime = "video/*"; fg = colorscheme.colors.bright_yellow; }
          { mime = "audio/*"; fg = colorscheme.colors.bright_yellow; }
          { mime = "application/zip"; fg = colorscheme.colors.bright_purple; }
          { mime = "application/gzip"; fg = colorscheme.colors.bright_purple; }
          { mime = "application/x-tar"; fg = colorscheme.colors.bright_purple; }
          { mime = "application/x-bzip"; fg = colorscheme.colors.bright_purple; }
          { mime = "application/x-bzip2"; fg = colorscheme.colors.bright_purple; }
          { mime = "application/x-7z-compressed"; fg = colorscheme.colors.bright_purple; }
          { mime = "application/x-rar"; fg = colorscheme.colors.bright_purple; }
          { name = "*"; fg = colorscheme.colors.bright_white; }
          { name = "*/"; fg = colorscheme.colors.n_pink_4; }
        ];
      };
    };
  };

  home.file."/.config/yazi/plugins/previewer.yazi/init.lua" = {
    text = ''
      local M = {}

      --[[
        Function: calc_sha256
        Description: Calculates the SHA256 hash of the specified file.
        Parameters:
          - job (table): Contains information about the current job, including the file URL.
        Returns:
          - sha256 (string): The SHA256 hash of the file.
      --]]
      function M.calc_sha256(job)
          local child = Command('sha256sum')
              :args({
                  tostring(job.file.url)
              })
              :stdout(Command.PIPED)
              :stderr(Command.PIPED)
              :spawn()

          local output = child:read_line()
          if output then
              output = output:match("([a-z0-9]+)")
          else
              output = "N/A"
          end

          child:start_kill()

          return output
      end

      --[[
        Function: calc_file1
        Description: Determines the file type using the 'file' command.
        Parameters:
          - job (table): Contains information about the current job, including the file URL.
        Returns:
          - file_magic (string): The type of the file.
      --]]
      function M.calc_file1(job)
          -- Calculate file type
          local child = Command("file")
              :args({
                  "-b",
                  tostring(job.file.url),
              })
              :stdout(Command.PIPED)
              :stderr(Command.PIPED)
              :spawn()

          local file_magic = child:read_line()
          if not file_magic then
              file_magic = "Unknown"
          end

          child:start_kill()

          return file_magic
      end

      --[[
        Function: peek
        Description: Generates a hexdump of the specified file using hexyl and updates the UI with the hexdump, file type, and SHA256 hash.
        Parameters:
          - job (table): Contains information about the current job, including the file URL, area dimensions, and skip count.
      --]]
      function M:peek(job)
          local child = Command("hexyl")
              :args({
                  "--border",
                  "none",
                  "--terminal-width",
                  tostring(job.area.w),
                  "--character-table", "ascii",
                  tostring(job.file.url),
              })
              :stdout(Command.PIPED)
              :stderr(Command.PIPED)
              :spawn()

          -- Ensure that the hexyl command was spawned successfully
          if not child then
              ya.err("Failed to spawn hexyl for file: " .. tostring(job.file.url))
              return
          end

          local limit = job.area.h
          local i, lines = 0, ""
          repeat
              local next_line, event = child:read_line()
              if event == 1 then
                  ya.err("Hexyl error event: " .. tostring(event))
                  break
              elseif event ~= 0 then
                  break
              end

              i = i + 1
              if i > job.skip then
                  lines = lines .. next_line
              end
          until i >= job.skip + limit

          child:start_kill()

          if job.skip > 0 and i < job.skip + limit then
              ya.manager_emit("peek", { 
                  math.max(0, job.skip + i - limit), 
                  only_if = tostring(job.file.url), 
                  upper_bound = true 
              })
          else
              lines = lines:gsub("\t", string.rep(" ", PREVIEW.tab_size))

              -- Define display areas within the peek function
              local hexdumpArea = ui.Rect {
                  x = job.area.x,
                  y = job.area.y + 3,
                  w = job.area.w,
                  h = job.area.h - 3,
              }
              local fileArea = ui.Rect {
                  x = job.area.x,
                  y = job.area.y,
                  w = job.area.w,
                  h = 1,
              }
              local sha256Area = ui.Rect {
                  x = job.area.x,
                  y = job.area.y + 1,
                  w = job.area.w,
                  h = 1,
              }

              -- Fetch file type and SHA256 hash
              local file1 = M.calc_file1(job)
              local sha256 = M.calc_sha256(job)

              -- Update the UI with the hexdump and file information
              ya.preview_widgets(job, {
                  ui.Text.parse(lines):area(hexdumpArea),
                  ui.Text.parse(" File(1): " .. file1):area(fileArea),
                  ui.Text.parse(" SHA256: " .. sha256):area(sha256Area)
              })
          end
      end

      function M:seek(job)
          local h = cx.active.current.hovered
          if h and h.url == job.file.url then
              local step = math.floor(job.units * job.area.h / 10)
              ya.manager_emit("peek", {
                  tostring(math.max(0, cx.active.preview.skip + step)),
                  only_if = tostring(job.file.url),
              })
          end
      end

      return M
    '';
    executable = false;
  };
}
