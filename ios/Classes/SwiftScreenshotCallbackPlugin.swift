import Flutter
import UIKit

public class SwiftScreenshotCallbackPlugin: NSObject, FlutterPlugin {
  static var channel: FlutterMethodChannel?
    
  static var observer: NSObjectProtocol?;
    

  public static func register(with registrar: FlutterPluginRegistrar) {
    channel  = FlutterMethodChannel(name: "flutter.moum/screenshot_callback", binaryMessenger: registrar.messenger())
    observer = nil;
    let instance = SwiftScreenshotCallbackPlugin()
    if let channel = channel {
      registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    func applicationUserDidTakeScreenshot(Notification: Notification) {
        if let channel = SwiftScreenshotCallbackPlugin.channel {
            channel.invokeMethod("onCallback", arguments: nil)
          }

          result("screen shot called")
    }
    
    if(call.method == "initialize"){
        if(SwiftScreenshotCallbackPlugin.observer != nil) {
            NotificationCenter.default.removeObserver(SwiftScreenshotCallbackPlugin.observer!);
            SwiftScreenshotCallbackPlugin.observer = nil;
        }
        SwiftScreenshotCallbackPlugin.observer = NotificationCenter.default.addObserver(
          forName: NSNotification.Name.UIApplicationUserDidTakeScreenshot,
          object: nil,
          queue: .main,
          using: applicationUserDidTakeScreenshot) 
      result("initialize")
    }else if(call.method == "dispose"){
        if(SwiftScreenshotCallbackPlugin.observer != nil) {
            NotificationCenter.default.removeObserver(SwiftScreenshotCallbackPlugin.observer!);
            SwiftScreenshotCallbackPlugin.observer = nil;
        }
        result("dispose")
    }else{
      result("")
    }
  }
    
    deinit {
        if(SwiftScreenshotCallbackPlugin.observer != nil) {
            NotificationCenter.default.removeObserver(SwiftScreenshotCallbackPlugin.observer!);
            SwiftScreenshotCallbackPlugin.observer = nil;
        }
    }
}
