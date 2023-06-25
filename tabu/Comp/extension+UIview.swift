//
//  extension+UIview.swift
//  pokemonCase
//
//  Created by İSMAİL AÇIKYÜREK on 27.03.2023.
//

import Foundation
import UIKit

extension UIView {
    func createView(backgroundColor: UIColor? = nil, maskedToBounds: Bool? = nil, cornerRadius: CGFloat? = nil, isUserInteractionEnabled: Bool? = nil,image:String? = nil,shadowColor : CGColor? = nil,shadowOffset : CGSize? = nil,clipsToBounds : Bool? = nil,borderColor : CGColor? = nil,borderWidth: CGFloat? = nil) {
        self.layer.masksToBounds = maskedToBounds ?? false
        self.layer.cornerRadius = cornerRadius ?? 0
        self.isUserInteractionEnabled = isUserInteractionEnabled ?? false
        self.backgroundColor = backgroundColor
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.shadowColor = shadowColor
        self.layer.shadowOffset = shadowOffset ?? .zero
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.3
        self.clipsToBounds = clipsToBounds ?? false
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth ?? 0
    }
    
    func removeShadow() {
        self.layer.shadowRadius = 0
        self.layer.shadowOpacity = 0
    }
    
}

extension UIView {
    func addSubviews(_ views: UIView...) {
        for i in views {
            addSubview(i)
        }
    }
}

extension UIView {
    func roundCornersView(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
