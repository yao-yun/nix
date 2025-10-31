{
  inputs,
  config,
  ...
}:
{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];
  programs.zen-browser = {
    enable = true;

    # this only installs kiss and ublock-origin last time I check
    # better just manually set up sync
    # policies =
    #   let
    #     mkExtensionSettings = builtins.mapAttrs (
    #       _: pluginId: {
    #         install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
    #         installation_mode = "force_installed";
    #       }
    #     );
    #   in
    #   {
    #     ExtensionSettings = mkExtensionSettings {
    #       "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "birwarden";
    #       "addon@darkreader.org" = "dark-reader";
    #       "{fb25c100-22ce-4d5a-be7e-75f3d6f0fc13}" = "kiss-translator";
    #       "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = "vimium";
    #       "uBlock0@raymondhill.net" = "ublock-origin";
    #       "{f10c197e-c2a4-43b6-a982-7e186f7c63d9}" = "bilibili-sponsor-block";
    #     };
    #   };

    # this does not work
    # packages = with inputs.firefox-addons.packages.${pkgs.system}; [
    #   ublock-origin
    #   bitwarden
    #   vimium
    #   darkreader
    #   kiss-translator
    # ];
  };

  stylix.targets.zen-browser.profileNames = if config.stylix.enable then [ "default" ] else [ ];
}
