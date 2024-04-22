import ArgumentParser
import CompassUtils
import Foundation

struct Dock: AsyncParsableCommand {

    static let configuration = CommandConfiguration(
        abstract: "Enables the user to add dependencies to their project via crates and fleets."
    )

    @Flag(name: .shortAndLong, help: "Update the dock to the latest version.") var update: Bool = false
    @Flag(name: .shortAndLong, help: "Clean the dock folder.") var clean: Bool = false
    @Flag(name: .shortAndLong, help: "Lists the current version of the dock.") var version: Bool = false
    @Flag(name: .shortAndLong, help: "List out available crates and fleets with their versions.") var list: Bool = false

    func fetchDock(dockPath: String) async throws  {
        if !fileExists(atPath: dockPath) {
            print("Fetching dock file")
            try await getRaw(url: "https://raw.githubusercontent.com/SailorWebFramework/Dock/main/dock.json", to: dockPath)
        } 
    }

    func fetchVersion(versionPath: String) async throws {
        if !fileExists(atPath: versionPath) {
            print("Fetching version file")
            try await getRaw(url: "https://raw.githubusercontent.com/SailorWebFramework/Dock/main/version.txt", to: versionPath)
        }
        print("Successfully initialized dock version \(try String(contentsOfFile: versionPath, encoding: .utf8))\n")
    }
        
    func run() async throws {

        let dockFolder = getCurrentWorkingDirectory() + "/.Dock"
        let dockPath = dockFolder + "/dock.json"
        let versionPath = dockFolder + "/version.txt"

        /* Handle update flag */
        if update && isDirectory(atPath: dockFolder) {
            print("Updating dock...")
            // remove the dock folder recursively
            try removeFile(atPath: dockPath)
            try removeFile(atPath: versionPath)
            try await fetchDock(dockPath: dockPath)
            try await fetchVersion(versionPath: versionPath)
            return
        }

        /* Handle clean flag */
        if clean && isDirectory(atPath: dockFolder) {
            print("Cleaning dock...")
            try removeFolder(atPath: dockFolder)
            return
        }

        /* Handle version flag */
        if version {
            let version = try String(contentsOfFile: versionPath, encoding: .utf8)
            print("Dock version: \(version)")
            return
        }

        /* Handle list flag */
        if list {
            let dock = try String(contentsOfFile: dockPath, encoding: .utf8)
            let dockContent = try JSONDecoder().decode(DockContent.self, from: dock.data(using: .utf8)!)
            print("\nFleets:")
            for (name, fleet) in dockContent.fleet {
                print("  \(name) - \(fleet.version)")
            }
            print("\nCrates:")
            for (name, crate) in dockContent.crates {
                print("  \(name) - \(crate.version)")
            }
            return
        }

        /* Dock command with no flags */
        if !isDirectory(atPath: String(dockFolder)) {
            print("Creating .Dock folder")
            try createDirectory(atPath: dockFolder)
        }  else {
            print(".Dock folder already exists\n")
            //TODO: --clean command? Would need to keep track of dock releases?
            print("Run `compass dock --clean` to clean the dock.")
            return;
        }
        try await fetchDock(dockPath: dockPath)
        try await fetchVersion(versionPath: versionPath)
    }
}