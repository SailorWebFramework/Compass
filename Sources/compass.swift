import ArgumentParser

@main
struct MyCommand: ParsableCommand {
    @Option(name: .shortAndLong, help: "The name of the person to greet.")
    var name: String

    func run() {
        print("Hello, \(name)!")
    }
}
