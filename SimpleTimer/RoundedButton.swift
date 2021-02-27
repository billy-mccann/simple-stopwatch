import Foundation
import UIKit

@IBDesignable
class RoundedButton: UIButton {
  
  @IBInspectable var cornerRadius: CGFloat = 10
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.layer.cornerRadius = cornerRadius
    self.clipsToBounds = true
  }
}
