// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RayTracer",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "RayTracer",
            targets: ["RayTracer"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "RayTracer",
            dependencies: []),
        .testTarget(
            name: "RayTracerTests",
            dependencies: ["RayTracer"],
            resources: [
                .copy("TextureImages/Earth-1300x1300.png"),
                .copy("TextureImages/Earth-2048x1024.jpeg")
            ]
        ),
    ]
)
