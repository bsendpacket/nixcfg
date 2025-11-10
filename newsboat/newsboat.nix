{ channels, ... }: {

  programs.newsboat = {
    enable = true;
    package = channels.nixpkgs-unstable.newsboat;

    urls = [
      {
        title = "Malpedia";
        url = "https://malpedia.caad.fkie.fraunhofer.de/feeds/rss/latest";
      }
      {
        title = "Nao-Sec";
        url = "https://nao-sec.org/feed";
      }
      {
        title = "Checkpoint Research";
        url = "https://research.checkpoint.com/feed/";
      }
      {
        title = "Mandiant";
        url = "https://feeds.feedburner.com/threatintelligence/pvexyqv7v0v";
      }
      {
        title = "GDATA";
        url = "https://feeds.feedblitz.com/GDataSecurityBlog-EN&x=1";
      }
      {
        title = "ESET";
        url = "https://www.welivesecurity.com/en/rss/feed/";
      }
    ];

  };
}
