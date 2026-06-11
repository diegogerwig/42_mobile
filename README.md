# 42 Mobile Piscine

Bienvenido al repositorio de proyectos de la Mobile Piscine. A continuación, se detallan los comandos fundamentales para la creación y ejecución de aplicaciones en Flutter.

---

## 🚀 Pasos Fundamentales

### 1. Crear un proyecto nuevo
Para inicializar un proyecto de Flutter desde cero, ejecuta en tu terminal:
```bash
flutter create nombre_del_proyecto
```
Luego, entra en el directorio generado para poder trabajar en él:
```bash
cd nombre_del_proyecto
```

---

## 📱 Modos de Ejecución

Flutter permite probar la aplicación en diferentes plataformas. Asegúrate siempre de estar dentro del directorio de tu proyecto (ej: `cd ex00`) antes de ejecutar estos comandos.

### 🌐 1. Ejecución en Google Chrome
Es la forma más rápida y sencilla de probar la aplicación en el ordenador mientras desarrollas (soporta *Hot Reload* o recarga en caliente).
```bash
flutter run -d chrome
```

### 📱 2. Ejecución en un Smartphone físico
Para instalar y correr la aplicación directamente en tu dispositivo móvil mediante cable USB:

1. Asegúrate de tener habilitadas las **Opciones de desarrollador** y la **Depuración por USB** en los ajustes de tu smartphone.
2. Conecta el dispositivo a tu ordenador por USB (y acepta el mensaje de "Permitir depuración" en la pantalla de tu móvil).
3. Lista los dispositivos disponibles para confirmar que el ordenador lo reconoce y encontrar su `ID`:
   ```bash
   flutter devices
   ```

rm ~/.android/adbkey
rm ~/.android/adbkey.pub
adb kill-server
adb start-server


4. Ejecuta la app indicando el dispositivo deseado:
   ```bash
   flutter run -d <ID_del_dispositivo>
   ```
   *(Nota: Si solo tienes tu móvil conectado y no hay emuladores abiertos, a veces basta con escribir `flutter run`).*

### 💻 3. Ejecución en Terminal (Web Server local)
Si por algún motivo necesitas correr la aplicación en un servidor web local sin abrir automáticamente un navegador (por ejemplo, para que otro equipo en tu misma red pueda acceder):
```bash
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
```
