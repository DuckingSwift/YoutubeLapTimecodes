import Foundation

let offsetInSeconds: Float = 17

let laps: [Float] = [
    24.879,
    22.479,
    22.801,
]

extension Float {
    var frm3: String { String(format: "%.3f", self) }
    var minutes: Int { Int(truncatingRemainder(dividingBy: 3600) / 60) }
    var seconds: Int { Int(truncatingRemainder(dividingBy: 60)) }

    var toTimecode: String {
        let min = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        let sec = seconds < 10 ? "0\(seconds)" : "\(seconds)"
        return min + ":" + sec
    }
}

var fileString = ""

func youtubeTimecodes(_ laps: [Float], _ offset: Float) {
    let bestLap = laps.min()!
    let bestLapIndex = laps.firstIndex(of: bestLap)! - 1
    var time = offset

    fileString += "Timecodes\n\n"
    fileString += "00:00 Pre race\n"
    fileString += "\(offset.toTimecode) Lap 1\n"

    laps.enumerated().forEach {
        let currentLap = $0 + 2
        let bestMark = $0 == bestLapIndex ? " - Best Lap \(bestLap.frm3)" : ""
        time += $1
        let secondPart = $0 != laps.count - 1 ? "Lap \(currentLap)\(bestMark)\n" : "End race"
        fileString += "\(time.toTimecode) \(secondPart)"
    }

    do {
        try fileString.write(toFile: "timecodes.txt", atomically: false, encoding: .utf8)
        print("Wrote txt file.")
    } catch {
        print("Error writing to file.")
    }
}

youtubeTimecodes(laps, offsetInSeconds)
