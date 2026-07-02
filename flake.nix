{
  description = "acl_flutter - Flutter + Android SDK dev shell (APK build + emulator con local_auth)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    flake-utils.url = "github:numtide/flake-utils";
    android-nixpkgs = {
      url = "github:tadfisher/android-nixpkgs/main";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    android-nixpkgs,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          android_sdk.accept_license = true;
        };
      };

      # >>> AJUSTA AQUÍ SI CAMBIAS DE VERSIONES >>>
      minSdkVersion = "21";
      targetSdkVersion = "34";
      platformVersion = "34";
      kotlinVersion = "2.1.0"; # subido: requerido por Flutter reciente
      agpVersion = "8.9.1"; # subido: requerido por androidx.core 1.18.0
      ndkVersion = "27.0.12077973";
      avdName = "acl_flutter_emulator";
      # <<<

      androidEnv = android-nixpkgs.sdk.${system} (sdkPkgs:
        with sdkPkgs; [
          cmdline-tools-latest
          build-tools-34-0-0
          build-tools-36-0-0
          platform-tools
          platforms-android-34
          platforms-android-36
          emulator
          ndk-27-0-12077973
          system-images-android-34-google-apis-playstore-x86-64
        ]);

      wrappedEmulator = pkgs.writeShellScriptBin "run-emulator" ''
        #!/usr/bin/env bash
        echo "Launching emulator (${avdName}) ..."

        NIX_XHOST="${pkgs.xhost}/bin/xhost"
        if [ -x "$NIX_XHOST" ] && [ -n "$DISPLAY" ]; then
          "$NIX_XHOST" +local: > /dev/null
          XHOST_CLEANUP=true
          echo "✅ X access granted via Nix-xhost."
        else
          echo "⚠️ DISPLAY no seteado o xhost no encontrado. Fix omitido."
          XHOST_CLEANUP=false
        fi

        if [ -n "$FHS_LIB" ]; then
          export LD_LIBRARY_PATH="$FHS_LIB/usr/lib:$LD_LIBRARY_PATH"
          export ANDROID_HOME="$PWD/.android/sdk"
          export ANDROID_SDK_ROOT="$ANDROID_HOME"
          export PATH="$ANDROID_HOME/bin:$ANDROID_HOME/platform-tools:$PATH"
        else
          echo "❌ FHS_LIB no seteado. La emulación puede fallar."
        fi

        if [ -n "$WAYLAND_DISPLAY" ]; then
          echo "🌿 Wayland detectado: $WAYLAND_DISPLAY"
          [ -z "$DISPLAY" ] && export DISPLAY=:0
        else
          echo "🖥️  X11 detectado: ${DISPLAY:-:0}"
        fi
        export QT_QPA_PLATFORM=xcb
        export QT_QPA_PLATFORM_PLUGIN_PATH="${pkgs.qt6.qtbase}/lib/qt-6/plugins"
        export QT_PLUGIN_PATH="${pkgs.qt6.qtbase}/lib/qt-6/plugins"
        export QML2_IMPORT_PATH="${pkgs.qt6.qtbase}/lib/qt-6/qml"
        export QTWEBENGINE_DISABLE_SANDBOX=1
        export QT_OPENGL=desktop
        export QT_QPA_PLATFORMTHEME=gtk3
        export QT_ACCESSIBILITY=1
        export QT_IM_MODULE=compose
        export XMODIFIERS=@im=none
        export GTK_IM_MODULE=gtk-im-context-simple
        export SDL_VIDEODRIVER=x11
        export XKB_DEFAULT_LAYOUT=us

        if [ -d "/run/opengl-driver" ]; then
          echo "✅ Driver GPU (NVIDIA/OpenGL) detectado"
          export LD_LIBRARY_PATH="/run/opengl-driver/lib:$FHS_LIB/usr/lib:$LD_LIBRARY_PATH"
          export LIBGL_DRIVERS_PATH="/run/opengl-driver/lib/dri"
        else
          echo "⚠️ Driver NVIDIA no encontrado, usando fallback Mesa"
          export LD_LIBRARY_PATH="${pkgs.mesa}/lib:${pkgs.libdrm}/lib:${pkgs.vulkan-loader}/lib:$LD_LIBRARY_PATH"
          export LIBGL_DRIVERS_PATH="${pkgs.mesa}/lib/dri"
          export MESA_LOADER_DRIVER_OVERRIDE=i965
        fi

        export QEMU_GL_ENABLE=1
        export QEMU_VULKAN_ENABLE=1
        export LD_PRELOAD="${pkgs.libglvnd}/lib/libGL.so.1"

        # Habilita teclado físico y botones (útil para navegar diálogos de local_auth)
        AVD_CFG="$ANDROID_AVD_HOME/${avdName}.avd/config.ini"
        if [ -f "$AVD_CFG" ]; then
          for kv in "hw.keyboard=yes" "hw.mainKeys=yes" "hw.dPad=yes"; do
            key="''${kv%%=*}"
            if grep -q "^$key" "$AVD_CFG"; then
              sed -i "s/^$key.*/$kv/" "$AVD_CFG"
            else
              echo "$kv" >> "$AVD_CFG"
            fi
          done
        fi

        if $XHOST_CLEANUP; then
          trap "xhost -local: > /dev/null; echo '✅ X access revocado.'" EXIT
        fi

        exec emulator -avd ${avdName} \
          -gpu host \
          -no-snapshot \
          -no-snapshot-load \
          -no-snapshot-save \
          -port 5554 \
          -grpc 8554 \
          -qemu -enable-kvm
      '';

      enrollFakeFingerprint = pkgs.writeShellScriptBin "enroll-fake-fingerprint" ''
        #!/usr/bin/env bash
        echo "🔐 Configurando bloqueo de pantalla + huella simulada para local_auth..."
        adb -e wait-for-device
        adb -e shell locksettings set-pin 1234
        adb -e emu finger touch 1
        echo "✅ Listo. Cuando la app pida biometría, corre:"
        echo "    adb -e emu finger touch 1"
        echo "para simular una huella válida."
      '';

      patchedFlutter = pkgs.flutter.overrideAttrs (oldAttrs: {
        patchPhase = ''
          runHook prePatch
          substituteInPlace $FLUTTER_ROOT/packages/flutter_tools/gradle/src/main/kotlin/FlutterTask.kt \
            --replace 'val cmakeExecutable = project.file(cmakePath).absolutePath' 'val cmakeExecutable = "cmake"' \
            --replace 'val ninjaExecutable = project.file(ninjaPath).absolutePath' 'val ninjaExecutable = "ninja"'
          find $FLUTTER_ROOT -name "*.gradle" -o -name "*.gradle.kts" | xargs -I {} \
            sed -i 's|cmake/[^/]*/bin/cmake|cmake|g' {} 2>/dev/null || true
          find $FLUTTER_ROOT/packages/flutter_tools -name "*.dart" | xargs -I {} \
            sed -i 's|/cmake/[^/]*/bin/cmake|cmake|g' {} 2>/dev/null || true
          runHook postPatch
        '';
      });
    in {
      devShells.default =
        (pkgs.buildFHSEnv {
          name = "acl_flutter";
          targetPkgs = pkgs:
            with pkgs; [
              bashInteractive
              git
              cmake
              ninja
              python3
              jdk17
              nix-ld
              gradle
              patchedFlutter
              wrappedEmulator
              enrollFakeFingerprint
              androidEnv
              patchelf

              glibc
              zlib
              ncurses5
              stdenv.cc.cc.lib

              libsForQt5.qt5.qtbase
              libsForQt5.qt5.qtsvg
              libsForQt5.qt5.qtwayland
              libsForQt5.qt5.qttools
              libsForQt5.qt5.qtdeclarative
              qt6.qt5compat
              libsForQt5.qt5ct
              qt6.qtbase
              qt6.qtsvg
              qt6.qtwayland
              qt6.qt5compat

              libX11
              libXext
              libXfixes
              libXi
              libXrandr
              libXrender
              libxcb
              xcbutil
              xcbutilwm
              xcbutilimage
              xcbutilkeysyms
              xcbutilrenderutil
              libxkbcommon
              xcb-util-cursor
              libXcursor

              mesa
              libdrm
              vulkan-loader
              fontconfig
              freetype
              mesa-demos
              linuxPackages.nvidia_x11
              libglvnd

              dbus
              libevdev
              libpulseaudio
              pipewire
              udev
              libinput
              libinput-gestures
              at-spi2-atk
              at-spi2-core

              gtk3
              gdk-pixbuf
              cairo
              pango
              harfbuzz
              glib
              gsettings-desktop-schemas
              setxkbmap
              xauth
              xhost
              xset
            ];

          multiPkgs = pkgs: with pkgs; [zlib ncurses5 mesa];

          profile = ''
            echo "🚀 acl_flutter - entorno FHS activo"
            export PATH="$FHS_LIB/usr/bin:$PATH"
            export NIX_LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [
              pkgs.glibc
              pkgs.zlib
              pkgs.ncurses5
              pkgs.stdenv.cc.cc.lib
              pkgs.libsForQt5.qt5.qtbase
              pkgs.libsForQt5.qt5.qtsvg
              pkgs.libsForQt5.qt5.qtwayland
              pkgs.libsForQt5.qt5.qttools
              pkgs.libsForQt5.qt5.qtdeclarative
              pkgs.qt6.qt5compat
              pkgs.libsForQt5.qt5ct
              pkgs.qt6.qtbase
              pkgs.qt6.qtsvg
              pkgs.qt6.qtwayland
              pkgs.qt6.qt5compat
              pkgs.libX11
              pkgs.libXext
              pkgs.libXfixes
              pkgs.libXi
              pkgs.libXrandr
              pkgs.libXrender
              pkgs.libxcb
              pkgs.xcbutil
              pkgs.xcbutilwm
              pkgs.xcbutilimage
              pkgs.xcbutilkeysyms
              pkgs.xcbutilrenderutil
              pkgs.libxkbcommon
              pkgs.mesa
              pkgs.libdrm
              pkgs.vulkan-loader
              pkgs.libglvnd
              pkgs.linuxPackages.nvidia_x11
              pkgs.fontconfig
              pkgs.freetype
              pkgs.dbus
              pkgs.libpulseaudio
              pkgs.pipewire
              pkgs.udev
              pkgs.libinput
              pkgs.libevdev
              pkgs.libinput-gestures
              pkgs.at-spi2-atk
              pkgs.at-spi2-core
              pkgs.gtk3
              pkgs.gdk-pixbuf
              pkgs.cairo
              pkgs.pango
              pkgs.harfbuzz
              pkgs.glib
              pkgs.gsettings-desktop-schemas
              pkgs.xcb-util-cursor
              pkgs.libXcursor
              pkgs.setxkbmap
              pkgs.xauth
              pkgs.xhost
              pkgs.xset
            ]}"
            export LD_LIBRARY_PATH="$NIX_LD_LIBRARY_PATH:$LD_LIBRARY_PATH"

            # ==========================================================
            # AISLAMIENTO REFORZADO: todo lo que normalmente iría a $HOME
            # se redirige a $PWD/.env. Se sobrescribe HOME para que
            # herramientas que ignoran las vars XDG/ANDROID igual escriban
            # dentro del proyecto.
            # ==========================================================
            export PROJECT_ENV="$PWD/.env"
            export HOME="$PROJECT_ENV/home"     # <-- clave: fuerza aislamiento total
            export XDG_CONFIG_HOME="$PROJECT_ENV/.config"
            export XDG_CACHE_HOME="$PROJECT_ENV/.cache"
            export XDG_DATA_HOME="$PROJECT_ENV/.data"
            export XDG_STATE_HOME="$PROJECT_ENV/.state"
            export PUB_CACHE="$PROJECT_ENV/pub-cache"
            export ANDROID_USER_HOME="$PROJECT_ENV/android"
            export ANDROID_EMULATOR_HOME="$PROJECT_ENV/android/emulator"
            export ANDROID_AVD_HOME="$PROJECT_ENV/android/avd"
            export ANDROID_SDK_HOME="$PROJECT_ENV/android"
            export GRADLE_USER_HOME="$PROJECT_ENV/gradle"
            export FLUTTER_ROOT_OVERRIDE=""      # placeholder, no crítico
            export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$PROJECT_ENV/java -Djava.util.prefs.systemRoot=$PROJECT_ENV/java"
            mkdir -p "$HOME" "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME" \
                     "$PUB_CACHE" "$ANDROID_USER_HOME" "$ANDROID_EMULATOR_HOME" "$ANDROID_AVD_HOME" \
                     "$GRADLE_USER_HOME" "$PROJECT_ENV/java"

            if [ -f "$PWD/.flutter_env_ready" ] && [ -d "$PWD/.android/sdk" ]; then
              export ANDROID_HOME="$PWD/.android/sdk"
              export ANDROID_SDK_ROOT="$ANDROID_HOME"
              export JAVA_HOME="${pkgs.jdk17}"
              export PATH="${pkgs.cmake}/bin:${pkgs.ninja}/bin:$PATH"
              export LD_LIBRARY_PATH="$FHS_LIB/usr/lib:$LD_LIBRARY_PATH"
              echo "⚡ Entorno ya configurado."
              echo "👉 flutter run -d emulator-5554  (con emulador corriendo)"
              echo "👉 run-emulator             (lanza el AVD ${avdName})"
              echo "👉 enroll-fake-fingerprint  (huella simulada para local_auth)"
              echo "👉 flutter build apk --release"
            else
              echo "🔧 Configuración inicial del entorno..."
              "${androidEnv}/share/android-sdk/platform-tools/adb" kill-server &> /dev/null || true

              mkdir -p "$PWD/.android/sdk"
              export ANDROID_HOME="$PWD/.android/sdk"
              export ANDROID_SDK_ROOT="$ANDROID_HOME"
              export JAVA_HOME="${pkgs.jdk17}"

              gradle --version
              "$JAVA_HOME/bin/java" -version

              mkdir -p "$ANDROID_HOME/licenses" "$ANDROID_HOME/avd" "$ANDROID_HOME/bin"
              cp -LR ${androidEnv}/share/android-sdk/* "$ANDROID_HOME/" || true
              for bin in adb avdmanager emulator sdkmanager; do
                cp -LR ${androidEnv}/bin/$bin "$ANDROID_HOME/bin/" || true
              done
              rm -rf "$ANDROID_HOME/cmake"
              mkdir -p "$ANDROID_HOME/cmake/3.22.1/bin"
              ln -sf "${pkgs.cmake}/bin/cmake" "$ANDROID_HOME/cmake/3.22.1/bin/cmake"
              ln -sf "${pkgs.ninja}/bin/ninja" "$ANDROID_HOME/cmake/3.22.1/bin/ninja"
              chmod -R u+w "$ANDROID_HOME"

              find "$ANDROID_HOME/bin" "$ANDROID_HOME/platform-tools" \
                   "$ANDROID_HOME/emulator" "$ANDROID_HOME/cmdline-tools/latest/bin" \
                   "$ANDROID_HOME/build-tools" "$ANDROID_HOME/platforms" \
                   "$ANDROID_HOME/ndk" -type f -exec chmod +x {} \; 2>/dev/null || true

              for license in android-sdk-license android-sdk-preview-license googletv-license; do
                touch "$ANDROID_HOME/licenses/$license"
              done
              yes | flutter doctor --android-licenses || true
              flutter config --android-sdk "$ANDROID_HOME"

              if [ ! -f pubspec.yaml ]; then
                echo "⚠️ No se encontró pubspec.yaml en $PWD. Verifica que estás en la raíz de acl_flutter."
              fi

              if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
                git init
                echo "✅ Git inicializado."
              fi

              mkdir -p android/app/src/main/{kotlin,java}
              mkdir -p android/app/src/debug/{kotlin,java}
              mkdir -p android/app/src/profile/{kotlin,java}
              mkdir -p android/app/src/release/{kotlin,java}

              if [ -d android ]; then
                touch android/gradle.properties
                sed -i '/^android\.cmake\.path=/d' android/gradle.properties
                sed -i '/^android\.ninja\.path=/d' android/gradle.properties
                sed -i '/^android\.cmake\.version=/d' android/gradle.properties
                echo "android.cmake.path=${pkgs.cmake}/bin" >> android/gradle.properties
                echo "android.ninja.path=${pkgs.ninja}/bin" >> android/gradle.properties
                echo "android.cmake.version=" >> android/gradle.properties
                echo "android.cmake.makeProgram=${pkgs.ninja}/bin/ninja" >> android/gradle.properties
              fi

              # Kotlin DSL: pinea AGP/Kotlin
              if [ -f "android/settings.gradle.kts" ]; then
                sed -i -e "s/id(\"com.android.application\") version \"[0-9.]*\"/id(\"com.android.application\") version \"${agpVersion}\"/g" android/settings.gradle.kts
                sed -i -e "s/id(\"org.jetbrains.kotlin.android\") version \"[0-9.]*\"/id(\"org.jetbrains.kotlin.android\") version \"${kotlinVersion}\"/g" android/settings.gradle.kts
              fi
              if [ -f "android/build.gradle.kts" ]; then
                sed -i -e "s/id(\"com.android.application\") version \"[0-9.]*\"/id(\"com.android.application\") version \"${agpVersion}\"/g" android/build.gradle.kts
                sed -i -e "s/id(\"org.jetbrains.kotlin.android\") version \"[0-9.]*\"/id(\"org.jetbrains.kotlin.android\") version \"${kotlinVersion}\"/g" android/build.gradle.kts
              fi

              if [ -f "android/app/build.gradle.kts" ]; then
                sed -i -e "s/minSdk = [0-9a-zA-Z._]*/minSdk = ${minSdkVersion}/g" android/app/build.gradle.kts
                sed -i -e "s/targetSdk = [0-9a-zA-Z._]*/targetSdk = ${targetSdkVersion}/g" android/app/build.gradle.kts

                sed -i '/ndkVersion\s*=/d' android/app/build.gradle.kts
                if grep -q "android\s*{" android/app/build.gradle.kts; then
                  sed -i "/android\s*{/a \    ndkVersion = \"${ndkVersion}\"" android/app/build.gradle.kts
                else
                  echo -e "\nandroid {\n    ndkVersion = \"${ndkVersion}\"\n}" >> android/app/build.gradle.kts
                fi
              fi

              # Crear AVD si no existe
              if ! avdmanager list avd | grep -q '${avdName}'; then
                echo "Creando AVD: ${avdName}"
                yes | avdmanager create avd \
                  --name "${avdName}" \
                  --package "system-images;android-${platformVersion};google_apis_playstore;x86_64" \
                  --device "pixel" \
                  --abi "x86_64" \
                  --tag "google_apis_playstore" \
                  --force
              fi

              AVD_CFG="$ANDROID_AVD_HOME/${avdName}.avd/config.ini"
              if [ -f "$AVD_CFG" ]; then
                for kv in "hw.keyboard=yes" "hw.mainKeys=yes" "hw.dPad=yes"; do
                  key="''${kv%%=*}"
                  if grep -q "^$key" "$AVD_CFG"; then
                    sed -i "s/^$key.*/$kv/" "$AVD_CFG"
                  else
                    echo "$kv" >> "$AVD_CFG"
                  fi
                done
              fi

              export PATH="${pkgs.cmake}/bin:${pkgs.ninja}/bin:$PATH"
              echo "🔧 CMake: $(${pkgs.cmake}/bin/cmake --version | head -1)"
              echo "🔧 Ninja: $(${pkgs.ninja}/bin/ninja --version)"

              flutter doctor --quiet

              touch "$PWD/.flutter_env_ready"
              grep -qxF ".flutter_env_ready" .gitignore 2>/dev/null || echo ".flutter_env_ready" >> .gitignore
              grep -qxF ".android/sdk" .gitignore 2>/dev/null || echo ".android/sdk" >> .gitignore
              grep -qxF ".env" .gitignore 2>/dev/null || echo ".env" >> .gitignore

              echo "✅ acl_flutter dev shell listo."
              echo "👉 run-emulator             (lanza el AVD ${avdName})"
              echo "👉 enroll-fake-fingerprint  (huella simulada para local_auth)"
              echo "👉 flutter run -d emulator-5554"
              echo "👉 flutter build apk --release"
            fi
          '';
          runScript = "bash";
        }).env;
    });
}
