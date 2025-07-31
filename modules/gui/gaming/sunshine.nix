{ config, lib, ... }:
let
  sunshine = config.gui.gaming.sunshine;
in
{
  options.gui.gaming.sunshine = with lib; {
    enable = mkEnableOption "Enable an opinionated Sunshine config.

Sunshine is a game streaming server used with the moonlight app on PC, Android, and iOS.";

    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = "If `autoStart` is set to `true`, server will start on user login.
If `autoStart` is set to `false` you need to start the server with the command `sunshine`";
    };

    settings = {
      # General
      locale = mkOption {
        type = types.str;
        default = "en_US";
        description = "The locale used for Sunshine's user interface. Complete list of options can be found in the [Sunshine docs](https://docs.lizardbyte.dev/projects/sunshine/latest/md_docs_2configuration.html#locale).";
      };
      sunshineName = mkOption {
        type = types.str;
        default = config.networking.hostName;
        description = "The name displayed by Moonlight.";
      };
      minLogLevel = mkOption {
        type = types.enum [ "verbose" "debug" "info" "warning" "error" "fatal" "none" ];
        default = "info";
        description = "The minimum log level printed to standard out.";
      };
      globalPrepCommands = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [
          ''{"do":"hyprctl keyword monitor \"desc:Japan Display Inc. GPD1001H 0x00000001, 1280x720@60.01Hz, 0x0, 1\"","undo":"hyprctl keyword monitor \"desc:Japan Display Inc. GPD1001H 0x00000001, 2560x1600@60.01Hz, 0x0, 1.666667\""}''
          ''{"do":"hyprctl keyword windowrulev2 \"idleinhibit always, class:(.*)\"","undo":"hyprctl keyword windowrulev2 \"idleinhibit  none, class:(.*)\""}''
        ];
        description = "A list of strings that include the commands you want to run everytime a Sunshine session is started.";
      };
      # Input
      controller = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to allow controller input from the client.";
      };
      gamepad = mkOption {
        type = types.enum [ "auto" "ds5" "switch" "xone" ];
        default = "auto";
        description = "The type of gamepad to emulate on the host. [Docs](https://docs.lizardbyte.dev/projects/sunshine/latest/md_docs_2configuration.html#gamepad)";
      };
      backButtonTimeout = mkOption {
        type = types.int;
        default = -1;
        example = 2000;
        description = "If the `Back`/`Select` button is held down for the specified number of milliseconds, a `Home`/`Guide` button press is emulated.";
      };
      keyboard = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to allow keyboard input from the client.";
      };
      keyRepeatDelay = mkOption {
        type = types.int;
        default = 500;
        description = "The initial delay, in milliseconds, before repeating keys. Controls how fast keys will repeat themselves.";
      };
      keyRepeatFrequency = mkOption {
        type = types.float;
        default = 24.9;
        description = "How often keys repeat every second.";
      };
      keyRightAltToKeyWin = mkOption {
        type = types.bool;
        default = false;
        description = "It may be possible that you cannot send the Windows Key from Moonlight directly. In those cases it may be useful to make Sunshine think the Right Alt key is the Windows key.";
      };
      mouse = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to allow mouse input from the client.";
      };
      highResolutionScrolling = mkOption {
        type = types.bool;
        default = true;
        description = "When enabled, Sunshine will pass through high resolution scroll events from Moonlight clients.
This can be useful to disable for older applications that scroll too fast with high resolution scroll events.";
      };
      nativePenTouch = mkOption {
        type = types.bool;
        default = true;
        description = "When enabled, Sunshine will pass through native pen/touch events from Moonlight clients.
This can be useful to disable for older applications without native pen/touch support.";
      };
      keybindings = mkOption {
        type = types.listOf types.str;
        default = [
          "0x10, 0xA0"
          "0x11, 0xA2"
          "0x12, 0xA4"
        ];
        description = "Sometimes it may be useful to map keybindings. Wayland won't allow clients to capture the Win Key for example.
[See list of virtual keycodes.](https://learn.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes)";
      };

      # Audio/Video
      audioSink = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "alsa_output.pci-0000_65_00.6.analog-stereo";
        description = "The name of the audio sink used for audio loopback. You can use the command `wpctl status | grep Audio/Sink | sed -e 's/\(.*\)Audio\/Sink *\(.*\)/\2/'`

If set to `null` Sunshine will select the default audio device.
";
      };
      virtualSink = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "Stream Streaming Speakers";
        description = "The audio device that's virtual, like Steam Streaming Speakers. This allows Sunshine to stream audio, while muting the speakers.
