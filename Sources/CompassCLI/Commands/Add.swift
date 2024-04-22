import ArgumentParser
import CompassUtils
import Foundation

struct Add: AsyncParsableCommand {

    // var dock = "https://raw.githubusercontent.com/SailorWebFramework/Dock/main/dock.json"

    static let configuration = CommandConfiguration(
        abstract: "Add Cargo/Fleet dependencies to your project"
    )

    @Argument var name = ""

    //TODO: make this better
    func readDock() async throws -> String {
        let dockFolder = getCurrentWorkingDirectory() + "/.Dock"
        if !isDirectory(atPath: String(dockFolder)) {
            print("Did not find .Dock folder\nPlease run compass dock to initialize the dock\n")
            throw CompassError.DockNotFound
        }
        let dockPath = dockFolder + "/dock.json"
        if fileExists(atPath: dockPath) {
            return try String(contentsOfFile: dockPath, encoding: .utf8)
        } else {
            print("Did not find dock.json\nPlease run compass dock --clean to clean the dock\n")
            throw CompassError.DockNotFound
        }
    }

    func findFleet(name: String, dock: DockContent) -> Fleet? {
        if let fleet = dock.fleet[name] {
            return fleet
        }
        return nil
    }

    func findCrate(name: String, dock: DockContent) -> Crate? {
        if let crate = dock.crates[name] {
            return crate
        }
        return nil
    }
        
    func run() async throws {
        
        if name == "" {
            print("Please enter a name for the dependency you want to add to your project\n")
            return;
        }

        let dockContents: String = try await readDock()
        let dockData = dockContents.data(using: .utf8)
        var dock: DockContent

        do {
            dock = try JSONDecoder().decode(DockContent.self, from: dockData!)
        } catch {
            print("Error: \(error)")
            return
        }

        let fleet = findFleet(name: name, dock: dock) 
        let crate = findCrate(name: name, dock: dock)
        
        if fleet == nil && crate == nil {
            print("Error: Could not find \(name) in the dock\n")
            print("Please check your spelling or run 'compass update' to update the dock\n")
            return
        }

        if fleet != nil {
            print("Adding Fleet: \(fleet!.name) to your project")
            // try await getRaw(url: fleet!.location, to: getCurrentWorkingDirectory() + "/Crates/\(fleet!.name).swift")
        } else {
            print("Adding Crate: \(crate!.name) to your project")
            // try await getRaw(url: crate!.location, to: getCurrentWorkingDirectory() + "/Crates/\(crate!.name).swift")
        }
        // try await getRaw(url: "https://raw.githubusercontent.com/SailorWebFramework/Compass/main/Sources/Compass/Main.swift", to: getCurrentWorkingDirectory() + "/Crates/test.swift")
    }
}