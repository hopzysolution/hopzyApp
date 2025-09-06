# Razorpay SDK
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Keep Firebase Crashlytics
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**    

# Required for annotations used in the SDK
-keep class proguard.annotation.Keep
-keep @interface proguard.annotation.Keep
-keepclasseswithmembers class * {
    @proguard.annotation.Keep <methods>;
    @proguard.annotation.Keep <fields>;
}

# Flutter specific
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }


