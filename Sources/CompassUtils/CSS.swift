import Foundation
import FileWatcher


public class ResourceWatcher {
    let watcher: FileWatcher
    let basePath: String
    let cwd: String = getCurrentWorkingDirectory()

    let swiftPackagePath: String = getCurrentWorkingDirectory() + "/test.swift"
    var packageContent: String = ""

    let resourceLower: String = "//⛵Sailor Generated Resources (DONT REMOVE THIS COMMENT)"
    let resourceUpper: String = "//⛵End (DONT REMOVE THIS COMMENT)"

    public init(file: String = "Sources/Resources") throws {
        guard isDirectory(atPath: String(self.cwd + "/\(file)")) else { throw CompassError.invalidDirectory }
        self.basePath = self.cwd + "/\(file)"

        self.watcher = FileWatcher([self.cwd + "/\(file)"])
        self.watcher.queue = DispatchQueue(label: "compass.csswatcher")

        self.watcher.callback = { [weak self] event in
            guard let self = self else { return }

            if event.fileModified { return } /// Don't need to track this
            let path = event.path.replacingOccurrences(of: self.basePath, with: "") /// Clean path

            if event.fileRenamed {

                /// Deleted files are classified as renamed. See: https://github.com/eonist/FileWatcher/issues/16
                /// A renamed file === removed then created, thus this event triggers twice
                if !FileManager().fileExists(atPath: event.path) {
                    self.removeResource(path: path)
                } else {
                    self.addResource(path: path)
                }

            } else if event.fileCreated {

                /// Created event at the end of else if block to avoid funky behavior:
                /// when files are renamed/deleted sometimes the event is triggered as created
                self.addResource(path: path)

            } else if event.dirRenamed {

                /// Same reasoning as event.fileRenamed
                if !FileManager().fileExists(atPath: event.path) {
                    self.removeResources(path: path)
                } else {
                    self.addResources(path: path)
                }

            } else if event.dirCreated {
                self.addResources(path: path)
            }
            ///TODO: consider other events? Pretty confident these are the only ones needed... event.fileDeleted? IDK what dirModified is
            ///TODO: Better path matching algo for directory logic
        }
    }

    public func start() {
        watcher.start()
    }
    public func stop() {
        watcher.stop()
    }

    /// IDK how this works, but it takes the leading whitespace before a comment. ChatGPT generated
    func leadingWhitespace(content: String, range: Range<String.Index>) -> String {
        guard let start = content[..<range.lowerBound].lastIndex(of: "\n") else {
            return ""
        }
        
        let leadingWhitespaceRange = content.index(after: start)..<range.lowerBound
        let leadingWhitespace = content[leadingWhitespaceRange]
            .prefix(while: { $0.isWhitespace })
        return String(leadingWhitespace)
    }

    /// Adds a resource to the Package.swift file
    func addResource(path: String) {
        try? self.readPackageFile()
        guard let range = packageContent.range(of: resourceLower) else { return }

        let whitespace = leadingWhitespace(content: packageContent, range: range)

        let newContent = packageContent.replacingOccurrences(of: resourceLower, with: """
        \(resourceLower)
        \(whitespace).process("\(path)")
        """)

        do {
            try newContent.write(toFile: self.swiftPackagePath, atomically: true, encoding: .utf8)
        } catch {
            print("Error writing to Package.swift file: \(error)")
        }
        
    }

    /// Removes a resource from the Package.swift file
    func removeResource(path: String) {
        try? self.readPackageFile() /// Read for fresh content
        guard let range = self.packageContent.range(of: resourceLower) else { return }

        let whitespace = leadingWhitespace(content: packageContent, range: range)
        let newContent = self.packageContent.replacingOccurrences(of: """
        \(whitespace).process("\(path)")\n
        """, with: "")
        
        do {
            try newContent.write(toFile: self.swiftPackagePath, atomically: true, encoding: .utf8)
        } catch {
            print("Error writing to Package.swift file: \(error)")
        }
    
    }

    /// Reads the Package.swift file
    func readPackageFile() throws {
        do {
            self.packageContent = try String(contentsOfFile: swiftPackagePath, encoding: .utf8)
        } catch {
            print("Error reading Package.swift file: \(error)")
            print("Your styles might not be properly updated.")
            throw error
        }
    }

    /// Adds all resources in a directory to the Package.swift file
    func addResources(path: String) {
        let files = try? FileManager().contentsOfDirectory(atPath: self.basePath + path)
        files?.forEach { file in
            if isDirectory(atPath: self.basePath + path + "/\(String(file))") {
                print("found directory", file)
                self.addResources(path: path + "/" + file)
            } else {
                self.addResource(path: path + "/" + file)
            }
        }
    }

    /// Removes all resources in a directory from the Package.swift file
    func removeResources(path: String) {
        try? self.readPackageFile()

        guard let start: String.Index = self.packageContent.range(of: resourceLower)?.upperBound else { return }
        guard let end: String.Index = self.packageContent.range(of: resourceUpper)?.lowerBound else { return }

        let range = start..<end
        let content = self.packageContent[range]
        let regex = try! NSRegularExpression(pattern: "\\.process\\(\"(.*?)\"\\)")
        for line in content.split(separator: "\n") {
            guard line.contains(path) else { continue }

            if let match = regex.firstMatch(in: String(line), range: NSRange(line.startIndex..., in: line)) {
                // Extract the range of the content within .process() call
                let range = Range(match.range(at: 1), in: line)!
                
                // Extract the content within .process() call
                let contentWithinProcessCall = line[range]
                
                print(contentWithinProcessCall)
                self.removeResource(path: String(contentWithinProcessCall))
            } else {
                print("No match found.")
            }
        }
    }

    /// Regenerates resources... should be used every init?
    func regenerate(path: String) {
        try? self.readPackageFile()
        self.removeResources(path: path)
        self.addResources(path: path)
    }
}