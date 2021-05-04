import Foundation
import Combine
import CoreData

class StopwatchViewModel: ObservableObject {
  
  @Published var timerText: String
  @Published var startStopButtonLabelText: String
  @Published var laps: [String] = []
  
  private let resetTimeString = String(0.0)
  private var timerIsRunning: Bool = false
  private let formatter = NumberFormatter()
  private var elapsed: Int = 0
  private var cancellable: AnyCancellable? = nil
  
  private let storageManager: StorageManager

  init(_ storageManager: StorageManager) {
    self.storageManager = storageManager
    self.timerText = resetTimeString
    self.startStopButtonLabelText = StopwatchStrings.STOPWATCH_START_TEXT
    
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 2
  }
  
  func startStopButtonPressed() {
    switch timerIsRunning {
    case true:
      startStopButtonLabelText = StopwatchStrings.STOPWATCH_START_TEXT
      timerIsRunning = !timerIsRunning
      stopTimer()
    case false:
      startStopButtonLabelText = StopwatchStrings.STOPWATCH_STOP_TEXT
      timerIsRunning = !timerIsRunning
      startTimer()
    }
  }
  
  func lapButtonPressed() {
    elapsed = 0
    laps.append(timerText)
    timerText = resetTimeString
  }
  
  func deleteLap(_ indexForLap: Int) {
    laps.remove(at: indexForLap)
  }
  
  func startTimer() {
    cancellable = Timer
      .publish(every: 0.01, on: RunLoop.main, in: RunLoop.Mode.common)
      .autoconnect()
      .sink { _ in
        self.elapsed += 1
        let elapsedDecimal = NSNumber(value: (Double(self.elapsed) / 100.00))
        guard let formattedString = self.formatter.string(from: elapsedDecimal) else {
          return
        }
        self.timerText = formattedString
    }
  }
  
  func stopTimer() {
    cancellable?.cancel()
  }
  
  func saveLaps() {
    storageManager.saveLaps(laps)
  }
  
  func deleteAllLaps() {
    storageManager.deleteAllLaps()
  }
  
  func printLaps() {
    storageManager.fetchLaps()
  }
}
