//
//  AlertMessage.swift
//  pokemonCase
//
//  Created by İSMAİL AÇIKYÜREK on 27.06.2023.
//

import UIKit

extension UIViewController {
  func alertMessageShow(title : String,message : String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "Tamam", style: .default)
    alert.addAction(ok)
    present(alert, animated: true)
  }

  func showAlertWithTwoCustomAction(vc: UIViewController, title: String, message: String, buttonTitle: String, completion: (() -> Void)? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let addAction = UIAlertAction(title: buttonTitle, style: .default) { action in
      if let completion = completion {
        completion()
      }
    }
    alert.addAction(addAction)
    vc.present(alert, animated: true, completion: nil)
  }
}



