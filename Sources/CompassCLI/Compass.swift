import ArgumentParser
import CompassUtils

public struct Compass: ParsableCommand {

    public static let configuration: CommandConfiguration = CommandConfiguration(
        abstract: "CLI tool for Sailor - a Swift Frontend Web Framework",
        version: compassVersion,
        subcommands: [Init.self, Test.self, Bundle.self, Dev.self, Development.self, Add.self, Dock.self]
    )

    public init() {}
}
