// swift-tools-version:5.3
import PackageDescription

let package = Package(
  name: "SwiftUILib-DocumentPicker",
  platforms: [ .iOS(.v13), .macOS(.v10_15) ],
  products: [
    .library(
      name: "SwiftUILib.DocumentPicker",
      targets: ["SwiftUILib_DocumentPicker"]),
  ],
  targets: [
    .target(
      name: "SwiftUILib_DocumentPicker",
      path: "src"),
    .testTarget(
      name: "SwiftUILib-DocumentPickerTests",
      dependencies: ["SwiftUILib_DocumentPicker"],
      path: "test"),
  ]
)
