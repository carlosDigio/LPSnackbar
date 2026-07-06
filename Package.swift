// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "LPSnackbar",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "LPSnackbar",
            targets: ["LPSnackbar"]
        ),
    ],
    targets: [
        .target(
            name: "LPSnackbar",
            path: "src/LPSnackbar",
            exclude: ["Info.plist"],
            resources: [
                .process("LPSnackbarView.xib")
            ]
        ),
        .testTarget(
            name: "LPSnackbarTests",
            dependencies: ["LPSnackbar"],
            path: "src/LPSnackbarTests",
            exclude: ["Info.plist"]
        )
    ],
    swiftLanguageVersions: [.v5]
)
