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
        let ok = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
}


