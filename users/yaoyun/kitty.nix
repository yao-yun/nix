{ lib, ... }:
{
  programs.kitty = lib.mkForce {
    enable = true;
    settings = {
      window_padding_width = 8;
      scrollback_pager = "nvim -c \"set signcolumn=no showtabline=0\" -c \"silent write! /tmp/kitty_scrollback_buffer | bd | te /bin/cat /tmp/kitty_scrollback_buffer - \"";
      cursor_trail = 3;
    };
  };
}
