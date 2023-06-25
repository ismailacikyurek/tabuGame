//
//  GameViewController.swift
//  tabu
//
//  Created by İSMAİL AÇIKYÜREK on 23.06.2023.
//

import UIKit
import Lottie
import SnapKit
import AudioToolbox

class GameViewController: UIViewController {
  private lazy var wordCartView = UIView()
  private lazy var wordTableView = UITableView()
  private lazy var wordTableImage = UIImageView()

  private lazy var pasButton = UIButton()
  private lazy var tabuButton = UIButton()
  private lazy var trueButton = UIButton()
   lazy var timeLabel = UILabel()

  private lazy var tabuLabel = UILabel()
  internal lazy var isFirstTeam = true
  internal lazy var firstTeam = 0
  internal lazy var secondTeam = 0
  internal lazy var passCount = 0
  var timer = Timer()
  var time = UserDefaults.getTimeRound()
  private lazy var animationView : LottieAnimationView = {
        let animationView = LottieAnimationView(name: "ok-tik", animationCache: .none)
        animationView.contentMode = .scaleToFill
        animationView.animationSpeed = 3
        animationView.isHidden = true
        animationView.layer.masksToBounds = true
        animationView.layer.cornerRadius = 40
        animationView.translatesAutoresizingMaskIntoConstraints = true
        return animationView
    }()

  let shapeLayer = CAShapeLayer()
  let trackLAyer = CAShapeLayer()
  lazy var viewModel = GameViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

      viewModel.delegate = self
      viewModel.viewController = self
      setTableView()
      addView()
      addTarget()
      setupUI()
      layoutUI()
      timerAnimation()
      musicVolume(Float(0.0))
      if self.time == nil {
        self.time = 60
      }

    }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.nextWordCart()
    viewModel.startTime()
  }
  override func viewWillDisappear(_ animated: Bool) {
    musicVolume(UserDefaults.getMusicVolume() ?? 0.7)
  }
   func startTime() {
    let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
    basicAnimation.toValue = 0.8
    basicAnimation.duration = CFTimeInterval(time!)
    basicAnimation.fillMode = .forwards
    basicAnimation.isRemovedOnCompletion = false
    shapeLayer.add(basicAnimation, forKey: "urBasic")

  }
  func musicVolume(_ value : Float) {
    var volumeUserInfo = ["volume" : value]
    NotificationCenter.default.post(name: Notification.Name(rawValue: "volume_value"), object: nil,userInfo: volumeUserInfo)
  }


  @objc func fireTimer() {
    time! -= 1
    self.timeLabel.text = "\(time!)"
    if time == 0 {
      timer.invalidate()
      finishTime()
    }
  }
  func finishTime() {
    self.timeLabel.text = "Süre Bitti"
    UIView.animate(withDuration: 1.5, animations: { [self] in
      timeLabel.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
    },completion: nil)
    self.trackLAyer.isHidden = true
    self.shapeLayer.isHidden = true
    let alert = UIAlertController(title: "dsf", message: "message", preferredStyle: .alert)
    let ok = UIAlertAction(title: "Ok", style: .default) {_ in
     self.otherTeam()
   }
    alert.addAction(ok)
    present(alert, animated: true)
  }

  func otherTeam() {
    if UserDefaults.getTimeRound() == nil {
      self.time = 60
    } else {
      self.time = UserDefaults.getTimeRound()
    }
    self.timeLabel.text = ""
    self.viewModel.nextWordCart()
    self.viewModel.startTime()
    self.trackLAyer.isHidden = false
    self.shapeLayer.isHidden = false
    timeLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
  }
}


