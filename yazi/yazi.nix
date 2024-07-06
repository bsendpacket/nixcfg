{ pkgs, ... }: 
let
  # To get a SHA-256 for a GitHub repo:
  # Use nix-prefetch-url --unpack
  # i.e. for the Hexyl repo, use:
  # nix-prefetch-url --unpack https://github.com/Reledia/hexyl.yazi/archive/refs/heads/main.zip

  # Alternatively, simply leave the sha256 field blank
  # and copy the correct hash during rebuild

  # Hex viewer
  hexylPlugin = pkgs.fetchFromGitHub {
    owner = "Reledia";
    repo = "hexyl.yazi";
    rev = "4162cb34fa9d4e27251243714c3c19166aa4be95";
    sha256 = "15ci64d29qc6qidnmsmy4ykzfcjdzpz6hx25crsbg1rfad9vqxbj";
  };

  # Preview Markdown files
  glowPlugin = pkgs.fetchFromGitHub {
    owner = "Reledia";
    repo = "glow.yazi";
    rev = "cf1f1f0a36a0411fcc99d3666692a543fc626f3d";
    sha256 = "sha256-U4ullcOwN6TCaZ8gXCPMk/fGbtZLe4e1Y0RhRKLZKng=";
  };

  # Preview archives as a tree
  ouchPlugin = pkgs.fetchFromGitHub {
    owner = "ndtoan96";
    repo = "ouch.yazi";
    rev = "694d149be5f96eaa0af68d677c17d11d2017c976";
    sha256 = "sha256-J3vR9q4xHjJt56nlfd+c8FrmMVvLO78GiwSNcLkM4OU=";
  };

  # Search with fg / ff (content, fzf)
  fgPlugin = pkgs.fetchFromGitHub {
    owner = "DreamMaoMao";
    repo = "fg.yazi";
    rev = "cc53d56a673e5ec2cf48a6f18bc76d83aa61d52d";
    sha256 = "sha256-xUZdmDZhbUzX5Ka2xogRQJI52EL81n9ZLrcxDacgfN0=";
  };

  # Vim-like relative motions
  relativeMotionsPlugin = pkgs.fetchFromGitHub {
    owner = "dedukun";
    repo = "relative-motions.yazi";
    rev = "585554d512ae31fbb6211ab20372f4d913884a3f";
    sha256 = "sha256-WPGoHx70Xrq037zT12DWcICAzolwltqbu+WeTRAsoFs=";
  };

