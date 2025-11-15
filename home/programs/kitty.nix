{ lib, ... }:
{
  programs.kitty = lib.mkForce {
    enable = true;
    settings = {
      # looks
      window_padding_width = 8;
      cursor_shape = "block";
      cursor_trail = 3;
      tab_separator = " | ";
      background_opacity = 0.79;
      background_blur = 1;
      # util
      open_url_modifiers = "ctrl";
      scrollback_pager = "nvim -c \"set signcolumn=no showtabline=0\" -c \"silent write! /tmp/kitty_scrollback_buffer | bd | te /bin/cat /tmp/kitty_scrollback_buffer - \"";
      # advanced
      shell_integration = "enabled";
      term = "xterm-kitty";
    };
  };
}
