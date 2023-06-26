//
//  ViewController.swift
//  tabu
//
//  Created by İSMAİL AÇIKYÜREK on 22.06.2023.
//

import UIKit
import SnapKit
import Lottie


class MainViewController: UIViewController {

  lazy var tabuTextImage = UIImageView()
  lazy var startButton = UIButton()
  lazy var rulesButton = UIButton()

  lazy var customView = UIView()

  lazy var timeUImageView = UIImageView()
  lazy var timeLabel = UILabel()

  lazy var roundUImageView = UIImageView()
  lazy var roundCountLabel = UILabel()

  lazy var passUImageView = UIImageView()
  lazy var passCountLabel = UILabel()

  lazy var viewModel = MainViewModel()
  lazy var customViewController = CustomViewController()
  private lazy var animationView : LottieAnimationView = {
        let animationView = LottieAnimationView(name: "smile", animationCache: .none)
        animationView.contentMode = .scaleToFill
        animationView.animationSpeed = 0.3
        animationView.loopMode = .loop
        animationView.backgroundColor = .black
        animationView.layer.masksToBounds = true
        animationView.layer.cornerRadius = 40
        animationView.translatesAutoresizingMaskIntoConstraints = true
        return animationView
    }()

  override func viewDidLoad() {
    super.viewDidLoad()


    viewModel.delegate = self
    viewModel.viewController = self
    setNavBar()
    setGradientBackground()
    addView()
    setupUI()
    layoutUI()
    addTarget()
    animationView.play()

    NotificationCenter.default.addObserver(self, selector: #selector(customChanged), name: Notification.Name(rawValue: "custom_changed"), object: nil)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    animatePhotoImageView()
  }
  
  func setNavBar() {
    navigationController?.navigationBar.tintColor = .black
    navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }

  

  func setGradientBackground() {
    let colorTop =  UIColor.mainBackgroundColor.cgColor
    let colorBottom = UIColor.mainBackgroundBottomColor.cgColor

    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [colorTop, colorBottom]
    gradientLayer.locations = [0.3, 1.0]
    gradientLayer.frame = self.view.bounds

    self.view.layer.insertSublayer(gradientLayer, at:0)
  }

  @objc func customChanged() {
    passCountLabel.text = "\(UserDefaults.getRightofPass() ?? 2)"
    roundCountLabel.text = "\(UserDefaults.getNumberofRounds() ?? 2)"
    timeLabel.text = "\(UserDefaults.getTimeRound() ?? 60) saniye"
  }

}

extension MainViewController : GeneralProtocol {

  func addView() {
    self.view.addSubviews(tabuTextImage,rulesButton,animationView,startButton,customView)
    self.customView.addSubviews(timeLabel,timeUImageView,roundCountLabel,roundUImageView,passCountLabel,passUImageView)

  }

  func addTarget() {
    self.startButton.addTarget(self, action: #selector(startViewButtonTapped), for: .touchUpInside)
    self.rulesButton.addTarget(self, action: #selector(rulesButtonTapped), for: .touchUpInside)

    customView.isUserInteractionEnabled = true
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(customViewTapped))
    self.customView.addGestureRecognizer(gestureRecognizer)

  }

  func setupUI() {

    tabuTextImage.createUIImageView(image: UIImage(named: "tabuText"),contentMode: .scaleToFill,maskedToBounds: true)

    startButton.setImage(UIImage(named: "oyunaBasla"), for: .normal)
    startButton.clipsToBounds = true
    startButton.layer.cornerRadius = 40
    startButton.layer.zPosition = 1

    startButton.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]

    rulesButton.setImage(UIImage(named: "nasilOynanir"), for: .normal)
    rulesButton.clipsToBounds = true
    rulesButton.layer.cornerRadius = 40
    rulesButton.layer.zPosition = 1
    rulesButton.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]

    animationView.layer.zPosition = 3

    customView.createView(backgroundColor: .systemGray6,cornerRadius: 20,shadowColor: UIColor.black.cgColor,shadowOffset: CGSize(width: -20, height: 20))

    timeUImageView.createUIImageView(image: UIImage(systemName: "clock"),tintColor: .black)
    timeLabel.createLabel(text: "",textColor: .black)
    timeLabel.text = "\(UserDefaults.getTimeRound() ?? 60) saniye"

    roundUImageView.createUIImageView(image: UIImage(systemName: "repeat"),tintColor: .black)
    roundCountLabel.createLabel(text: "",textColor: .black)
    roundCountLabel.text = "\(UserDefaults.getNumberofRounds() ?? 2)"


    passUImageView.createUIImageView(image: UIImage(systemName: "arrow.turn.up.right"),tintColor: .black)
    passCountLabel.createLabel(text: "",textColor: .black)
    passCountLabel.text = "\(UserDefaults.getRightofPass() ?? 2)"

  }

