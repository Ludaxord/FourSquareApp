# FourSquareApp
This solution contains 2 applications: one for iOS, second for Android. 
It was created with usage of native technologies (Swift, Kotlin).
Application fetch data from foursquare.com. Data contains places near user location and also places that user type into input
## applications contains:

* RestFul Connection with foursquare.com API
* Present data in listview/tableview to user
* Fetch data base on user localisation
* Fetch data base on what user type into edittext/textfield
* click on cell in ListView/TableView opens map with marker

## TODO:
* correct lag when scrolling tableView (iOS)
* lag when loading items into Adapter in ListView (Android)
* test google maps (Android)
* Optimalisation

## How to run:

* Android:
1. Open Project FourSquareAppAndroid in Android Studio.
2. Click Run.

* iOS: 
1. Open Project FourSquareAppIOS in xCode.
2. Open Directory FourSquareAppIOS in Terminal.
3. Type Pod Install.
4. When all dependencies will be installed Click Run in xCode.

## Important note:

* Android

To test all features please add ClientID and ClientSecret in `MainActivity` in  `onCreate` method 
Just change `<YOUR_CLIENT_ID>` and `<YOUR_CLIENT_SECRET>` to your own ClientID and ClientSecret, like in example below:
```
        userSettings.setPreferences("clientId", "<YOUR_CLIENT_ID>")
        userSettings.setPreferences("clientSecret", "<YOUR_CLIENT_SECRET>")
```
Also to test Google Maps please provide google maps api key that is in `res/values/google_maps_api.xml`
Add api key from google console in place of `YOUR_KEY_HERE` like in example below:
```
<string name="google_maps_key" templateMergeStrategy="preserve" translatable="false">YOUR_KEY_HERE</string>
```
* IOS

To test all features please add ClientID and ClientSecret in `ViewController` in  `loadView` method 
Just change `<YOUR_CLIENT_ID>` and `<YOUR_CLIENT_SECRET>` to your own ClientID and ClientSecret, like in example below:
```
settings.setPreferences(key: "clientId", value: "<YOUR_CLIENT_ID>")
settings.setPreferences(key: "clientSecret", value: "<YOUR_CLIENT_SECRET>")
```

