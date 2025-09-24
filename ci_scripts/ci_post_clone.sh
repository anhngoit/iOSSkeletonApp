# Workaround for SwiftLint plugin validation issues in Xcode Cloud
## This script tells Xcode Cloud to skip plugin/macro fingerprint validation, avoiding the SwiftLint plugin error you’ve been seeing.
defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES
defaults write com.apple.dt.Xcode IDESkipMacroFingerprintValidation -bool YES
