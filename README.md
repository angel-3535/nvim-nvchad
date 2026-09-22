**This repo is supposed to be used as config by NvChad users!**

- The main nvchad repo (NvChad/NvChad) is used as a plugin by this repo.
- So you just import its modules , like `require "nvchad.options" , require "nvchad.mappings"`
- So you can delete the .git from this repo ( when you clone it locally ) or fork it :)

# Personal bindings

This configuration keeps NvChad's UI while restoring the main navigation,
editing, LSP, Harpoon, project-runner, and TODO bindings from `nvim-dotconfig`.

See [CONFIG-DIFFERENCES.md](CONFIG-DIFFERENCES.md) for the shortcuts and the
remaining plugin, language-support, and behavior differences.

On this workstation, run `nvchad` or `NVIM_APPNAME=nvim-nvchad nvim`.
Configuration and plugin data stay separate from the original `nvim` profile.

To install this fork on another machine with Neovim and Git installed:

```sh
git clone git@github.com:angel-3535/nvim-nvchad.git ~/.config/nvim-nvchad
NVIM_APPNAME=nvim-nvchad nvim
```

See the [NvChad installation prerequisites](https://nvchad.com/docs/quickstart/install/).
Language servers and formatters are managed separately through `:Mason`.

# Credits

1) Lazyvim starter https://github.com/LazyVim/starter as nvchad's starter was inspired by Lazyvim's . It made a lot of things easier!
