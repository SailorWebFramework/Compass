import Foundation

public func cloneRepositoryAsync(url: String, destinationPath: String) async throws {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    process.arguments = ["git", "clone", url, destinationPath]

    /* Todo: figure better way to redirect output? */
    let devNullURL = URL(fileURLWithPath: "/dev/null")
    process.standardOutput = try FileHandle(forWritingTo: devNullURL)
    process.standardError = try FileHandle(forWritingTo: devNullURL)

    try process.run()
    process.waitUntilExit()
}

public func removeGitDirectory(atPath path: String) throws {
    let gitDirectoryPath = URL(fileURLWithPath: path).appendingPathComponent(".git")
    let fileManager = FileManager.default
    try fileManager.removeItem(at: gitDirectoryPath)
}