import Foundation
import Combine

class TimerViewModel: ObservableObject {
  
  @Published var timerText: String
  @Published var startStopButtonLabelText: String
  @Published var laps: [String] = []
  
  private let resetTimeString = String(0.0)
  
  private var timerIsRunning: Bool = false
  private let formatter = NumberFormatter()
  private var elapsed: Int = 0
  private var cancellable: AnyCancellable? = nil

  init() {
    self.timerText = resetTimeString
    self.startStopButtonLabelText = TimerStrings.TIMER_START_TEXT
    
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 2
  }
  
  func startStopButtonPressed() {
    switch timerIsRunning {
    case true:
      startStopButtonLabelText = TimerStrings.TIMER_START_TEXT
      timerIsRunning = !timerIsRunning
      stopTimer()
    case false:
      startStopButtonLabelText = TimerStrings.TIMER_STOP_TEXT
      timerIsRunning = !timerIsRunning
      startTimer()
    }
  }
  
  func clearButtonPressed() {
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
}
