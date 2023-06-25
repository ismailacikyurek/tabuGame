//
//  AlertMessage.swift
//  pokemonCase
//
//  Created by İSMAİL AÇIKYÜREK on 27.03.2023.
//

import UIKit
    
extension UIViewController {
     func alertMessageShow(title : successOrError,message : String) {
        let alert = UIAlertController(title: title.rawValue, message: message, preferredStyle: .alert)
       let ok = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
}

enum successOrError : String {
    case error = "Error"
    case success = "Success"
}
