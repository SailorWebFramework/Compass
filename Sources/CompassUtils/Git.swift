import Foundation

// Function to clone the repository asynchronously
public func cloneRepositoryAsync(url: String, destinationPath: String) async throws {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    process.arguments = ["git", "clone", url, destinationPath]
    try process.run()
    process.waitUntilExit()
}

// Function to remove the .git directory asynchronously
public func removeGitDirectoryAsync(atPath path: String) async throws {
    let gitDirectoryPath = URL(fileURLWithPath: path).appendingPathComponent(".git")
    let fileManager = FileManager.default
    try fileManager.removeItem(at: gitDirectoryPath)
}