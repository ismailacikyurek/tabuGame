//
//  PopupViewController.swift
//  tabu
//
//  Created by İSMAİL AÇIKYÜREK on 26.06.2023.
//

import UIKit

class PopupViewController: UIViewController {

  @IBOutlet weak var mainView: UIView!
  @IBOutlet weak var yesButton: UIButton!
  @IBOutlet weak var noButton: UIButton!
  
  var gameViewController : GameViewController?

  override func viewDidLoad() {
    super.viewDidLoad()

    mainView.layer.masksToBounds = true
    mainView.layer.cornerRadius = 20

    yesButton.layer.masksToBounds = true
    yesButton.layer.cornerRadius = 10

    noButton.layer.masksToBounds = true
    noButton.layer.cornerRadius = 10
  }

  @IBAction func yesButtonTapped(_ sender: Any) {
    dismiss(animated: true) {
      let mainVC = MainViewController()
      mainVC.modalPresentationStyle = .overFullScreen
      self.gameViewController?.navigationController?.pushViewController(mainVC, animated: true)
    }
  }

  @IBAction func noButtonTapped(_ sender: Any) {
    self.dismiss(animated: true)
  }

}
