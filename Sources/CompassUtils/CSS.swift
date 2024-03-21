import Foundation
import FileWatcher


public class ResourceWatcher {
    let watcher: FileWatcher
    let basePath: String
    let cwd: String = getCurrentWorkingDirectory()

    let swiftPackagePath: String = getCurrentWorkingDirectory() + "/test.swift"
    var packageContent: String = ""

    let resourceLocation: String = "//⛵Sailor Generated Resources (DONT REMOVE THIS COMMENT)"

    public init(file: String = "Sources/Resources") throws {
        self.basePath = self.cwd + "/\(file)"

        self.watcher = FileWatcher([self.cwd + "/\(file)"])
        self.watcher.queue = DispatchQueue(label: "compass.csswatcher")

        self.watcher.callback = { [weak self] event in
            guard let self = self else { return }

            if event.fileModified { return }
            let path = event.path.replacingOccurrences(of: self.basePath, with: "")
            Swift.print(path)

            if event.fileRemoved {
                /// Is this called sporadically? 
                print("fileRemoved")
                self.removeResource(path: path)

            } else if event.fileRenamed {

                /// Deleted files are classified as renamed. See: https://github.com/eonist/FileWatcher/issues/16
                if !FileManager().fileExists(atPath: event.path) {
                    print("deleted")
                    self.removeResource(path: path)
                } else {
                     print("fileRenamed")
                }

            } else if event.fileCreated {
                /// Created event at the end of else if block to avoid funky behavior:
                /// when files are renamed/deleted sometimes the event is triggered as created
                // print("fileCreated")
                self.addResource(path: path)

            }
        }
    }

    public func start() {
        watcher.start()
    }
    public func stop() {
        watcher.stop()
    }

    func addResource(path: String) {
        try? self.readPackageFile() /// Read for fresh content

        if let range = packageContent.range(of: resourceLocation) {
            let newContent = packageContent.replacingOccurrences(of: resourceLocation, with: """
            \(resourceLocation)
                .process("\(path)")
            """)
            do {
                try newContent.write(toFile: self.swiftPackagePath, atomically: true, encoding: .utf8)
            } catch {
                print("Error writing to Package.swift file: \(error)")
            }
        }
    }
    func removeResource(path: String) {
        try? self.readPackageFile() /// Read for fresh content

        if let range = packageContent.range(of: resourceLocation) {
            let newContent = packageContent.replacingOccurrences(of: "    .process(\"\(path)\")\n", with: "")
            do {
                try newContent.write(toFile: self.swiftPackagePath, atomically: true, encoding: .utf8)
            } catch {
                print("Error writing to Package.swift file: \(error)")
            }
        }
    }

    func readPackageFile() throws {
        do {
            self.packageContent = try String(contentsOfFile: swiftPackagePath, encoding: .utf8)
        } catch {
            print("Error reading Package.swift file: \(error)")
            print("Your styles might not be properly updated.")
            throw error
        }
    }
}