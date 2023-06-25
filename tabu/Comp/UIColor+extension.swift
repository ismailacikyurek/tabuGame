//
//  UIColor+extension.swift
//  tabu
//
//  Created by İSMAİL AÇIKYÜREK on 23.06.2023.
//



import UIKit

extension UIColor {


  @nonobjc class var  mainBackgroundColor: UIColor {
    return UIColor(hexString:"#251A4F")
  }
  @nonobjc class var  mainBackgroundBottomColor: UIColor {
    return UIColor(hexString:"#716CA6")
  }
  @nonobjc class var buttonBackgorund: UIColor {
    return UIColor(hexString:"#D9C6BE")
  }
  @nonobjc class var readTeamColor: UIColor {
    return UIColor(hexString:"#CC3333")
  }
  @nonobjc class var blueTeamColor: UIColor {
    return UIColor(hexString:"#4169E1")
  }
  @nonobjc class var customPageColor: UIColor {
    return UIColor(hexString:"# 484B4C")
  }

}

extension UIColor {

  convenience init(hexString: String) {
    let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int = UInt32()
    Scanner(string: hex).scanHexInt32(&int)
    let a, r, g, b: UInt32
    switch hex.count {
    case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (255, 0, 0, 0)
    }
    self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
  }

}






