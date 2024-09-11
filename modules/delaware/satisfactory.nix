{config, pkgs, lib, ...}:
let
  cfg = config.services.satisfactory;
in
{
  # Sourced from
  # https://github.com/matejc/helper_scripts/blob/master/nixes/satisfactory.nix
  # https://github.com/matejc/helper_scripts/commit/733725339fcba99f0dddc8219a6a70029ce3c607
  options.services.satisfactory = {
    enable = lib.mkEnableOption "Enable Satisfactory Dedicated Server";

    beta = lib.mkOption {
      type = lib.types.enum [ "public" "experimental" ];
      default = "public";
      description = "Beta channel to follow";
    };

    maxPlayers = lib.mkOption {
      type = lib.types.number;
      default = 4;
      description = "Number of players";
    };

    autoPause = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Auto pause when no players are online";
    };

    autoSaveOnDisconnect = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Auto save on player disconnect";
    };

    extraSteamCmdArgs = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Extra arguments passed to steamcmd command";
    };
  };
  config = lib.mkIf cfg.enable {
    users.users.satisfactory = {
      home = "/var/lib/satisfactory";
      createHome = true;
      isSystemUser = true;
      group = "satisfactory";
    };
    users.groups.satisfactory = {};

    nixpkgs.config.allowUnfree = true;

    networking = {
      firewall = {
        allowedUDPPorts = [ 7777 ];
        allowedTCPPorts = [ 7777 ];
      };
    };

    systemd.services.satisfactory = {
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        ${pkgs.steamcmd}/bin/steamcmd \
          +force_install_dir /var/lib/satisfactory/SatisfactoryDedicatedServer \
          +login anonymous \
          +app_update 1690800 \
          -beta ${cfg.beta} \
          ${cfg.extraSteamCmdArgs} \
          validate \
          +quit
        ${pkgs.patchelf}/bin/patchelf --set-interpreter ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 /var/lib/satisfactory/SatisfactoryDedicatedServer/Engine/Binaries/Linux/FactoryServer-Linux-Shipping
        ln -sfv /var/lib/satisfactory/.steam/steam/linux64 /var/lib/satisfactory/.steam/sdk64
        mkdir -p /var/lib/satisfactory/SatisfactoryDedicatedServer/FactoryGame/Saved/Config/LinuxServer
        ${pkgs.crudini}/bin/crudini --set /var/lib/satisfactory/SatisfactoryDedicatedServer/FactoryGame/Saved/Config/LinuxServer/Game.ini '/Script/Engine.GameSession' MaxPlayers ${toString cfg.maxPlayers}
        ${pkgs.crudini}/bin/crudini --set /var/lib/satisfactory/SatisfactoryDedicatedServer/FactoryGame/Saved/Config/LinuxServer/ServerSettings.ini '/Script/FactoryGame.FGServerSubsystem' mAutoPause ${if cfg.autoPause then "True" else "False"}
        ${pkgs.crudini}/bin/crudini --set /var/lib/satisfactory/SatisfactoryDedicatedServer/FactoryGame/Saved/Config/LinuxServer/ServerSettings.ini '/Script/FactoryGame.FGServerSubsystem' mAutoSaveOnDisconnect ${if cfg.autoSaveOnDisconnect then "True" else "False"}
      '';
      script = ''
        /var/lib/satisfactory/SatisfactoryDedicatedServer/Engine/Binaries/Linux/FactoryServer-Linux-Shipping FactoryGame
      '';
      serviceConfig = {
        Restart = "always";
        User = "satisfactory";
        Group = "satisfactory";
        WorkingDirectory = "/var/lib/satisfactory";
      };
      environment = {
        LD_LIBRARY_PATH="
        .local/share/Steam/linux64:
        .local/share/Steam/siteserverui/linux64:
        SatisfactoryDedicatedServer:
        SatisfactoryDedicatedServer/linux64:
        SatisfactoryDedicatedServer/Engine/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Binaries/ThirdParty/MsQuic/v220/linux:
        SatisfactoryDedicatedServer/Engine/Plugins/AI/AISupport/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Editor/FacialAnimation/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Cameras/GameplayCameras/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Animation/ControlRigSpline/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Animation/IKRig/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Animation/ACLPlugin/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Animation/DeformerGraph/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Animation/ControlRig/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/DSTelemetry/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Portal/LauncherChunkInstaller/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Wwise/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Messaging/TcpMessaging/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Messaging/UdpMessaging/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/MovieScene/SequencerScripting/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/MovieScene/ActorSequence/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/MovieScene/TemplateSequence/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Runtime/Synthesis/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Runtime/ModelViewViewModel/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Runtime/AndroidFileServer/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Runtime/CableComponent/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Runtime/AudioSynesthesia/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Runtime/Metasound/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Runtime/GeometryProcessing/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Runtime/GeometryCache/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Runtime/ChunkDownloader/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Runtime/ComputeFramework/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Runtime/WaveTable/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Runtime/MsQuic/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Runtime/RigVM/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Runtime/HairStrands/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Runtime/AudioCapture/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Runtime/AssetTags/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Runtime/LinuxDeviceProfileSelector/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Runtime/ResonanceAudio/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Runtime/CustomMeshComponent/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Runtime/PacketHandlers/DTLSHandlerComponent/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Runtime/MeshModelingToolset/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Runtime/ReplicationGraph/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Runtime/AudioWidgets/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Runtime/AppleImageUtils/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Runtime/GooglePAD/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Runtime/SoundFields/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Runtime/ActorLayerUtilities/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Runtime/ProceduralMeshComponent/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Runtime/ApexDestruction/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Runtime/SignificanceManager/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Runtime/ExampleDeviceProfileSelector/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/FX/Niagara/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/WwiseNiagara/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Interchange/Runtime/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Developer/AnimationSharing/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Developer/UObjectPlugin/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Enterprise/VariantManagerContent/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Enterprise/GLTFExporter/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Enterprise/DatasmithContent/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/EnhancedInput/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/2D/Paper2D/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Compositing/LensDistortion/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/TraceUtilities/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Media/MediaPlate/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Media/MediaCompositing/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Media/ImgMedia/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Compression/OodleNetwork/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Online/OnlineServicesOSSAdapter/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Online/OnlineFramework/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Online/OnlineSubsystemUtils/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Online/OnlineServicesNull/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Online/OnlineSubsystemNull/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Online/OnlineSubsystem/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Online/OnlineBase/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Online/OnlineServices/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/VirtualProduction/Takes/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Experimental/ModularGameplay/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Experimental/FullBodyIK/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Experimental/StructUtils/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Experimental/AutomationUtils/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Experimental/GeometryScripting/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Experimental/Landmass/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Experimental/ChaosVehiclesPlugin/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Experimental/PythonScriptPlugin/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Experimental/ChaosCaching/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Experimental/ChaosCloth/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Experimental/CharacterAI/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Experimental/Dataflow/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Experimental/BackChannel/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Experimental/ControlFlows/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Experimental/ChaosUserDataPT/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Experimental/Fracture/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Experimental/PlanarCutPlugin/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Experimental/LocalizableMessage/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Experimental/PlatformCrypto/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Experimental/GeometryCollectionPlugin/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Plugins/Experimental/ChaosNiagara/Binaries/Linux:
        SatisfactoryDedicatedServer/Engine/Binaries/ThirdParty/MsQuic/v220/linux:
        SatisfactoryDedicatedServer/FactoryGame/Plugins/GameplayEvents/Binaries/Linux:
        SatisfactoryDedicatedServer/FactoryGame/Binaries/Linux:
        SatisfactoryDedicatedServer/FactoryGame/Plugins/AbstractInstance/Binaries/Linux:
        SatisfactoryDedicatedServer/FactoryGame/Plugins/InstancedSplines/Binaries/Linux:
        SatisfactoryDedicatedServer/FactoryGame/Plugins/SignificanceISPC/Binaries/Linux:
        SatisfactoryDedicatedServer/FactoryGame/Plugins/GameplayEvents/Binaries/Linux:
        SatisfactoryDedicatedServer/FactoryGame/Plugins/Online/OnlineIntegration/Binaries/Linux:
        ";
      };
    };
  };
}

