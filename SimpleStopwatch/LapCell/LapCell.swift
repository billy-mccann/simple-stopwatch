import UIKit

class LapCell: UITableViewCell {
  
  @IBOutlet var lapNumberLabel: UILabel!
  @IBOutlet var lapTimeLabel: UILabel!
  @IBOutlet var deleteLapButton: UIButton!
  
  var delegate: LapCellDelegate!
  var lapNumber: Int!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  @IBAction func deleteLapPressed(_ button: UIButton) {
    guard delegate != nil else {
      return
    }
    delegate.deleteLap(indexForLap: lapNumber)
  }
    
}
