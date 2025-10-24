{ lib, config, systemDetails, ... }:
let
  gui = config.gui;
  eww = gui.eww;
  bar = eww.bar;
  defwindow = (
    if
      (builtins.match "wayland" systemDetails.display != null)
    then # Wayland config
      /*yuck*/ ''
:stacking "bg"
  :exclusive true
  :focusable false
      ''
    else # X11 config
      /*yuck*/ ''
:stacking "bg"
  :wm-ignore false
  :reserve (struts :distance "2%" :side "top")
  :windowtype "dock"
      ''
  );
  enableBattery = (
    if
      (builtins.match "android" systemDetails.hostType != null || builtins.match "laptop" systemDetails.hostType != null)
    then # If device is a laptop or android device, display a battery icon.
/*yuck*/ "
(battery_widget)"
    else # Anything else shouldn't
      ""
  );
in
{
  config = lib.mkIf (gui.enable && (eww.enable && bar.enable)) {
    home.file."/.config/eww/bar/eww.yuck" = {
      enable = true;
      force = true;
      text = /*yuck*/ ''
(defwindow bar [ width height offset ]
  :monitor 0
  ${defwindow}
  :geometry (geometry :x "0%"
                      :y "10px"
                      :width width
                      :height height
                      :anchor "top center")
  (bar :offset offset))

(defwidget sidestuff []
  (box :class "sidestuff" :orientation "h" :space-evenly false :halign "end"
    (systray :class "systray"
             :spacing 5
             :orientation "h"
             :space-evenly true
             :icon-size 20
             :prepend-new true)
    (metric :onclick "pamixer -t"
            :onscroll ""
            :tooltip "Volume: ''${volume}%
Mute  : ''${mute_status}"
            :image-path "../img/volume-high.svg"
            :bool-name "ui_volume_visible"
            :bool ui_volume_visible
            :value volume
            :onchange "pamixer --set-volume {}")
    (metric :onclick ""
            :onscroll ""
            :tooltip "Available RAM: ''${round(EWW_RAM.available_mem / 1000000000, 2)}GB"
            :image-path "../img/memory.svg"
            :bool-name "ui_memory_visible"
            :bool ui_memory_visible
            :value {EWW_RAM.used_mem_perc}
            :onchange "")${enableBattery}
    (label :text time)))

(defwidget bar [ offset ]
  (centerbox :orientation "h"
             :class "barwidget"
    (workspaces :offset offset)
    (music)
    (sidestuff)))

(defwidget workspaces [ offset ]
  (box :class "workspaces"
       :orientation "h"
       :space-evenly true
       :halign "start"
       :spacing 15
    (workspace_toggle :workspace 1
                      :offset offset)
    (workspace_toggle :workspace 2
                      :offset offset)
    (workspace_toggle :workspace 3
                      :offset offset)
    (workspace_toggle :workspace 4
                      :offset offset)
    (workspace_toggle :workspace 5
                      :offset offset)
    (workspace_toggle :workspace 6
                      :offset offset)
    (workspace_toggle :workspace 7
                      :offset offset)
    (workspace_toggle :workspace 8
                      :offset offset)
    (workspace_toggle :workspace 9
                      :offset offset)
  ))

(defwidget music []
  (box :class "music"
       :orientation "h"
       :space-evenly false
       :halign "center"
    (label :truncate true
           :text {music != "" ? "  ''${music}  " : ""})))

(defwidget metric [ onclick onscroll tooltip image-path bool-name bool value onchange ]
  (eventbox :class "metric"
            :onhover "eww update -c ${config.xdg.configHome}/eww/bar ''${bool-name}=true"
            :onhoverlost "eww update -c ${config.xdg.configHome}/eww/bar ''${bool-name}=false"
            :onscroll onscroll
    (tooltip
      (label :class "tooltiptext"
             :text tooltip )
      (box :orientation "h"
           :space-evenly false
        (button :onclick onclick
          (image :class "icon"
                 :path image-path
                 :image-height 20
                 :image-width 20
                 :preserve-aspect-ratio true))
        (revealer :transition "slideleft"
                  :reveal bool
                  :duration "500ms"
          (scale :min 0
                 :max 101
                 :active {onchange != ""}
                 :value value
                 :onchange onchange)
                 )))))

(defwidget battery_widget [ ]
  (tooltip
    (label :class "tooltiptext"
           :text "Capacity: ''${battery_capacity}%
Status  : ''${battery_status}")
    (box :orientation "h"
         :space-evenly false
      (label :class battery_class
             :text battery_icon)
      (label :text "''${EWW_BATTERY["${eww.battery.identifier}"].capacity}% | "))))

(defwidget workspace_toggle [ workspace offset ]
  (button :onclick "~/.config/eww/scripts/set_workspace.sh ''${workspace}"
          :class {active_workspace == "''${offset + workspace}" ? "workspace-active" : "workspace-inactive"}))

(deflisten music :initial ""
  "playerctl --follow metadata --format '{{ artist }} - {{ title }}' || true")

(defpoll volume :interval "5s"
  "pamixer --get-volume")

(defpoll time :interval "10s"
  "date '+%I:%M %b %d, %Y'")

(defvar mute_status false)

(defvar battery_status "")
(defvar battery_capacity 100)
(defvar battery_icon "󰁹󱐋")
(defvar battery_class "battery-full")

(defvar active_workspace "1")

(defvar ui_volume_visible false)
(defvar ui_memory_visible false)
(defvar ui_battery_visible false)
      '';
    };
  };
}

