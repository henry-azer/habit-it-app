# Habit It App
A habit tracker flutter project, built using clean architecture software techniques.


## Google Drive URL
(APK) https://drive.google.com/file/d/1ETv7WnpfP4klRQCV9S2rRqwsDX-WJTKY/view

## App Screenshots
### Splash and Onboarding
<img src="https://github.com/henry-azer/habit-it-app/blob/master/assets/images/github/splash_1.png?raw=true" alt="Image description" width="220"/>   <br/><img src="https://github.com/henry-azer/habit-it-app/blob/master/assets/images/github/onboarding_1.png?raw=true" alt="Image description" width="220"/>   <img src="https://github.com/henry-azer/habit-it-app/blob/master/assets/images/github/onboarding_2.png?raw=true" alt="Image description" width="220"/>   <img src="https://github.com/henry-azer/habit-it-app/blob/master/assets/images/github/onboarding_3.png?raw=true" alt="Image description" width="220"/>

### Signup Journey
<img src="https://github.com/henry-azer/habit-it-app/blob/master/assets/images/github/signup_1.png?raw=true" alt="Image description" width="220"/>   <img src="https://github.com/henry-azer/habit-it-app/blob/master/assets/images/github/signup_2.png?raw=true" alt="Image description" width="220"/>   <img src="https://github.com/henry-azer/habit-it-app/blob/master/assets/images/github/signup_3.png?raw=true" alt="Image description" width="220"/>   

### Welcome to our world
<img src="https://github.com/henry-azer/habit-it-app/blob/master/assets/images/github/signup_4.png?raw=true" alt="Image description" width="220"/>

### Signin Journey
<img src="https://github.com/henry-azer/habit-it-app/blob/master/assets/images/github/signin_1.png?raw=true" alt="Image description" width="220"/>   <img src="https://github.com/henry-azer/habit-it-app/blob/master/assets/images/github/signin_2.png?raw=true" alt="Image description" width="220"/>

### Habit It Home
<img src="https://github.com/henry-azer/habit-it-app/blob/master/assets/images/github/home_1.png?raw=true" alt="Image description" width="220"/>   <img src="https://github.com/henry-azer/habit-it-app/blob/master/assets/images/github/home_2.png?raw=true" alt="Image description" width="220"/>   <br/><img src="https://github.com/henry-azer/habit-it-app/blob/master/assets/images/github/home_5.png?raw=true" alt="Image description" width="220"/>   <img src="https://github.com/henry-azer/habit-it-app/blob/master/assets/images/github/home_4.png?raw=true" alt="Image description" width="220"/>

### Habit It Profile
<img src="https://github.com/henry-azer/habit-it-app/blob/master/assets/images/github/profile_1.png?raw=true" alt="Image description" width="220"/>   <img src="https://github.com/henry-azer/habit-it-app/blob/master/assets/images/github/update_profile_1.png?raw=true" alt="Image description" width="220"/>   <img src="https://github.com/henry-azer/habit-it-app/blob/master/assets/images/github/about_us_1.png?raw=true" alt="Image description" width="220"/>

### Habits Progress and Stats
<img src="https://github.com/henry-azer/habit-it-app/blob/master/assets/images/github/progress_1.png?raw=true" alt="Image description" width="220"/>   <br/><img src="https://github.com/henry-azer/habit-it-app/blob/master/assets/images/github/progress_2.png?raw=true" alt="Image description"/>


## Getting Started
Habit It is your go-to mobile companion for cultivating a healthier and more productive lifestyle. This innovative Flutter-based application empowers you to take control of your daily routines, monitor your progress, and make positive changes in your life. With a seamless user experience, local authentication options, and robust user profile management, Habit It is your trusted partner on your journey towards self-improvement.


## How to Use
Certainly! To run the Habit It app, you will need to follow a few steps:
- Download and install Android Studio on your computer.
- Download or clone [Habit It App](https://github.com/henry-azer/habit-it-app) repository by using the link below:
```
git clone https://github.com/henry-azer/habit-it-app
```
- Open Android Studio and select "Open an existing Android Studio project" from the welcome screen.
- Navigate to the directory where you cloned the Habit It app repository and select the project folder.
- Go to the project root and execute the following command in the console to get the required dependencies:
```
flutter pub get
```
- Once the project has finished loading, you can either connect your Android device to your computer using a USB cable or create an emulator in Android Studio.
- If you're using a physical device, make sure to enable USB debugging mode on your phone by going to "Developer options" in your phone's settings and toggling the "USB debugging" option.
- Select the device you want to run the app on by clicking on the device dropdown menu in Android Studio.
- Finally, Run the app.
```
flutter run
```

By following these steps, you should be able to run the Habit It app on your Android device or emulator without any issues. However, keep in mind that the exact process may vary depending on your specific setup and the version of Android Studio you are using.


## Project Structure
```
├──  android - This folder contains the main Android application code with the Gradle wrapper file.
|    └── app/
|    └── gradle/wrapper/
│    
│
├──  assets - This folder contains the resources used in the app.
│    
│
├──  ios - This folder contains the Flutter engine code for the app on iOS.
│    └── Flutter/
|    └── Runner/
│    
|
├──  lib - This folder contains the Dart source code for the app's user interface and business logic.
│    └── config/
|    └── core/
|    └── data/
|    └── features/
|    └── app.dart
|    └── injection_container.dart
|    └── main.dart
│
│
├──  test - The "test" folder in a Flutter project contains the test code for the app.
     └── widget_test.dart
```


## Features
Here is a summary of the features Habit It provides:
- Habit Tracking: Create and track your daily, weekly, or custom habits effortlessly.
- Progress Monitoring: Visualize your habit streaks and progress over time with charts and statistics.
- Local Authentication: Secure your personal habit data with biometric fingerprint or PIN-based authentication.
- User Profiles: Personalize your experience with user profiles, including profile settings.
- Flexible Habit Types: Define various habit types to suit your needs, whether it's daily routines or weekly goals.
- Customizable Habit Descriptions: Add detailed descriptions and notes to each habit for better tracking and understanding.
- Offline Access: Use Habit It even without an internet connection, ensuring you can track your habits anytime, anywhere.
- Data Insights: Gain insights into your habits and patterns to identify areas for improvement.
- Dark Mode: Enjoy a comfortable viewing experience in low-light conditions with a dark mode option.
- Intuitive User Interface: Navigate the app effortlessly with a user-friendly and aesthetically pleasing interface.


## Technologies
- Get It
- Dependency Injection
- Clean Architecture
- Validation and Logging
- Local Authentication
- Local Storage
- Month Picker
- AppBar Calendar
- localization
- Permission Handler
- Shared Preferences

Developed by [@henry-azer](https://github.com/henry-azer)
