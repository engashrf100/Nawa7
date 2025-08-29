# 🔑 Nawa7 App Keystore Setup

## Overview
This document explains the Android signing configuration for the Nawa7 healthcare consultation app.

## 📁 Files Created

### 1. Keystore File
- **File**: `nawa7.keystore`
- **Location**: Project root directory
- **Type**: RSA 2048-bit keystore
- **Validity**: 10,000 days (~27 years)

### 2. Keystore Properties
- **File**: `android/key.properties`
- **Purpose**: Stores keystore configuration for Gradle

### 3. Build Configuration
- **File**: `android/app/build.gradle.kts`
- **Purpose**: Configures Android signing for release builds

## 🔐 Keystore Details

- **Alias**: `nawa7`
- **Password**: `ashrf123`
- **Key Password**: `ashrf123`
- **Algorithm**: RSA 2048-bit
- **Certificate**: Self-signed SHA384withRSA

## 🚀 CodeMagic CI/CD Integration

The `codemagic.yaml` file is configured to:
1. Automatically set up the keystore during CI/CD builds
2. Use the keystore for signing release APKs
3. Store keystore credentials as environment variables

## ⚠️ Important Security Notes

1. **Keep the keystore secure** - This is your app's identity
2. **Backup the keystore** - You cannot update your app without it
3. **Store passwords safely** - Use environment variables in production
4. **Never commit keystore to public repositories**

## 📱 Building Signed APK

### Local Build
```bash
# Build release APK with signing
flutter build apk --release
```

### CodeMagic Build
- Automatic signing during CI/CD
- Release APK will be signed with this keystore
- Build artifacts include signed APK files

## 🔄 Updating Keystore

If you need to change the keystore:
1. Generate new keystore using keytool
2. Update `android/key.properties`
3. Update CodeMagic environment variables
4. Test build process

## 📋 Troubleshooting

### Common Issues
1. **Keystore not found**: Check path in `key.properties`
2. **Password mismatch**: Verify passwords in `key.properties`
3. **Signing failed**: Ensure keystore file exists and is readable

### Verification
```bash
# Verify keystore contents
keytool -list -v -keystore nawa7.keystore
```

## 📞 Support
For keystore-related issues, refer to:
- [Android Developer Documentation](https://developer.android.com/studio/publish/app-signing)
- [Flutter Signing Guide](https://flutter.dev/docs/deployment/android#signing-the-app)
