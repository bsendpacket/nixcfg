{ pkgs, lib, ... }: 
let
  firefoxSettings = {
    "browser.aboutConfig.showWarning" = false;
    "browser.toolbars.bookmarks.visibility" = "always";
    "browser.tabs.firefox-view" = false;
    "browser.shell.checkDefaultBrowser" = false;
    "browser.translations.automaticallyPopup" = false;
    "signon.rememberSignons" = false;
    "media.webspeech.synth.dont_notify_on_error" = true;
    "browser.newtabpage.activity-stream.showSponsored" = false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
  };
  firefoxExtensions = with pkgs.nur.repos.rycee.firefox-addons; [
    ublock-origin
    privacy-badger
    clearurls
  ];
in 
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    profiles = {
      default = {
        id = 0;
        isDefault = true;
        settings = firefoxSettings;
        extensions = firefoxExtensions;
      };
    };
  };
}
