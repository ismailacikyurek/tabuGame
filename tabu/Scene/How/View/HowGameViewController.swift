//
//  HowGameViewController.swift
//  tabu
//
//  Created by İSMAİL AÇIKYÜREK on 26.06.2023.
//

import UIKit

final class HowGameViewController: UIViewController {

  @IBOutlet weak var mainView: UIView!
  override func viewDidLoad() {
        super.viewDidLoad()

    mainView.layer.masksToBounds = true
    mainView.layer.cornerRadius = 20
    }


  @IBAction func exitButtonTapped(_ sender: Any) {
    dismiss(animated: true)
  }


}
