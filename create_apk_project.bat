@echo off
echo Setting up Conduit APK project structure...

REM 1. Create directories
if not exist www mkdir www
if not exist .github\workflows mkdir .github\workflows

REM 2. Move index.html into www if it's in the root
if exist index.html (
    copy /Y index.html www\index.html >nul
    echo [OK] Copied index.html to www\
)

REM 3. Generate package.json
(
echo {
echo   "name": "lv-filling-ratio",
echo   "version": "1.0.0",
echo   "description": "Conduit Filling Ratio Calculator",
echo   "scripts": {
echo     "build": "echo Assets ready"
echo   },
echo   "dependencies": {
echo     "@capacitor/android": "^6.0.0",
echo     "@capacitor/cli": "^6.0.0",
echo     "@capacitor/core": "^6.0.0"
echo   }
echo }
) > package.json
echo [OK] Created package.json

REM 4. Generate capacitor.config.json
(
echo {
echo   "appId": "com.elsewedy.conduitfill",
echo   "appName": "LV Filling Ratio",
echo   "webDir": "www",
echo   "server": {
echo     "androidScheme": "https"
echo   }
echo }
) > capacitor.config.json
echo [OK] Created capacitor.config.json

REM 5. Generate .github\workflows\build-apk.yml
(
echo name: Build Android APK
echo.
echo on:
echo   push:
echo     branches: [ main, master ]
echo   workflow_dispatch:
echo.
echo jobs:
echo   build:
echo     runs-on: ubuntu-latest
echo     steps:
echo       - name: Checkout Source Code
echo         uses: actions/checkout@v4
echo.
echo       - name: Setup Node.js
echo         uses: actions/setup-node@v4
echo         with:
echo           node-version: 20
echo.
echo       - name: Install Dependencies
echo         run: npm install
echo.
echo       - name: Setup Java JDK
echo         uses: actions/setup-java@v4
echo         with:
echo           distribution: 'zulu'
echo           java-version: '17'
echo.
echo       - name: Setup Android SDK
echo         uses: android-actions/setup-android@v3
echo.
echo       - name: Add Capacitor Android Platform ^& Sync
echo         run: ^|
echo           npx cap add android
echo           npx cap copy android
echo           npx cap sync android
echo.
echo       - name: Build Debug APK with Gradle
echo         run: ^|
echo           cd android
echo           chmod +x gradlew
echo           ./gradlew assembleDebug
echo.
echo       - name: Upload APK Artifact
echo         uses: actions/upload-artifact@v4
echo         with:
echo           name: LV_Filling_Ratio_Debug
echo           path: android/app/build/outputs/apk/debug/app-debug.apk
) > .github\workflows\build-apk.yml
echo [OK] Created GitHub Actions Workflow

echo.
echo ========================================================
echo Done! All files and folders are prepared.
echo ========================================================
pause