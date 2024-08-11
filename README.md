# studentPortal_iOS



## Installation
To install and run the Student Portal iOS app:

1. Unzip the project folder and open the terminal.


2. Navigate to the project directory:


3. Open the project in Xcode:
   

4. Add Firebase SDK (steps shown below)


5. Follow the Xcode installation guide

   [Installing Xcode and Simulators](https://developer.apple.com/documentation/safari-developer-tools/installing-xcode-and-simulators)


6. Build and run the app on a simulator or connected device.

###  Add Firebase SDK

To integrate Firebase into your iOS app, follow these steps to install and manage Firebase dependencies using Swift Package Manager.

#### 1. Open Your Xcode Project
- With your app project open in Xcode, navigate to `File > Add Packages`.

#### 2. Add Firebase iOS SDK Repository
- When prompted, enter the Firebase iOS SDK repository URL:     
  [Firebase iOS SDK repository](https://github.com/firebase/firebase-ios-sdk)
- Select the SDK version that you want to use.
- **Note:** We recommend using the default (latest) SDK version, but you can use an older version if needed.

#### 3. Choose Firebase Libraries
- Choose the Firebase libraries that you want to use in your project.
- **Important:** Make sure to add `FirebaseAnalytics`.
- For Analytics without IDFA collection capability, add `FirebaseAnalyticsWithoutAdId` instead.

#### 4. Finish Setup
- After selecting the desired libraries, click `Finish`.
- Xcode will automatically begin resolving and downloading your dependencies in the background.
