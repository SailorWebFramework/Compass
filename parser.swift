import Foundation
import ArgumentParser

// MAYBE NOT NEEDED

struct Sailor: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "sailor",
        abstract: "Description of your CLI tool",
        version: "1.0.0" // Replace with your actual version
    )

    func run() throws {
        if CommandLine.arguments.contains("--version") {
            print("Sailor version \(Self.configuration.version ?? "unknown")")
        } else {
            // Handle other commands or provide a usage message
            print("Usage: sailor [--version]")
        }
    }
}

Sailor.main()


// struct MySwiftWasmCLI: ParsableCommand {
//     // ... other properties and configurations ...

//     // Define a computed property for the version flag
//     @Flag(name: .shortAndLong, help: "Show the version of MySwiftWasmCLI")
//     var version: Bool

//     // ... other properties and configurations ...

//     // Implement the run() method
//     func run() throws {
//         if version {
//             // If the version flag is provided, print the version and exit
//             print("MySwiftWasmCLI v1.0.0") // Replace with your actual version
//             return
//         }

//         // Your other command logic goes here
//     }
// }
