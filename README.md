# Demo

If you would like to follow along, while this should directly work on any Linux VM, a testing VM with a bare-bones Debian VM is available here:
[TODO] Make the bare-bones VM:
- 48gb vm
- Add user to sudoers file
- Install curl
- Disable sleep mode (for VM perf)

## A Brief Overview
### Nix (The Langauge)
_Nix_ (the language) is a functional, declarative, and reproducible programming language. It is used by _Nix_ (the package manager) and _NixOS_ (the operating system).
### Nix (The Package Manager)
_Nix_ (the package manager) is a fully featured package manager written in _Nix_ (the langauge). It uses a repository named _[Nixpkgs](https://github.com/NixOS/nixpkgs)_ which hosts a very large number of packages (currently [108k](https://repology.org/repositories/statistics/total) on the Unstable branch), and their accompanying modules and expressions.

Searching for packages on _Nixpkgs_ is as simple as:
1. Web: https://search.nixos.org/packages
2. CLI`*`: `nix search nixpkgs <package-name>`

`*` Once installed

### Channels
The Nix package manager uses the concept of _channels_ to obtain specific versions of the _Nixpkgs_ repository. 

The following are the most commonly used _channels_:
- `nixos-25.05` - The current stable channel
- `nixpkgs-unstable` - The current unstable channel
More channels can be found here: https://channels.nixos.org/

One way of interfacing with the Nix package manager is to simply subscribe to a _channel_ and install/use packages from it.

For example:
```
nix-channel --add https://channels.nixos.org/nixpkgs-unstable nixpkgs
```
will subscribe you to the unstable channel.

And one can use:
- `nix-shell -p <package-name>` (expanded upon further in the demo)
or 
- `nix-env -iA nixpkgs.<package-name>` (_not recommended!_`*`) 
to install a given package.

`*` This is _not declarative_ and _does not add the package to your Nix configuration!_ This should only be used if you would like to use the Nix package manager like a traditional package manager.

Note: You _can_ technically pin and download packages from the current _upstream_ nixpkgs (and therefore being _ahead_ of even the unstable channel) however, this is not recommended as most packages will not have cached bins (you will be building a _lot_ from source!) If a specific newer (or older) version of a package is required, you can bring in a specific older or newer state of nixpkgs via its commit hash, or bring in a newer/older version of the package itself via its git commit hash. For both options, you can set up an [overlay (see: Examples of overlays)](https://wiki.nixos.org/wiki/Overlays) to use the newer/older version of the package. 

For some examples of pinning nixpkgs as well as specific packages, check `channels.nix` within the demo files, as well as [this blog post](https://jade.fyi/blog/pinning-packages-in-nix/) for some inspiration.

### Home-Manager
[Home-Manager](https://nix-community.github.io/home-manager/) is a system for managing a user environment using the Nix package manager. It provides configuration options for packages that use downloaded via nixpkgs, and allows you to configure said packages in a declarative manner. The demo uses home-manager configuration of nearly all packages, where possible.

### Flakes
[Flakes](https://wiki.nixos.org/wiki/Flakes) are a widely used 'experimental feature' which attempts to improve parts of the Nix ecosystem by providing abstraction for pinning specific versions of dependencies and sharing dependencies via lock files.

While a very popular option, and certainly worth exploring, I am personally not well versed in Flakes, and do not use it for my personal configurations. Thus, for this demo we will not be covering or using flakes. 

However, this does not mean we will not be achieving some of its main benefits (e.g.  dependency pinning)- we will just be doing it _without_ flakes.

### NixOS
_NixOS_ is an immutable operating system which uses the _Nix_ language to control the operating system. We will not be using NixOS here today as:
- There _are_ benefits to having an escape-hatch from the _Nix_ ecosystem
- A core idea of the demo is to showcase utilizing Nix within a non-NixOS environment

# Demo
## Setting Up Nix (Lix)
We will be using _[Lix](https://lix.systems/about)_, a fork/implementation of the _Nix_ package manager for this demo (there is much discourse on the _Nix_ package manager and its forks...), however, I will use the names _Nix_ and _Lix_ interchangeably, as functionally, there should be no major differences, especially during this demo.

We will begin by simply installing a premade setup, and we can dive into it further once it is installed. 

Installing _Lix_ is as simple as running:
```
curl -sSf -L https://install.lix.systems/lix | sh -s -- install
```
and going through its installation process:
- When asked if you would like to enable Flakes, feel free to enable them (there is no downside to this)
- Proceed with the plan created by the installer
- Once complete, run the following command:
```
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

## Trying Out a Package
Sometimes, we want to use a package _temporarily_, maybe just to try it out, or to use it for a one-time process without installing and uninstalling it.

This is supported within the Nix package manager via [nix-shell](https://nix.dev/manual/nix/2.18/command-ref/nix-shell)'s `--package`/`-p` option!

Right now, we don't have `git`, but we need to be able to clone the demo repository. To get around this, let's create a temporary shell with `git`:
```
nix-shell -p git
```

This will automatically grab a copy of the `git` package from `nixpkgs-unstable` and drop you into a shell with `git`.

## Downloading the Demo
Now that we have `git`, we can proceed with downloading the files for this demo, followed by exiting the shell with `git`:
```
git clone https://github.com/bsendpacket/nixcfg ~/.config/home-manager && exit
```
TODO: UPDATE LINK

## Installing the Demo
Let's now `cd` to the newly downloaded directory:
```
cd ~/.config/home-manager
```

And run the following command:
```
nix-shell
```
to enter a declarative shell created by the `shell.nix` file within this directory.

Once we are in the shell, let's install the configuration:
```
home-manager switch
```

This will:
- Install home-manager (pinned in `channels.nix`)
- Install a set of packages from nixpkgs (set in `home.nix`)
- Configure said packages as defined within the home-manager configuration

Once it has finished, we can `exit` out of the shell and run one last command to finalize the installation:
```
sudo ln ~/.local/share/applications/i3.desktop /usr/share/xsessions/
```
(To my knowledge, this cannot be done declaratively without NixOS, as Home Manager cannot not run as sudo and thus cannot modify files in the `/usr` directory)

And now we can reboot:
```
sudo reboot
```

Once we are at the login screen, select the user and click the settings cog on the bottom right to choose `i3` as the display manager:
![[Pasted image 20251025192059.png]]

Now, upon login- you will enter an `i3` window manager installation and can:
- Open a terminal (Alt-Enter)
- Pick a program to open (Alt-D)
- Switch between desktops (Alt-1, Alt-2, ...)
- Open a floating terminal (Alt-Esc)

# Showcase
## Installing Packages via Home Manager
`./home.nix` contains multiple examples of installing packages via Home Manager. 
In general, it is quite simple:
```
home = {
	packages = (with pkgs; [
		neovim
	])
}
```
In my setup, since I pin channels within my `channels.nix` file, it looks more like:
```
home = {
	packages = (with channels.nixpkgs-unstable; [
		...
	])
}
```
The former is more common, but it depends on your setup/preference.

## Git-Pinned Neovim Plugins
The Neovim theme `vim-moonfly-colors`, pulled in via `neovim/neovim.nix` is on an older version than upstream.
```
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
```
We can obtain the newest version via:
```
nurl https://github.com/bluz71/vim-moonfly-colors
```
Which provides us with:
```
fetchFromGitHub {
  owner = "bluz71";
  repo = "vim-moonfly-colors";
  rev = "ef85b89739bee184e204c89bc06280d62bd84039";
  hash = "sha256-VW4eiliCsQjX+wxvrFdQ7HVrl88RqW1FcntG8G6y/sk=";
}
```
However, when we update it, we will notice that it breaks the colors within Neovim.
While fixable, for the time being, reverting is simple: you just set the hash back to the old one.

## Nixpkgs Pinning Showcase
The API for Yazi changes frequently, and can be problematic when updating. The latest versions have breaking changes for my configuration, and not all of the plugins I use currently support it. For cases like this, pinning Nixpkgs can be a viable option. Within `channels.nix`, you can find an second unstable NixPkgs pinned at a git commit hash from Feburary 2025:
```
nixpkgs-unstable-feb-2025 = import (builtins.fetchTarball {
  url = "https://github.com/NixOS/nixpkgs/archive/df251e20548ee2ee060ac4f43c4d52fafc62d695.tar.gz";
  sha256 = "sha256-NRLlc2l8v72H2mcj9cY9KMym1BFiweimzr/2X0y3PQ0=";
}) {
  system = "x86_64-linux";
  config = {
    allowUnfree = true;
  };
};
```
which I use to bring in a slightly older version of Yazi.


# Notes
## Good-To-Knows
Building takes up a lot of space within the Nix store. To remove unused/unreachable store objects, invoke the Nix garbage collector with the following command:
```
nix-collect-garbage
```

Switching derivations on a Nix setup can take a fair bit of memory, especially if some packages are built from source. Additionally, sometimes Nix will attempt to optimize for speed and build multiple packages at the same time. It is recommended to provide 6+GB of memory if you are anticipating a large build, especially on VMs.

## Resources
The [reference manual](https://nixos.org/manual/nixpkgs/stable) is hefty but has a _lot_ of information. Additionally, for learning more about using Nix with flakes, [zero-to-nix](https://zero-to-nix.com/) has a quick start guide and a section on common Nix [concepts](https://zero-to-nix.com/concepts/).
