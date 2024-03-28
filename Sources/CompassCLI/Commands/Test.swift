import ArgumentParser
import CompassUtils
import Foundation

struct Test: WrapperCommand {
    static let configuration = CommandConfiguration(
        abstract: "Environment used to run the tests. (Wrapper for carton test)"
    )

    var command: String = "test"

    @Argument var args: [String] = []

    /* Override help commands to allow for -h and --help to be passed */
    @Flag(help: "Override help flag, pass this to see an in depth help message for Carton's test command") var help: Bool = false
}