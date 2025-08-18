# Flutter ProGuard Rules for Release Build
# This file contains rules for code obfuscation and optimization

# Keep Flutter framework classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep native methods
-keepclassmembers class * {
    native <methods>;
}

# Keep Parcelable implementations
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Keep Serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Keep R classes
-keep class **.R$* {
    public static <fields>;
}

# Keep custom models and data classes
-keep class com.example.nawah.features.**.model.** { *; }
-keep class com.example.nawah.features.**.data.** { *; }

# Keep API service classes
-keep class com.example.nawah.core.network.** { *; }

# Keep repository implementations
-keep class com.example.nawah.features.**.repositories.** { *; }

# Keep cubit/bloc classes
-keep class com.example.nawah.features.**.cubits.** { *; }

# Keep utility and helper classes
-keep class com.example.nawah.core.** { *; }

# Keep JSON serialization
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep Retrofit annotations
-keepattributes *Annotation*
-keep class retrofit2.** { *; }
-keepattributes Signature
-keepattributes Exceptions

# Keep Dio HTTP client
-keep class io.flutter.plugins.** { *; }
-keep class com.example.nawah.core.network.api_service.** { *; }

# Keep secure storage
-keep class com.example.nawah.core.services.** { *; }

# General optimization rules
-optimizations !code/simplification/arithmetic,!code/simplification/cast,!field/*,!class/merging/*
-optimizationpasses 5
-allowaccessmodification

# Remove logging in release
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}

# Keep native libraries
-keep class **.R$* {
    public static <fields>;
}

# Keep custom fonts
-keep class com.example.nawah.core.const.app_assets { *; }

# Keep localization
-keep class com.example.nawah.core.** { *; }

# Keep image assets
-keep class com.example.nawah.core.const.** { *; }

# --- Google Play Core (SplitInstall / Deferred Components) ---
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**