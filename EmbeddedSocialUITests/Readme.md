# EmbeddedSocial UI Tests

## Prerequisites
The following settings must be turned off in a simulator:
- Hardware -> Keyboard -> Connect Hardare Keyboard
- Hardware -> Keyboard -> Uses the Same Layout as macOS

To disable options for new instances of a simulator execute the following in the command line:

```defaults write com.apple.iphonesimulator ConnectHardwareKeyboard 0
defaults write com.apple.iphonesimulator EnableKeyboardSync 0```
