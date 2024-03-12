import ArgumentParser
import CompassUtils
import Foundation

struct Bundle: WrapperCommand {
    static let configuration = CommandConfiguration(
        abstract: "Specify name of an executable product to produce the bundle for. (Wrapper for carton bundle)"
    )

    var command: String = "bundle"

    @Argument var args: [String] = []

    /* Override help commands to allow for -h and --help to be passed */
    @Flag(help: "Override help flag, pass this to see an in depth help message for Carton's bundle command") var help: Bool = false
}