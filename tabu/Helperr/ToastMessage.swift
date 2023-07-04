//
//  ToastMessage.swift
//  tabu
//
//  Created by İSMAİL AÇIKYÜREK on 26.06.2023.
//

//
import UIKit

final class ToastMessage {

    public static func showToastMessage(message : String, font: UIFont,y:CGFloat, vc: UIViewController) {
        let view = UIView(frame: CGRect(x: 40, y: y, width: UIScreen.main.bounds.width-80, height: 45))
        view.layer.backgroundColor = UIColor.mainBackgroundColor.cgColor
        view.alpha = 1.0
        view.layer.masksToBounds = true
       view.layer.borderColor = UIColor.mainBackgroundColor.cgColor
       view.layer.borderWidth = 1
        view.layer.cornerRadius = 14
        view.clipsToBounds  =  true

        let messageLabel = UILabel(frame: CGRect(x: 45, y: y + 2, width: view.frame.width - 40 , height: 42))
        messageLabel.textColor = UIColor.white
        messageLabel.font = font
        messageLabel.adjustsFontSizeToFitWidth = true
        messageLabel.minimumScaleFactor = 0.2
        messageLabel.numberOfLines = 2
        messageLabel.text = message

        vc.view.addSubview(view)
        vc.view.addSubview(messageLabel)

        UIView.animate(withDuration: 4.0, delay: 2, options: .curveEaseOut, animations: {
            messageLabel.alpha = 0.0
            view.alpha = 0.0
        }, completion: {(isCompleted) in
            messageLabel.removeFromSuperview()
            view.removeFromSuperview()
        })
    }
}
