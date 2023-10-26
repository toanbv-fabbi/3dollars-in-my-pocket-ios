import ProjectDescription

struct Version {
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
    name: "Home",
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
            name: "Home",
            platform: .iOS,
            product: .framework,
            bundleId: "com.macgongmon.-dollar-in-my-pocket.home",
            deploymentTarget: .iOS(targetVersion: Version.targetVersion, devices: .iphone),
            infoPlist: .default,
            sources: ["Targets/Home/Sources/**"],
            resources: ["Targets/Home/Resources/**"],
            dependencies: [
                .project(target: "Networking", path: "../../Network"),
                .project(target: "DesignSystem", path: "../../DesignSystem"),
                .project(target: "Common", path: "../../Common"),
                .project(target: "Model", path: "../../Common"),
                .project(target: "AppInterface", path: "../../../App"),
                .project(target: "StoreInterface", path: "../Store"),
                .project(target: "MembershipInterface", path: "../Membership"),
                .external(name: "SnapKit"),
                .external(name: "Then"),
                .external(name: "PanModal")
            ]
        ),
        Target(
            name: "HomeDemo",
            platform: .iOS,
            product: .app,
            bundleId: "com.macgongmon.-dollar-in-my-pocket.home-demo",
            deploymentTarget: .iOS(targetVersion: Version.targetVersion, devices: .iphone),
            infoPlist: "Targets/Demo/Info.plist",
            sources: ["Targets/Demo/Sources/**"],
            dependencies: [
                .project(target: "Home", path: "./")
            ]
        )
    ],
    schemes: [
        Scheme(
            name: "Home",
            buildAction: BuildAction(targets: ["Home"])
        ),
        Scheme(
            name: "HomeDemo",
            buildAction: BuildAction(targets: ["HomeDemo", "Home"]),
            runAction: .runAction(
                configuration: .debug,
                attachDebugger: true
            ),
            archiveAction: .archiveAction(configuration: .debug)
        ),
    ]
)
