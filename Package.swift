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
            url: "https://api.github.com/repos/fraudcom/mobile/releases/assets/595143973.zip",
            checksum: "04f59bb2cf3f9cacf83568029cee525acd6a60e1d016f99981d40a7320fb95f9"
        )
    ]
)
