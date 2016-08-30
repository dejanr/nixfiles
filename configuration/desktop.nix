{ pkgs, ... }:

let
  credentials = import ../credentials.nix;
in
{
  environment.systemPackages = with pkgs; [
    arandr # manage dispays
    chromium
    google-chrome
    evince # gnome document viewer
    electrum # bitcoin thin-client
    firefox
    freecad # General purpose Open Source 3D CAD/MCAD/CAx/CAE/PLM modeler
    gnupg # encryption
    gtypist # typing practice
    google-drive-ocamlfuse # FUSE-based file system backed by Google Drive
    hfsprogs # HFS user space utils, for mounting HFS+ osx partitions
    inkscape # vector graphics editor
    kde4.calligra # suite of producitivity applications
    keepassx2 # password managment
    keychain
    libnotify # send notifications to a notification daemon
    libreoffice
    meshlab # Processing and editing of unstructured 3D triangular meshes
    networkmanagerapplet
    openscad # 3D parametric model compiler
    pamixer # cli tools for pulseaudio
    pinentry # gnupg interface to passphrase input
    pidgin-with-plugins
    purple-plugin-pack
    pidginwindowmerge # merge contacts and message window
    skype4pidgin # use running skype inside pidgin
    pidgin-skypeweb
    scrot # screen capturing
    skype
    tesseract # OCR engine
    transmission # bittorrent client
    unrar
    unzip
    xarchiver
    xclip # clipboard
    xdg_utils # Set of cli tools that assist applications integration
    xfce.gtk_xfce_engine
    xfce.gvfs # virtual filesystem
    xfce.ristretto
    xfce.thunar # file manager
    xfce.thunar_volman
    xfce.tumbler
    xfce.xfce4icontheme
    xfce.xfconf
    xlibs.libX11
    xlibs.libXinerama
    xlibs.xev
    xlibs.xkill
    xlibs.xmessage
    xsel
    xsettingsd
    zip
    qalculate-gtk # The ultimate desktop calculator
    polkit # A dbus session bus service that is used to bring up authentication dialogs
    pcmanfm # File manager witth GTK+ interface
    transmission_gtk
    thunderbird # email client
    pythonPackages.udiskie # Removable disk automounter for udisks
    slic3r # G-code generator for 3D printers
    sxiv # image viewer
    printrun # 3d printing host software
    pythonPackages.youtube-dl # Command-line tool to download videos from YouTube.com and other sites
  ];

  services = {
    transmission = {
      enable = true;
      settings = {
        incomplete-dir-enabled = false;
        ratio-limit-enabled = true;
        watch-dir-enabled = true;
        ratio-limit = 2;
        encryption = 2;
        umask = 2;
        speed-limit-up = 1;
        speed-limit-up-enabled = true;
        rpc-whitelist = "127.0.0.1,192.168.*.*";
        rpc-username = credentials.transmission-user;
        rpc-password = credentials.transmission-password;
      };
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
    nixpkgs.config.packageOverrides = pkgs: {
      inherit (import ./packages { inherit pkgs; }) custom;
    };
  };
}
