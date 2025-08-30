# Razorpay SDK
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Required for annotations used in the SDK
-keep class proguard.annotation.Keep
-keep @interface proguard.annotation.Keep
-keepclasseswithmembers class * {
    @proguard.annotation.Keep <methods>;
    @proguard.annotation.Keep <fields>;
}

# Firebase Crashlytics
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception
-keep class com.google.firebase.crashlytics.** { *; }
-dontwarn com.google.firebase.crashlytics.**

# Flutter specific
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }


