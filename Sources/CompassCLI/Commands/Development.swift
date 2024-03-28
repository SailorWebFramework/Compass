import ArgumentParser
import CompassUtils
import Foundation

struct Development: AsyncParsableCommand {

    static let configuration = CommandConfiguration(
        abstract: "Testing Compass"
    )
        
    func run() async throws {
        let csswatcher = try CSSWatcher(file: "css")
        csswatcher.start()

        while true {
            sleep(1)
        }
    }
}