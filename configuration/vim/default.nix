with import <nixpkgs> {};

let
  vimrc = builtins.readFile ./vimrc/default.vim;
  plugins = callPackage ./plugins.nix {};
  rc = ''
  ${vimrc}
    '';
  vamConfig = {
    knownPlugins = pkgs.vimPlugins // plugins;
    pluginDictionaries = [ { names = [
        "sensible"
        "vim-nix"
        "fugitive"
        "fzf"
        "fzf.vim"
        "trailing-whitespace"
        "nerdtree"
        ];
      }
    ];
  };

  custom_vim = vim_configurable.customize {
    name = "vim";
    vimrcConfig.customRC = rc;
    vimrcConfig.vim = vamConfig;
  };

  custom_neovim = pkgs.neovim.override {
    vimAlias = true;
    configure = {
      customRC = rc;
      vam = vamConfig;
    };
  };
in
  lib.overrideDerivation custom_neovim (o: {
    ftNixSupport             = true;
    luaSupport              = true;
  })
