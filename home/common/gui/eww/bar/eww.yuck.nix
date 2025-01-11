{ lib, config, system-details, ... }:
let
  cfg = config.gui.eww;
  defwindow = (
    if
      builtins.match "wayland" system-details.display-type != null
    then # Wayland config
      ":stacking \"bg\"
  :exclusive true
  :focusable false"
    else # X11 config
      ":stacking \"bg\"
  :wm-ignore true
  :reserve (struts :distance \"2%\" :side \"top\")
  :windowtype \"dock\" "
  );
in
{
  config = lib.mkIf (cfg.enable && cfg.bar.enable) {
    home.file."/.config/eww/bar/eww.yuck" = {
      enable = true;
      force = true;
      text = /*yuck*/ ''
(defwindow bar
  :monitor 0
  ${defwindow}
  :geometry (geometry :x "0%"
                      :y "10px"
                      :width "118%"
                      :height "2%"
                      :anchor "top center")
  (bar))

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
            :onchange "")
    (metric :onclick ""
            :onscroll ""
            :tooltip "Capacity: ''${EWW_BATTERY["${cfg.battery.identifier}"].capacity}%
Status  : ''${EWW_BATTERY["${cfg.battery.identifier}"].status}"
            :image-path "../img/battery-full.svg"
            :bool-name "ui_battery_visible"
            :bool ui_battery_visible
            :value {EWW_BATTERY["${cfg.battery.identifier}"].capacity}
            :onchange "")
    (battery_widget)
    time))

(defwidget bar []
  (centerbox :orientation "h"
    (workspaces)
    (music)
    (sidestuff)))

(defwidget workspaces []
  (box :class "workspaces"
       :orientation "h"
       :space-evenly true
       :halign "start"
       :spacing 15
    (workspace_toggle :workspace 1)
    (workspace_toggle :workspace 2)
    (workspace_toggle :workspace 3)
    (workspace_toggle :workspace 4)
    (workspace_toggle :workspace 5)
    (workspace_toggle :workspace 6)
    (workspace_toggle :workspace 7)
    (workspace_toggle :workspace 8)
    (workspace_toggle :workspace 9)
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
    (overlay :class "battery"
      (image :class "icon"
             :path battery_icon
             :image-height 20
             :image-width 20
             :preserve-aspect-ratio true)
      (scale :min 0
             :max 100
             :value battery_capacity))))

(defwidget workspace_toggle [ workspace ]
  (button :onclick "hyprctl dispatch split:workspace ''${workspace} && eww update -c ${config.xdg.configHome}/eww/bar active_workspace=''${workspace}"
          :class {active_workspace == "''${workspace}" ? "workspace-active" : "workspace-inactive"}))

(deflisten music :initial ""
  "playerctl --follow metadata --format '{{ artist }} - {{ title }}' || true")

(defpoll volume :interval "5s"
  "pamixer --get-volume")

(defpoll time :interval "10s"
  "date '+%I:%M %b %d, %Y'")

(defvar mute_status false)

(defvar battery_status "Full")
(defvar battery_capacity 100)
(defvar battery_icon "../img/battery-full.svg")


(defvar active_workspace "1")

(defvar ui_volume_visible false)
(defvar ui_memory_visible false)
(defvar ui_battery_visible false)
      '';
    };
  };
}

