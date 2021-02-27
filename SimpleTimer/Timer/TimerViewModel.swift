import Foundation
import Combine

class TimerViewModel: ObservableObject {
  
  var timerText: Publisher<String>
  @Published var combineButtonLabel: String
  
  
  private let startText = "Start"
  private let stopText = "Stop"
  private let resetTimeString = String(0.0)
  
  private var timerIsRunning: Bool = false
  private let formatter = NumberFormatter()
  private var elapsed: Int = 0
  private var cancellable: AnyCancellable? = nil

  init() {
    self.timerText = Publisher(resetTimeString)
    self.combineButtonLabel = startText
    
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 2
  }
  
  func startStopButtonPressed() {
    switch timerIsRunning {
    case true:
      combineButtonLabel = startText
      timerIsRunning = !timerIsRunning
      stopTimer()
    case false:
      combineButtonLabel = stopText
      timerIsRunning = !timerIsRunning
      startTimer()
    }
  }
  
  func clearButtonPressed() {
    elapsed = 0
    timerText.value = resetTimeString
  }
  
  func startTimer() {
    cancellable = Timer
      .publish(every: 0.01, on: RunLoop.main, in: RunLoop.Mode.default)
      .autoconnect()
      .sink { _ in
        self.elapsed += 1
        let elapsedDecimal = NSNumber(value: (Double(self.elapsed) / 100.00))
        guard let formattedString = self.formatter.string(from: elapsedDecimal) else {
          return
        }
        self.timerText.value = formattedString
    }
  }
  
  func stopTimer() {
    cancellable?.cancel()
  }
}
