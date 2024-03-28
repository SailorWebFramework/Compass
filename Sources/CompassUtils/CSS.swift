import Foundation
import FileWatcher

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


public class CSSWatcher: ResourceWatcher {

    let swiftPackagePath: String = getCurrentWorkingDirectory() + "/test.swift"

    let resourceLower: String = "//⛵Sailor Generated Resources (DONT REMOVE THIS COMMENT)"
    let resourceUpper: String = "//⛵End (DONT REMOVE THIS COMMENT)"

    override public init(file: String = "Sources/Resources", title: String = "compass.csswatcher") throws {
        try super.init(file: file, title: title)

        // self.regenerate(path: String(file))

        self.watcher.callback = { [weak self] event in
            guard let self = self else { return }

            if event.fileModified { return } /// Don't need to track this
            let path = event.path.replacingOccurrences(of: self.basePath, with: "Resources/") /// Clean path... TODO: better way to add resources?

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
            self.removeTrailingComma()
        }
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

    /// Reads the Package.swift file
    func readPackageFile() throws -> String {
        do {
            let packageContent = try String(contentsOfFile: swiftPackagePath, encoding: .utf8)
            return packageContent
        } catch {
            print("Error reading Package.swift file: \(error)")
            print("Your styles might not be properly updated.")
            throw error
        }
    }
    /// Writes to Package.swift file
    func writePackageFile(content: String) -> Bool {
        do {
            try content.write(toFile: self.swiftPackagePath, atomically: true, encoding: .utf8)
            return true
        } catch {
            print("Error writing to Package.swift file: \(error)")
            return false
        }
    }

    /// Removes trailing comma from the last resource
    func removeTrailingComma() {
        guard let packageContent: String = try? self.readPackageFile() else { return }

        guard let start: String.Index = packageContent.range(of: resourceLower)?.upperBound else { return }
        guard let end: String.Index = packageContent.range(of: resourceUpper)?.lowerBound else { return }
        let range = start..<end
        let content = packageContent[range]

        let lines = content.split(separator: "\n")
        if lines.count == 0 { return }
        let lastLine = content[lines.last!.startIndex...]
        if lastLine.hasSuffix(",\n") {
            let newContent = packageContent.replacingOccurrences(of: ",\n", with: "\n", options: .backwards)
            let _ = self.writePackageFile(content: newContent)
        }
    }

    /// Adds a resource to the Package.swift file
    func addResource(path: String) {
        guard let packageContent: String = try? self.readPackageFile() else { return }
        guard let range = packageContent.range(of: resourceLower) else { return }

        let whitespace = leadingWhitespace(content: packageContent, range: range)

        let newContent = packageContent.replacingOccurrences(of: resourceLower, with: """
        \(resourceLower)
        \(whitespace).process("\(path)"),
        """)
        
        let _ = writePackageFile(content: newContent)
    }

    // /// Removes a resource from the Package.swift file
    func removeResource(path: String) {
        guard let packageContent: String = try? self.readPackageFile() else { return }
        guard let range = packageContent.range(of: resourceLower) else { return }

        let whitespace = leadingWhitespace(content: packageContent, range: range)

        /* Write twice to account for case with and without comma? TODO? */
        var newContent = packageContent.replacingOccurrences(of: """
        \(whitespace).process("\(path)")\n
        """, with: "")
        let _ = writePackageFile(content: newContent)

        newContent = newContent.replacingOccurrences(of: """
        \(whitespace).process("\(path)"),\n
        """, with: "")
        let _ = writePackageFile(content: newContent)
    }

    /// Adds all resources in a directory to the Package.swift file
    func addResources(path: String) {
        let files = try? FileManager().contentsOfDirectory(atPath: self.basePath + path)
        files?.forEach { file in
            if isDirectory(atPath: self.basePath + path + "/\(String(file))") {
                self.addResources(path: path + "/" + file)
            } else {
                self.addResource(path: path + "/" + file)
            }
        }
    }

    /// Removes all resources in a directory from the Package.swift file
    func removeResources(path: String) {
        guard let packageContent: String = try? self.readPackageFile() else { return }

        guard let start: String.Index = packageContent.range(of: resourceLower)?.upperBound else { return }
        guard let end: String.Index = packageContent.range(of: resourceUpper)?.lowerBound else { return }

        let range = start..<end
        var content = "\n"
        var match = false
        let lines = packageContent[range].split(separator: "\n")
        
        for line in lines {
            if line.contains(path) { continue }
            content += "\(line),\n"
            match = true
        }
        
        if !match { print("No content removed..."); return }

        var newPackageContent = packageContent
        newPackageContent.replaceSubrange(range, with: content)
        print(newPackageContent)
        let _ = self.writePackageFile(content: newPackageContent)
    }

    /// TODO: use every init?
    func regenerate(path: String) {
        self.removeResources(path: path)
        self.addResources(path: path)
    }
}