// swift-tools-version:5.8
import PackageDescription

let package = Package(
    name: "UdentifyLiveKYC",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "UdentifyLiveKYC",
            targets: ["UdentifyLiveKYC"]),
    ],
    dependencies: [
        .package(url: "https://github.com/fraudcom/UdentifyCommons.git", exact: "26.3.0928"),
    ],
    targets: [
        .binaryTarget(
            name: "UdentifyLiveKYC",
            url: "https://api.github.com/repos/fraudcom/mobile/releases/assets/595587647.zip",
            checksum: "f94a8ba4cc5f26041d9633d2ac94a7e87f34ed1fca3acee4fcfbcfbd42f2f680"
        )
    ]
)
