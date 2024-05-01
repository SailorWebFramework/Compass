import ArgumentParser
import CompassUtils
import Foundation
import Darwin
import Dispatch

struct Dev: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Watch the current directory, host the app, rebuild on change. (Wrapper for carton dev)"
    )

    var command: String = "dev"

    @Argument var args: [String] = []

    /* Override help commands to allow for -h and --help to be passed */
    @Flag(help: "Override help flag, pass this to see an in depth help message for Carton's dev command") var help: Bool = false

    mutating func run() async throws {
        
        let dev_process = Process()
        dev_process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        dev_process.arguments = ["swift", "run", "carton", "dev"] + (help ? ["--help"] : args)
        let devNullURL = URL(fileURLWithPath: "/dev/null")
        dev_process.standardError = try FileHandle(forWritingTo: devNullURL) //TODO: ideally shouldn't do this, but interrupting swift run carton dev is throwing an error code 2
        print("Running \(dev_process.executableURL!.path) with \(dev_process.arguments!.joined(separator: " "))")
        /// TODO: or...
        // process.executableURL = URL(fileURLWithPath: "/usr/bin/swift")
        // process.arguments = ["run", "carton", command] + args + (help ? ["--help"] : [])
        /// TODO: some commands run twice when invoked with --help? (e.g. `compass test --help`)
        let signalSource = DispatchSource.makeSignalSource(signal: SIGINT, queue: .main)
        signalSource.setEventHandler {
            print("SIGINT received, terminating processes...")
            dev_process.interrupt()
            signalSource.cancel()
        }
        signal(SIGINT, SIG_IGN) // Ignore the default action to terminate the process
        signalSource.resume()

        try dev_process.run()
        dev_process.waitUntilExit()
    }
}