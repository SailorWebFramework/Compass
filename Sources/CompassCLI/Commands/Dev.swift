import ArgumentParser
import CompassUtils
import Foundation

struct Dev: WrapperCommand {
    static let configuration = CommandConfiguration(
        abstract: "Watch the current directory, host the app, rebuild on change. (Wrapper for carton dev)"
    )

    var command: String = "dev"

    @Argument var args: [String] = []

    /* Override help commands to allow for -h and --help to be passed */
    @Flag(help: "Override help flag, pass this to see an in depth help message for Carton's dev command") var help: Bool = false
}