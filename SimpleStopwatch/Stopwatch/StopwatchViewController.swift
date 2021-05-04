import UIKit
import Combine

class StopwatchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, LapCellDelegate {

  // MARK: Parameters
  @IBOutlet var timerLabel: UILabel!
  @IBOutlet var startStopButton: UIButton!
  @IBOutlet var lapButton: UIButton!
  @IBOutlet var saveLapsButton: UIButton!
  @IBOutlet var deleteLapsButton: UIButton!
  @IBOutlet var lapsTable: UITableView!
  
  private var laps: [String] = []
  private var cancellables: Set<AnyCancellable> = []
  private let stopwatchViewModel: StopwatchViewModel = { () -> StopwatchViewModel in
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let cdStorageManager = CoreDataStorageManager(appDelegate)
    return StopwatchViewModel(cdStorageManager)
  }()
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
    stopwatchViewModel.$timerText
      // DispatchQueue is necessary here, because Runloop.main can be busy if user is scrolling
      .receive(on: DispatchQueue.main)
      .sink { value in
        self.timerLabel.text = value }
      .store(in: &cancellables)

    
    stopwatchViewModel.$startStopButtonLabelText
      .receive(on: RunLoop.main)
      .sink { value in
        self.startStopButton.backgroundColor = value == StopwatchStrings.STOPWATCH_START_TEXT ? UIColor.systemGreen : UIColor.systemRed
        self.startStopButton.setTitle(value, for: .normal) }
      .store(in: &cancellables)
    
    stopwatchViewModel.$laps
      .receive(on: RunLoop.main)
      .sink { receivedLaps in
        self.laps = receivedLaps
        self.lapsTable.reloadData()
      }
      .store(in: &cancellables)
  }
  
  // MARK: Actions
  @IBAction func startStopPressed(_ button:UIButton) {
    self.stopwatchViewModel.startStopButtonPressed()
    self.stopwatchViewModel.printLaps()
  }
  
  @IBAction func lapPressed(_ button: UIButton) {
    self.stopwatchViewModel.lapButtonPressed()
  }
  
  @IBAction func saveLapsPressed(_ sender: UIButton) {
    self.stopwatchViewModel.saveLaps()
  }
  
  @IBAction func deleteLapsPressed(_ sender: UIButton) {
    self.stopwatchViewModel.deleteAllLaps()
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
    self.stopwatchViewModel.deleteLap(indexForLap)
  }
}

