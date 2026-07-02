# PROYECTO DE FLUTTER LOCAL
Proyecto de Flutter en NixOs para crear apps y desarrollar esas cuestiones

Esta mierda es un asco

## INSTALACION

```console
git clone https://github.com/ArielParedesLozada/ac_flutter.git
cd acl_flutter
nix develop
```

## EJECUCION
Para ejecutar el sistema, primero se levanta el flake.
```console
nix develop
# Una vez se este en la consola de Nix, se puede hacer todo lo demas
run-emulator # Ejecuta el emulador de Android
flutter run -d emulator-5554 # El emulador de Android que se esta ejecutando
```

*Nota*: La ejecucion de Android con Flutter es un *infierno* para la CPU. Solo se deberia utilizar el entorno de Android cuando sea estrictamente necesario, como para revisar funciones nativas (local_auth, etc...)

## COSAS PARA ELIMINAR
Estos son los archivos generados por **Nix** y donde se guarda el cache de la aplicacion. Deberian borrarse para no gastar espacio tras acabar con el desarrollo
```console
rm -rf .android
rm -rf .dart_tool
rm -rf .env
rm -rf ~/.android # No tengo idea de como llego aqui, pero bueno
```