extension GameViewController : GeneralProtocol {
  func addView() {
    view.addSubviews(wordCartView,pasButton,tabuButton,trueButton,animationView,tabuLabel,timeLabel)
    wordCartView.addSubviews(wordTableView,wordTableImage)

  }
  func addTarget() {
    self.pasButton.addTarget(self, action: #selector(pasButtonTapped), for: .touchUpInside)
    self.tabuButton.addTarget(self, action: #selector(tabuButtonButtonTapped), for: .touchUpInside)
    self.trueButton.addTarget(self, action: #selector(trueButtonTapped), for: .touchUpInside)
  }
  func setupUI() {
    view.backgroundColor = .readTeamColor
    wordCartView.createView(backgroundColor: .white, maskedToBounds: true, cornerRadius: 20, clipsToBounds: true)
    wordCartView.layer.borderColor = UIColor.white.cgColor
    wordCartView.layer.borderWidth = 1

    wordTableImage.createUIImageView(image: UIImage(named: "T"), zPosition: 4)
    wordTableImage.alpha = 0.1

    pasButton.layer.masksToBounds = true
    pasButton.layer.cornerRadius = 45
    pasButton.backgroundColor = .yellow
    pasButton.setImage(UIImage(named: "pass"), for: .normal)

    tabuButton.layer.masksToBounds = true
    tabuButton.layer.cornerRadius = 55
    tabuButton.layer.borderColor = UIColor.white.cgColor
    tabuButton.layer.borderWidth = 4
    tabuButton.setImage(UIImage(named: "T"), for: .normal)
    tabuButton.backgroundColor = .red

    trueButton.layer.masksToBounds = true
    trueButton.layer.cornerRadius = 45
    trueButton.setImage(UIImage(named: "tik"), for: .normal)
    trueButton.backgroundColor = .green
    animationView.layer.zPosition = 3

    tabuLabel.createLabel(text: "Tabu", textColor: .red, font: UIFont.systemFont(ofSize: 297), textAlignment: .center)
    tabuLabel.layer.zPosition = 3
    tabuLabel.isHidden = true


    timeLabel.createLabel(textColor: .white,font: UIFont.systemFont(ofSize: 25), textAlignment: .center)


  }
  func layoutUI() {
    wordCartViewConstraints()
    wordTableViewConstraints()
    wordTableImageConstraints()
   
    tabuButtonConstraints()
    pasButtonConstraints()
    trueButtonConstraints()
    animationViewConstraints()
    tabuLabelConstraints()
    timeLabelConstraints()

  }
  func timerAnimation() {
    let circulaterPath = UIBezierPath(arcCenter: CGPoint(x: view.frame.width/2,
                                                            y: view.frame.height/6),
                                                            radius: 30,
                                                            startAngle: -CGFloat.pi / 2,
                                                            endAngle: CGFloat.pi * 2,
                                                            clockwise: true)


    trackLAyer.path = circulaterPath.cgPath
    view.layer.addSublayer(trackLAyer)
    trackLAyer.strokeColor = UIColor.lightGray.cgColor
    trackLAyer.fillColor = UIColor.clear.cgColor
    trackLAyer.lineWidth = 3

    shapeLayer.path = circulaterPath.cgPath

    view.layer.addSublayer(shapeLayer)

    shapeLayer.strokeColor = UIColor.white.cgColor
    shapeLayer.strokeEnd = 0
    shapeLayer.lineWidth = 3
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.lineCap = .round
  }

}

extension GameViewController  : GameViewModelProtocol{
  func fetchWord() {
    DispatchQueue.main.async { [self] in
      wordTableView.reloadData()
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [self] in
      UIView.animate(withDuration: 0.6, delay: 0.0, options: .curveEaseOut, animations: { [self] in
        wordCartView.transform = CGAffineTransform(translationX: 0, y: 0)

        trueButton.isEnabled = true
        pasButton.isEnabled = true
        tabuButton.isEnabled = true
      })

    }

  }

  func trueNextWord() {
    if isFirstTeam {
      firstTeam += 1
    } else {
      secondTeam += 1
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [self] in
      animationView.isHidden = true
      UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut, animations: { [self] in
        wordCartView.transform = CGAffineTransform(translationX: 900, y: 0)
        self.viewModel.nextWordCart()
      })
    }
  }

  func tabuNextWord() {
//    viewModel.scoreCalculator(count: -1, teamColor: .blueTeam)

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [self] in
      tabuLabel.isHidden = true
      tabuLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
      UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut, animations: { [self] in
        wordCartView.transform = CGAffineTransform(translationX: 0, y: 990)
        self.viewModel.nextWordCart()
      })
    }
  }

  func passNextWord() {
    trueButton.isEnabled = true
    tabuButton.isEnabled = true
    guard passCount <= 1 else {return}
    passCount += 1
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [self] in
      UIView.animate(withDuration: 0.6, delay: 0.0, options: .curveEaseOut, animations: { [self] in
        wordCartView.transform = CGAffineTransform(translationX: 0, y: -790)
        self.viewModel.nextWordCart()
      })
    }

  }

  @objc func pasButtonTapped() {
    trueButton.isEnabled = false
    pasButton.isEnabled = false
    tabuButton.isEnabled = false
    passNextWord()
  }
  
  @objc func tabuButtonButtonTapped() {
    trueButton.isEnabled = false
    pasButton.isEnabled = false
    tabuButton.isEnabled = false
    tabuLabel.isHidden = false
    UIView.animate(withDuration: 0.5, animations: { [self] in
      tabuLabel.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
    },completion: nil)
    tabuNextWord()

    if UserDefaults.getVabilition() == true {
      print("titre")
      AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }

  }
  @objc func trueButtonTapped() {
    trueButton.isEnabled = false
    pasButton.isEnabled = false
    tabuButton.isEnabled = false
    animationView.isHidden = false
    animationView.play()
    trueNextWord()
  }

}
extension GameViewController  {
  func wordCartViewConstraints() {
    self.wordCartView.snp.makeConstraints { make in
      make.centerY.equalTo(self.view).offset(0)
      make.height.equalTo(290)
      make.leading.equalTo(self.view.snp.leading).offset(70)
      make.trailing.equalTo(self.view.snp.trailing).offset(-70)
    }
  }

