<p align="center">
  <img src="https://raw.githubusercontent.com/pmusolino/Wormholy/master/logo.png" alt="Icon"/>
</p>

  [![Pod version](https://img.shields.io/cocoapods/v/Wormholy.svg?style=flat)](https://cocoapods.org/pods/Wormholy)
  
  Start debugging iOS network calls like a wizard, without extra code! Wormholy makes debugging quick and reliable.
  
  
  **What you can do:**
  
  - [x] No code to write and no imports.
  - [x] Record all app traffic that uses `NSURLSession`.
  - [x] Reveal the content of all requests, responses, and headers simply by shaking your phone!
  - [x] No headaches with SSL certificates on HTTPS calls.
  - [x] Find, isolate and fix bugs quickly.
  - [x] Swift & Objective-C compatibility.
  - [x] Also works with external libraries like `Alamofire` & `AFNetworking`.
  - [x] Ability to blacklist hosts from being recorded using the array `ignoredHosts`.
  - [x] Ability to share cURL rappresentation of API requests
  
<p align="center">
<img src="https://raw.githubusercontent.com/pmusolino/Wormholy/master/screens.png" alt="Icon"/>
</p>
  
## Requirements
----------------

- iOS 9.0+
- Xcode 10+


## Usage
----------------
Add it to your project, and that's all! **Shake your device** or your simulator and Wormholy will appear! You don't need to import the library into your code, it works magically!

I suggest you install it only in debug mode. The easiest way is with CocoaPods:

```
pod 'WormholyForObjectiveC', :configurations => ['Debug']
``` 


If you want to disable the shake, and fire Wormholy from another point inside your app, you need to set the [environment variable](https://medium.com/@derrickho_28266/xcode-custom-environment-variables-681b5b8674ec) `WORMHOLY_SHAKE_ENABLED` = `NO`, and call this local notification:

```
[[NSNotificationCenter defaultCenter] postNotificationName:@"wormholy_fire" object:nil];
```

You can also programmatically enable/disable the shake gesture at any time. You can do `WHWormholy.shakeEnabled = NO` to disable (or enable) the shake gesture. 


## MIT License
----------------
Wormholy is available under the MIT license. See the LICENSE file for more info.
