{ lib, config, ... }:
let
  cfg = config.servers.ntfy;
in
{
  # WIP
  options.servers.ntfy = with lib; {
    enable = mkEnableOption "Enable an opinionated ntfy-sh server.";

    domain = mkOption {
      type = types.str;
      default = "ntfy.example.com";
      description = "Public facing base URL of the service

This setting is required for any of the following features:

- attachments (to return a download URL)
- e-mail sending (for the topic URL in the email footer)
- iOS push notifications for self-hosted servers (to calculate the Firebase poll_request topic)
- Matrix Push Gateway (to validate that the pushkey is correct)
";
    };

    sopsFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "The secrets file needs to be formatted as a single variable named `ntfyEnvironmentVars` representing the entire ntfy environment variables file.";
    };

  };

  config = lib.mkif cfg.enable {
    services.ntfy-sh = {
      enable = true;
      settings = {
        base-url = "https://${cfg.domain}";
      };
      environmentFile = config.sops.templates."ntfyEnvironmentFile".path;
    };

    sops.secrets.ntfyEnvironmentVars = {
      sopsFile = cfg.sopsFile;
      mode = "0400";
      owner = "ntfy-sh";
      group = "ntfy-sh";
    };

    sops.templates."ntfyEnvironmentFile" = {
      content = ''
        ${config.sops.placeholder.ntfyEnvironmentVars}
      '';
      mode = "0400";
      owner = "ntfy-sh";
      group = "ntfy-sh";
    };
  };
}
