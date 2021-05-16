import Foundation
import CoreData

class CoreDataStorageManager: StorageManager {

  private let appDelegate: AppDelegate
  private var mainContext: NSManagedObjectContext!
  private var backgoundContext: NSManagedObjectContext!
  private var session: Session?
  
  init(_ appDelegate: AppDelegate) {
    self.appDelegate = appDelegate
    mainContext = appDelegate.persistentContainer.viewContext
    backgoundContext = appDelegate.persistentContainer.newBackgroundContext()
  }
  
  private func getCurrentSession() -> Session {
    if let session = self.session { return session }
    else {
      let newSession = Session.init(context: mainContext)
      newSession.date = Date.init()
      newSession.id = generateSessionId()
    }
    return session != nil ? session! : Session.init(context: mainContext)
  }
  
  func setSession(_ session: Session) {
    self.session = session
  }
  
  private func generateSessionId() -> Int32 {
    return Int32.random(in: 0 ... INT32_MAX)
  }
  
  private func generateLapId() -> Int32 {
    return Int32.random(in: 0 ... INT32_MAX)
  }
  
  func saveLaps(_ laps: [String]) -> (Bool?, Error?) {
    let currentSession = getCurrentSession()
    if currentSession.laps != nil {
      currentSession.removeFromLaps(currentSession.laps!)
    }
    
    for (index, str) in laps.enumerated(){
      let lap = Lap.init(context: mainContext)
      lap.lap_time = str
      lap.lap_number = Int16(index + 1)
      lap.id = generateLapId()
      lap.session = currentSession
      currentSession.addToLaps(lap)
    }
    
    guard let _ = try? mainContext.save() else {
      print("Error occurred saving to Core Data")
      return (nil, StorageManagerError.saveLapsFailed)
    }
    return (true, nil)
  }
  
  func getLapsFromSession(_ session: Session) -> [Lap] {
    guard let lapSet = session.laps else { return [] }
    var laps = lapSet.allObjects as! [Lap]
    laps.sort(by: { (one, two ) -> Bool in
      return one.lap_number < two.lap_number
    })
    return laps
  }
  
  func loadLaps() -> [String] {
    let laps = getLapsFromSession(getCurrentSession())
    return laps.map {($0.lap_time ?? "")}
  }
  
  func fetchLaps() {
    let fetchRequest = Lap.lapFetchRequest()
    guard let results = try? mainContext.fetch(fetchRequest) else {
      print("Error occurred fetching from Core Data")
      return
    }
    for result in results {
      print(result.id)
      print(result.lap_number)
      print(result.lap_time ?? "no lap time found")
      print()
      print("****************************************")
      print()
    }
  }
  
  func deleteAllLaps() {
    let fetchRequest = Lap.lapFetchRequest()
    guard let results = try? mainContext.fetch(fetchRequest) else {
      print("Error occurred fetching from Core Data")
      return
    }
    for result in results {
      mainContext.delete(result)
    }
    try! mainContext.save()
  }
  
  func saveNewSession() {
    
  }
  
  func saveCurrentSession() {
    
  }
  
  func fetchSessions() {
    
  }
  
  func deleteAllSessions() {
    
  }
}
