# 42 Mobile Piscine

Welcome to the Mobile Piscine project repository. Below, you will find the fundamental commands for creating and running Flutter applications.

---

## 🚀 Key Steps

### 1. Create a New Project
To initialize a Flutter project from scratch, run in your terminal:
```bash
flutter create project_name
```
Then, navigate into the generated directory to start working:
```bash
cd project_name
```

---

## 📱 Execution Modes

Flutter allows you to test your application on different platforms. Always ensure you are inside your project's directory (e.g., `cd ex00`) before running these commands.

### 🌐 1. Running on Google Chrome
This is the fastest and easiest way to test your application on your computer while developing (supports *Hot Reload*).
```bash
flutter run -d chrome
```

### 📱 2. Running on a Physical Smartphone
To install and run the application directly on your mobile device via a USB cable:

1. **Enable USB Debugging on your device**:
   Follow the detailed guide below to authorize your smartphone.
2. **List available devices**:
   Run the following command to confirm the computer recognizes your device and to find its `ID`:
   ```bash
   flutter devices
   ```
3. **Run the application**:
   Execute the app by specifying the desired device ID:
   ```bash
   flutter run -d <device_ID>
   ```
   *(Note: If your phone is the only connected device and there are no active emulators, you can usually just run `flutter run`).*

### 💻 3. Running on a Local Web Server
If you need to run the application on a local web server without automatically launching a browser (e.g., to allow other devices on the same network to access it):
```bash
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080
```

---

## 🔒 Guide: How to Authorize your Smartphone via USB Debugging

To run and debug apps directly on your physical smartphone, you need to enable and authorize **USB Debugging**. Follow these steps:

### Step 1: Enable Developer Options
1. Open **Settings** on your smartphone.
2. Scroll down and select **About phone** (or *About device* / *Software info*).
3. Find the **Build number**.
   > [!NOTE]
   > On some devices (like Xiaomi/MIUI), this might be named *MIUI version* or located under *Software information*.
4. Tap the **Build number 7 times** consecutively. You will see a notification saying *"You are now a developer!"*.

### Step 2: Enable USB Debugging
1. Go back to the main **Settings** menu.
2. Navigate to **System** -> **Developer options** (or search for *"Developer options"* directly in the Settings search bar).
3. Find **USB debugging** and toggle it on.
4. Confirm any security warnings that appear.

### Step 3: Connect your Phone to the Computer
1. Connect your smartphone to the computer using a high-quality **USB data cable** (ensure it supports data transfer, not just charging).
2. If prompted on your phone, choose **File Transfer (MTP)** or leave it on charge mode.

### Step 4: Authorize the Computer (RSA Key Fingerprint)
1. Open a terminal on your computer.
2. Run the following command to list connected devices:
   ```bash
   adb devices
   ```
3. The first time, your device will be listed as `unauthorized`. Example:
   ```text
   List of devices attached
   3245239847293847    unauthorized
   ```
4. Check your phone's screen. A dialog box will appear asking: **"Allow USB debugging?"** along with the computer's RSA key fingerprint.
5. Check the box **"Always allow from this computer"** and tap **Allow** (or *OK*).

### Step 5: Verify the Authorization
1. In your computer's terminal, run `adb devices` again:
   ```bash
   adb devices
   ```
2. Your device status should now be `device`:
   ```text
   List of devices attached
   3245239847293847    device
   ```

---

## 🛠️ Troubleshooting

If your device is still `unauthorized` or not detected:

1. **Re-plug the USB cable** or try a different port/cable.
2. **Restart the ADB server** by running:
   ```bash
   adb kill-server
   adb start-server
   ```
3. **Revoke USB debugging authorizations** in your phone's *Developer options*, unplug the cable, and plug it back in to trigger the RSA prompt again.
4. **Clean old keys** (if you have authentication issues):
   ```bash
   rm ~/.android/adbkey
   rm ~/.android/adbkey.pub
   adb kill-server
   adb start-server
   ```
5. **Install ADB tools** (if the `adb` command is not found):
   * **Debian/Ubuntu**: `sudo apt install adb`
   * **macOS**: `brew install android-platform-tools`
   * **Windows**: Download the official platform-tools and add them to your PATH.
