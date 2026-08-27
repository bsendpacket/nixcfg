# nixcfg — macOS (terminal only)

A [home-manager](https://github.com/nix-community/home-manager) config that manages
the terminal environment only: **zsh** (oh-my-zsh + powerlevel10k), **neovim**
(via nixvim), **yazi**, **zoxide**, **git**, and the CLI utilities they depend on.

This branch is the macOS port of the Linux config on `master`. Everything
X11/i3-specific and all of the reverse-engineering tooling has been removed.
No GUI applications are managed here — install your terminal emulator
(Ghostty, iTerm2, kitty, …) however you like; nix only configures what runs
*inside* it.

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

Then point your terminal emulator at the **CaskaydiaCove Nerd Font Mono** family
(installed by `home.packages`) so the powerlevel10k prompt and yazi icons render.

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
| `zsh/` | zsh, oh-my-zsh, powerlevel10k, vi-mode, fzf history |
| `neovim/` | nixvim: LSPs, cmp, telescope, treesitter, DAP |
| `yazi/` | yazi keymaps, previewers, theme, hexdump previewer plugin |
| `zoxide/`, `git/` | zoxide and git |

## FAQ
- **Yazi is pinned to an older nixpkgs.** Yazi renamed its `manager` config
  section to `mgr` in later releases. `channels.nix` keeps the Feb 2025 pin so
  `yazi/yazi.nix` stays valid; updating means renaming those keys.
- **`rustup` is installed but has no toolchain.** Run `rustup default stable`
  once — `rustaceanvim` in neovim shells out to `rustup run stable rust-analyzer`.
