{ channels, ... }: 
let
  firefoxSettings = {
    "browser.aboutConfig.showWarning" = false;
    "browser.aboutwelcome.enabled" = false;
    "browser.toolbars.bookmarks.visibility" = "always";
    "browser.tabs.firefox-view" = false;
    "browser.shell.checkDefaultBrowser" = false;
    "browser.translations.automaticallyPopup" = false;
    "signon.rememberSignons" = false;
    "media.webspeech.synth.dont_notify_on_error" = true;
    "browser.newtabpage.activity-stream.showSponsored" = false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
  };
  firefoxExtensions = with channels.nixpkgs-unstable.nur.repos.rycee.firefox-addons; [
    ublock-origin
    privacy-badger
    clearurls
  ];
  firefoxBookmarks = [
    {
      name = "Bookmarks Toolbar";
      toolbar = true;
      bookmarks = [
        {
          name = "References";
          bookmarks = [
            {
              name = "MagnumDB Magic Number Lookup";
              url = "https://www.magnumdb.com/";
            }
            {
              name = "Unprotect Project";
              url = "https://www.unprotect.it/map/";
            }
            {
              name = "Aldeid Wiki";
              url = "https://www.aldeid.com/wiki";
            }
            {
              name = "MalAPI.io";
              url = "https://malapi.io/";
            }
            {
              name = "Windows Locales LANGID Enum";
              url = "https://gist.github.com/herrcore/22e820f1e8a99238070cd7c5b350261e";
            }
            {
              name = "Virtual Key Codes";
              url = "https://www.aldeid.com/wiki/Virtual-Key-Codes";
            }
            {
              name = "Windows API & Malware Injection Cheatsheet";
              url = "https://github.com/7etsuo/windows-api-function-cheatsheets";
            }
            {
              name = "Anti-Debug Tricks";
              url = "https://anti-debug.checkpoint.com/";
            }
            {
              name = "Malware Analysis Cheatsheet";
              url = "https://fareedfauzi.github.io/2022/08/08/Malware-analysis-cheatsheet.html";
            }
            {
              name = "Vergilius Project - Windows Kernel Structures";
              url = "https://vergiliusproject.com";
            }
          ];
        }
        {
          name = "Malware Research";
          bookmarks = [
            {
              name = "Malpedia";
              url = "https://malpedia.caad.fkie.fraunhofer.de/";
            }
            {
              name = "VirusTotal";
              url = "https://www.virustotal.com/";
            }
            {
              name = "MalwareBazaar";
              url = "https://bazaar.abuse.ch/browse/";
            }
            {
              name = "URLhaus";
              url = "https://urlhaus.abuse.ch/browse/";
            }
          ];
        }
        {
          name = "Windows Structures";
          bookmarks = [
            {
              name = "PE - Portable Executable";
              url = "https://www.aldeid.com/wiki/PE-Portable-executable";
            }
            {
              name = "TEB - Thread Environment Block";
              url = "https://www.aldeid.com/wiki/TEB-Thread-Environment-Block";
            }
            {
              name = "PEB - Process Environment Block";
              url = "https://www.aldeid.com/wiki/PEB-Process-Environment-Block";
            }
            {
              name = "PEB_LDR_DATA";
              url = "https://www.aldeid.com/wiki/PEB_LDR_DATA";
            }
            {
              name = "LDR_DATA_TABLE_ENTRY";
              url = "https://www.aldeid.com/wiki/LDR_DATA_TABLE_ENTRY";
            }
            {
              name = "LIST_ENTRY";
              url = "https://www.aldeid.com/wiki/LIST_ENTRY";
            }
            {
              name = "Structured Exception Handling (SEH)";
              url = "https://www.aldeid.com/wiki/Category:Architecture/Windows/SEH-Structured-Exception-Handling";
            }
          ];
        }
        {
          name = "Windows APIs";
          bookmarks = [
            {
              name = "VirtualAlloc";
              url = "https://www.aldeid.com/wiki/VirtualAlloc";
            }
            {
              name = "VirtualAllocEx";
              url = "https://www.aldeid.com/wiki/VirtualAllocEx";
            }
            {
              name = "CreateRemoteThread";
              url = "https://www.aldeid.com/wiki/CreateRemoteThread";
            }
            {
              name = "CreateProcess";
              url = "https://www.aldeid.com/wiki/CreateProcess";
            }
            {
              name = "CoCreateInstance";
              url = "https://www.aldeid.com/wiki/CoCreateInstance";
            }
            {
              name = "CreateEvent";
              url = "https://www.aldeid.com/wiki/CreateEvent";
            }
            {
              name = "CreateFile";
              url = "https://www.aldeid.com/wiki/CreateFile";
            }
            {
              name = "CreateFileMapping";
              url = "https://www.aldeid.com/wiki/CreateFileMapping";
            }
            {
              name = "CreateMutex";
              url = "https://www.aldeid.com/wiki/CreateMutex";
            }
            {
              name = "CreatePipe";
              url = "https://www.aldeid.com/wiki/CreatePipe";
            }
            {
              name = "CreateThread";
              url = "https://www.aldeid.com/wiki/CreateThread";
            }
            {
              name = "CreateToolhelp32Snapshot";
              url = "https://www.aldeid.com/wiki/CreateToolhelp32Snapshot";
            }
            {
              name = "GlobalAlloc";
              url = "https://www.aldeid.com/wiki/GlobalAlloc";
            }
            {
              name = "HeapAlloc";
              url = "https://www.aldeid.com/wiki/HeapAlloc";
            }
            {
              name = "IsWow64Process";
              url = "https://www.aldeid.com/wiki/IsWow64Process";
            }
            {
              name = "LoadResource";
              url = "https://www.aldeid.com/wiki/LoadResource";
            }
            {
              name = "MapViewOfFile";
              url = "https://www.aldeid.com/wiki/MapViewOfFile";
            }
            {
              name = "NtQueryInformationProcess";
              url = "https://www.aldeid.com/wiki/NtQueryInformationProcess";
            }
            {
              name = "PeekNamedPipe";
              url = "https://www.aldeid.com/wiki/PeekNamedPipe";
            }
            {
              name = "Process32First";
              url = "https://www.aldeid.com/wiki/Process32First";
            }
            {
              name = "Process32Next";
              url = "https://www.aldeid.com/wiki/Process32Next";
            }
            {
              name = "QueueUserAPC";
              url = "https://www.aldeid.com/wiki/QueueUserAPC";
            }
            {
              name = "ReadProcessMemory";
              url = "https://www.aldeid.com/wiki/ReadProcessMemory";
            }
            {
              name = "RegOpenKey";
              url = "https://www.aldeid.com/wiki/RegOpenKey";
            }
            {
              name = "RegOpenKeyEx";
              url = "https://www.aldeid.com/wiki/RegOpenKeyEx";
            }
            {
              name = "ResumeThread";
              url = "https://www.aldeid.com/wiki/ResumeThread";
            }
            {
              name = "SetThreadContext";
              url = "https://www.aldeid.com/wiki/SetThreadContext";
            }
            {
              name = "ShellExecute";
              url = "https://www.aldeid.com/wiki/ShellExecute";
            }
            {
              name = "URLDownloadToFile";
              url = "https://www.aldeid.com/wiki/URLDownloadToFile";
            }
            {
              name = "WaitForSingleObject";
              url = "https://www.aldeid.com/wiki/WaitForSingleObject";
            }
            {
              name = "WaitForSingleObjectEx";
              url = "https://www.aldeid.com/wiki/WaitForSingleObjectEx";
            }
            {
              name = "WaitForMultipleObjectsEx";
              url = "https://www.aldeid.com/wiki/WaitForMultipleObjectsEx";
            }
            {
              name = "WriteProcessMemory";
              url = "https://www.aldeid.com/wiki/WriteProcessMemory";
            }
          ];
        }
      ];
    }
  ];
in 
{
  programs.firefox = {
    enable = true;

    package = channels.nixpkgs-unstable.wrapFirefox channels.nixpkgs-unstable.firefox-unwrapped {
      extraPolicies = {
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;

        FirefoxHome = {
          Search = true;
          Pocket = false;
          Snippets = false;
          Highlights = false;
        };

        UserMessaging = {
          ExtensionRecommendations = false;
          SkipOnboarding = true;
        };
      };
    };

    profiles = {
      default = {
        id = 0;
        isDefault = true;
        settings = firefoxSettings;
        extensions.packages = firefoxExtensions;
        bookmarks = { 
          force = true;
          settings = firefoxBookmarks;
        };
      };
    };
  };
}
