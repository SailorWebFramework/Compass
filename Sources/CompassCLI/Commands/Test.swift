import ArgumentParser
import CompassUtils
import Foundation
import ANSITerminal

// define some special constants for easy typing
// let ESCAPE = NonPrintableChar.escape.char()
// let DELETE = NonPrintableChar.del.char()
// let RETURN = NonPrintableChar.enter.char()
// let BACKSP = NonPrintableChar.erase.char()
// let HTAB   = NonPrintableChar.tab.char()
// let SPACE  = NonPrintableChar.space.char()
// let DELAY  = 10

struct Test: AsyncParsableCommand {

    static let configuration = CommandConfiguration(
        abstract: "Used for testing"
    )
        
    func run() async throws {
        let choice = picker(title: "Choose your favourite fruit", options: ["🍌 Banana", "🥝 Kiwi", "🍓 Strawberry"])
        print("\n\nYou chose: \(choice)")
    }
}