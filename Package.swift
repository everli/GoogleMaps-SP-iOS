// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GoogleMapsWrapper",
    products: [
        .library(
            name: "GoogleMaps",
            targets: [
                "GoogleMaps",
                "GoogleMapsBase",
                "GoogleMapsCore",
            ]
        ),
        .library(
            name: "GoogleMapsBase",
            targets: ["GoogleMapsBase"]
        ),
        .library(
            name: "GoogleMapsCore",
            targets: ["GoogleMapsCore"]
        ),
        .library(
            name: "GoogleMapsM4B",
            targets: ["GoogleMapsM4B"]
        ),
        .library(
            name: "GooglePlaces",
            targets: [
                "GooglePlaces",
                "GoogleMapsBase",
            ]
        ),
    ],
    targets: [
        .binaryTarget(
            name: "GoogleMaps",
            url: "https://github.com/dimentar/GoogleMapsWrapper/releases/download/6.0.1-maps/GoogleMaps.xcframework.zip",
            checksum: "61c8f69da94fe7d07f8a31be91f9109f104da9e1051c80629a6bc5e97427177a"
        ),
        .binaryTarget(
            name: "GoogleMapsBase",
            url: "https://github.com/dimentar/GoogleMapsWrapper/releases/download/6.0.1-maps/GoogleMapsBase.xcframework.zip",
            checksum: "f64f926473e626220b6f3f407feea6eca6b504bd8529bbb2a35ec03944ce8194"
        ),
        .binaryTarget(
            name: "GoogleMapsCore",
            url: "https://github.com/dimentar/GoogleMapsWrapper/releases/download/6.0.1-maps/GoogleMapsCore.xcframework.zip",
            checksum: "5331a2e2d27dbdca68b2bf9e0696ae2178f23b541d13a3de1c6726780e84f79c"
        ),
        .binaryTarget(
            name: "GoogleMapsM4B",
            url: "https://github.com/dimentar/GoogleMapsWrapper/releases/download/6.0.1-maps/GoogleMapsM4B.xcframework.zip",
            checksum: "0712b59f9b16e17dc5610e72c7d351ecde7e4f6a1c83aec5056e6a3e5ea40a16"
        ),
        .binaryTarget(
            name: "GooglePlaces",
            url: "https://github.com/dimentar/GoogleMapsWrapper/releases/download/6.0.1-maps/GooglePlaces.xcframework.zip",
            checksum: "2e90f2e2b2d40a7a2d1b9b46b2f8b904c3c38058b899d66d90a01d1c85acb441"
        ),
    ]
)