in {
  xdg.configFile = {
    "yazi/init.lua".source = pkgs.writeText "init.lua" ''
      require("relative-motions"):setup({ show_numbers="relative", show_motion = true })
    '';
    
    # Previewers
    "yazi/plugins/hexyl.yazi".source = hexylPlugin;
    "yazi/plugins/glow.yazi".source = glowPlugin;
    "yazi/plugins/ouch.yazi".source = ouchPlugin;

    # Functional Plugins
    "yazi/plugins/fg.yazi".source = fgPlugin;
    "yazi/plugins/relative-motions.yazi".source = relativeMotionsPlugin;

  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;

    keymap = {
      manager = {
        prepend_keymap = [
          { on = [ "1" ]; run = "plugin relative-motions --args=1"; desc = "Move in relative steps"; }
          { on = [ "2" ]; run = "plugin relative-motions --args=2"; desc = "Move in relative steps"; }
          { on = [ "3" ]; run = "plugin relative-motions --args=3"; desc = "Move in relative steps"; }
          { on = [ "4" ]; run = "plugin relative-motions --args=4"; desc = "Move in relative steps"; }
          { on = [ "5" ]; run = "plugin relative-motions --args=5"; desc = "Move in relative steps"; }
          { on = [ "6" ]; run = "plugin relative-motions --args=6"; desc = "Move in relative steps"; }
          { on = [ "7" ]; run = "plugin relative-motions --args=7"; desc = "Move in relative steps"; }
          { on = [ "8" ]; run = "plugin relative-motions --args=8"; desc = "Move in relative steps"; }
          { on = [ "9" ]; run = "plugin relative-motions --args=9"; desc = "Move in relative steps"; }

          { on = [ "f" "g" ]; run = "plugin fg";                    desc = "Find file by Content";   }
          { on = [ "f" "f" ]; run = "plugin fg --args='fzf'";       desc = "Find file by Name";      }

          { on = [ "K" ];     run = "seek -5";                      desc = "Seek up 5 units in the preview";   }
          { on = [ "J" ];     run = "seek 5";                       desc = "Seek down 5 units in the preview"; }
          { on = [ "<C-k>" ]; run = "arrow -5";                     desc = "Move cursor up 5 lines";           }
          { on = [ "<C-j>" ]; run = "arrow 5";                      desc = "Move cursor down 5 lines";         }
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
        cwd = { fg = "#85dc85"; };
        hovered = { reversed = true; };
        preview_hovered = { underline = true; };

        find_keyword = {
          fg = "#c6c684";
          bold = true;
          italic = true;
          underline = true;
        };

        find_position = { 
          fg = "#ae81ff";
          bg = "reset";
          bold = true;
          italic = true;
        };

        marker_copied = {
          fg = "#36c692";
          bg = "#36c692";
        };

        marker_cut = {
          fg = "#ff5189";
          bg = "#ff5189";
        };

        marker_marked = {
          fg = "#c6c684";
          bg = "#c6c684";
        };

        marker_selected = {
          fg = "#74b2ff";
          bg = "#74b2ff";
        };

        tab_active = {
          fg = "#080808";
          bg = "#e4e4e4";
        };

        tab_inactive = {
          fg = "#e4e4e4";
          bg = "#323437";
        };

        tab_width = 1;
        count_copied = {
          fg = "#080808";
          bg = "#36c692";
        };

        count_cut = {
          fg = "#080808";
          bg = "#ff5189";
        };

        count_selected = {
          fg = "#080808";
          bg = "#74b2ff";
        };

        border_symbol = "│";
        border_style = { fg = "#949494"; };
      };
      
      status = {
        separator_open = "";
        separator_close = "";

        separator_style = {
          fg = "#323437";
          bg = "#323437";
        };

        mode_normal = {
          fg = "#080808";
          bg = "#74b2ff";
          bold = true;
        };

        mode_select = {
          fg = "#080808";
          bg = "#36c692";
          bold = true;
        };

        mode_unset = {
          fg = "#080808";
          bg = "#ff5189";
          bold = true;
        };

        progress_label = {
          fg = "#e4e4e4";
          bold = true;
        };

        progress_normal = {
          fg = "#74b2ff";
          bg = "#323437";
        };

        progress_error = {
          fg = "#ff5189";
          bg = "#323437";
        };

        permissions_t = { fg = "#74b2ff"; };
        permissions_r = { fg = "#c6c684"; };
        permissions_w = { fg = "#ff5189"; };
        permissions_x = { fg = "#36c692"; };
        permissions_s = { fg = "#949494"; };
      };

      input = {
        border = { fg = "#74b2ff"; };
        title = {};
        value = {};
        selected = { reversed = true; };
      };

      select = {
        border = { fg = "#74b2ff"; };
        active = { fg = "#ae81ff"; };
        inactive = {};
      };

      tasks = {
        border = { fg = "#74b2ff"; };
        title = {};
        hovered = { underline = true; };
      };

      which = {
        mask = { bg = "#323437"; };
        cand = { fg = "#85dc85"; };
        rest = { fg = "#bdbdbd"; };
        desc = { fg = "#ae81ff"; };
        separator = "  ";
        separator_style = { fg = "#949494"; };
      };

      help = {
        on = { fg = "#ae81ff"; };
        run = { fg = "#85dc85"; };
        desc = { fg = "#bdbdbd"; };
        hovered = {
          bg = "#323437";
          bold = true;
        };
        footer = {
          fg = "#323437";
          bg = "#e4e4e4";
        };
      };

      filetype = {
        rules = [
          { mime = "image/*"; fg = "#85dc85"; }
          { mime = "video/*"; fg = "#c6c684"; }
          { mime = "audio/*"; fg = "#c6c684"; }
          { mime = "application/zip"; fg = "#ae81ff"; }
          { mime = "application/gzip"; fg = "#ae81ff"; }
          { mime = "application/x-tar"; fg = "#ae81ff"; }
          { mime = "application/x-bzip"; fg = "#ae81ff"; }
          { mime = "application/x-bzip2"; fg = "#ae81ff"; }
          { mime = "application/x-7z-compressed"; fg = "#ae81ff"; }
          { mime = "application/x-rar"; fg = "#ae81ff"; }
          { name = "*"; fg = "#e4e4e4"; }
          { name = "*/"; fg = "#74b2ff"; }
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
                  y = self.area.y,
                  w = self.area.w,
                  h = 1,
              }

              -- Print hexdump
              fileArea = ui.Rect {
                  x = self.area.x,
                  y = self.area.y + 1,
                  w = self.area.w,
                  h = 1,
              }

              sha256Area = ui.Rect {
                  x = self.area.x,
                  y = self.area.y + 2,
                  w = self.area.w,
                  h = 1,
              }

              hexdumpArea = ui.Rect {
                  x = self.area.x,
                  y = self.area.y + 4,
                  w = self.area.w,
                  h = self.area.h - 4,
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
