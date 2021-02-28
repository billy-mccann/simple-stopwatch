import UIKit
import Combine

class TimerViewController: UIViewController {
  
  @IBOutlet var timerLabel: UILabel!
  @IBOutlet var startStopButton: UIButton!
  @IBOutlet var clearButton: UIButton!
  private var cancellables: Set<AnyCancellable> = []
  
  let timerViewModel = TimerViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bindViewModel()
  }
  
  @IBAction func startStopPressed(_ button:UIButton) {
    self.timerViewModel.startStopButtonPressed()
  }
  
  @IBAction func clearPressed(_ button: UIButton) {
    self.timerViewModel.clearButtonPressed()
  }
  
  func bindViewModel() {
    timerViewModel.$timerText
      .receive(on: RunLoop.main)
      .sink { value in
        self.timerLabel.text = value }
      .store(in: &cancellables)

    
    timerViewModel.$combineButtonLabel
      .receive(on: RunLoop.main)
      .sink { value in
        self.startStopButton.setTitle(value, for: .normal) }
      .store(in: &cancellables)
  }
}

