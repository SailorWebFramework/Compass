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

public func fileExists(atPath path: String) -> Bool {
    return FileManager.default.fileExists(atPath: path)
}

public func isDirectory(atPath path: String) -> Bool {
    var isDirectory: ObjCBool = false
    FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
    return isDirectory.boolValue
}

public func validCratesDirectory() -> Bool {
    let path = getCurrentWorkingDirectory()
    return isDirectory(atPath: path + "/Crates")
}
