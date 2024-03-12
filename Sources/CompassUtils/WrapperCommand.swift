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
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    process.arguments = ["carton", command] + args + (help ? ["--help"] : [])
    try process.run()
    process.waitUntilExit()
  }
}