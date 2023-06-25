
//
//extension+UILabel.swift
//  pokemonCase
//
//  Created by İSMAİL AÇIKYÜREK on 27.03.2023.
//

import UIKit

extension UILabel {
func createLabel(text: String? = nil,
                  backgroundColor : UIColor? = nil,
                  textColor : UIColor? = nil,
                  font : UIFont? = nil,
                  cornerRadius : CGFloat? = nil,
                  zPozisition : CGFloat? = nil,
                  numberOfLines : Int? = nil,
                  textAlignment : NSTextAlignment? = .left ) {
    self.backgroundColor = backgroundColor ?? .clear
    self.font = font
    self.text = text
    self.textColor = textColor
    self.layer.cornerRadius = cornerRadius ?? 0
    self.layer.masksToBounds = true
    self.layer.zPosition = zPozisition ?? 0
    self.numberOfLines = numberOfLines ?? 1
    self.textAlignment = textAlignment ?? .left
    self.isUserInteractionEnabled = true

}
}

