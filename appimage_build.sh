flutter build linux --release
cp -r ./build/linux/x64/release/bundle/ ./build/linux/x64/renamer.AppDir
cp -r ./appimage/renamer.desktop ./build/linux/x64/renamer.AppDir
cp -r ./assets/ic_launcher.png ./build/linux/x64/renamer.AppDir
cp -r ./appimage/AppRun ./build/linux/x64/renamer.AppDir
chmod +x ./build/linux/x64/renamer.AppDir/AppRun
appimagetool ./build/linux/x64/renamer.AppDir
rm -rf ./build/linux/x64/renamer.AppDir
