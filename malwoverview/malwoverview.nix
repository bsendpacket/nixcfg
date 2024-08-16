{ config, lib, pkgs, ... }:

let
  malwapiConfig = ''
    [VIRUSTOTAL]
    VTAPI = 

    [HYBRID-ANALYSIS]
    HAAPI = 

    [MALSHARE]
    MALSHAREAPI = 

    [HAUSSUBMIT]
    HAUSSUBMITAPI =

    [POLYSWARM]
    POLYAPI = 

    [ALIENVAULT]
    ALIENAPI = 

    [MALPEDIA]
    MALPEDIAAPI =

    [TRIAGE]
    TRIAGEAPI =

    [INQUEST]
    INQUESTAPI =
  '';

  createMalwapiConfig = ''
    MALWAPI_CONF="$HOME/.malwapi.conf"
    if [ ! -f "$MALWAPI_CONF" ]; then
      echo "${malwapiConfig}" > "$MALWAPI_CONF"
    fi
  '';

in
{
  home.activation.createMalwapiConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${createMalwapiConfig}
  '';
}
