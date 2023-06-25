//
//  extension+UIImageView.swift
//  pokemonCase
//
//  Created by İSMAİL AÇIKYÜREK on 27.03.2023.
//

import UIKit

extension UIImageView {
    func createUIImageView(image: UIImage? = nil,tintColor: UIColor? = nil,backgroundColor: UIColor? = nil, contentMode: ContentMode? = nil, maskedToBounds: Bool? = nil, cornerRadius: CGFloat? = nil, isUserInteractionEnabled: Bool? = nil,borderColor : CGColor? = nil,borderWidth : CGFloat? = nil,zPosition : CGFloat? = nil ) {
        self.layer.masksToBounds = maskedToBounds ?? false
        self.image = image
        self.layer.cornerRadius = cornerRadius ?? 0
        self.isUserInteractionEnabled = isUserInteractionEnabled ?? true
        self.contentMode = contentMode ?? .scaleToFill
        self.tintColor = tintColor
        self.backgroundColor = backgroundColor
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth ?? 0
        self.layer.zPosition = zPosition ?? 1
}}



