{ lib, config, ... }:
let
  cfg = config.gui.eww;
in
{
  config = lib.mkIf (cfg.enable && cfg.bar.enable) {
    home.file."/.config/eww/eww.yuck" = {
      enable = true;
      force = true;
      text = ''
(defwindow bar
  :monitor 0
  :stacking "bg"
  :exclusive true
  :focusable false
  :geometry (geometry :x "0%"
                      :y "10px"
                      :width "120%"
                      :height "2%"
                      :anchor "top center")
  (bar))

(defwidget sidestuff []
  (box :class "sidestuff" :orientation "h" :space-evenly false :halign "end"
    (systray :spacing 5
             :orientation "h"
             :space-evenly true
             :icon-size 30
             :prepend-new true)
    (metric :image-path "./img/volume-high.svg"
            :value volume
            :onchange "amixer -D pulse sset Master {}%")
    (metric :image-path "./img/memory.svg"
            :value {EWW_RAM.used_mem_perc}
            :onchange "")
    (metric :image-path "./img/battery-full.svg"
            :value {EWW_BATTERY["BAT0"].capacity}
            :onchange "")
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

(defwidget metric [image-path value onchange]
  (box :orientation "h"
       :class "metric"
       :space-evenly false
    (box (image :class "icon"
                :path image-path
                :image-height 20
                :image-width 20
                :preserve-aspect-ratio true))
    (scale :min 0
           :max 101
           :active {onchange != ""}
           :value value
           :onchange onchange)))

(defwidget workspace_toggle [ workspace ]
  (button :onclick "hyprctl dispatch split:workspace ''${workspace} && eww update active_workspace=''${workspace}"
          :class {active_workspace == "''${workspace}" ? "circle-filled" : "circle-empty"}))

(deflisten music :initial ""
  "playerctl --follow metadata --format '{{ artist }} - {{ title }}' || true")

(defpoll volume :interval "1s"
  "scripts/getvol")

(defpoll time :interval "10s"
  "date '+%I:%M %b %d, %Y'")

(defvar active_workspace "1")
      '';
    };
  };
}

