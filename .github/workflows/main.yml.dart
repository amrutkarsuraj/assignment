name: Flutter CI/CD

on:
push:
branches:
- main

permissions:
contents: write

jobs:
build:
runs-on: ubuntu-latest

steps:
# 1️⃣ Checkout code
- name: Checkout repository
uses: actions/checkout@v4

# 2️⃣ Setup Java (required for Android build)
- name: Setup Java
uses: actions/setup-java@v4
with:
distribution: 'temurin'
java-version: '17'

# 3️⃣ Setup Flutter (match your local version)
- name: Setup Flutter
uses: subosito/flutter-action@v2
with:
flutter-version: '3.41.2'
cache: true

# 4️⃣ Verify Flutter
- name: Flutter Doctor
run: flutter doctor -v

# 5️⃣ Install dependencies
- name: Install dependencies
run: flutter pub get

# 6️⃣ Analyze code
- name: Run analyzer
run: flutter analyze

# 7️⃣ Run tests
- name: Run tests
run: flutter test

# 8️⃣ Build release APK
- name: Build APK
run: flutter build apk --release

# 9️⃣ Upload artifact (optional)
- name: Upload APK artifact
uses: actions/upload-artifact@v4
with:
name: release-apk
path: build/app/outputs/flutter-apk/app-release.apk

# 🔟 Create GitHub Release + upload APK
- name: Create Release
uses: softprops/action-gh-release@v1
with:
tag_name: v1.${{ github.run_number }}
name: Release v1.${{ github.run_number }}
files: build/app/outputs/flutter-apk/app-release.apk
env:
GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}