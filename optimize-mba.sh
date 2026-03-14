#!/bin/bash
# MacBook Air 2020 (Intel i3) optimization script
# Run: chmod +x ~/optimize-mba.sh && ~/optimize-mba.sh
# Then RESTART your Mac to clear swap.

set -e

echo "=== Animations & Visual Effects ==="
defaults write com.apple.universalaccess reduceMotion -bool true
defaults write com.apple.finder DisableAllAnimations -bool true
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write -g QLPanelAnimationDuration -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.2
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock expose-animation-duration -float 0.12
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock no-bouncing -bool true
defaults write com.apple.dock mru-spaces -bool false

echo "=== Misc ==="
defaults write com.apple.CrashReporter DialogType -string "none"

echo "=== Restarting Dock & Finder ==="
killall Dock
killall Finder

echo "=== Disabling background daemons (persistent) ==="
sudo launchctl disable system/us.zoom.ZoomDaemon
launchctl disable gui/$(id -u)/us.zoom.updater
launchctl disable gui/$(id -u)/us.zoom.updater.login.check
launchctl disable gui/$(id -u)/com.amazon.codewhisperer.launcher

echo "=== DNS → Cloudflare ==="
sudo networksetup -setdnsservers Wi-Fi 1.1.1.1 1.0.0.1
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder

echo ""
echo "✅ Done. Now RESTART your Mac to clear 2.3GB swap."
