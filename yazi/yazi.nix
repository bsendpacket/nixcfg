{ pkgs, colorscheme, ... }: 
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

    initLua = ''
      require("relative-motions"):setup({ show_numbers="relative", show_motion = true })
    '';

    plugins = {
      # Hex viewer
      "hexyl" = pkgs.fetchFromGitHub {
        owner = "Reledia";
        repo = "hexyl.yazi";
        rev = "64daf93a67d75eff871befe52d9013687171ffad";
        hash = "sha256-B2L3/Q1g0NOO6XEMIMGBC/wItbNgBVpbaMMhiXOYcrI=";
      };

      # Preview Markdown files
      "glow" = pkgs.fetchFromGitHub {
        owner = "Reledia";
        repo = "glow.yazi";
        rev = "536185a4e60ac0adc11d238881e78678fdf084ff";
        sha256 = "sha256-NcMbYjek99XgWFlebU+8jv338Vk1hm5+oW5gwH+3ZbI=";
      };

      # Preview archives as a tree
      "ouch" = pkgs.fetchFromGitHub {
        owner = "ndtoan96";
        repo = "ouch.yazi";
        rev = "251da6930ca8b7ee0384810086c3bf644caede3e";
        sha256 = "sha256-yLt9aY6hUIOdBI5bMdCs7VYFJGyD3WIkmPxvWKNCskA=";
      };

      # Search with fg / ff (content, fzf)
      "fg" = pkgs.fetchgit {
        url = "https://gitee.com/DreamMaoMao/fg.yazi";
        rev = "bb5832fcc7a20f9011fee86cab91b492ad203dfd";
        sha256 = "sha256-IHlQSRHwnKxJ/y+bDInXmCImdEHjb1Eq7/cKECbs+oU=";
      };

      # Vim-like relative motions
      "relative-motions" = pkgs.fetchFromGitHub {
        owner = "dedukun";
        repo = "relative-motions.yazi";
        rev = "73f554295f4b69756597c9fe3caf3750a321acea";
        sha256 = "sha256-jahJC6LXOnr974+zHEH9gqI+J1C68O+PvjSt8pelkP0=";
      };

      # Preview media metadata information
      "mediainfo" = pkgs.fetchFromGitHub {
        owner = "Ape";
        repo = "mediainfo.yazi";
        rev = "c69314e80f5b45fe87a0e06a10d064ed54110439";
        sha256 = "sha256-8xdBPdKSiwB7iRU8DJdTHY+BjfR9D3FtyVtDL9tNiy4=";
      };
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
          { on = [ "c" "h" ]; run = "shell --confirm 'ef \"$@\" [| cfmt \"{sha256}  {path}\n\" ]| xclip -selection clipboard'"; desc = "Copy SHA256 and filename of files in directory"; }

          # ' - Common Aliases
          # 1 - Reserved
          # 2 - Reserved

          # 3 - Files
          # Compression
          { on = [ "'" "3" "c" ]; run = "shell --interactive --block '7z a -pinfected -mhe=on \"$@\".7z \"$@\"'"; desc = "Compress folder with password=infected"; }
          { on = [ "'" "3" "e" ]; run = "shell --interactive --block '7z x \"$@\" -pinfected'";                   desc = "Extract with password=infected";         }

          # 4 - Tools
          { on = [ "'" "4" "j" ]; run = "shell --interactive --orphan 'jadx-gui \"$@\"'"; desc = "Launch Jadx-GUI with the selected file"; }

        ];
      };
    };

    settings = {
      log = {
        enabled = true;
      };        

      plugin = {
        append_previewers = [
          { name = "*"; run = "previewer"; }
        ];
        prepend_previewers = [
          { name = "*.md";                        run = "glow"; }
          { mime = "application/*zip";            run = "ouch"; }
          { mime = "application/x-tar";           run = "ouch"; }
          { mime = "application/x-bzip2";         run = "ouch"; }
          { mime = "application/x-7z-compressed"; run = "ouch"; }
          { mime = "application/x-rar";           run = "ouch"; }
          { mime = "application/x-xz";            run = "ouch"; }
          { mime = "{image,audio,video}/*";       run = "mediainfo"; }
          { mime = "application/x-subrip";        run = "mediainfo"; }
        ];
      };

      manager = {
        ratio = [ 1 3 4 ];
        show_hidden = true;
        sort_by = "natural";
        sort_dir_first = true;
        sort_reverse = false;
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
      
      status = {
        separator_open = "";
        separator_close = "";

        separator_style = {
          fg = colorscheme.colors.black;
          bg = colorscheme.colors.black;
        };

        mode_normal = {
          fg = colorscheme.colors.background;
          bg = colorscheme.colors.n_pink_4;
          bold = true;
        };

        mode_select = {
          fg = colorscheme.colors.background;
          bg = colorscheme.colors.bright_green;
          bold = true;
        };

        mode_unset = {
          fg = colorscheme.colors.background;
          bg = colorscheme.colors.bright_red;
          bold = true;
        };

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

        permissions_t = { fg = colorscheme.colors.n_pink_4; };
        permissions_r = { fg = colorscheme.colors.bright_yellow; };
        permissions_w = { fg = colorscheme.colors.bright_red; };
        permissions_x = { fg = colorscheme.colors.bright_green; };
        permissions_s = { fg = colorscheme.colors.bright_black; };
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

      function M:calc_sha256()
              local child = Command('sha256sum')
                      :args({
                              tostring(self.file.url)
                      })
                      :stdout(Command.PIPED)
                      :stderr(Command.PIPED)
                      :spawn()

              local output = child:read_line()
              output = output:match("([a-z0-9]+)")

              child:start_kill()

              return output
      end

      function M:calc_file1()
          -- Calulate File
          local file1 = Command("file")
              :args({
                  "-b",
                  tostring(self.file.url),
              })
              :stdout(Command.PIPED)
              :stderr(Command.PIPED)
              :spawn()


          file_magic = file1:read_line()
          file1:start_kill()

          return file_magic
      end

      function M:peek()
          local child = Command("hexyl")
              :args({
                  "--border",
                  "none",
                  "--terminal-width",
                  tostring(self.area.w),
                  "--character-table", "ascii",
                  tostring(self.file.url),
              })
              :stdout(Command.PIPED)
              :stderr(Command.PIPED)
              :spawn()

          local limit = self.area.h
          local i, lines = 0, ""
          repeat
              local next, event = child:read_line()
              if event == 1 then
                  ya.err(tostring(event))
              elseif event ~= 0 then
                  break
              end

              i = i + 1
              if i > self.skip then
                  lines = lines .. next
              end
          until i >= self.skip + limit

          child:start_kill()
          if self.skip > 0 and i < self.skip + limit then
              ya.manager_emit(
                  "peek",
                  { tostring(math.max(0, i - limit)), only_if = tostring(self.file.url), upper_bound = "" }
              )
          else
              -- Print hexdump
              magicArea = ui.Rect {
                  x = self.area.x,
                  y = self.area.y - 1,
                  w = self.area.w,
                  h = 1,
              }

              -- Print hexdump
              fileArea = ui.Rect {
                  x = self.area.x,
                  y = self.area.y,
                  w = self.area.w,
                  h = 1,
              }

              sha256Area = ui.Rect {
                  x = self.area.x,
                  y = self.area.y + 1,
                  w = self.area.w,
                  h = 1,
              }

              hexdumpArea = ui.Rect {
                  x = self.area.x,
                  y = self.area.y + 3,
                  w = self.area.w,
                  h = self.area.h - 3,
              }

              lines = lines:gsub("\t", string.rep(" ", PREVIEW.tab_size))
              ya.preview_widgets(self, { 
                  ui.Paragraph.parse(hexdumpArea, lines),
                  ui.Paragraph.parse(fileArea, " File(1): " .. "Loading..."),
                  ui.Paragraph.parse(sha256Area, " SHA256: " .. "Loading...")
              })

              ya.preview_widgets(self, {
                  ui.Paragraph.parse(hexdumpArea, lines), 
                  ui.Paragraph.parse(fileArea, " File(1): " .. "Loading..."),
                  ui.Paragraph.parse(sha256Area, " SHA256: " .. "Loading...")
              })

              local file1 = M:calc_file1()

              ya.preview_widgets(self, {
                  ui.Paragraph.parse(hexdumpArea, lines), 
                  ui.Paragraph.parse(fileArea, " File(1): " .. file1),
                  ui.Paragraph.parse(sha256Area, " SHA256: " .. "Loading...")
              })
              
              local sha256 = M:calc_sha256()
              
              ya.preview_widgets(self, {
                  ui.Paragraph.parse(hexdumpArea, lines), 
                  ui.Paragraph.parse(fileArea, " File(1): " .. file1),
                  ui.Paragraph.parse(sha256Area, " SHA256: " .. sha256)
              })



          end
      end

      function M:seek(units)
          local h = cx.active.current.hovered
          if h and h.url == self.file.url then
              local step = math.floor(units * self.area.h / 10)
              ya.manager_emit("peek", {
                  tostring(math.max(0, cx.active.preview.skip + step)),
                  only_if = tostring(self.file.url),
              })
          end
      end

      return M
    '';
    executable = false;
  };
}
