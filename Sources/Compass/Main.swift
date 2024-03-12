import CompassCLI
import CompassUtils
import Foundation
import ArgumentParser

@main
struct Main {
  typealias Command = Compass

  public static func main() async {
    do {
      var command = try Command.parseAsRoot()
      if var command = command as? AsyncParsableCommand {
        try await command.run()
      } else {
        try command.run()
      }
    } catch {
      Command.exit(withError: error)
    }
  }
}

