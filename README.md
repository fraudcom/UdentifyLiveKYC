# UdentifyLiveKYC SDK

UdentifyLiveKYC runs Udentify identity-verification steps inside a live video KYC call. While the customer is on a Udentify Video Call, the agent starts each step from the agent dashboard, and the SDK opens the module screen, runs the step and uploads the result. Your app needs no screens or flow logic of its own.

## 🚀 Features
- Agent-driven OCR, NFC, face recognition with liveness, and hologram checks during a video call
- Modules are optional: the SDK detects at runtime which module frameworks your app embeds
- Three observation modes for the agent: camera feed, screen share, or progress only
- Optional typed events and step results for your own UI

## 📋 Requirements
- iOS 13.0+
- A working [UdentifyVC](https://github.com/fraudcom/UdentifyVC) video call integration
- UdentifyVC and UdentifyCommons from the same release as UdentifyLiveKYC

## 📦 Installation

LiveKYC needs UdentifyVC and UdentifyCommons. The OCR, FACE and NFC modules are optional: add only the ones you want the agent to be able to start.

| Package / Framework | Required | Enables |
|---|---|---|
| UdentifyLiveKYC | Yes | LiveKYC |
| [UdentifyVC](https://github.com/fraudcom/UdentifyVC) | Yes | The video call |
| [UdentifyCommons](https://github.com/fraudcom/UdentifyCommons) | Yes | Shared base SDK |
| [UdentifyOCR](https://github.com/fraudcom/UdentifyOCR) | Optional | OCR, hologram, document liveness |
| [UdentifyFACE](https://github.com/fraudcom/UdentifyFACE) | Optional | Face recognition and liveness |
| [UdentifyNFC](https://github.com/fraudcom/UdentifyNFC) | Optional | NFC chip reading |

> [!IMPORTANT]
> Use the same release for every Udentify package or framework. Mixing releases makes the app fail at launch.

### Swift Package Manager (SPM)
You can install UdentifyLiveKYC via Swift Package Manager by adding the following dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/fraudcom/UdentifyLiveKYC.git", exact: "x.y.z")
]
```

Or in Xcode:
1. Go to **File > Add Package Dependencies**.
2. Enter the repository URL: `https://github.com/fraudcom/UdentifyLiveKYC.git`.
3. Select **Exact Version**, enter the release and add the package.

Add UdentifyVC, UdentifyCommons and the modules you need the same way, at the same version.

### Manual (xcframework)
1. Drag `UdentifyLiveKYC.xcframework`, `UdentifyVC.xcframework`, `UdentifyCommons.xcframework` and the module frameworks you need into your project.
2. Set each one to **Embed & Sign** under **Targets > General > Frameworks, Libraries, and Embedded Content**.
3. If you add `UdentifyFACE.xcframework`, add `Lottie.xcframework` too. Without it the app crashes at launch.
4. Go to **File > Add Package Dependencies**, enter `https://github.com/livekit/webrtc-xcframework.git` and choose **Exact Version** `144.7559.3`. `UdentifyVC.xcframework` links against it.

> [!CAUTION]
> With the xcframework setup, do not add `livekit/client-sdk-swift`. It causes duplicate-symbol build errors.

### Complete the video call setup
Follow [UdentifyVC](https://github.com/fraudcom/UdentifyVC) for the call itself: the call screen strings, the delegate and the call screen customisation.

## 🔑 Permissions

Add the camera and microphone descriptions to your `Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Camera permission is required for scanning documents and face detection.</string>
<key>NSMicrophoneUsageDescription</key>
<string>Microphone permission is required for two-way audio during video calls.</string>
```

> [!IMPORTANT]
> The SDK checks the camera and microphone permissions but never requests them. Request both before you present the call; otherwise the call does not start.

If you embed `UdentifyNFC`, also add the **Near Field Communication Tag Reading** capability and these keys:

```xml
<key>NFCReaderUsageDescription</key>
<string>NFC permission is required for reading passport and ID chip data.</string>
<key>com.apple.developer.nfc.readersession.iso7816.select-identifiers</key>
<array>
    <string>A0000002471001</string>
</array>
```

## 📖 Usage

### Import
```swift
import UdentifyVC
import UdentifyCommons
```

### Start a call with LiveKYC
Create a `VCLiveKYCOptions` and pass it to `VCCameraController`. Keep the controller as a property for the whole call.

```swift
private var cameraController: VCCameraController?

func startCall() {
    let liveKYCOptions = VCLiveKYCOptions(
        ocrCountry: .TUR,       // Issuing country of the documents
        userID: "USER_ID"       // Required for face registration and authentication
    )

    let cameraController = VCCameraController(
        delegate: self,
        serverURL: "https://your-server-url.com",
        wsURL: "wss://your-websocket-url.com",
        transactionID: "your-transaction-id",   // Created by your backend
        username: "your-username",
        settings: VCSettings(),
        liveKYCOptions: liveKYCOptions
    )
    cameraController.modalPresentationStyle = .fullScreen
    self.cameraController = cameraController
    present(cameraController, animated: true)
}
```

Conform to `VCCameraControllerDelegate` as described in [UdentifyVC](https://github.com/fraudcom/UdentifyVC), and release the controller in `cameraControllerDidDismiss(_:)`.

That's all. The agent starts each step from the dashboard, and the results are uploaded to the Udentify server.

### Listen to events (optional)
Add `onEvent` to follow the steps in your own UI. Events are delivered on the main thread.

```swift
let liveKYCOptions = VCLiveKYCOptions(
    userID: "USER_ID",
    onEvent: { event in
        switch event {
        case .moduleStarted(let module):
            print("Started \(module.rawValue)")
        case .moduleCompleted(let module):
            print("Completed \(module.rawValue)")
        case .moduleFailed(let module, let code, _):
            print("Failed \(module.rawValue): \(code.rawValue)")
        default:
            break
        }
    }
)
```

### Observation modes
`observationMode` decides what the agent sees while a step runs:

| Mode | What the agent sees |
|---|---|
| `.cameraFeed` (default) | The module screen's camera feed |
| `.screenShare` | The customer's app screen, only while a step runs |
| `.progressOnly` | Progress events only |

## 🛠 Dependencies
- [UdentifyVC](https://github.com/fraudcom/UdentifyVC) and [UdentifyCommons](https://github.com/fraudcom/UdentifyCommons)
- Optional: [UdentifyOCR](https://github.com/fraudcom/UdentifyOCR), [UdentifyFACE](https://github.com/fraudcom/UdentifyFACE), [UdentifyNFC](https://github.com/fraudcom/UdentifyNFC)
- [LiveKitWebRTC](https://github.com/livekit/webrtc-xcframework) - MIT License
- [Lottie](https://github.com/airbnb/lottie-ios) (with UdentifyFACE) - Apache 2.0 License

## 📄 License

UdentifyLiveKYC is proprietary software. Copyright © 2026 Fraud.com International Ltd. All rights reserved. See the [LICENSE](LICENSE) file for more info.

## 🙏 Third-Party Licenses

UdentifyLiveKYC does not bundle third-party code. Your app adds the following libraries itself:

### LiveKitWebRTC
- **License:** MIT License
- **Repository:** [https://github.com/livekit/webrtc-xcframework](https://github.com/livekit/webrtc-xcframework)

### Lottie
- **License:** Apache License 2.0
- **Repository:** [https://github.com/airbnb/lottie-ios](https://github.com/airbnb/lottie-ios)

For complete third-party license information, please refer to the respective repositories.
