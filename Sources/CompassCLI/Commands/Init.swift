import ArgumentParser
import CompassUtils
import Foundation

var cwd: String = getCurrentWorkingDirectory()
var url: String = "https://github.com/SailorWebFramework/Base" 

struct Init: AsyncParsableCommand {

    static let configuration = CommandConfiguration(
        abstract: "Initialize a new Sailor project"
        )

    @Flag var tailwind: Bool = false
    
    func run() async throws {
        print(tailwind)
        print("Please enter a name for your project ", terminator: "")
        let name: String? = Swift.readLine(strippingNewline: true)
        if name == nil{
            print("Error, invalid name")
            return
        }

        /* Clone starter Code */
        let destinationPath = cwd + "/" + name!
        do {
            if isDirectoryExists(atPath: destinationPath) && isDirectoryEmpty(atPath: destinationPath) == false {
                print("Error: Destination directory '\(destinationPath)' already exists and is not empty.")
                return
            }
        
            print("Cloning \(url)...")
            try await cloneRepositoryAsync(url: url, destinationPath: destinationPath)
            print("Repository cloned successfully.")
        
            print("Removing .git directory...")
            try await removeGitDirectoryAsync(atPath: destinationPath)
            print(".git directory removed.")
        } catch {
            print("Error: \(error)")
        }

        /* Change YOURNAME to the name of the project in package.swift */
        let packagePath = destinationPath + "/Package.swift"
        do {
            let packageContents = try String(contentsOfFile: packagePath, encoding: .utf8)
            let newPackageContents = packageContents.replacingOccurrences(of: "YOURNAME", with: name!)
            try newPackageContents.write(toFile: packagePath, atomically: true, encoding: .utf8)
        } catch {
            print("Error: \(error)")
        }
    }
}
