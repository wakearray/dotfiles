{ lib, config, ... }:
{
  config = lib.mkIf config.gui.gaming.enable {
    gui.gaming.sunshine = {
      enable = true;
      globalPrepCommands = [
        ''{"do":"hyprctl keyword monitor \"desc:Japan Display Inc. GPD1001H 0x00000001, 1280x800@60.01Hz, 0x0, 1\"","undo":"hyprctl keyword monitor \"desc:Japan Display Inc. GPD1001H 0x00000001, 2560x1600@60.01Hz, 0x0, 1.666667\""}''
        ''{"do":"hyprctl keyword windowrulev2 \"idleinhibit always, class:(.*)\"","undo":"hyprctl keyword windowrulev2 \"idleinhibit  none, class:(.*)\""}''
      ];
      applications = {
        env = {
          PATH = "$(PATH):$(HOME)/.local/bin";
        };
        apps = [
          {
          name = "Steam";
            detached = [
              "setsid steam -bigpicture"
            ];
          }
          {
            name = "Baldur's Gate 3";
            detached = [
              "setsid steam -applaunch 1086940"
            ];
            image-path = "/home/kent/.config/sunshine/covers/1086940.png";
          }
          {
            name = "L.A. Noire";
            detached = [
                  "setsid steam -applaunch 110800"
            ];
            image-path = "/home/kent/.config/sunshine/covers/110800.png";
          }
          {
            name = "Mars First Logistics";
            detached = [
                  "setsid steam -applaunch 1532200"
            ];
            image-path = "/home/kent/.config/sunshine/covers/1532200.png";
          }
          {
            name = "Palworld";
            detached = [
                  "setsid steam -applaunch 1623730"
            ];
            image-path = "/home/kent/.config/sunshine/covers/1623730.png";
          }
          {
            name = "The Elder Scrolls IV: Oblivion Remastered";
            detached = [
                  "setsid steam -applaunch 2623190"
            ];
            image-path = "/home/kent/.config/sunshine/covers/2623190.png";
          }
          {
            name = "Caves of Qud";
            detached = [
                  "setsid steam -applaunch 333640"
            ];
            image-path = "/home/kent/.config/sunshine/covers/333640.png";
          }
          {
            name = "Disco Elysium";
            detached = [
                  "setsid steam -applaunch 632470"
            ];
            image-path = "/home/kent/.config/sunshine/covers/632470.png";
          }
          {
            name = "dotAGE";
            detached = [
                  "setsid steam -applaunch 638510"
            ];
            image-path = "/home/kent/.config/sunshine/covers/638510.png";
          }
          {
            name = "Do Not Feed the Monkeys";
            detached = [
                  "setsid steam -applaunch 658850"
            ];
            image-path = "/home/kent/.config/sunshine/covers/658850.png";
          }
        ];
      };
    };
  };
}
