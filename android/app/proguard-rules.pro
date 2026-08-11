# Flutter Standard Rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class com.example.zold_gold.GeneratedPluginRegistrant { *; }

# Razorpay Rules (Critical for Payment UI)
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes SourceFile,LineNumberTable
-keep class com.razorpay.** {*;}
-dontwarn com.razorpay.**
-keep class com.google.android.gms.wallet.** {*;}
-keep class com.google.android.gms.internal.** {*;}

# Flutter Secure Storage (Critical for Token Persistence)
-keep class com.it_is_not_a_bug.flutter_secure_storage.** { *; }

# Dio and JSON Rules (Keep all models for manual parsing)
-keep class com.example.zold_gold.app.data.models.** { *; }

# Socket.IO Rules
-keep class io.socket.** { *; }
-keep class okhttp3.** { *; }
-dontwarn io.socket.**
-dontwarn okhttp3.**

# Flutter Play Core (Ignore missing classes for deferred components)
# This fixes the R8 error: "Missing class com.google.android.play.core..."
-dontwarn com.google.android.play.core.**
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**

# AndroidX and General Build Stability
-dontwarn android.support.**
-dontwarn androidx.**

# Keep generic types and annotations for GetX and other reflectable-like behaviors
-keepattributes *Annotation*, Signature, InnerClasses

# Google Fonts
-keep class com.google.fonts.** { *; }

# Shared Preferences
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# Image Picker
-keep class io.flutter.plugins.imagepicker.** { *; }

