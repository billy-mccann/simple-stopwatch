import Foundation
import UIKit

@IBDesignable
class RoundedButton: UIButton {
  
  @IBInspectable var cornerRadius: CGFloat = 10
  var colorIsGreen: Bool = true
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.layer.cornerRadius = cornerRadius
    self.clipsToBounds = true
  }
}
