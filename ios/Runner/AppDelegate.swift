// import UIKit
// import Firebase

// @UIApplicationMain
// class AppDelegate: UIResponder, UIApplicationDelegate {

//   var window: UIWindow?

//   func application(_ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions:
//       [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//     FirebaseApp.configure()
//     return true
//   }
// }


import UIKit
import Flutter
import Firebase
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyC-zg58w1ZPlTmmqRVlGihyDDj1RmHLCSk")
    GeneratedPluginRegistrant.register(with: self)
    //FirebaseApp.configure()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

