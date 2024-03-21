import ArgumentParser
import CompassUtils
import Foundation

struct Test: AsyncParsableCommand {

    static let configuration = CommandConfiguration(
        abstract: "Specify name of an executable product to produce the bundle for. (Wrapper for carton bundle)"
    )
        
    func run() async throws {
        let csswatcher = try ResourceWatcher(file: "css")
        csswatcher.start()

        while true {
            sleep(1)
        }
    }
}