import Foundation

protocol StorageManager {
  func saveLaps(_ laps: [String]) -> (Bool?, Error?)
  
  func fetchLaps()
  
  func loadLaps() -> [String]
  
  func deleteAllLaps()
  
  func saveNewSession()
  
  func saveCurrentSession()
  
  func fetchSessions()
  
  func deleteAllSessions()
}
