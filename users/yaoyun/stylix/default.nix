{
  pkgs,
  ...
}:
{
  stylix = {
    enable = true;
    autoEnable = true;
    cursor = {
      name = "macOS";
      package = pkgs.apple-cursor;
      size = 24;
    };
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
