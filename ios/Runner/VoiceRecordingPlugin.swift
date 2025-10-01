import Foundation
import Flutter
import AVFoundation

public class VoiceRecordingPlugin: NSObject, FlutterPlugin {
  var audioRecorder: AVAudioRecorder?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "voice_recording", binaryMessenger: registrar.messenger())
    let instance = VoiceRecordingPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "startRecording":
      guard let args = call.arguments as? [String: Any], let path = args["path"] as? String else {
        result(FlutterError(code: "INVALID_ARGS", message: "Missing path", details: nil))
        return
      }
      startRecording(at: path, result: result)
    case "stopRecording":
      stopRecording(result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func startRecording(at path: String, result: @escaping FlutterResult) {
    let url = URL(fileURLWithPath: path)

    let settings: [String: Any] = [
      AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
      AVSampleRateKey: 44100,
      AVNumberOfChannelsKey: 1,
      AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
    ]

    do {
      try AVAudioSession.sharedInstance().setCategory(.record, mode: .default)
      try AVAudioSession.sharedInstance().setActive(true)

      let directory = url.deletingLastPathComponent()
      try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)

      audioRecorder = try AVAudioRecorder(url: url, settings: settings)
      audioRecorder?.prepareToRecord()
      audioRecorder?.record()
      result("Recording started")
    } catch {
      result(FlutterError(code: "RECORDING_ERROR", message: "Failed to start recording: \(error.localizedDescription)", details: nil))
    }
  }

  private func stopRecording(result: @escaping FlutterResult) {
    guard let recorder = audioRecorder else {
      result(nil)
      return
    }
    recorder.stop()
    let path = recorder.url.path
    audioRecorder = nil
    result(path)
  }
}
