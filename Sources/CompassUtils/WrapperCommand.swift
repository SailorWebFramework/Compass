import Foundation
import ArgumentParser

public protocol WrapperCommand: AsyncParsableCommand {
  var command: String { get }
  var args: [String] { get }
  var help: Bool { get }
  mutating func run() async throws
}

extension WrapperCommand {
  public mutating func run() async throws {
    // print("Running \(command) with args: \(args)")
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    process.arguments = ["swift", "run", "carton", command] + args + (help ? ["--help"] : [])
    print("Running \(process.executableURL!.path) with \(process.arguments!.joined(separator: " "))")
    /// TODO: or...
    // process.executableURL = URL(fileURLWithPath: "/usr/bin/swift")
    // process.arguments = ["run", "carton", command] + args + (help ? ["--help"] : [])
    /// TODO: some commands run twice when invoked with --help? (e.g. `compass test --help`)
    try process.run()
    process.waitUntilExit()
  }
}