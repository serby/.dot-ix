echo "Super Fast Keyboard Repeat Rate"
defaults write -g InitialKeyRepeat -int 12 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 0.5 # normal minimum is 2 (30 ms)

echo "Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)"
defaults write -g AppleKeyboardUIMode -int 3

echo "Speed up trackpad"
defaults write -g com.apple.trackpad.scaling -int 4

echo "Enable taping"
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

echo "Disable window animations and Get Info animations in Finder"
defaults write com.apple.finder DisableAllAnimations -bool true

echo "Don’t animate opening applications from the Dock"
defaults write com.apple.dock launchanim -bool false

echo "Disable opening and closing window animations"
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false

echo "Enable AirDrop over Ethernet and on unsupported Macs running Lion"
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

echo "Increase window resize speed for Cocoa applications"
defaults write -g NSWindowResizeTime -float 0.001

echo "Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo "Show the ~/Library folder"
chflags nohidden ~/Library

echo "Kill affected applications"
for app in Safari Finder Dock Mail SystemUIServer; do killall "$app" >/dev/null 2>&1; done

echo "Get rid of dock"
defaults write com.apple.dock autohide-delay -float 1000; killall Dock