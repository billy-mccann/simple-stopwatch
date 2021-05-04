import Foundation
import CoreData

class CoreDataStorageManager: StorageManager {
  private let appDelegate: AppDelegate
  private var mainContext: NSManagedObjectContext!
  
  // Keys
  private let SESSION_ID_KEY:String = "session_id"
  private let LAP_TIMES_KEY:String = "lap_times"
  private let LAPS_ENTITY_STRING = "Laps"
  private let DATE_KEY:String = "date"
  
  init(_ appDelegate: AppDelegate) {
    self.appDelegate = appDelegate
    mainContext = appDelegate.persistentContainer.viewContext
  }
  
  func saveLaps(_ laps: [String]) {
    // Values
    var lapTimesString = "::"
    for lap in laps{
      lapTimesString.append(lap)
      lapTimesString.append("::")
    }
    let uuid = UUID()
    let date = Date()
    
    let entity = NSEntityDescription.entity(forEntityName: LAPS_ENTITY_STRING, in: mainContext)!
    let lapEntity = NSManagedObject(entity: entity, insertInto: mainContext)
    lapEntity.setValue(date, forKey: DATE_KEY)
    lapEntity.setValue(uuid, forKey: SESSION_ID_KEY)
    lapEntity.setValue(lapTimesString, forKey: LAP_TIMES_KEY)
    
    do {
      try mainContext.save()
    } catch let error as NSError {
      print("Error saving to CoreData: \(error)")
    }
  }
  
  func fetchLaps() {
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: LAPS_ENTITY_STRING)
    guard let results = try? mainContext.fetch(fetchRequest) else {
      print("Error occurred fetching from Core Data")
      return
    }
    for result in results {
      print(result.value(forKey: DATE_KEY) ?? "no date found")
      print(result.value(forKey: SESSION_ID_KEY) ?? "no session found")
      print(result.value(forKey: LAP_TIMES_KEY) ?? "no lap times found")
      print()
      print("****************************************")
      print()
    }
  }
  
  func deleteAllLaps() {
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: LAPS_ENTITY_STRING)
    guard let results = try? mainContext.fetch(fetchRequest) else {
      print("Error occurred fetching from Core Data")
      return
    }
    for result in results {
      mainContext.delete(result)
    }
    try! mainContext.save()
  }
}
