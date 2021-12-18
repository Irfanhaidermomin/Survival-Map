import UIKit
import Flutter
import GoogleMaps
  
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    //Add your Google Maps API Key here
    GMSServices.provideAPIKey("AIzaSyAvLRrdtuA5o6NuyHI5KoLa1584YolTLkY")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}