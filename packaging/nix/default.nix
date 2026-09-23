{ pkgs ? import <nixpkgs> {} }:
assert pkgs.stdenv.hostPlatform.system == "@SYSTEM@";
pkgs.stdenv.mkDerivation {
  pname = "flut-renamer";
  version = "@VERSION@";
  src = ./bundle;
  nativeBuildInputs = with pkgs; [ autoPatchelfHook wrapGAppsHook3 ];
  buildInputs = with pkgs; [
    gtk3 glib pango cairo atk gdk-pixbuf libepoxy fontconfig
    libGL stdenv.cc.cc.lib xz jdk17_headless
  ];
  # Flutter loads the graphics driver dynamically.
  runtimeDependencies = [ pkgs.libGL ];
  dontBuild = true;
  dontStrip = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/flut-renamer $out/bin $out/share/applications \
      $out/share/icons/hicolor/256x256/apps $out/share/licenses/flut-renamer
    cp -a . $out/lib/flut-renamer/
    ln -s $out/lib/flut-renamer/flut-renamer $out/bin/flut-renamer
    cp ${./flut-renamer.desktop} $out/share/applications/flut-renamer.desktop
    cp ${./desktop.png} $out/share/icons/hicolor/256x256/apps/flut-renamer.png
    cp ${./LICENSE} $out/share/licenses/flut-renamer/LICENSE
    runHook postInstall
  '';
  preFixup = ''
    addAutoPatchelfSearchPath $out/lib/flut-renamer/lib
    # libdartjni.so links to libjvm.so. OpenJDK keeps it below JAVA_HOME,
    # outside the top-level lib directory normally searched by the hook.
    test -f ${pkgs.jdk17_headless.home}/lib/server/libjvm.so
    addAutoPatchelfSearchPath ${pkgs.jdk17_headless.home}/lib/server
  '';
  meta = {
    description = "Batch rename files and directories";
    license = pkgs.lib.licenses.gpl3Only;
    platforms = [ "@SYSTEM@" ];
    mainProgram = "flut-renamer";
  };
}
