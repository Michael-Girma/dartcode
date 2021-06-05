
# A Father's Blessing App
## Getting Started

### Installing the flutter Sdk
[Download](https://storage.googleapis.com/flutter_infra/releases/stable/macos/flutter_macos_2.0.5-stable.zip) the installation bundle to get the latest stable release of the flutter sdk.
For other channels and older builds see the SDK releases page

extract the file in the desired location, for example
```
$ cd ~/development
$ unzip ~/Downloads/flutter_macos_2.0.5-stable.zip
```


Add the flutter toold to your path:
```
$ export PATH="$PATH:`pwd`/flutter/bin"
```

#### Run flutter doctor
Run the following command to see if there are any dependencies you need to install to complete the setup
```
$ flutter doctor
```


### iOS setup
To develop flutter apps for iOS, you need a Mac with XCode installed
1. Install the latest stable version of XCode (using [web](https://developer.apple.com/xcode/) ord Mac App Store)
2. Configure the XCode command-line tools to use the newly-installed version of Xcode by running the following from the 
command line:

```
$ sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
$ sudo xcodebuild -runFirstLaunch

```

3. Make sure the Xcode license agreement is signed by either opening Xcode once and confirming or running 
```
sudo xcodebuild -license
```
from the command line.

Setting up an iOS simulator
To prepare to run and test your flutter app on the iOS simulator, follow these steps:

1. Find the simulator vai Spotlight or by using the following command:
```
$ open -a Simulator
```

2. Make sure your simulator is using a 64-bit device (iPhone 5s or later) by checking the settings in the simulator’s Hardware > Device menu.

3. Depending on your development machine’s screen size, simulated high-screen-density iOS devices might overflow your screen. Grab the corner of the simulator and drag it to change the scale. You can also use the Window > Physical Size or Window > Pixel Accurate options if your computer’s resolution is high enough.
If you are using a version of Xcode older than 9.1, you should instead set the device scale in the Window > Scale menu.

### Building the project

cd into the A_fathers_blessing_app directory and run the following command in the terminal
```
flutter pub get
```
This command shall fetch all dependencies of the app that are specified in the pubspec.yaml file

## Generating APK
After building, run the following command to get a release build for android.
```
flutter run --release
```
This should generate a build apk usually located in project_dir/build/app/outputs/flutter-apk/app-release.apk


## Generating IPA
Instead of wording it our short, a [good article](https://flutteragency.com/how-to-get-apk-and-ipa-file-from-flutter/) here briefly explains a straight-forward method to generate an ipa


