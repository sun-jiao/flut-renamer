![feature graphic image](/assets/play-feature-graphic.png?raw=true)

# Flut Renamer

**Flut Renamer** is a powerful yet easy-to-use tool designed to help users manage and rename files and directories. No more manually renaming one by one – our app offers various features including inserting text, inserting file metadata and Exif data, replacing text, deleting text, rearranging, and more, allowing you to quickly batch rename files according to your needs.

"**Flut**" is derived from "**Flutter**", meaning the app is built using Flutter, but does not use the full name to avoid any possible trademark infringement. And "Flut" means flood in German, which implies that this app can batch rename files as fast as a flood.

* Multiple renaming options: Easily achieve batch file renaming by inserting, replacing, deleting text, and rearranging.
* Insert file metadata and Exif data: Extract information from file metadata and Exif data and insert it into the file name.
* Completely open-source and free: Flut Renamer is entirely open-source and contains no advertisements or in-app purchases, allowing you to use it freely at any time.
* Cross-platform compatibility: Built on the Flutter framework, Flut Renamer can run on multiple operating systems, enabling you to use it anytime, anywhere.

## Install
### Android
<a href="https://play.google.com/store/apps/details?id=net.sunjiao.renamer"><img alt="Get it on Google Play" src="https://play.google.com/intl/en_us/badges/images/generic/en-play-badge.png" height=60px /></a>

Install from Google Play Store or download *.apk from [releases].

### Linux
Download *.AppImage or *.tar.gz from [releases].

For Arch Linux users, just run:
```shell
yay -S flut-renamer # build from source code
yay -S flut-renamer-bin # binary version
```

### Windows
Download *.exe from [releases].

### macOS
Download *.dmg from [releases].

### iOS
Download *.ipa from [releases] and install by AltStore or other tools.

## todo:
- ~~Duplicate name check~~.(Done.)
- ~~Convert, including case convert, Chinese simp/trad/pinyin convert, Latin/Cyrillic script transliteration~~.(Done.)
- ~~Incremental renaming: for example, RenamerFile-1, RenamerFile-2, RenamerFile-3, RenamerFile-4, ...~~.(Done.)
- Rules re-editing.
- ~~Implement iOS renamer with specific code and Platform channel~~.(Done.) In fact, I have no Apple development experience at all, and I don’t even know the Swift language. The iOS and macOS native code was completed with the following links as references: [Writing custom platform-specific code](https://docs.flutter.dev/platform-integration/platform-channels?tab=type-mappings-swift-tab#type-mappings-swift-tab), [Providing access to directories](https://developer.apple.com/documentation/uikit/view_controllers/providing_access_to_directories), [juanmartin/renamerApp-ios](https://github.com/juanmartin/renamerApp-ios). Therefore, if there are any errors in the swift code, please fell free to point them out by opening an issue or a pull request. I'll be very grateful to you.

# Screenshots
## Desktop
| ![Desktop-0](/screenshots/Desktop-0.png?raw=true) | ![Desktop-1](/screenshots/Desktop-1.png?raw=true) |
|:--------------------------------------------------|:--------------------------------------------------|
| ![Desktop-2](/screenshots/Desktop-2.png?raw=true) | ![Desktop-3](/screenshots/Desktop-3.png?raw=true) |

## Phone
| ![Phone-0](/screenshots/Phone-0.png?raw=true) | ![Phone-1](/screenshots/Phone-1.png?raw=true) | ![Phone-2](/screenshots/Phone-2.png?raw=true) | ![Phone-3](/screenshots/Phone-3.png?raw=true) |
|:----------------------------------------------|:----------------------------------------------|:----------------------------------------------|:----------------------------------------------|

## Seven-inch Tablet
| ![Seven-inch_Tablet-0](/screenshots/Seven-inch_Tablet-0.png?raw=true) | ![Seven-inch_Tablet-1](/screenshots/Seven-inch_Tablet-1.png?raw=true) |
|:----------------------------------------------------------------------|:----------------------------------------------------------------------|
| ![Seven-inch_Tablet-2](/screenshots/Seven-inch_Tablet-2.png?raw=true) | ![Seven-inch_Tablet-3](/screenshots/Seven-inch_Tablet-3.png?raw=true) |

## Ten-inch Tablet
| ![Ten-inch_Tablet-0](/screenshots/Ten-inch_Tablet-0.png?raw=true) | ![Ten-inch_Tablet-1](/screenshots/Ten-inch_Tablet-1.png?raw=true) |
|:------------------------------------------------------------------|:------------------------------------------------------------------|
| ![Ten-inch_Tablet-2](/screenshots/Ten-inch_Tablet-2.png?raw=true) | ![Ten-inch_Tablet-3](/screenshots/Ten-inch_Tablet-3.png?raw=true) |

# Credit
Thanks to [m040601](https://aur.archlinux.org/account/m040601) for suggesting a new name for this application. "flut renamer" is inspired by their suggestion "renamer-flutter"

[releases]: https://github.com/sun-jiao/renamer/releases