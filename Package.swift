import PackageDescription

let package = Package(
	name: "Swamp",
	targets: [
		Target(
			name: "Swamp",
			dependencies: []
		)
	],
	dependencies: [
        .Package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", versions: Version(1,0,0)..<Version(3, .max, .max)),
		.Package(url: "https://github.com/daltoniam/Starscream", majorVersion: 2, minor: 0),
		.Package(url: "https://github.com/krzyzanowskim/CryptoSwift", majorVersion: 0, minor: 6),
	],
	exclude: ["Example"]
)