//
//  ReadyViewController.swift
//  tabu
//
//  Created by İSMAİL AÇIKYÜREK on 24.06.2023.
//

import UIKit
import Lottie
import SnapKit

final class ReadyViewController: UIViewController {

  let redView = UIView()
  let roundLabel = UILabel()
  let blueView = UIView()
  let personsImage = UIImageView()
  let personsImage2 = UIImageView()
  private lazy var animationView : LottieAnimationView = {
    let animationView = LottieAnimationView(name: "victory", animationCache: .none)
    animationView.contentMode = .scaleToFill
    animationView.animationSpeed = 0.3
    animationView.loopMode = .loop
    animationView.layer.masksToBounds = true
    animationView.layer.zPosition = 3
    animationView.isHidden = true
    animationView.translatesAutoresizingMaskIntoConstraints = true
    return animationView
  }()

  private lazy var backTheLobyyButton : UIButton = {
    let x = UIButton()
    x.backgroundColor = .buttonBackgorund
    x.setTitle("Lobiye Dön", for: .normal)
    x.setTitleColor(.black, for: .normal)
    x.layer.masksToBounds = true
    x.layer.cornerRadius = 15
    return x
  }()
  private lazy var winningTeamLabel : UILabel = {
    let x = UILabel()
    x.backgroundColor = .clear
    x.textColor = .white
    x.numberOfLines = 4
    x.textAlignment = .center
    x.font = UIFont.boldSystemFont(ofSize: 24)
    return x
  }()

  var roundCount = 1
  override func viewDidLoad() {
    super.viewDidLoad()

    if UserDefaults.getWhichTeam() == nil {
      UserDefaults.setWhichTeam(value: teams.blueTeam.rawValue)
    }

    addView()
    addTarget()
    roundCount = UserDefaults.getWhichRound()

    if roundCount > UserDefaults.getNumberofRounds() ?? 3 {
      if  UserDefaults.getRedTeamScore() == UserDefaults.getBlueTeamScore() {
        //berabere kaldılar
        setupUI()
        showAlertWithTwoCustomAction(vc: self, title: "Oyun Bitti", message: "İki takım berabere kaldı", buttonTitle: "Lobiye Dön") {
          let mainVC = MainViewController()
          self.navigationController?.pushViewController(mainVC, animated: true)
        }

      } else {
        //Oyun Bitti
        self.finishGame()
      }

    } else {
      //Devam
      setupUI()
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){ [self] in
        self.entryAnimate()
      }
    }

  }

  fileprivate func  entryAnimate() {
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


  fileprivate func  finishGame() {
    setGradientBackground()
    layoutUI()
    animationView.play()
    animationView.isHidden = false
    if UserDefaults.getRedTeamScore() > UserDefaults.getBlueTeamScore() {
      //kırmızı kazandı
      winningTeamLabel.text = "Kazanan : Kırmızı Takım"
    }  else {
      //mavi kazandı
      winningTeamLabel.text = "Kazanan : Mavi Takım"
    }

  }

  fileprivate func  setGradientBackground() {
    let colorTop =  UIColor.mainBackgroundColor.cgColor
    let colorBottom = UIColor.mainBackgroundBottomColor.cgColor

    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [colorTop, colorBottom]
    gradientLayer.locations = [0.3, 1.0]
    gradientLayer.frame = self.view.bounds

    self.view.layer.insertSublayer(gradientLayer, at:0)
  }

  @objc func backtoLobyy() {
    let mainVC = MainViewController()
    navigationController?.pushViewController(mainVC, animated: true)
  }

}
extension ReadyViewController : GeneralProtocol {
  func addView() {
    view.addSubviews(redView,blueView,roundLabel,personsImage,personsImage2,animationView,backTheLobyyButton,winningTeamLabel)
  }

  func addTarget() {
    self.backTheLobyyButton.addTarget(self, action: #selector(backtoLobyy), for: .touchUpInside)
  }

  func setupUI() {
    redView.backgroundColor = .readTeamColor
    blueView.backgroundColor = .blueTeamColor
    redView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/2)
    roundLabel.frame = CGRect(x: 0, y: 0, width: 180, height: 90)
    roundLabel.center = view.center
    roundLabel.backgroundColor = .blue

    roundLabel.createLabel(text: "\(roundCount).Round                HAZIR OL!", textColor: .white, font: UIFont.systemFont(ofSize: 33), zPozisition: -1, numberOfLines: 2, textAlignment: .center)

    self.personsImage.createUIImageView(image: UIImage(systemName: "person.3.fill"),tintColor:.systemGray3)
    personsImage.frame = CGRect(x: redView.center.x-90, y: redView.center.y-60, width: 180, height: 120)

    blueView.frame = CGRect(x: 0, y: view.frame.height/2, width: view.frame.width, height: view.frame.height/2)
    self.personsImage2.createUIImageView(image: UIImage(systemName: "person.3.fill"),tintColor:.systemGray3)
    personsImage2.frame = CGRect(x: blueView.center.x-90, y: blueView.center.y-60, width: 180, height: 120)
  }

  func layoutUI() {
    animationViewConstraints()
    backTheLobyyButtonConstraints()
    winningTeamLabelConstraints()
  }


}
extension ReadyViewController {
  func animationViewConstraints() {
    self.animationView.snp.makeConstraints { make in
      make.top.equalTo(view.snp.top).offset(-10)
      make.bottom.equalTo(view.snp.bottom).offset(10)
      make.leading.equalTo(view.snp.leading).offset(-10)
      make.trailing.equalTo(view.snp.trailing).offset(10)

    }
  }

  func backTheLobyyButtonConstraints() {
    self.backTheLobyyButton.snp.makeConstraints { make in
      make.bottom.equalTo(view.snp.bottom).offset(-30)
      make.height.equalTo(40)
      make.width.equalTo(200)
      make.centerX.equalTo(view.snp.centerX).offset(0)

    }
  }
  func winningTeamLabelConstraints() {
    self.winningTeamLabel.snp.makeConstraints { make in
      make.height.equalTo(140)
      make.width.equalTo(200)
      make.centerY.equalTo(view.snp.centerY).offset(0)
      make.centerX.equalTo(view.snp.centerX).offset(0)
    }
  }
}
