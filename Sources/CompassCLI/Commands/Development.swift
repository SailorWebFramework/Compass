import ArgumentParser
import CompassUtils
import Foundation

struct Development: AsyncParsableCommand {

    static let configuration = CommandConfiguration(
        abstract: "Testing Compass"
    )
        
    func run() async throws {
       let s: String = """
        .process("Resources/main.css"),
        .process("Resources/favicon.ico")
        balls
        laskjflkasjd
        lasdjflskjf
        ("Resources/main.css"),
        ("Resources/favicon.ico")
       """

       /// create regex pattern to strip out the file paths
        let pattern = #""(.*)""#
        let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)

       /// iterate over this string by line
       for line in s.split(separator: "\n") {
              print("Line: \(line)")
              let nsrange = NSRange(line.startIndex..<line.endIndex, in: line)
              let matches = regex.matches(in: String(line), options: [], range: nsrange)
              for match in matches {
                let range = match.range(at: 1)
                if let swiftRange = Range(range, in: line) {
                     print("Match: \(line[swiftRange])")
                }
              }
       }
    }
}