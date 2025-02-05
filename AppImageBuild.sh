#!/bin/zsh


# SPDX-License-Identifier: GPL-3.0-or-later or MIT or 0BSD

#### THIS IS USING MANUAL APPIMAGETOOL. I HAVENT FOUND ANY ISSUES WITH THIS IN ITS CURRENT FORM; BUT ALTERNATIVELY LINUXDEPLOY COULD BE USED LIKE THIS
# ./linuxdeploy-x86_64.AppImage --appdir AppDir --executable dist/release/blenderlauncher --output appimage -d dist/release/AppImageDir/blenderlauncher.desktop -i dist/release/AppImageDir/bl_256.png
#
#### THIS DOES NOT ADD ANY METADATA AND IS PROBABLY NOT FIT TO BE DISTRIBUTED ON APPIMAGE MARKETPLACES, BUT FOR USAGE LOCALLY DOWNLOADED AS AN EXECUTABLE, IT SHOULD BE FINE

# 1. Build BL

sh scripts/build_linux.sh
executable='dist/release/Blender Launcher'

# 2. Download AppImage Tool (ENSURE YOU HAVE ZSYNC INSTALLED)
wget https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x appimagetool-x86_64.AppImage

# 3. Create AppImage FS
AID='dist/release/AppImageDir/'
mkdir -p $AID/usr/bin
## 3.1 copy executable to AppImage Directory
cp $executable $AID/usr/bin/BlenderLauncher
## 3.2 copy icon to AID
cp source/resources/icons/bl/bl_256.png $AID/

# 4. Create Desktop Entry
#sed 's+/usr/bin/blenderlauncher+blenderlauncher+g' extras/blenderlauncher.desktop > $AID/blenderlauncher.desktop // THIS IS BROKEN?
cat > $AID/blenderlauncher.desktop << EOF
[Desktop Entry]
Name=Blender Launcher V2
GenericName=Launcher
Exec=blenderlauncher
MimeType=application/x-blender;
Icon=bl_256
Terminal=false
Type=Application
Categories=Graphics;3DGraphics
EOF

# 5. Create AppRun
#HERE="$(dirname "$(readlink -f "${0}")")"
#cat > $AID/AppRun << EOF
#!/bin/bash
#exec '$HERE/usr/bin/BlenderLauncher'
#EOF
ln -s usr/bin/BlenderLauncher $AID/AppRun
## 5.5 Make it executable
chmod +x $AID/AppRun

# 6. Create AppImage with AppImagetool (and zsync)
ARCH=x86_64 ./appimagetool-x86_64.AppImage $AID BlenderLauncher.AppImage

# 7. Cleanup
rm appimagetool-x86_64.AppImage
rm -rf $AID
