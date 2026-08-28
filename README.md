# nixcfg — macOS (terminal only)

A [home-manager](https://github.com/nix-community/home-manager) config that manages
the terminal environment only: **zsh** (oh-my-zsh + powerlevel10k), **neovim**
(via nixvim), **yazi**, **zoxide**, **git**, and the CLI utilities they depend on.

This branch is the macOS port of the Linux config on `master`. Everything
X11/i3-specific and all of the reverse-engineering tooling has been removed.

**kitty** is config-managed but not installed here: `programs.kitty.package` is
`null`, so home-manager writes `~/.config/kitty/kitty.conf` and leaves the app
itself to the Homebrew cask (`brew install --cask kitty`). This matters because
the emulator supplies the 16 ANSI colors that `lsd`, powerlevel10k, `git` and
`bat` all draw from — without it, `colorscheme.nix` only reaches yazi.

## Notes
- The install assumes `curl` and `git` from the system (Xcode Command Line Tools).
- `channels.nix` uses `builtins.currentSystem`, so the same tree evaluates on
  `aarch64-darwin`, `x86_64-darwin` and `x86_64-linux`.
- The nix-managed zsh is not made the login shell. macOS already uses zsh, and it
  reads the `~/.zshrc` that home-manager writes, which is enough. See below if you
  want the exact nix build of zsh instead.

## Installation
```
1. xcode-select --install
2. curl -sSf -L https://install.lix.systems/lix | sh -s -- install
3. Restart shell
4. git clone -b macos https://github.com/bsendpacket/nixcfg ~/.config/home-manager && cd ~/.config/home-manager
5. git update-index --assume-unchanged git/git.nix
6. Add your name/email to git/git.nix
7. nix-shell
8. home-manager switch
9. exit, then restart the shell
```

kitty picks up the font and palette on its next start; `ctrl+shift+f5` reloads
the config in a running instance. Note the family name is **CaskaydiaCove Nerd
Font Mono** on macOS — the Linux config's `CaskaydiaCove NFM Light` does not
resolve here.

## Optional: use the nix build of zsh as the login shell
```
sudo sh -c 'echo "$HOME/.nix-profile/bin/zsh" >> /etc/shells'
chsh -s ~/.nix-profile/bin/zsh
```

## Layout
| Path | What it configures |
| --- | --- |
| `channels.nix` | Pinned nixpkgs / home-manager / nixvim inputs |
| `home.nix` | Entry point: imports, packages, session variables |
| `colorscheme.nix` | Shared palette, consumed by zsh and yazi |
| `kitty/` | kitty colors and font (config only — app comes from brew) |
| `zsh/` | zsh, oh-my-zsh, powerlevel10k, vi-mode, fzf history |
| `neovim/` | nixvim: LSPs, cmp, telescope, treesitter, DAP |
| `yazi/` | yazi keymaps, previewers, theme, hexdump previewer plugin |
| `zoxide/`, `git/` | zoxide and git |

## FAQ
- **Yazi is pinned to an older nixpkgs.** Yazi renamed its `manager` config
  section to `mgr` in later releases. `channels.nix` keeps the Feb 2025 pin so
  `yazi/yazi.nix` stays valid; updating means renaming those keys.
- **Homebrew shadows the nix profile.** `~/.zprofile` runs `brew shellenv`, which
  prepends `/opt/homebrew/bin`, and zsh sources it *after* home-manager's
  `~/.zshenv` — so a brew-installed `nvim`/`git`/`jq` would win over the nix ones.
  `zsh/zsh.nix` re-prepends `~/.nix-profile/bin` from `.zshrc` (sourced last) to
  correct this. Check with `command -v nvim`.
- **`rustup` is installed but has no toolchain.** Run `rustup default stable`
  once — `rustaceanvim` in neovim shells out to `rustup run stable rust-analyzer`.
