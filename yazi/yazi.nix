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
  #
  # TODO- borrow some ideas from: https://github.com/khaneliman/khanelinix/blob/main/modules/home/programs/terminal/tools/yazi/default.nix
in {

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    package = channels.nixpkgs-unstable-feb-2025.yazi;

    initLua = ''
      require("relative-motions"):setup({ show_numbers="relative", show_motion = true })
    '';

    plugins = {
      # Preview Markdown files
      "glow" = channels.nixpkgs-unstable.fetchFromGitHub {
        owner = "Reledia";
        repo = "glow.yazi";
        rev = "c76bf4fb612079480d305fe6fe570bddfe4f99d3";
        hash = "sha256-DPud1Mfagl2z490f5L69ZPnZmVCa0ROXtFeDbEegBBU=";
      };

      # Preview archives as a tree
      "ouch" = channels.nixpkgs-unstable.fetchFromGitHub {
        owner = "ndtoan96";
        repo = "ouch.yazi";
        rev = "0742fffea5229271164016bf96fb599d861972db";
        hash = "sha256-C0wG8NQ+zjAMfd+J39Uvs3K4U6e3Qpo1yLPm2xcsAaI=";
      };

      # Search with fg / ff (content, fzf)
      # TODO: Migrate to https://github.com/lpnh/fr.yazi
      "fg" = channels.nixpkgs-unstable.fetchFromGitHub {
        owner = "DreamMaoMao";
        repo = "fg.yazi";
        rev = "c201a3e1c0cda921c06019127886f16faef4b17e";
        hash = "sha256-PNZngyiWuzw2bmJ4v66er9HEAcD5z0Dr6iKYwcxJwf0=";
      };

      # Vim-like relative motions
      "relative-motions" = channels.nixpkgs-unstable.fetchFromGitHub {
        owner = "dedukun";
        repo = "relative-motions.yazi";
        rev = "3a85f7c60b44cd0f9691a3307c8c22bd45217c78";
        sha256 = "sha256-QCCKkYMQ6+wurKjvN0jQi3k+3geBnS5uqq1boK1M2k4=";
      };

      # Preview media metadata information
      "mediainfo" = channels.nixpkgs-unstable.fetchFromGitHub {
        owner = "boydaihungst";
        repo = "mediainfo.yazi";
        rev = "436cb5f04d6e5e86ddc0386527254d87b7751ec8";
        hash = "sha256-oFp8mJ62FsJX46mKQ7/o6qXPC9qx3+oSfqS0cKUZETI=";
      };
    };

    keymap = {
      manager = {
        prepend_keymap = [
          # Relative motions
          { on = [ "1" ]; run = "plugin relative-motions 1"; desc = "Move in relative steps"; }
          { on = [ "2" ]; run = "plugin relative-motions 2"; desc = "Move in relative steps"; }
          { on = [ "3" ]; run = "plugin relative-motions 3"; desc = "Move in relative steps"; }
          { on = [ "4" ]; run = "plugin relative-motions 4"; desc = "Move in relative steps"; }
          { on = [ "5" ]; run = "plugin relative-motions 5"; desc = "Move in relative steps"; }
          { on = [ "6" ]; run = "plugin relative-motions 6"; desc = "Move in relative steps"; }
          { on = [ "7" ]; run = "plugin relative-motions 7"; desc = "Move in relative steps"; }
          { on = [ "8" ]; run = "plugin relative-motions 8"; desc = "Move in relative steps"; }
          { on = [ "9" ]; run = "plugin relative-motions 9"; desc = "Move in relative steps"; }

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
          { on = [ "f" "g" ]; run = "plugin fg";              desc = "Find file by Content (Fuzzy)";   }
          { on = [ "f" "G" ]; run = "plugin fg -- rg";        desc = "Find file by Content (RipGrep)"; }
          { on = [ "f" "f" ]; run = "plugin fg -- fzf'";      desc = "Find file by Name";              }

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
          { on = [ "b" "o" ]; run = "shell 'xdragon -x -i -T \"$1\"' --confirm"; desc = "Drag file OUT of yazi"; }
          { on = [ "b" "i" ]; run = "shell DRAG_TO_VM --confirm"; desc = "Drag file INTO yazi"; }

          # Copy
          { on = [ "c" "h" ]; run = "shell --confirm 'ef \"$@\" [| pf \"{sha256}  {path}\n\" ]| xsel -psb'"; desc = "Copy SHA256 and filename of selected files"; }
          { on = [ "c" "H" ]; run = "shell --confirm 'ef \"$@\" [| pf \"{sha256}\n\" ]| xsel -psb'"; desc = "Copy SHA256 of selected files"; }
          { on = [ "c" "p" ]; run = "shell --confirm 'echo $PWD | xsel -psb'"; desc = "Copy the current folder path"; }

          # ' - Common Aliases
          # 1 - Reserved
          # 2 - Reserved

          # 3 - Files
          # Compression
          { on = [ "'" "3" "c" ]; run = "shell --interactive --block '7z a -pinfected -mhe=on \"$1\".7z \"$@\"'"; desc = "Compress seleted files with password=infected"; }
          { on = [ "'" "3" "e" ]; run = "shell --interactive --block '7z x \"$@\" -pinfected'";                   desc = "Extract with password=infected"; }
          { on = [ "'" "3" "r" ]; run = "shell --interactive --block 'unar $@'"; desc = "Decompress with unar"; }

          # 4 - Tools
          { on = [ "'" "4" "j" ]; run = "shell --interactive --orphan 'jadx-gui \"$@\"'"; desc = "Launch Jadx-GUI with the selected file"; }
          { on = [ "'" "4" "g" ]; run = "shell --confirm 'GoReSym $@ | dump $@_info/goresym'"; desc = "Run GoReSym"; }
          { on = [ "'" "4" "w" ]; run = "shell --confirm 'wireshark $@'"; desc = "Run Wireshark"; }
          { on = [ "'" "4" "c" ]; run = "shell --confirm 'capa -j $@ | dump $@_info/capa'"; desc = "Run Capa"; }
          { on = [ "'" "4" "f" ]; run = "shell --confirm 'floss -j $@ | dump $@_info/floss'"; desc = "Run Floss"; }
          { on = [ "'" "4" "d" "d" ]; run = "shell --confirm 'ilspycmd -p -d -usepdb --no-dead-code --no-dead-stores -o $@_info/decompiled/ $@'"; desc = "[D]otNet [D]ecompile"; }
          { on = [ "'" "4" "h" ]; run = "shell --confirm --orphan '${nixGLPrefix}imhex $@'"; desc = "Open in ImHex"; }

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
          { name = "*.md";                      run = "glow"; }
          { mime = "application/*zip";          run = "ouch"; }
          { mime = "application/tar";           run = "ouch"; }
          { mime = "application/bzip2";         run = "ouch"; }
          { mime = "application/7z-compressed"; run = "ouch"; }
          { mime = "application/rar";           run = "ouch"; }
          { mime = "application/xz";            run = "ouch"; }
          { mime = "{image,audio,video}/*";     run = "mediainfo"; }
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

          { mime = "application/*json*"; use = [ "json" ]; }

          { mime = "application/microsoft.portable-executable"; use = [ "triage_pe" ]; }
          { mime = "application/msi"; use = [ "triage_msi" ]; }
          { mime = "application/ms-cab-compressed"; use = [ "triage_cab" ]; }

          { mime = "application/executable"; use = [ "triage_elf" ]; }
          { mime = "application/coredump"; use = [ "triage_elf" ]; }
          { mime = "application/object"; use = [ "triage_elf" ]; }
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

  home.file."/.config/yazi/plugins/previewer.yazi/main.lua" = {
    text = ''
      local M = {}

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

        local limit = job.area.h - 3
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

        -- If we're trying to scroll past the end, clamp to the maximum valid position
        if job.skip > 0 and i < job.skip + limit then
          local max_skip = math.max(0, i - limit)
          if job.skip > max_skip then
            -- We've scrolled too far, correct the position
            ya.manager_emit("peek", { 
              max_skip, 
              only_if = tostring(job.file.url), 
              upper_bound = true 
            })
            return
          end
        end
        
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
