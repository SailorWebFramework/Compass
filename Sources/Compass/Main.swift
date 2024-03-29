import CompassCLI
import CompassUtils
import Foundation
import ArgumentParser

// var wrapperCommands: [String] = ["bundle", "dev", "test"]

@main
struct Main {
  typealias Command = Compass

  public static func main() async {
    do {
      var command: any ParsableCommand = try Command.parseAsRoot()
      print(command)
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

