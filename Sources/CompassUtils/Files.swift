import Foundation

public func getCurrentWorkingDirectory() -> String {
    return FileManager.default.currentDirectoryPath
}

public func directoryEmpty(atPath path: String) -> Bool {
    do {
        let contents = try FileManager.default.contentsOfDirectory(atPath: path)
        return contents.isEmpty
    } catch {
        return false
    }
}

public func isAbsolutePath(_ path: String) -> Bool {
    return path.hasPrefix("/")
}

public func directoryExists(atPath path: String) -> Bool {
    var isDirectory: ObjCBool = false
    FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
    return isDirectory.boolValue
}

public func validCratesDirectory() -> Bool {
    let path = getCurrentWorkingDirectory()
    return directoryExists(atPath: path + "/Crates")
}
