{
  description = "Flutter shellish development";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        config = {
          android_sdk.accept_license = true;
          allowUnfree = true;
        };
      };

      buildToolsVersion = "34.0.0";
      androidComposition = pkgs.androidenv.composeAndroidPackages {
        buildToolsVersions = [buildToolsVersion "28.0.3"];
        platformVersions = ["34" "28"];
        abiVersions = ["armeabi-v7a" "arm64-v8a"];
      };
      androidSdk = androidComposition.androidsdk;
      androidSdkPath = "${androidSdk}/libexec/android-sdk";
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = [
          pkgs.flutter
          androidSdk
          pkgs.jdk17
        ];

        # Rutas del store: NO dependen de $PWD, pueden ir como atributos.
        ANDROID_HOME = androidSdkPath;
        ANDROID_SDK_ROOT = androidSdkPath;
        JAVA_HOME = pkgs.jdk17.home;

        # Todo lo relativo al proyecto ($PWD) va aquí, en tiempo de ejecución.
        shellHook = ''
          export PROJECT_ENV="$PWD/.env"

          export XDG_CONFIG_HOME="$PROJECT_ENV/.config"
          export XDG_CACHE_HOME="$PROJECT_ENV/.cache"
          export XDG_DATA_HOME="$PROJECT_ENV/.data"
          export XDG_STATE_HOME="$PROJECT_ENV/.state"

          export PUB_CACHE="$PROJECT_ENV/pub-cache"

          export ANDROID_USER_HOME="$PROJECT_ENV/android"
          export ANDROID_EMULATOR_HOME="$PROJECT_ENV/android/emulator"
          export ANDROID_AVD_HOME="$PROJECT_ENV/android/avd"

          export GRADLE_USER_HOME="$PROJECT_ENV/gradle"

          export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$PROJECT_ENV/java -Djava.util.prefs.systemRoot=$PROJECT_ENV/java"

          mkdir -p \
            "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME" \
            "$PUB_CACHE" \
            "$ANDROID_USER_HOME" "$ANDROID_EMULATOR_HOME" "$ANDROID_AVD_HOME" \
            "$GRADLE_USER_HOME" \
            "$PROJECT_ENV/java"
        '';
      };
    });
}
