// swift-tools-version:4.0

import PackageDescription

let package = Package(
	name: "PC2Paper",
	products: [
		.library(name: "PC2Paper", targets: ["PC2Paper"])
	],
//	dependencies: [
//		.package(url: "https://github.com/drmohundro/SWXMLHash.git", .upToNextMajor(from: "4.6.0"))
//		],
	targets: [
//		.target(name: "PC2Paper", dependencies: ["SWXMLHash"], path: "Source")
		.target(name: "PC2Paper", path: "Source")
	]
)

