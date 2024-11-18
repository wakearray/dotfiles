{ ... }:
{

# Delaware starship prompt:

#"$schema" = 'https://starship.rs/config-schema.json'
#
#format = """
#[](color_01)\
#[](fg:color_02 bg:color_01)\
#$os\
#$username\
#[](fg:color_04 bg:color_03)\
#$directory\
#[](fg:color_04 bg:color_03)\
#$git_branch\
#$git_status\
#[](fg:color_04 bg:color_03)\
#$c\
#$rust\
#$golang\
#$nodejs\
#$php\
#$java\
#$kotlin\
#$haskell\
#$python\
#[](fg:color_04 bg:color_03)\
#$docker_context\
#$conda\
#[](fg:color_04 bg:color_03)\
#$time\
#[ ](fg:color_03)\
#$line_break$character"""
#
#palette = 'gruvbox_dark'
#
#[palettes.gruvbox_dark]
#color_fg0 = '#000000'
#color_fg1 = '#000000'
#color_fg2 = '#000000'
#color_green = '#98971a'
#color_purple = '#b16286'
#color_red = '#cc241d'
#
## Made to mimic the colors of the Delaware Chicken
#color_01 = '#F53A30' # Red of a chicken's comb
#color_02 = '#FFD000' # Yellow of beak
#color_03 = '#FFFFFF' # White of the feathers
#color_04 = '#000000' # Black of the speckled feathers
#
#[os]
#disabled = false
#style = "bg:color_03 fg:color_fg0"
#
#[os.symbols]
#Windows = "󰍲"
#Ubuntu = "󰕈"
#SUSE = ""
#Raspbian = "󰐿"
#Mint = "󰣭"
#Macos = "󰀵"
#Manjaro = ""
#Linux = "󰌽"
#Gentoo = "󰣨"
#Fedora = "󰣛"
#Alpine = ""
#Amazon = ""
#Android = ""
#Arch = "󰣇"
#Artix = "󰣇"
#CentOS = ""
#Debian = "󰣚"
#Redhat = "󱄛"
#RedHatEnterprise = "󱄛"
#NixOS = ""
#
#[username]
#show_always = true
#style_user = "bg:color_03 fg:color_fg0"
#style_root = "bg:color_03 fg:color_fg0"
#format = '[ $user ]($style)'
#
#[directory]
#style = "fg:color_fg0 bg:color_03"
#format = "[ $path ]($style)"
#truncation_length = 3
#truncation_symbol = "…/"
#
#[directory.substitutions]
#"Documents" = "󰈙 "
#"Downloads" = " "
#"Music" = "󰝚 "
#"Pictures" = " "
#"Developer" = "󰲋 "
#
#[git_branch]
#symbol = ""
#style = "bg:color_03"
#format = '[[ $symbol $branch ](fg:color_fg0 bg:color_03)]($style)'
#
#[git_status]
#style = "bg:color_03"
#format = '[[($all_status$ahead_behind )](fg:color_fg0 bg:color_03)]($style)'
#
#[nodejs]
#symbol = ""
#style = "bg:color_03"
#format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_03)]($style)'
#
#[c]
#symbol = " "
#style = "bg:color_03"
#format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_03)]($style)'
#
#[rust]
#symbol = ""
#style = "bg:color_03"
#format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_03)]($style)'
#
#[golang]
#symbol = ""
#style = "bg:color_03"
#format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_03)]($style)'
#
#[php]
#symbol = ""
#style = "bg:color_03"
#format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_03)]($style)'
#
#[java]
#symbol = " "
#style = "bg:color_03"
#format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_03)]($style)'
#
#[kotlin]
#symbol = ""
#style = "bg:color_03"
#format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_03)]($style)'
#
#[haskell]
#symbol = ""
#style = "bg:color_03"
#format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_03)]($style)'
#
#[python]
#symbol = ""
#style = "bg:color_03"
#format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_03)]($style)'
#
#[docker_context]
#symbol = ""
#style = "bg:color_05"
#format = '[[ $symbol( $context) ](fg:color_fg2 bg:color_03)]($style)'
#
#[conda]
#style = "bg:color_05"
#format = '[[ $symbol( $environment) ](fg:color_fg2 bg:color_03)]($style)'
#
#[time]
#disabled = false
#use_12hr = true
#time_format = "%l:%M %P"
#style = "bg:color_06"
#format = '[[  $time ](fg:color_fg1 bg:color_03)]($style)'
#
#[line_break]
#disabled = false
#
#[character]
#disabled = false
#success_symbol = '[](bold fg:color_green)'
#error_symbol = '[](bold fg:color_red)'
#vimcmd_symbol = '[](bold fg:color_green)'
#vimcmd_replace_one_symbol = '[](bold fg:color_purple)'
#vimcmd_replace_symbol = '[](bold fg:color_purple)'
#vimcmd_visual_symbol = '[](bold fg:color_02)'

}
