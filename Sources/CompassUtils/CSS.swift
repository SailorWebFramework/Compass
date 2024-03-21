import Foundation
import FileWatcher


public class ResourceWatcher {
    let watcher: FileWatcher
    let cwd: String = getCurrentWorkingDirectory()
    let basePath: String
    let swiftPackagePath: String = getCurrentWorkingDirectory() + "/test.swift"
    let packageContent: String
    let resourceLocation: String = "//⛵Sailor Generated Resources (DONT REMOVE THIS COMMENT)"

    public init(file: String = "Sources/Resources") throws {
        self.basePath = self.cwd + "/\(file)"

        self.watcher = FileWatcher([self.cwd + "/\(file)"])
        self.watcher.queue = DispatchQueue(label: "compass.csswatcher")

        do {
            self.packageContent = try String(contentsOfFile: swiftPackagePath)
        } catch {
            print("Error reading Package.swift file: \(error)")
            print("Your styles might not be properly updated.")
            throw error
        }

        self.watcher.callback = { [weak self] event in
            guard let self = self else { return }

            if event.fileModified { return }
            let path = event.path.replacingOccurrences(of: self.basePath, with: "")
            Swift.print(path)

            if event.fileCreated {
                print("fileCreated")

                if let range = packageContent.range(of: resourceLocation) {
                    let newContent = packageContent.replacingCharacters(in: range, with: resourceLocation + "\n    .process(\"\(path)\")")
                    do {
                        try newContent.write(toFile: self.swiftPackagePath, atomically: true, encoding: .utf8)
                    } catch {
                        print("Error writing to Package.swift file: \(error)")
                    }
                }

            } else if event.fileRemoved {
                print("fileRemoved")

                if let range = packageContent.range(of: resourceLocation) {
                    let newContent = packageContent.replacingOccurrences(of: "    .process(\"\(path)\")", with: "")
                    do {
                        try newContent.write(toFile: self.swiftPackagePath, atomically: true, encoding: .utf8)
                    } catch {
                        print("Error writing to Package.swift file: \(error)")
                    }
                }

            } else if event.fileRenamed {

                /// Deleted files are classified as renamed. See: https://github.com/eonist/FileWatcher/issues/16
                if !FileManager().fileExists(atPath: event.path) {
                    print("deleted")
                } else {
                     print("fileRenamed")
                }

            }
        }
    }

    public func start() {
        watcher.start()
    }
    public func stop() {
        watcher.stop()
    }
}