# voip_calling_iphone

Voip_calling_iphone is an open source softphone for voice over IP calling. It is fully SIP-based, for all calling. General description is available from linphone web site

**License**

Copyright © Bueno Technologies Inc.

Voip_calling_iphone is licensed, and is available :

- under a GNU/GPLv3 license, for free (open source). Please make sure that you understand and agree with the terms of this license before using it (see LICENSE file for details).
- under a proprietary license, for a fee, to be used in closed source applications. Contact Belledonne Communications for any question about costs and services.
	
 
**Building the application**

You can clone the project and use as below

**Using a local voip_calling_ios SDK**

 Clone the Voip_calling_iphone repository from our git project
  
  - git clone https://github.com/priyankavachhani/voip_calling_iphone.git --recursive
   
 Rebuild the project: 
  
  
**Enabling crashlytics**

We've integrated Crashlytics into Voip_calling_iphone, which can automatically send crash reports. It is disabled by default. To activate it:

-	Replace the GoogleService-Info.plist for this project with yours (specific to your crashlytics account).
-	Rebuild the project:
    USE_CRASHLYTICS=true pod install
-	Then open linphone.xcworkspace with Xcode to build and run the app.

 **Quick UI reference**
 
-	The app is contained in a window, which resides in the MainStoryboard file.
-	“LoginViewController” is a login view class where user can add their sip credentials to register the endpoints.
-	After registering endpoint successfully there is “Dialer” screen from where user can dial the number and initiate call.
-	In calling screen there is a basic functions like hold, mute, speaker and IVR.

**Documentation**

Please check below document for detailed app flow
	- https://docs.google.com/document/d/15AJlwUH2ZMbFxaqJO5UqP8suuVEMsS9MsC5NRvk7UwA/edit?usp=sharing

