import CompassCLI
import CompassUtils
import Foundation
import ArgumentParser

@main
struct Main: ParsableCommand {

  static func main() async {
      let destinationPath = getCurrentWorkingDirectory() + "/tmp"
      let url = "https://github.com/SailorWebFramework/Base" 
    
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
}
    
}

