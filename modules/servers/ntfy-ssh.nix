{ lib, config, ... }:
let
  cfg = config.servers.ntfy;
in
{
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
  };

  config = cfg.enable {
    services.ntfy-sh = {
      enable = true;
      settings = {
        base-url = "https://${cfg.domain}";
      };
    };
  };
}