  func wordTableViewConstraints() {
    self.wordTableView.snp.makeConstraints { make in
      make.top.equalTo(self.wordCartView.snp.top).offset(-10)
      make.bottom.equalTo(self.wordCartView).offset(0)
      make.leading.equalTo(self.view.snp.leading).offset(70)
      make.trailing.equalTo(self.view.snp.trailing).offset(-70)
    }
  }
  func wordTableImageConstraints() {
    self.wordTableImage.snp.makeConstraints { make in
      make.top.equalTo(self.wordCartView.snp.top).offset(0)
      make.bottom.equalTo(self.wordCartView).offset(0)
      make.leading.equalTo(self.view.snp.leading).offset(70)
      make.trailing.equalTo(self.view.snp.trailing).offset(-70)
    }
  }
  func pasButtonConstraints() {
    self.pasButton.snp.makeConstraints { make in
      make.bottom.equalTo(self.tabuButton.snp.bottom).offset(0)
      make.height.width.equalTo(90)
      make.trailing.equalTo(self.tabuButton.snp.leading).offset(-20)
    }
  }

  func tabuButtonConstraints() {
    self.tabuButton.snp.makeConstraints { make in
      make.bottom.equalTo(self.view.snp.bottom).offset(-40)
      make.height.width.equalTo(110)
      make.centerX.equalTo(self.view).offset(0)
    }
  }
  func trueButtonConstraints() {
    self.trueButton.snp.makeConstraints { make in
      make.bottom.equalTo(self.tabuButton.snp.bottom).offset(0)
      make.height.width.equalTo(90)
      make.leading.equalTo(self.tabuButton.snp.trailing).offset(20)
    }
  }
  func animationViewConstraints() {
    self.animationView.snp.makeConstraints { make in
      make.centerX.equalTo(self.wordCartView.snp.trailing).offset(0)
      make.centerY.equalTo(self.wordCartView.snp.bottom).offset(0)
      make.height.width.equalTo(80)
    }
  }
  func timeLabelConstraints() {
    self.timeLabel.snp.makeConstraints { make in
      make.centerX.equalTo(self.view.snp.centerX).offset(0)
      make.top.equalTo(self.view.snp.top).offset(view.bounds.height/6-60)
      make.height.equalTo(120)
      make.width.equalTo(120)
    }
  }
  func tabuLabelConstraints() {
    self.tabuLabel.snp.makeConstraints { make in
      make.centerY.equalTo(self.wordCartView.snp.centerY).offset(0)
      make.centerX.equalTo(self.wordCartView.snp.centerX).offset(0)
    }
  }
}

extension GameViewController : UITableViewDelegate,UITableViewDataSource {

  func setTableView() {
    self.wordTableView.dataSource = self
    self.wordTableView.delegate = self
    self.wordTableView.separatorStyle = .none
    self.wordTableView.register(UINib(nibName: "WordsTableViewCell", bundle: nil), forCellReuseIdentifier: "WordsTableViewCell")
  }
//  func setGradientBackground(label : UILabel,cell : UITableViewCell) {
//    let colorTop =  UIColor.mainBackgroundColor.cgColor
//    let colorBottom = UIColor.mainBackgroundBottomColor.cgColor
//
//    let gradientLayer = CAGradientLayer()
//    gradientLayer.colors = [colorTop, colorBottom]
//    gradientLayer.locations = [0.3, 1.0]
//    gradientLayer.frame = cell.label.bounds
//
//    cell.label.layer.insertSublayer(gradientLayer, at:0)
//  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.wordStringArray.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "WordsTableViewCell") as? WordsTableViewCell {
      switch indexPath.row {
      case 0 :
        cell.loadData(data:  self.viewModel.wordStringArray[0].uppercased())
        var colorTop =  UIColor.mainBackgroundColor.cgColor.copy(alpha: 0.1)
        var colorBottom = UIColor.mainBackgroundBottomColor.cgColor.copy(alpha: 0.1)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.2, 0.3]
        gradientLayer.frame = cell.wordLabel.bounds
        cell.wordLabel.layer.insertSublayer(gradientLayer, at:0)
        cell.wordLabel.backgroundColor = .purple
        cell.wordLabel.textColor = .white
      default:
        cell.loadData(data:  self.viewModel.wordStringArray[indexPath.row])
        cell.wordLabel.backgroundColor = .white
        cell.wordLabel.textColor = .black
      }

        return cell

    }
    return UITableViewCell()
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          var height:CGFloat = CGFloat()
          switch indexPath.row {
          case 0 :
              height = 65
          default:
              height = 48
          }
          return height
      }
  

}
