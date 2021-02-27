import Foundation

enum RaceTeam {
  case Honda
  case Suzuki
  case Kawasaki
  case Yamaha
  case KTM
}

struct Racer {
  let name: String
  let number: Int
  let team: RaceTeam
  
  init(_ name: String, _ number: Int, _ team: RaceTeam) {
    self.name = name
    self.number = number
    self.team = team
  }
}

let racers: [Racer] = [
  Racer("Ken Roczen", 94, RaceTeam.Honda),
  Racer("Eli Tomac", 3, RaceTeam.Kawasaki),
  Racer("Adam Ciancurulo", 9, RaceTeam.Kawasaki)
]
