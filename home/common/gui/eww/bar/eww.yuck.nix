{ lib, config, system-details, ... }:
let
  cfg = config.gui.eww;
  defwindow = (
    if
      builtins.match "wayland" system-details.display-type != null
    then # Wayland config
      ''
  :stacking "bg"
  :exclusive true
  :focusable false
  :namespace "dock"
      ''
    else # X11 config
      ''
  :stacking "bg"
  :wm-ignore true
  :reserve (struts :distance "2%" :side "top")
  :windowtype "dock"
      ''
  );
in
{
  config = lib.mkIf (cfg.enable && cfg.bar.enable) {
    home.file."/.config/eww/bar/eww.yuck" = {
      enable = true;
      force = true;
      text = ''
(defwindow bar
  :monitor 0
${defwindow}
  :geometry (geometry :x "0%"
                      :y "10px"
                      :width "120%"
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
            :tooltip "{volume}%"
            :image-path "../img/volume-high.svg"
            :value volume
            :onchange "pamixer --set-volume {}")
    (metric :tooltip "Available RAM: {EWW_RAM.available_mem}"
            :image-path "../img/memory.svg"
            :value {EWW_RAM.used_mem_perc}
            :onchange "")
    (metric :tooltip "Capacity: {EWW_BATTERY["${cfg.battery}"].capacity}% \nStatus: {EWW_BATTERY["${cfg.battery}"].status}"
            :image-path "../img/battery-full.svg"
            :value {EWW_BATTERY["${cfg.battery}"].capacity}
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

(defwidget metric [tooltip image-path value onclick onmiddleclick onrightclick onhover onscroll onchange]
  (eventbox :onclick onclick
            :onmiddleclick onmiddleclick
            :onrightclick onrightclick
            :onhover onhover
            :onhoverlost onhoverlost
            :onscroll onscroll
    (box :orientation "h"
         :class "metric"
         :space-evenly false
         :tooltip tooltip
      (box (image :class "icon"
                  :path image-path
                  :image-height 20
                  :image-width 20
                  :preserve-aspect-ratio true))
      (scale :min 0
             :max 101
             :active {onchange != ""}
             :value value
             :onchange onchange))))

(defwidget workspace_toggle [ workspace ]
  (button :onclick "hyprctl dispatch split:workspace ''${workspace} && eww update -c ${config.xdg.configHome}/eww/bar active_workspace=''${workspace}"
          :class {active_workspace == "''${workspace}" ? "circle-filled" : "circle-empty"}))

(deflisten music :initial ""
  "playerctl --follow metadata --format '{{ artist }} - {{ title }}' || true")

(defpoll volume :interval "5s"
  "pamixer --get-volume")

(defpoll time :interval "10s"
  "date '+%I:%M %b %d, %Y'")

(defvar mute_status "false")

(defvar active_workspace "1")
      '';
    };
  };
}

