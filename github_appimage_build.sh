sudo apt install -y python3-pip python3-setuptools patchelf desktop-file-utils libgdk-pixbuf2.0-dev fakeroot strace fuse

# Install appimagetool AppImage
sudo wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage -O /usr/local/bin/appimagetool
sudo chmod +x /usr/local/bin/appimagetool

cp -r ./build/linux/x64/release/bundle/ ./build/linux/x64/renamer.AppDir
cp -r ./appimage/renamer.desktop ./build/linux/x64/renamer.AppDir
cp -r ./assets/desktop.png ./build/linux/x64/renamer.AppDir
cp -r ./appimage/AppRun ./build/linux/x64/renamer.AppDir
chmod +x ./build/linux/x64/renamer.AppDir/AppRun
appimagetool ./build/linux/x64/renamer.AppDir
rm -rf ./build/linux/x64/renamer.AppDir