  func layoutUI() {
    animationViewConstraints()
    startButtonConstraints()
    rulesButtonConstraints()
    animatePhotoImageView()
    tabuTextImageConstraints()
    customViewConstraints()
    timeUImageViewwConstraints()
    timeLabelConstraints()
    roundUImageViewConstraints()
    roundCountLabelConstraints()

    passCountLabelConstraints()
    passUImageViewConstraints()
  }


}
extension MainViewController {

  func animatePhotoImageView() {
    UIView.animate(withDuration: 0.4, delay: 0.4, options: .curveEaseOut, animations: { [self] in
      startButton.frame = CGRect(x: 0, y: 790, width: 100, height: 100)
      rulesButton.frame = CGRect(x: -60, y: -790, width: 100, height: 100)

    })
  }

  @objc func startViewButtonTapped() {
    let gameVC = ReadyViewController()
    gameVC.modalPresentationStyle = .fullScreen
    navigationController?.pushViewController(gameVC, animated: true)
  }
  @objc func rulesButtonTapped() {
    let vc = HowGameViewController()
    vc.modalPresentationStyle = .pageSheet
    self.present(vc, animated: true)
  }
  @objc func customViewTapped() {
    let vc = CustomViewController()
    vc.modalPresentationStyle = .pageSheet
    self.present(vc, animated: true)
  }


}

extension MainViewController {

  func tabuTextImageConstraints() {
    self.tabuTextImage.snp.makeConstraints { make in
      make.bottom.equalTo(self.startButton.snp.top).offset(-50)
      make.height.equalTo(90)
      make.leading.equalTo(self.view.snp.leading).offset(10)
      make.trailing.equalTo(self.view.snp.trailing).offset(-10)
    }
  }
  func startButtonConstraints() {
    self.startButton.snp.makeConstraints { make in
      make.bottom.equalTo(self.animationView.snp.top).offset(40)
      make.height.equalTo(UIScreen.main.bounds.height/5.5)
      make.leading.equalTo(self.view.snp.leading).offset(10)
      make.trailing.equalTo(self.view.snp.trailing).offset(-10)
    }
  }


  func rulesButtonConstraints() {
    self.rulesButton.snp.makeConstraints { make in
      make.top.equalTo(startButton.snp.bottom).offset(3)
      make.height.equalTo(UIScreen.main.bounds.height/5.5)
      make.leading.equalTo(self.view.snp.leading).offset(10)
      make.trailing.equalTo(self.view.snp.trailing).offset(-10)
    }
  }

  func animationViewConstraints() {
    self.animationView.snp.makeConstraints { make in
      make.centerY.equalTo(view.snp.centerY).offset(30)
      make.width.height.equalTo(80)
      make.leading.equalTo(self.view.snp.leading).offset(UIScreen.main.bounds.width/2-40)
    }
  }
  func customViewConstraints() {
    self.customView.snp.makeConstraints { make in
      make.centerX.equalTo(view.snp.centerX).offset(0)
      make.height.equalTo(60)
      make.width.equalTo(view.frame.width/1.3)
      make.bottom.equalTo(self.view.snp.bottom).offset(-40)
    }
  }

  func timeUImageViewwConstraints() {
    self.timeUImageView.snp.makeConstraints { make in
      make.centerY.equalTo(self.customView.snp.centerY).offset(0)
      make.height.width.equalTo(20)
      make.leading.equalTo(self.customView.snp.leading).offset(20)
    }
  }
  func timeLabelConstraints() {
    self.timeLabel.snp.makeConstraints { make in
      make.centerY.equalTo(self.customView.snp.centerY).offset(0)
      make.height.equalTo(20)
      make.width.equalTo(120)
      make.leading.equalTo(self.timeUImageView.snp.leading).offset(20)
    }
  }
  func roundUImageViewConstraints() {
    self.roundUImageView.snp.makeConstraints { make in
      make.centerY.equalTo(self.customView.snp.centerY).offset(0)
      make.height.width.equalTo(20)
      make.leading.equalTo(self.timeLabel.snp.leading).offset(100)
    }
  }
  func roundCountLabelConstraints() {
    self.roundCountLabel.snp.makeConstraints { make in
      make.centerY.equalTo(self.customView.snp.centerY).offset(0)
      make.height.width.equalTo(20)
      make.leading.equalTo(self.roundUImageView.snp.leading).offset(20)
    }
  }

  func passCountLabelConstraints() {
    self.passCountLabel.snp.makeConstraints { make in
      make.centerY.equalTo(self.customView.snp.centerY).offset(0)
      make.height.width.equalTo(20)
      make.trailing.equalTo(self.customView.snp.trailing).offset(-20)
    }
  }
  func passUImageViewConstraints() {
    self.passUImageView.snp.makeConstraints { make in
      make.centerY.equalTo(self.customView.snp.centerY).offset(0)
      make.height.width.equalTo(20)
      make.trailing.equalTo(self.passCountLabel.snp.leading).offset(-5)
    }
  }
}

extension MainViewController : MainViewModelProtocol {
  func customizationComplete() {

  }


}

