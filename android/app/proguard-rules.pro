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
