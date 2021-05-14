import Foundation

protocol StorageManager {
  func saveLaps(_ laps: [String])
  
  func fetchLaps()
  
  func deleteAllLaps()
}
