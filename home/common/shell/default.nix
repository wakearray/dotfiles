{ config, lib, ... }:
let
  devices = import ../../../modules/devices.nix;
  # Function to generate aliases for a given user
  generateAliasesForUser = user:
  let
    isUserInDevice = device: lib.elem user device.value.users;
    devicesForUser = lib.filter isUserInDevice (lib.attrsToList devices);
    deviceAliases = builtins.map (device: {
      name = device.name;
      value = "zellij action rename-tab '${device.name}' && ssh -t ${device.value.ip} \"zellij a || zellij\"; zellij action undo-rename-tab";
    }) devicesForUser;
  in
  lib.listToAttrs deviceAliases;
  # Get current user
  currentUser = config.home.username;

  # Generate aliases for the current user
  userShellAliases = generateAliasesForUser currentUser;
in
{
  imports = [
    ./zsh.nix
    ./flakeworkflow.nix
  ];

  config = {
    home = {
      shell.enableZshIntegration = true;
      shellAliases = {
        #repl = ''
        #  source /etc/set-environment && nix repl $(echo $NIX_PATH | perl -pe 's|.*(/nix/store/.*-source/repl.nix).*|\1|')
        #'';

        repl = "zellij action rename-tab \"Nix Repl\"; nix repl --extra-experimental-features \"flakes\" nixpkgs; zellij action undo-rename-tab";

        l = "eza -lag --color=always --color-scale=all --color-scale-mode=fixed --icons=always --group-directories-first --git-ignore";

        c = "clear";

        # use zoxide instead of cd.
        cd = "z";
        cdi = "zi";

        # Launch neovim with a named server
        nvim = "nvim --listen /tmp/nvim-socket-$(eval uuidgen)";

        # Opens nvim to the `~/notes` directory
        notes = "zellij action rename-tab Notes; nvim --listen /tmp/nvim-notes-socket-$(eval uuidgen) ~/notes; zellij action undo-rename-tab";

        systemctl = "sudo EDITOR=nvim systemctl-tui";

        rename = "zellij action rename-tab";

        # SSH Hosts
        lhosts = ''
          echo "
          The available hosts for ssh are:                           \n
                                                                     \n
          greatblue        GPD Win 2 2023        192.168.0.11        \n
          starling         7" Tablet             192.168.0.143       \n
          delaware         Dell Optiplex Server  192.168.0.46        \n
          Moonfish         Game Streaming Server 192.168.0.166       \n
          lagurus          Cat Projector         192.168.0.65        \n
          jerboa           Livingroom TV         192.168.0.32        \n
          sebrightbantam   QNAP TS-251           192.168.0.66        \n
          orloff           Odroid HC4            n/a                 \n
          cichlid          Jess' Desktop         n/a                 \n
          p80              Cubot P80 Phone       192.168.0.10 -p8022 \n
          hamburger        Hetzner VPS           5.161.77.151"
        '';
        #moonfish = "zellij action rename-tab 'Moonfish' && ssh 192.168.0.166 \"zellij a || zellij\"; zellij action undo-rename-tab"; # Game Streaming Server
        orloff = "echo 'This computer isn't setup yet'"; # Odroid HC4

        # Phones
        p80 = "zellij action rename-tab 'P80' && ssh u0_a183@192.168.0.10 -p8022; zellij action undo-rename-tab";
        #mountp80 = "zellij action rename-tab 'P80' && sshfs u0_a183@192.168.0.10:/data/data/com.termux/files /mnt/phones/p80 -p8022; zellij action undo-rename-tab";

        } // (userShellAliases);
      sessionVariables = {
        EDITOR = "nvim --listen /tmp/nvim-socket-$(eval uuidgen)";
        MANPAGER = "nvim --listen /tmp/nvim-socket-$(eval uuidgen) +Man!";
      };
    };
  };
}