";
      };
      streamAudio = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to stream audio or not. Disabling this can be useful for streaming headless displays as second monitors. ";
      };
      adapterName = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
Select the video card you want to stream.

Use `ls /dev/dri/renderD*` to find which GPUs are available.

To find their capabilities use the command:

```nix
nix-shell -p libva-utils --run 'vainfo --display drm --device /dev/dri/renderD128 | grep -E "((VAProfileH264High|VAProfileHEVCMain|VAProfileHEVCMain10).*VAEntrypointEncSlice)|Driver version"'
```

To be supported by Sunshine, it needs to have at the very minimum: `VAProfileH264High : VAEntrypointEncSlice`

If set to `null` Sunshine will select the default video card.
'';
      };
      outputName = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = ''
Select the display number you want to stream.

During Sunshine startup, you should see the list of detected displays:
```
Info: Detecting displays
Info: Detected display: DVI-D-0 (id: 0) connected: false
Info: Detected display: HDMI-0 (id: 1) connected: true
Info: Detected display: DP-0 (id: 2) connected: true
Info: Detected display: DP-1 (id: 3) connected: false
Info: Detected display: DVI-D-1 (id: 4) connected: false
```
You need to use the id value inside the parenthesis, e.g. 1.

If set to `null` Sunshine will select the default display.
'';
      };
      maxBitrate = mkOption {
        type = types.int;
        default = 0;
        description = "The maximum bitrate (in Kbps) that Sunshine will encode the stream at. If set to 0, it will always use the bitrate requested by Moonlight.";
      };

      ## Network
      upnp = mkOption {
        type = types.bool;
        default = false;
        description = "Sunshine will attempt to open ports for streaming over the internet.";
      };
      addressFamily = mkOption {
        type = types.enum [ "ipv4" "both" ];
        default = "ipv4";
        description = "Set the address family that Sunshine will use.";
      };
      port = mkOption {
        type = types.port;
        default = 47989;
        description = "Set the family of ports used by Sunshine. Changing this value will offset other ports as shown in config UI.";
      };
      originWebUiAllowed = mkOption {
        type = types.enum [ "pc" "lan" "wan" ];
        default = "lan";
        description = "The origin of the remote endpoint address that is not denied for HTTPS Web UI.";
      };
      externalIP = mkOption {
        type = types.str;
        default = "";
        description = "If no external IP address is given, Sunshine will attempt to automatically detect external ip-address.";
      };
      lanEncryptionMode = mkOption {
        type = types.ints.between 0 2;
        default = 0;
        description = "This determines when encryption will be used when streaming over your local network.

Options include:
0 = encryption will not be used
1 = encryption will be used if the client supports it
2 = encryption is mandatory and unencrypted connections are rejected

::: {.warning}
Encryption can reduce streaming performance, particularly on less powerful hosts and clients.
:::
";
      };
      wanEncryptionMode = mkOption {
        type = types.ints.between 0 2;
        default = 1;
        description = "This determines when encryption will be used when streaming over the Internet.

Options include:
0 = encryption will not be used
1 = encryption will be used if the client supports it
2 = encryption is mandatory and unencrypted connections are rejected

::: {.warning}
Encryption can reduce streaming performance, particularly on less powerful hosts and clients.
:::
";
      };
      pingTimeout = mkOption {
        type = types.int;
        default = 1000;
        description = "How long to wait, in milliseconds, for data from Moonlight before shutting down the stream.";
      };

      ## Config Files
      credentialsFile = mkOption {
        type = types.str;
        default = "sunshine_state.json";
        description = "The file where user credentials for the UI are stored.";
      };
      logPath = mkOption {
        type = types.str;
        default = "sunshine.log";
        description = "The path where the Sunshine log is stored.";
      };
      pkey = mkOption {
        type = types.str;
        default = "credentials/cakey.pem";
        example = "/run/secrets/pkey.pem";
        description = "The private key used for the web UI and Moonlight client pairing. For best compatibility, this should be an RSA-2048 private key.

::: {.warning}
Not all Moonlight clients support ECDSA keys or RSA key lengths other than 2048 bits.
:::
";
      };
      cert = mkOption {
        type = types.str;
        default = "credentials/cacert.pem";
        example = "/run/secrets/cert.pem";
        description = "The certificate used for the web UI and Moonlight client pairing. For best compatibility, this should have an RSA-2048 public key.

::: {.warning}
Not all Moonlight clients support ECDSA keys or RSA key lengths other than 2048 bits.
:::
";
      };
      fileState = mkOption {
        type = types.str;
        default = "sunshine_state.json";
        description = "The file where current state of Sunshine is stored.";
      };

      ## Advanced
      fecPercentage = mkOption {
        type = types.ints.between 1 255;
        default = 20;
        description = "Percentage of error correcting packets per data packet in each video frame.

::: {.warning}
Higher values can correct for more network packet loss, but at the cost of increasing bandwidth usage.
:::
";
      };
      qp = mkOption {
        type = types.int;
        default = 28;
        description = "Quantization Parameter. Some devices don't support Constant Bit Rate. For those devices, QP is used instead.

::: {.warning}
Higher value means more compression, but less quality.
:::";
      };
      minThreads = mkOption {
        type = types.int.u8;
        default = 2;
        description = "Minimum number of CPU threads used for encoding.


::: {.note}
    Increasing the value slightly reduces encoding efficiency, but the tradeoff is usually worth it to gain the use of more CPU cores for encoding. The ideal value is the lowest value that can reliably encode at your desired streaming settings on your hardware.
:::
";
      };
      hevcMode = mkOption {
        type = types.ints.between 0 3;
        default = 0;
        description = "Allows the client to request HEVC Main or HEVC Main10 video streams.

Options:
0 = advertise support for HEVC based on encoder capabilities (recommended)
1 = do not advertise support for HEVC
2 = advertise support for HEVC Main profile
3 = advertise support for HEVC Main and Main10 (HDR) profiles

::: {.warning}
HEVC is more CPU-intensive to encode, so enabling this may reduce performance when using software encoding.
:::
";
      };
      av1Mode = mkOption {
        type = types.ints.between 0 3;
        default = 0;
        description = "Allows the client to request AV1 Main 8-bit or 10-bit video streams.

Options:
0 = advertise support for AV1 based on encoder capabilities (recommended)
1 = do not advertise support for AV1
2 = advertise support for AV1 Main 8-bit profile
3 = advertise support for AV1 Main 8-bit and 10-bit (HDR) profiles

::: {.warning}
AV1 is more CPU-intensive to encode, so enabling this may reduce performance when using software encoding.
:::
";
      };
      capture = mkOption {
        type = types.nullOr types.enum [ "nvfbc" "wlr" "kms" "x11" ];
        default = null;
        description = "Force specific screen capture method.

Options:
`null` = Automatic. Sunshine will use the first capture method available in the order of the table above.
`nvfbc` = Use NVIDIA Frame Buffer Capture to capture direct to GPU memory. This is usually the fastest method for NVIDIA cards. NvFBC does not have native Wayland support and does not work with XWayland.
`wlr` = Capture for wlroots based Wayland compositors via wlr-screencopy-unstable-v1. It is possible to capture virtual displays in e.g. Hyprland using this method.
`kms` = DRM/KMS screen capture from the kernel. This requires that Sunshine has cap_sys_admin capability.
`x11` = Uses XCB. This is the slowest and most CPU intensive so should be avoided if possible.

";
      };
      encoder = mkOption {
        type = types.nullOr types.enum [ "nvenc" "quicksync" "amdvce" "vaapi" "software" ];
        default = null;
        description = "Force a specific encoder.

Options:
`null` = Sunshine will use the first encoder that is available.
`nvenc` = For NVIDIA graphics cards
`quicksync` = For Intel graphics cards
`amdvce` = For AMD graphics cards
`vaapi` = Use Linux VA-API (AMD, Intel)
`software` = Encoding occurs on the CPU
";
      };

      ## Nvidia NVENC Encoder
      nvencPreset = mkOption {
        type = types.ints.between 1 7;
        default = 1;
        description = "NVENC encoder performance preset. Higher numbers improve compression (quality at given bitrate) at the cost of increased encoding latency. Recommended to change only when limited by network or decoder, otherwise similar effect can be accomplished by increasing bitrate.

Options:
1 = P1 (fastest)
2 = P2
3 = P3
4 = P4
5 = P5
6 = P6
7 = P7 (slowest)

::: {.note}
This option only applies when using NVENC encoder.
:::
";
      };
      nvencTwopass = mkOption {
        type = types.str;
        default = "quarter_res";
        description = "Enable two-pass mode in NVENC encoder. This allows to detect more motion vectors, better distribute bitrate across the frame and more strictly adhere to bitrate limits. Disabling it is not recommended since this can lead to occasional bitrate overshoot and subsequent packet loss.

Options:
`disabled` = One pass (fastest)
`quarter_res` = Two passes, first pass at quarter resolution (faster)
`full_res` = Two passes, first pass at full resolution (slower)

::: {.note}
This option only applies when using NVENC encoder.
:::
";
      };
      nvencSpatialAq = mkOption {
        type = types.bool;
        default = false;
        description = "Assign higher QP values to flat regions of the video. Recommended to enable when streaming at lower bitrates.

::: {.note}
This option only applies when using NVENC encoder.
:::

::: {.warning}
    Enabling this option may reduce performance.
:::
";
      };
      nvencVbvIncrease = mkOption {
        type = types.ints.between 0 400;
        default = 0;
        description = "Single-frame VBV/HRD percentage increase. By default Sunshine uses single-frame VBV/HRD, which means any encoded video frame size is not expected to exceed requested bitrate divided by requested frame rate. Relaxing this restriction can be beneficial and act as low-latency variable bitrate, but may also lead to packet loss if the network doesn't have buffer headroom to handle bitrate spikes. Maximum accepted value is 400, which corresponds to 5x increased encoded video frame upper size limit.

::: {.note}
This option only applies when using NVENC encoder.
:::

::: {.warning}
Can lead to network packet loss.
:::
";
      };
      nvencH264Cavlc = mkOption {
        type = types.bool;
        default = false;
        description = "Prefer CAVLC entropy coding over CABAC in H.264 when using NVENC. CAVLC is outdated and needs around 10% more bitrate for same quality, but provides slightly faster decoding when using software decoder.


::: {.note}
This option only applies when using H.264 format with the NVENC encoder.
:::
";
      };
      qsvPreset = mkOption {
        type = types.enum [ "veryfast" "faster" "fast" "medium" "slow" "slower" "veryslow" ];
        default = "medium";
        description = "The encoder preset to use.

Options:
`veryfast` = fastest (lowest quality)
`faster` = faster (lower quality)
`fast` = fast (low quality)
`medium` = medium (default)
`slow` = slow (good quality)
`slower` = slower (better quality)
`veryslow` = slowest (best quality)

::: {.note}
This option only applies when using quicksync encoder.
:::
";
      };
      qsvCoder = mkOption {
        type = types.enum [ "auto" "cabac" "cavlc" ];
        default = "auto";
        description = "The entropy encoding to use.

Options:
auto = let ffmpeg decide
cabac = context adaptive binary arithmetic coding - higher quality
cavlc = context adaptive variable-length coding - faster decode

::: {.note}
This option only applies when using H.264 with the quicksync encoder.
:::
";
      };
      qsvSlowHevc = mkOption {
        type = types.bool;
        default = false;
        description = "This options enables use of HEVC on older Intel GPUs that only support low power encoding for H.264.

::: {.note}
This option only applies when using quicksync encoder.
:::

::: {.caution}
Streaming performance may be significantly reduced when this option is enabled.
:::
";
      };

      ## AMD
      amdUsage = mkOption {
        type = types.enum [ "transcoding" "webcam" "lowlatency_high_quality" "lowlatency" "ultralowlatency" ];
        default = "ultralowlatency";
        description = "The encoder usage profile is used to set the base set of encoding parameters.

Options:
transcoding = transcoding (slowest)
webcam = webcam (slow)
lowlatency_high_quality = low latency, high quality (fast)
lowlatency = low latency (faster)
ultralowlatency = ultra low latency (fastest)


::: {.note}
This option only applies when using amdvce encoder.
:::

::: {.note}
The other AMF options that follow will override a subset of the settings applied by your usage profile, but there are hidden parameters set in usage profiles that cannot be overridden elsewhere.
:::
";
      };
      amdRc = mkOption {
        type = types.enum [ "cqp" "cbr" "vbr_latency" "vbr_peak" ];
        default = "vbr_latency";
        description = "
The encoder rate control.

Options:
`cqp` = constant qp mode
`cbr` = constant bitrate
`vbr_latency` = variable bitrate, latency constrained
`vbr_peak` = variable bitrate, peak constrained

::: {.note}
This option only applies when using amdvce encoder.
:::

::: {.warning}
The vbr_latency option generally works best, but some bitrate overshoots may still occur. Enabling HRD allows all bitrate based rate controls to better constrain peak bitrate, but may result in encoding artifacts depending on your card.
:::
";
      };
      amdEnforceHrd = mkOption {
        type = types.bool;
        default = false;
        description = "Enable Hypothetical Reference Decoder (HRD) enforcement to help constrain the target bitrate.

::: {.note}
This option only applies when using amdvce encoder.
:::

::: {.warning}
HRD is known to cause encoding artifacts or negatively affect encoding quality on certain cards.
:::
";
      };
      amdQuality = mkOption {
        type = types.enum [ "speed" "balanced" "quality" ];
        default = "balanced";
        description = "The quality profile controls the tradeoff between speed and quality of encoding.

Options:
`speed` = prefer speed
`balanced` = balanced
`quality` = prefer quality

::: {.note}
This option only applies when using amdvce encoder.
:::
";
      };
      amdPreanalysis = mkOption {
        type = types.bool;
        default = false;
        description = "Preanalysis can increase encoding quality at the cost of latency.

::: {.note}
This option only applies when using amdvce encoder.
:::
";
      };
      amdVbaq = mkOption {
        type = types.bool;
        default = true;
        description = "Variance Based Adaptive Quantization (VBAQ) can increase subjective visual quality by prioritizing allocation of more bits to smooth areas compared to more textured areas.

::: {.note}
This option only applies when using amdvce encoder.
:::
";
      };
      amdCoder = mkOption {
        type = types.enum [ "auto" "cabac" "cavlc" ];
        default = "auto";
        description = "The entropy encoding to use.

Options:
`auto` = let ffmpeg decide
`cabac` = context adaptive binary arithmetic coding - faster decode
`cavlc` = context adaptive variable-length coding - higher quality

::: {.note}
This option only applies when using H.264 with amdvce encoder.
:::
";
      };

      ## VA-API Encoder
      vaapiStrictRcBuffer = mkOption {
        type = types.enum [ "auto" "cabac" "cavlc" ];
        default = "auto";
        description = "Enabling this option can avoid dropped frames over the network during scene changes, but video quality may be reduced during motion.

Options:
`auto` = let ffmpeg decide
`cabac` = context adaptive binary arithmetic coding - faster decode
`cavlc` = context adaptive variable-length coding - higher quality

::: {.note}
This option only applies for H.264 and HEVC when using VA-API encoder on AMD GPUs.
:::
";
      };

      ## Software Encoder
      swPreset = mkOption {
        type = types.enum [ "ultrafast" "superfast" "veryfast" "faster" "fast" "medium" "slow" "slower" "veryslow" ];
        default = "superfast";
        description = "The encoder preset to use.

Options:
`ultrafast` fastest
`superfast`
`veryfast`
`faster`
`fast`
`medium`
`slow`
`slower`
`veryslow` slowest

::: {.note}
    This option only applies when using software encoder.
:::

::: {.note}
From FFmpeg.

A preset is a collection of options that will provide a certain encoding speed to compression ratio. A slower preset will provide better compression (compression is quality per filesize). This means that, for example, if you target a certain file size or constant bit rate, you will achieve better quality with a slower preset. Similarly, for constant quality encoding, you will simply save bitrate by choosing a slower preset.

Use the slowest preset that you have patience for.
:::

";
      };
      swTune = mkOption {
        type = types.enum [ "film" "animation" "grain" "stillimage" "fastdecode" "zerolatency" ];
        default = "zerolatency";
        description = "The tuning preset to use.

Options:
`film` = use for high quality movie content; lowers deblocking
`animation` = good for cartoons; uses higher deblocking and more reference frames
`grain` = preserves the grain structure in old, grainy film material
`stillimage` = good for slideshow-like content
`fastdecode` = allows faster decoding by disabling certain filters
`zerolatency` = good for fast encoding and low-latency streaming

::: {.note}
This option only applies when using software encoder.
:::

::: {.note}
From FFmpeg.

You can optionally use -tune to change settings based upon the specifics of your input.
:::
";
      };
    };

    applications = mkOption {
      type = submodule {
        options = {
          env = mkOption {
            default = { };
            description = "Environment variables to be set for the applications.";
            type = attrsOf str;
          };
          apps = mkOption {
            default = [ ];
            description = "Applications to be exposed to Moonlight.";
            type = listOf attrs;
          };
        };
      };
      example = literalExpression ''
        {
          env = {
            PATH = "$(PATH):$(HOME)/.local/bin";
          };
          apps = [
            {
              name = "1440p Desktop";
              prep-cmd = [
                {
                  do = "''${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.DP-4.mode.2560x1440@144";
                  undo = "''${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor output.DP-4.mode.3440x1440@144";
                }
              ];
              exclude-global-prep-cmd = "false";
              auto-detach = "true";
            }
            {
              "name": "Steam Big Picture",
              "detached": [
                "setsid steam steam://open/bigpicture"
              ],
              "image-path": "steam.png"
            }
          ];
        }
      '';
      default = {};
      description = "Configuration for applications to be exposed to Moonlight.";
    };
  };

  config = lib.mkIf sunshine.enable {
    # On the moonlight client manually add the server as `<server IP>:47989`
    services.sunshine = {
      enable = true;
      autoStart = sunshine.autoStart;
      # Needed for Wayland use, disable for x11
      capSysAdmin = true;
      openFirewall = true;

      settings =
      let
        boolToStatus = bool: if bool then "enabled" else "disabled";
      in
      {
        ## General
        locale = sunshine.locale;
        sunshine_name = sunshine.sunshineName;
        min_log_level = sunshine.minLogLevel;
        global_prep_cmd = ( builtins.toString sunshine.globalPrepCommands );
        # Since versioning is handled by nix, notifications of new releases is annoying
        notify_pre_releases = false;

        ## Input
        controller = boolToStatus sunshine.controller;
        gamepad = sunshine.gamepad;
        back_button_timeout = sunshine.backButtonTimeout;
        keyboard = boolToStatus sunshine.keyboard;
        key_repeat_delay = sunshine.keyRepeatDelay;
        key_repeat_frequency = sunshine.keyRepeatFrequency;
        key_rightalt_to_key_win = boolToStatus sunshine.keyRightAltToKeyWin;
        mouse = boolToStatus sunshine.mouse;
        high_resolution_scrolling = boolToStatus sunshine.highResolutionScrolling;
        native_pen_touch = boolToStatus sunshine.nativePenTouch;
        keybindings = ''
        [
          ${builtins.concatStringsSep ",\n  " sunshine.keybindings}
        ]
        '';

        ## Audio/Video
        audio_sink = lib.mkIf (!builtins.isNull sunshine.audioSink) sunshine.audioSink;
        virtual_sink = lib.mkIf (!builtins.isNUll sunshine.virtualSink) sunshine.virtualSink;
        stream_audio = boolToStatus sunshine.streamAudio;
        install_steam_audio_drivers = boolToStatus sunshine.installSteamAudioDrivers;
        output_name = lib.mkIf (!builtins.isNUll sunshine.outputName) sunshine.outputName;
        max_bitrate = sunshine.maxBitrate;

        ## Networking
        upnp = boolToStatus sunshine.upnp;
        address_family = sunshine.addressFamily;
        port = sunshine.port;
        origin_web_ui_allowed = sunshine.originWebUiAllowed;
        external_ip = sunshine.externalIP;
        lan_encryption_mode = sunshine.lanEncryptionMode;
        wan_encryption_mode = sunshine.wanEncryptionMode;
        ping_timeout = sunshine.pingTimeout;

        ## Config Files
        # file_apps is handled by the NixOS module
        credentials_file = sunshine.credentialsFile;
        log_path = sunshine.logPath;
        pkey = sunshine.pkey;
        file_state = sunshine.fileState;

        ## Advanced
        fec_percentage = sunshine.fecPercentage;
        qp = sunshine.qp;
        min_threads = sunshine.minThreads;
        hevc_mode = sunshine.hevcMode;
        av1_mode = sunshine.av1Mode;
        capture = lib.mkIf (!builtins.isNUll sunshine.capture) sunshine.capture;
        encoder = lib.mkIf (!builtins.isNull sunshine.encoder) sunshine.encoder;

        ## Nvidia NVENC Encoder
        nvenc_preset = sunshine.nvencPreset;
        nvenc_twopass = sunshine.nvencTwopass;
        nvencSpatialAq = boolToStatus sunshine.nvencSpatialAq;
        nvenc_vbv_increase = sunshine.nvencVbvIncrease;
        nvenc_h264_cavlc = boolToStatus sunshine.nvencH264Cavlc;

        ## Intel QuickSync Encoder
        qsv_preset = sunshine.qsvPreset;
        qsv_coder = sunshine.qsvCoder;
        qsv_slow_hevc = boolToStatus sunshine.qsvSlowHevc;

        ## AMD AMF Encoder
        amd_usage = sunshine.amdUsage;
        amd_enforce_hrd = boolToStatus sunshine.amdEnforceHrd;
        amd_quality = sunshine.amdQuality;
        amd_preanalysis = boolToStatus sunshine.amdPreanalysis;
        amd_vbac = boolToStatus sunshine.amdVbac;
        amd_coder = sunshine.amdCoder;

        ## VA-API Encoderlibva-utils
        vaapi_strict_rc_buffer = boolToStatus sunshine.vaapiStrictRcBuffer;

        ## Software Encoder
        sw_preset = sunshine.swPreset;
        sw_tune = sunshine.swTune;
      };

      applications = sunshine.applications;
    };
  };
}
