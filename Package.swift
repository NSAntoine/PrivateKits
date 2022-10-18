// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let coreUILinkerSetting = LinkerSetting.unsafeFlags(["Sources/AssetCatalogWrapper/CoreUI/CoreUI.framework/CoreUI.tbd"])

let package = Package(
    name: "SantanderWrappers",
    platforms: [.iOS(.v14), .macOS(.v11)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "ApplicationsWrapper", targets: ["ApplicationsWrapper"]),
        .library(name: "AssetCatalogWrapper", targets: ["AssetCatalogWrapper"]),
        .library(name: "FSOperations", targets: ["FSOperations"]),
        .library(name: "NSTask", targets: ["NSTask"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "ApplicationsWrapper", dependencies: ["CFrameworks"]),
        .target(name: "AssetCatalogWrapper", dependencies: ["CFrameworks"]),
        .target(name: "FSOperations", dependencies: ["AssetCatalogWrapper"], linkerSettings: [coreUILinkerSetting]),
        .target(name: "NSTask", dependencies: ["CFrameworks"]),
        .testTarget(name: "FSOperationsTests", dependencies: ["FSOperations", "AssetCatalogWrapper"]),
        .systemLibrary(name: "CFrameworks", path: nil, pkgConfig: nil, providers: nil)
    ]
)
