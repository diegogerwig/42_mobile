# Mobile_00 - 42 Mobile

Este repositorio contiene los ejercicios correspondientes al módulo **Mobile_00** del curso de desarrollo móvil.

---

## 📱 Guía: Cómo autorizar tu Smartphone mediante Depuración USB

Para poder probar y desplegar aplicaciones directamente en tu smartphone (físico) desde tu ordenador, debes habilitar y autorizar la **Depuración USB** (USB Debugging). Sigue estos pasos:

### 1. Activar las Opciones de Desarrollador en el Teléfono
1. Abre los **Ajustes** (Settings) de tu smartphone.
2. Desplázate hacia abajo y entra en **Información del teléfono** (o *Acerca del dispositivo* / *About phone*).
3. Busca el **Número de compilación** (Build number).
   > [!NOTE]
   > En algunos dispositivos (como Xiaomi), puede estar dentro de *Información de software* o llamarse *Versión de MIUI*.
4. Presiona el **Número de compilación 7 veces** consecutivas. Verás un mensaje en pantalla indicando que *"¡Ahora eres desarrollador!"*.

### 2. Habilitar la Depuración USB
1. Regresa al menú principal de **Ajustes**.
2. Entra en **Sistema** -> **Opciones de desarrollador** (o busca directamente *"Opciones de desarrollador"* / *"Developer options"* en la barra de búsqueda de Ajustes).
3. Busca la opción **Depuración USB** (USB debugging) y actívala.
4. Confirma la advertencia de seguridad que aparece en pantalla.

### 3. Conectar el Smartphone a la Computadora
1. Conecta tu smartphone al ordenador mediante un **cable USB** de buena calidad (asegúrate de que soporte transferencia de datos, no solo carga).
2. Si te aparece una notificación en el teléfono sobre el modo de conexión USB, selecciona **Transferencia de archivos (MTP)** o simplemente déjalo en carga (muchas veces con la depuración activa basta).

### 4. Autorizar la Computadora (Clave RSA)
1. Abre una terminal en tu ordenador.
2. Ejecuta el siguiente comando para verificar los dispositivos conectados:
   ```bash
   adb devices
   ```
3. La primera vez, el dispositivo aparecerá listado junto con la palabra `unauthorized`. Ejemplo:
   ```text
   List of devices attached
   3245239847293847    unauthorized
   ```
4. Mira la pantalla de tu smartphone. Verás un cuadro de diálogo flotante con el mensaje:
   **"¿Permitir depuración USB?"** junto con la huella digital de la clave RSA del ordenador.
5. Selecciona la casilla **"Permitir siempre desde este ordenador"** (Always allow from this computer) y pulsa en **Permitir** (Allow / OK).

### 5. Verificar que la Autorización fue Exitosa
1. En la terminal de tu ordenador, vuelve a ejecutar:
   ```bash
   adb devices
   ```
2. Ahora el estado de tu dispositivo debe haber cambiado a `device`:
   ```text
   List of devices attached
   3245239847293847    device
   ```

---

## 🛠️ Solución de Problemas Comunes

* **El dispositivo sigue apareciendo como `unauthorized` o no aparece:**
  1. Desconecta y vuelve a conectar el cable USB.
  2. Ejecuta en la terminal para reiniciar el servidor de ADB:
     ```bash
     adb kill-server
     adb start-server
     ```
  3. Desactiva y vuelve a activar la **Depuración USB** en los Ajustes de Desarrollador.
  4. En las Opciones de Desarrollador, busca y pulsa la opción **"Revocar autorizaciones de depuración USB"** y vuelve a conectar el cable para forzar a que aparezca de nuevo el mensaje de confirmación de la clave RSA.
  
* **El comando `adb` no se reconoce:**
  Asegúrate de tener instalado el SDK de Android y tener configuradas las variables de entorno, o instala las herramientas de ADB en tu sistema:
  * **Debian/Ubuntu:** `sudo apt install adb`
  * **macOS:** `brew install android-platform-tools`
  * **Windows:** Descarga las platform-tools oficiales y añádelas a tu PATH.
