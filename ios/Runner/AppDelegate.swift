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
    GeneratedPluginRegistrant.register(with: self)
    FirebaseApp.configure()
    GMSServices.provideAPIKey("AIzaSyButxchG6XuHfgqQFU5GFchdj5kULZ-_ig")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
