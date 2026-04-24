#!/bin/bash
# Returns a Nerd Font icon for a given app name ($1).
# Uses printf \xHH hex bytes (works on macOS bash 3.2).
app_icon() {
  case "$1" in
    # Terminals — U+F120 nf-fa-terminal
    "Terminal"|"iTerm2"|"kitty"|"Alacritty"|"WezTerm")
      printf '\xef\x84\xa0' ;;
    # Browsers
    "Safari")            printf '\xef\x89\xa7' ;;  # U+F267 nf-fa-safari
    "Arc"|"Google Chrome"|"Chromium")
                         printf '\xef\x89\xa8' ;;  # U+F268 nf-fa-chrome
    "Firefox")           printf '\xf3\xb0\x88\xb9' ;;  # U+F269 nf-fa-firefox
    # Editors / Dev
    "Code"|"Visual Studio Code")
                         printf '\xee\x9c\x8c' ;;  # U+E70C nf-dev-visualstudio
    "Neovide")           printf '\xee\x98\xab' ;;  # U+E62B nf-custom-vim
    "Xcode")             printf '\xef\x8c\x82' ;;  # U+F302 nf-fa-apple
    "DataGrip"|"TablePlus")
                         printf '\xef\x87\x80' ;;  # U+F1C0 nf-fa-database
    "Simulator")         printf '\xef\x84\x8b' ;;  # U+F10B nf-fa-mobile
    # Chat / Communication
    "Slack")             printf '\xef\x86\x98' ;;  # U+F198 nf-fa-slack
    "Discord")           printf '\xef\x87\xbf' ;;  # U+F392 nf-fa-discord
    "Telegram")          printf '\xef\x8b\x86' ;;  # U+F2C6 nf-fa-telegram
    "Mail")              printf '\xef\x83\xa0' ;;  # U+F0E0 nf-fa-envelope
    "Outlook"|"Microsoft Outlook")
                         printf '\xf3\xb0\xb4\xa2' ;;  # U+F0D22 nf-md-microsoft_outlook
    "Messages")          printf '\xef\x81\xb5' ;;  # U+F075 nf-fa-comment
    # Media
    "Spotify")           printf '\xef\x86\xbc' ;;  # U+F1BC nf-fa-spotify
    "Music")             printf '\xef\x80\x81' ;;  # U+F001 nf-fa-music
    # Productivity
    "Obsidian")          printf '\xef\x8a\x9f' ;;  # U+F5FC nf-fa-diamond
    "Finder")            printf '\xef\x85\xb9' ;;  # U+F179 nf-fa-apple
    "Notes")             printf '\xef\x89\x89' ;;  # U+F249 nf-fa-sticky-note-o
    "Calendar")          printf '\xef\x81\xb3' ;;  # U+F073 nf-fa-calendar
    # Fallback — U+F096 nf-fa-square-o
    *)                   printf '\xef\x82\x96' ;;
  esac
}
