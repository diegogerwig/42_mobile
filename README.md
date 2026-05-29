# 42_mobile

# 🚀 Guía de Instalación de Flutter en `sgoinfre` (Sin Sudo)

Este documento detalla los pasos para instalar el SDK de Flutter en un entorno de usuario sin privilegios de administrador (`sudo`), específicamente optimizado para sortear los problemas de bloqueo de red (NFS) que ocurren al instalar herramientas en particiones compartidas como `/sgoinfre`.

## 📌 El Problema de los Bloqueos (NFS Locks)
Al intentar ejecutar Flutter por primera vez en `sgoinfre`, el sistema intenta utilizar el comando nativo `flock` de Linux para bloquear archivos de caché y evitar ejecuciones simultáneas. Los sistemas de archivos en red a menudo no responden bien a esta petición, provocando que el comando se quede colgado en un bucle infinito con el mensaje:
> *Waiting for another flutter command to release the startup lock...*

Para solucionarlo, aplicamos un parche creando un comando `flock` falso que devuelve "éxito" inmediatamente, engañando a Flutter para que continúe la ejecución.

---

## 🛠️ Pasos de Instalación

### 1. Descarga y Extracción del SDK
Descargamos la versión estable oficial directamente en el directorio de `sgoinfre` para no agotar el espacio del `HOME` del usuario.

```bash
cd /sgoinfre/students/dgerwig-/

# Descargar el SDK (versión 3.29.3 estable)
curl -O [https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.29.3-stable.tar.xz](https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.29.3-stable.tar.xz)

# Extraer el contenido
tar -xf flutter_linux_3.29.3-stable.tar.xz -C /sgoinfre/students/dgerwig-/

```

### 2. Creación del Parche Anti-Bloqueo de Red

Creamos un directorio `bin` personal y generamos un script `flock` dummy para saltarnos las restricciones del sistema de archivos.

```bash
# Crear directorio de binarios personales
mkdir -p /sgoinfre/students/dgerwig-/bin

# Crear el script flock falso que siempre devuelve éxito (exit 0)
echo '#!/bin/bash' > /sgoinfre/students/dgerwig-/bin/flock
echo 'exit 0' >> /sgoinfre/students/dgerwig-/bin/flock

# Darle permisos de ejecución
chmod +x /sgoinfre/students/dgerwig-/bin/flock

```

### 3. Configuración de Variables de Entorno (`.zshrc`)

Añadimos las rutas necesarias al archivo de configuración de Zsh. Es crucial que el directorio personal `bin` (donde está el flock falso) y el binario de Flutter tengan prioridad en el `PATH`.

Añade el siguiente bloque a tu `~/.zshrc`:

```bash
# 1. Parche de red: Fuerza a usar el flock falso antes que el del sistema
export PATH="/sgoinfre/students/dgerwig-/bin:$PATH"

# 2. Añade los binarios de Flutter al PATH
export PATH="/sgoinfre/students/dgerwig-/flutter/bin:$PATH"

# 3. Variable de entorno para desactivar bloqueos internos del SDK
export FLUTTER_ALREADY_LOCKED=true

```

Recarga la configuración de la terminal:

```bash
source ~/.zshrc

```

### 4. Limpieza de Cachés Corruptas (En caso de intentos fallidos previos)

Si se abortó alguna ejecución anterior con `Ctrl + C`, es necesario limpiar los restos antes del primer arranque exitoso:

```bash
killall -9 flutter dart
rm -f /sgoinfre/students/dgerwig-/flutter/bin/cache/lockfile

```

### 5. Descarga de Herramientas del Motor e Inicialización

Finalmente, ejecutamos el diagnóstico en modo detallado. **Nota importante:** Este proceso tardará un par de minutos descargando el SDK de Dart. No se debe interrumpir (`Ctrl+C`).

```bash
flutter doctor -v

```

```bash
which flutter
flutter --version
```

# Ejecución de Proyectos Flutter

flutter create ex00

cd ex00

flutter run -d chrome

flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080

brew install adb-enhanced
brew install --cask android-platform-tools