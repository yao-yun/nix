{
  pkgs,
  ...
}:
{
  stylix = {
    enable = true;
    cursor = {
      name = "macOS";
      package = pkgs.apple-cursor;
      size = 24;
    };
    icons = {
      enable = true;
      light = "Papirus-Light";
      dark = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    polarity = "dark";
    fonts = {
      serif = {
        package = pkgs.source-han-serif;
        name = "Source Han Serif";
      };

      sansSerif = {
        package = pkgs.sarasa-gothic;
        name = "Sarasa UI SC";
      };

      monospace = {
        package = pkgs.maple-mono.NF-CN;
        name = "Maple Mono NF CN";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}
