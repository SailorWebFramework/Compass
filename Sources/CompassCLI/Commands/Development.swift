import ArgumentParser
import CompassUtils
import Foundation

struct Development: AsyncParsableCommand {

    static let configuration = CommandConfiguration(
        abstract: "Testing Compass"
    )
        
    func run() async throws {
        // let csswatcher = try ResourceWatcher(file: "css", title: "css")
        // // let w_one = try TestWatcherOne(file: "css", title: "blue")
        // // let w_two = try TestWatcherTwo(file: "css", title: "green")
        // // w_one.start()
        // // w_two.start()
        // csswatcher.start()

        // while true {
        //     sleep(1)
        // }
        try await getRaw(url: "https://raw.githubusercontent.com/SailorWebFramework/Compass/main/Sources/Compass/Main.swift", to: getCurrentWorkingDirectory() + "/Crates/test.swift")
    }
}