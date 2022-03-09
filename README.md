Voip_calling_iphone is an open source softphone for voice over IP calling. It is fully SIP-based, for all calling. General description is available from linphone web site
License
Copyright © Bueno Technologies Inc.
Voip_calling_iphone is licensed, and is available :
	•	under a GNU/GPLv3 license, for free (open source). Please make sure that you understand and agree with the terms of this license before using it (see LICENSE file for details).

	
How can I contribute?
Thanks for asking! We love pull requests from everyone. Depending on what you want to do, you can help us improve Voip_calling_iphone in various ways:
Report bugs and submit patchs
If you want to dig through Voip_calling_iphone code or report a bug, please read CONTRIBUTING.md first. You should also read this README entirely ;-).

Building the application
What's new
Now the default way of building linphone-iphone is to use CocoaPods to retrieve the linphone-sdk frameworks. Compared to previous versions, this project no longer uses submodules developper has to build in order to get a working app. However, if you wish to use a locally compiled SDK, read paragraph "Using a local linphone SDK" below to know how to proceed.

Using a local voip_calling_ios SDK
	•	Clone the Voip_calling_iphone repository from our git project:
   git clone https://github.com/priyankavachhani/voip_calling_iphone.git --recursive
	•	Rebuild the project: 
Enabling crashlytics
We've integrated Crashlytics into Voip_calling_iphone, which can automatically send crash reports. It is disabled by default. To activate it:
	•	Replace the GoogleService-Info.plist for this project with yours (specific to your crashlytics account).
	•	Rebuild the project:
    USE_CRASHLYTICS=true pod install
	•	Then open linphone.xcworkspace with Xcode to build and run the app.

Quick UI reference
	•	The app is contained in a window, which resides in the MainStoryboard file.
	•	“LoginViewController” is a login view class where user can add their sip credentials to register the endpoints.
	•	After registering endpoint successfully there is “Dialer” screen from where user can dial the number and initiate call.
	•	In calling screen there is a basic functions like hold, mute, speaker and IVR.
