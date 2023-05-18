import UIKit
import Flutter
import GoogleMaps
import FirebaseCore

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    FirebaseApp.configure()
    GMSServices.provideAPIKey("AIzaSyCMysLPZT6Ah-WNgDhFtZ1ZI8z7z3UhkSg")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
