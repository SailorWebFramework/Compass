import ArgumentParser

struct BuildOptions {
  @Option(
    name: .customLong("Xswiftc", withSingleDash: true),
    parsing: .unconditionalSingleValue,
    help: "Pass flag through to all Swift compiler invocations")
  var swiftCompilerFlags: [String] = []

  init() {}
}

