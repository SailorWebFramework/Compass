import Foundation

// Function to print a simple text-based progress bar
func printProgressBar(progress: Double) {
    let barLength = 40
    let progressBar = String(repeating: "=", count: Int(progress * Double(barLength)))
    let remainingSpace = String(repeating: " ", count: barLength - progressBar.count)
    let percentage = Int(progress * 100)
    print("[\(progressBar)\(remainingSpace)] \(percentage)%", terminator: "\r")
    fflush(stdout)
}