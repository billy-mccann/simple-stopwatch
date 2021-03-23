import Foundation
import Combine
import CoreData
import UIKit

class TimerViewModel: ObservableObject {
  
  @Published var timerText: String
  @Published var startStopButtonLabelText: String
  @Published var laps: [String] = []
  
  private let resetTimeString = String(0.0)
  private var timerIsRunning: Bool = false
  private let formatter = NumberFormatter()
  private var elapsed: Int = 0
  private var cancellable: AnyCancellable? = nil
  
  // Keys
  private let SESSION_ID_KEY:String = "session_id"
  private let LAP_TIMES_KEY:String = "lap_times"
  private let LAPS_ENTITY_STRING = "Laps"
  private let DATE_KEY:String = "date"
  
  // CoreData
  private var coreDataLaps: [NSManagedObject] = []

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
  
  func saveLaps() {
    guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    // Values
    var lapTimesString = "::"
    for lap in laps{
      lapTimesString.append(lap)
      lapTimesString.append("::")
    }
    let uuid = UUID()
    let date = Date()
    
    // CoreData Functionality
    let managedContext = delegate.persistentContainer.viewContext
    
    let entity = NSEntityDescription.entity(forEntityName: LAPS_ENTITY_STRING, in: managedContext)!
    let lapEntity = NSManagedObject(entity: entity, insertInto: managedContext)
    lapEntity.setValue(date, forKey: DATE_KEY)
    lapEntity.setValue(uuid, forKey: SESSION_ID_KEY)
    lapEntity.setValue(lapTimesString, forKey: LAP_TIMES_KEY)
    
    do {
      try managedContext.save()
    } catch let error as NSError {
      print("Error saving to CoreData: \(error)")
    }
  }
  
  func printLaps() {
    guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
      return
    }
    
    let managedContext = delegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: LAPS_ENTITY_STRING)
    
    do {
      let results = try managedContext.fetch(fetchRequest)
      for result in results {
        print(result.value(forKey: DATE_KEY) ?? "no date found")
        print(result.value(forKey: SESSION_ID_KEY) ?? "no session found")
        print(result.value(forKey: LAP_TIMES_KEY) ?? "no lap times found")
        print()
        print("****************************************")
        print()
      }
    } catch let error as NSError {
      print("Couldn't fetch from Core Data: \(error)")
    }
    
  }
}
