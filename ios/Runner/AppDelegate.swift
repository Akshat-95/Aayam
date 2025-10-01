import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // Register the local VoiceRecordingPlugin implemented in VoiceRecordingPlugin.swift
    VoiceRecordingPlugin.register(with: self.registrar(forPlugin: "VoiceRecordingPlugin")!)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
