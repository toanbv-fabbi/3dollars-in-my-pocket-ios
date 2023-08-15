import ProjectDescription

struct Version {
    static let version: SettingValue = "1.0.0"
    static let buildNumber: SettingValue = "1"
    static let targetVersion = "14.0"
}

struct BuildSetting {
    struct Project {
        static let base: SettingsDictionary = [
            "IPHONEOS_DEPLOYMENT_TARGET": "14.0"
        ]
    }
}


let project = Project(
    name: "Membership",
    organizationName: "macgongmon",
    packages: [],
    settings: .settings(
        base: BuildSetting.Project.base,
        configurations: [
            .debug(name: .debug),
            .release(name: .release)
        ]
    ),
    targets: [
        Target(
            name: "Membership",
            platform: .iOS,
            product: .framework,
            bundleId: "com.macgongmon.-dollar-in-my-pocket.membership",
            deploymentTarget: .iOS(targetVersion: Version.targetVersion, devices: .iphone),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "Networking", path: "../../Network"),
                .project(target: "DesignSystem", path: "../../DesignSystem"),
                .project(target: "Common", path: "../../Common"),
                .external(name: "SnapKit"),
                .external(name: "Then")
            ]
        )
    ]
)
