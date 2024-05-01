import ArgumentParser
import CompassUtils
import Foundation
import ANSITerminal

var cwd: String = getCurrentWorkingDirectory()
var url: String = "https://github.com/SailorWebFramework/ExampleProject" 

struct Init: AsyncParsableCommand {

    static let configuration = CommandConfiguration(
        abstract: "Initialize a new Sailor project"
    )

    @Argument var name = ""
    // @Flag(help: "Enable tailwind in Sailor project") var tailwind: Bool = false
    
    mutating func run() async throws {

        cursorOff()
        clearScreen() /// needed sometimes or else behavior is weird: i.e formatting is messed up in terminal output... suspect there's some buffer not being properly cleared? idk

        if name == "" {
            /* TODO: figure out ask() from AnsiTerminal... or maybe not bc it breaks the program */
            print("Please enter a name for your project: ")
            guard let name: String = Swift.readLine(strippingNewline: true) else {
                print("Error, invalid name")
                return
            }
            self.name = name
        } else {
            print("Initializing project: \(name)\n")
        }

        /* Check if valid destination */
        let destinationPath = cwd + "/" + name
        if isDirectory(atPath: destinationPath) && directoryEmpty(atPath: destinationPath) == false {
            print("Error: Destination directory '\(destinationPath)' already exists and is not empty.")
            return
        }

        /* Clone starter Code */
        do {        
            print("\nInitializing...\n")
            try await cloneRepositoryAsync(url: url, destinationPath: destinationPath)
            try removeGitDirectory(atPath: destinationPath)
        } catch {
            print("Error: \(error)")
        }

        /* Change YOURNAME to the name of the project in package.swift */
        let packagePath = destinationPath + "/Package.swift"
        do {
            let packageContents = try String(contentsOfFile: packagePath, encoding: .utf8)
            let newPackageContents = packageContents.replacingOccurrences(of: "ExampleProject", with: name)
            try newPackageContents.write(toFile: packagePath, atomically: true, encoding: .utf8)
        } catch {
            print("Error: \(error)")
        }

        print("Done! Your project is ready at ./\(name)\n")
        let steps = [
            "cd \(name)",
            "compass dev",
        ]
        print("Next steps:\n".bold)
        for (index, step) in steps.enumerated() {
            print("\(index + 1):".bold + " \(step)".asBlue)
        }

        print("\nTo close the dev server, press " + "Ctrl + C\n".bold)
    }
}
