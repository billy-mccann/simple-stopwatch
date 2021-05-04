import UIKit
import Combine

class TimerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, LapCellDelegate {

  // MARK: Parameters
  @IBOutlet var timerLabel: UILabel!
  @IBOutlet var startStopButton: UIButton!
  @IBOutlet var clearButton: UIButton!
  @IBOutlet var saveLapsButton: UIButton!
  @IBOutlet var lapsTable: UITableView!
  
  private var laps: [String] = []
  private var cancellables: Set<AnyCancellable> = []
  private let timerViewModel = TimerViewModel()
  private let lapCellIdString: String = "lapCell"
  
  // MARK: Overrides
  override func viewDidLoad() {
    super.viewDidLoad()
    lapsTable.delegate = self
    lapsTable.dataSource = self
    self.bindViewModel()
  }
  
  // MARK: Methods
  private func bindViewModel() {
    timerViewModel.$timerText
      // DispatchQueue is necessary here, because Runloop.main can be busy if user is scrolling
      .receive(on: DispatchQueue.main)
      .sink { value in
        self.timerLabel.text = value }
      .store(in: &cancellables)

    
    timerViewModel.$startStopButtonLabelText
      .receive(on: RunLoop.main)
      .sink { value in
        self.startStopButton.backgroundColor = value == TimerStrings.TIMER_START_TEXT ? UIColor.systemGreen : UIColor.systemRed
        self.startStopButton.setTitle(value, for: .normal) }
      .store(in: &cancellables)
    
    timerViewModel.$laps
      .receive(on: RunLoop.main)
      .sink { receivedLaps in
        self.laps = receivedLaps
        self.lapsTable.reloadData()
      }
      .store(in: &cancellables)
  }
  
  // MARK: Actions
  @IBAction func startStopPressed(_ button:UIButton) {
    self.timerViewModel.startStopButtonPressed()
  }
  
  @IBAction func clearPressed(_ button: UIButton) {
    self.timerViewModel.clearButtonPressed()
  }
  
  @IBAction func saveLapsPressed(_ sender: UIButton) {
    self.timerViewModel.saveLaps()
    self.timerViewModel.printLaps()
  }
  
  // MARK: TableView Methods
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.laps.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: lapCellIdString, for: indexPath) as! LapCell
    cell.lapTimeLabel?.text = laps[indexPath.item]
    cell.lapNumberLabel?.text = "Lap \(indexPath.item + 1)"
    cell.delegate = self
    cell.lapNumber = indexPath.item
    return cell
  }
  
  func deleteLap(indexForLap: Int) {
    self.timerViewModel.deleteLap(indexForLap)
  }
}

