//
//  ReadyViewController.swift
//  tabu
//
//  Created by İSMAİL AÇIKYÜREK on 24.06.2023.
//

import UIKit
import SnapKit

class ReadyViewController: UIViewController {

  let redView = UIView()
  let roundLabel = UILabel()
  let blueView = UIView()
  let personsImage = UIImageView()
  let personsImage2 = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
      view.addSubviews(redView,blueView,roundLabel,personsImage,personsImage2)
      redView.backgroundColor = .readTeamColor

      blueView.backgroundColor = .blueTeamColor
      redView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/2)
      roundLabel.frame = CGRect(x: 0, y: 0, width: 180, height: 90)
      roundLabel.center = view.center
      roundLabel.backgroundColor = .blue

      roundLabel.createLabel(text: "1.Round                HAZIR OL!", textColor: .white, font: UIFont.systemFont(ofSize: 33), zPozisition: -1, numberOfLines: 2, textAlignment: .center)

      self.personsImage.createUIImageView(image: UIImage(systemName: "person.3.fill"),tintColor:.systemGray3)
      personsImage.frame = CGRect(x: redView.center.x-90, y: redView.center.y-60, width: 180, height: 120)




      blueView.frame = CGRect(x: 0, y: view.frame.height/2, width: view.frame.width, height: view.frame.height/2)
      self.personsImage2.createUIImageView(image: UIImage(systemName: "person.3.fill"),tintColor:.systemGray3)
      personsImage2.frame = CGRect(x: blueView.center.x-90, y: blueView.center.y-60, width: 180, height: 120)
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){
        self.entryAnimate()
      }
    }

  func entryAnimate() {
    UIView.animate(withDuration: 0.6, delay: 0.6, options: .curveEaseOut, animations: { [self] in
      redView.transform = CGAffineTransform(translationX: 0, y: -60)
      blueView.transform = CGAffineTransform(translationX: 0, y: 60)
    })
    DispatchQueue.main.asyncAfter(deadline: .now() + 3){
      let gameVC = GameViewController()
      gameVC.modalPresentationStyle = .fullScreen
      self.navigationController?.pushViewController(gameVC, animated: true)
    }
  }
    



}
