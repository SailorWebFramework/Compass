import ArgumentParser
import CartonKit

@main
struct MyCommand: ParsableCommand {
    func run() {
        print("Hello, World!")
        CartonKit.openInSystemBrowser(url: "https://cbannon.com")
    }
}
