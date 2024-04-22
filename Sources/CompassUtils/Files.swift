import Foundation
import FileWatcher

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
    var isDir: ObjCBool = false
    FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
    return isDir.boolValue
}

public class ResourceWatcher {
    let watcher: FileWatcher
    let basePath: String
    let cwd: String = getCurrentWorkingDirectory()

    public init(file: String, title: String) throws {
        guard isDirectory(atPath: String(self.cwd + "/\(file)")) else { throw CompassError.invalidDirectory }
        self.basePath = self.cwd + "/\(file)"

        self.watcher = FileWatcher([self.cwd + "/\(file)"])
        self.watcher.queue = DispatchQueue(label: "\(title)")
    }

    public func start() {
        watcher.start()
    }
    public func stop() {
        watcher.stop()
    }
}

// public class TestWatcherOne: ResourceWatcher {

//     override public init(file: String, title: String) throws {
//         try super.init(file: file, title: title)

//         self.watcher.callback = { [weak self] event in
//             guard let self = self else { return }
            
//             print("\u{001B}[0;32m\(event.description)\u{001B}[0m") // Change to green color for example
//         }
//     }
// }

// public class TestWatcherTwo: ResourceWatcher {

//     override public init(file: String, title: String) throws {
//         try super.init(file: file, title: title)

//         self.watcher.callback = { [weak self] event in
//             guard let self = self else { return }
            
//             print("\u{001B}[0;34m\(event.description)\u{001B}[0m") // Change to green color for example
//         }
//     }
// }
