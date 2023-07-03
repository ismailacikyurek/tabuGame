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


final class GameViewController: UIViewController {
  private lazy var wordCartView = UIView()
  private lazy var wordTableView = UITableView()
  private lazy var wordTableImage = UIImageView()
  private lazy var pasButton = UIButton()
  private lazy var tabuButton = UIButton()
  private lazy var trueButton = UIButton()
  private lazy var homeButton = UIButton()
  private lazy var playAndStopButton = UIButton()
  private lazy var timeLabel = UILabel()
  private lazy var passCountLabel = UILabel()
  private lazy var scoreLabel = UILabel()
  private lazy var tabuLabel = UILabel()
  private lazy var roundFollowCounter = 0
  private lazy var passCount = UserDefaults.getRightofPass() ?? 2
  private lazy var isStop = Bool()
  private lazy var  time = UserDefaults.getTimeRound() ?? 60

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
  var  timer = Timer()
  private let shapeLayer = CAShapeLayer()
  private let trackLAyer = CAShapeLayer()
  private lazy var viewModel = GameViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    setNavBar()
    viewModel.delegate = self
    viewModel.viewController = self
    setTableView()
    addView()
    addTarget()
    setupUI()
    layoutUI()
    timerAnimation()
    musicVolume(Float(0.0))
    viewModel.fetchScore()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.nextWordCart()
    viewModel.startTime()
    self.startAnimateTime()
  }

  override func viewWillDisappear(_ animated: Bool) {
    musicVolume(UserDefaults.getMusicVolume() ?? 0.7)
  }

  fileprivate func setNavBar() {
    navigationController?.navigationBar.isHidden = true
  }

 fileprivate func startAnimateTime() {
    let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
    basicAnimation.toValue = 0.8
    basicAnimation.duration = CFTimeInterval(time ?? 2)
    basicAnimation.fillMode = .forwards
    basicAnimation.isRemovedOnCompletion = false
    shapeLayer.add(basicAnimation, forKey: "urBasic")

  }
  fileprivate func pauseAnimation(){
    var pausedTime = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
    shapeLayer.speed = 0.0
    shapeLayer.timeOffset = pausedTime
  }
  fileprivate func resumeAnimation(){
    var pausedTime = shapeLayer.timeOffset
    shapeLayer.speed = 1.0
    shapeLayer.timeOffset = 0.0
    shapeLayer.beginTime = 0.0
    let timeSincePause = shapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
    shapeLayer.beginTime = timeSincePause
  }

  fileprivate func musicVolume(_ value : Float) {
    var volumeUserInfo = ["volume" : value]
    NotificationCenter.default.post(name: Notification.Name(rawValue: "volume_value"), object: nil,userInfo: volumeUserInfo)
  }

  @objc func fireTimer() {
    time -= 1
    self.timeLabel.text = "\(time)"
    if time == 0 {
      timer.invalidate()
      finishTime()
    }
  }

  fileprivate func finishTime() {
    self.timeLabel.text = "Süre Doldu"
    UIView.animate(withDuration: 1.5, animations: { [self] in
      timeLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    },completion: nil)
    self.trackLAyer.isHidden = true
    self.shapeLayer.isHidden = true
    let alert = UIAlertController(title: "Süre Doldu", message: "Sıra diğer takımda", preferredStyle: .alert)
    let ok = UIAlertAction(title: "Tamam", style: .default) {_ in
      self.otherTeam()
    }
    alert.addAction(ok)
    present(alert, animated: true)
  }

  fileprivate func  otherTeam() {
    if UserDefaults.getWhichTeam() == teams.blueTeam.rawValue {
      UserDefaults.setWhichTeam(value: teams.redTeam.rawValue)
      let gameVC = ReadyViewController()
      gameVC.modalPresentationStyle = .fullScreen
      self.navigationController?.pushViewController(gameVC, animated: true)
    } else {
      UserDefaults.setWhichTeam(value: teams.blueTeam.rawValue)
      let gameVC = ReadyViewController()
      let whichRoundCount = UserDefaults.getWhichRound()
      UserDefaults.setWhichRound(value: whichRoundCount+1)
      gameVC.modalPresentationStyle = .fullScreen
      self.navigationController?.pushViewController(gameVC, animated: true)
    }
  }
}


extension GameViewController : GeneralProtocol {
  func addView() {
    view.addSubviews(wordCartView,pasButton,tabuButton,trueButton,animationView,tabuLabel,timeLabel,playAndStopButton,homeButton,passCountLabel,scoreLabel)
    wordCartView.addSubviews(wordTableView,wordTableImage)

  }

  func addTarget() {
    self.pasButton.addTarget(self, action: #selector(pasButtonTapped), for: .touchUpInside)
    self.tabuButton.addTarget(self, action: #selector(tabuButtonButtonTapped), for: .touchUpInside)
    self.trueButton.addTarget(self, action: #selector(trueButtonTapped), for: .touchUpInside)
    self.playAndStopButton.addTarget(self, action: #selector(playAndStopButtonTapped), for: .touchUpInside)
    self.homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)

  }

  fileprivate func playAndStopButtonSetImage(image : String) {
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 60, weight: .thin, scale: .medium)
    let largeBoldDoc = UIImage(systemName: image, withConfiguration: largeConfig)
    playAndStopButton.tintColor = .white
    playAndStopButton.setImage(largeBoldDoc, for: .normal)
  }

  func setupUI() {

    switch UserDefaults.getWhichTeam() {
    case teams.blueTeam.rawValue :
      view.backgroundColor = .blueTeamColor
    case teams.redTeam.rawValue :
      view.backgroundColor = .readTeamColor
    case .none:
      print("..")
    case .some(_):
      print(".")
    }

    wordCartView.createView(backgroundColor: .white, maskedToBounds: true, cornerRadius: 20, clipsToBounds: true)
    wordCartView.layer.borderColor = UIColor.white.cgColor
    wordCartView.layer.borderWidth = 1

    wordTableImage.createUIImageView(image: UIImage(named: "T"), zPosition: 4)
    wordTableImage.alpha = 0.1

    pasButton.layer.masksToBounds = true
    pasButton.layer.cornerRadius = 45
    pasButton.setImage(UIImage(named: "passButton"), for: .normal)

    tabuButton.layer.masksToBounds = true
    tabuButton.layer.cornerRadius = 50
    tabuButton.setImage(UIImage(named: "tabuButton"), for: .normal)

    trueButton.layer.masksToBounds = true
    trueButton.layer.cornerRadius = 45
    trueButton.setImage(UIImage(named: "trueButton"), for: .normal)
    animationView.layer.zPosition = 3

    tabuLabel.createLabel(text: "Tabu", textColor: .red, font: UIFont.systemFont(ofSize: 297), textAlignment: .center)
    tabuLabel.layer.zPosition = 3
    tabuLabel.isHidden = true

    timeLabel.createLabel(textColor: .white,font: UIFont.systemFont(ofSize: 25), textAlignment: .center)

    playAndStopButtonSetImage(image: "pause.fill")

    homeButton.setBackgroundImage(UIImage(systemName: "house.fill"), for: .normal)
    homeButton.tintColor = .white

    passCountLabel.createLabel(backgroundColor: .white,textColor: .black, cornerRadius: 13,textAlignment: .center)
    passCountLabel.layer.borderColor = UIColor.black.cgColor
    passCountLabel.layer.borderWidth = 2
    passCountLabel.text = "\(passCount)"

    scoreLabel.createLabel(textColor: .white,font: UIFont.boldSystemFont(ofSize: 20), textAlignment: .left)
    scoreLabel.adjustsFontSizeToFitWidth = true
    self.time = UserDefaults.getTimeRound() ?? 60
    self.passCount = UserDefaults.getRightofPass() ?? 2
    self.passCountLabel.text = "\(self.passCount)"
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
    playAndStopButtonConstraints()
    homeButtonConstraints()
    passCountLabelConstraints()
    scoreLabelConstraints()
  }

  fileprivate func  timerAnimation() {
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
  func fetchScore(redTeamScore: Int, blueTeamScore: Int) {
    if UserDefaults.getWhichTeam() == teams.blueTeam.rawValue {
      scoreLabel.text = "Puan : \(blueTeamScore)"
    } else {
      scoreLabel.text = "Puan : \(redTeamScore)"
    }
  }


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

  fileprivate func  trueNextWord() {
    
    if UserDefaults.getWhichTeam() == teams.blueTeam.rawValue  {
      viewModel.scoreCalculator(count: 1, teamColor: .blueTeam)
    } else {
      viewModel.scoreCalculator(count: 1, teamColor: .redTeam)
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [self] in
      animationView.isHidden = true
      UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut, animations: { [self] in
        wordCartView.transform = CGAffineTransform(translationX: 900, y: 0)
        self.viewModel.nextWordCart()
      })
    }
  }

  fileprivate func  tabuNextWord() {
    if UserDefaults.getWhichTeam() == teams.blueTeam.rawValue  {
      viewModel.scoreCalculator(count: -1, teamColor: .blueTeam)
    } else {
      viewModel.scoreCalculator(count: -1, teamColor: .redTeam)
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [self] in
      tabuLabel.isHidden = true
      tabuLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
      UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut, animations: { [self] in
        wordCartView.transform = CGAffineTransform(translationX: 0, y: 990)
        self.viewModel.nextWordCart()
      })
    }
  }

  fileprivate func  passNextWord() {

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [self] in
      UIView.animate(withDuration: 0.6, delay: 0.0, options: .curveEaseOut, animations: { [self] in
        wordCartView.transform = CGAffineTransform(translationX: 0, y: -790)
        self.viewModel.nextWordCart()
      })
    }

  }

  @objc func pasButtonTapped() {
    if passCount <= 0 {
      self.passCountLabel.text = "\(passCount)"
      passCountLabel.layer.borderColor = UIColor.red.cgColor
    } else {
      self.passCount -= 1
      self.passCountLabel.text = "\(passCount)"
      trueButton.isEnabled = false
      pasButton.isEnabled = false
      tabuButton.isEnabled = false
      passNextWord()
    }
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

  @objc func playAndStopButtonTapped() {
    if isStop {
      isStop = false
      playAndStopButtonSetImage(image: "pause.fill")
      self.viewModel.startTime()
      self.resumeAnimation()
      self.pasButton.isEnabled = true
      self.tabuButton.isEnabled = true
      self.trueButton.isEnabled = true
    } else {
      isStop = true
      playAndStopButtonSetImage(image: "play.fill")
      self.timer.invalidate()
      self.pauseAnimation()
      self.pasButton.isEnabled = false
      self.tabuButton.isEnabled = false
      self.trueButton.isEnabled = false
    }
  }

  @objc func homeButtonTapped() {
    let vc = PopupViewController()
    vc.modalPresentationStyle = .overFullScreen
    vc.gameViewController = self
    present(vc, animated: true)
  }
}

extension GameViewController  {
  fileprivate func  wordCartViewConstraints() {
    self.wordCartView.snp.makeConstraints { make in
      make.centerY.equalTo(self.view).offset(0)
      make.height.equalTo(290)
      make.leading.equalTo(self.view.snp.leading).offset(70)
      make.trailing.equalTo(self.view.snp.trailing).offset(-70)
    }
  }

  fileprivate func  wordTableViewConstraints() {
    self.wordTableView.snp.makeConstraints { make in
      make.top.equalTo(self.wordCartView.snp.top).offset(-10)
      make.bottom.equalTo(self.wordCartView).offset(0)
      make.leading.equalTo(self.view.snp.leading).offset(70)
      make.trailing.equalTo(self.view.snp.trailing).offset(-70)
    }
  }
  fileprivate func  wordTableImageConstraints() {
    self.wordTableImage.snp.makeConstraints { make in
      make.top.equalTo(self.wordCartView.snp.top).offset(0)
      make.bottom.equalTo(self.wordCartView).offset(0)
      make.leading.equalTo(self.view.snp.leading).offset(70)
      make.trailing.equalTo(self.view.snp.trailing).offset(-70)
    }
  }
  fileprivate func  pasButtonConstraints() {
    self.pasButton.snp.makeConstraints { make in
      make.bottom.equalTo(self.tabuButton.snp.bottom).offset(0)
      make.height.width.equalTo(90)
      make.trailing.equalTo(self.tabuButton.snp.leading).offset(-20)
    }
  }

  fileprivate func  tabuButtonConstraints() {
    self.tabuButton.snp.makeConstraints { make in
      make.bottom.equalTo(self.view.snp.bottom).offset(-30)
      make.height.width.equalTo(100)
      make.centerX.equalTo(self.view).offset(0)
    }
  }
  fileprivate func  trueButtonConstraints() {
    self.trueButton.snp.makeConstraints { make in
      make.bottom.equalTo(self.tabuButton.snp.bottom).offset(0)
      make.height.width.equalTo(90)
      make.leading.equalTo(self.tabuButton.snp.trailing).offset(20)
    }
  }
  fileprivate func  animationViewConstraints() {
    self.animationView.snp.makeConstraints { make in
      make.centerX.equalTo(self.wordCartView.snp.trailing).offset(0)
      make.centerY.equalTo(self.wordCartView.snp.bottom).offset(0)
      make.height.width.equalTo(80)
    }
  }
  fileprivate func  timeLabelConstraints() {
    self.timeLabel.snp.makeConstraints { make in
      make.centerX.equalTo(self.view.snp.centerX).offset(0)
      make.top.equalTo(self.view.snp.top).offset(view.bounds.height/6-60)
      make.height.width.equalTo(120)
    }
  }
  fileprivate func  tabuLabelConstraints() {
    self.tabuLabel.snp.makeConstraints { make in
      make.centerY.equalTo(self.wordCartView.snp.centerY).offset(0)
      make.centerX.equalTo(self.wordCartView.snp.centerX).offset(0)
    }
  }
  fileprivate func  playAndStopButtonConstraints() {
    self.playAndStopButton.snp.makeConstraints { make in
      make.top.equalTo(self.view.snp.top).offset(view.bounds.height/6-25)
      make.trailing.equalTo(self.view.snp.trailing).offset(-50)
      make.width.height.equalTo(50)
    }
  }
  fileprivate func  homeButtonConstraints() {
    self.homeButton.snp.makeConstraints { make in
      make.top.equalTo(self.view.snp.top).offset(35)
      make.leading.equalTo(self.view.snp.leading).offset(15)
      make.width.height.equalTo(30)
    }
  }
  fileprivate func  passCountLabelConstraints() {
    self.passCountLabel.snp.makeConstraints { make in
      make.top.equalTo(self.pasButton.snp.top).offset(7)
      make.leading.equalTo(self.pasButton.snp.leading).offset(7)
      make.width.height.equalTo(26)
    }
  }
  fileprivate func  scoreLabelConstraints() {
    self.scoreLabel.snp.makeConstraints { make in
      make.centerY.equalTo(self.timeLabel.snp.centerY).offset(0)
      make.leading.equalTo(self.view.snp.leading).offset(10)
      make.trailing.equalTo(self.timeLabel.snp.leading).offset(-15)
      make.height.equalTo(90)
    }
  }
}
extension GameViewController : UITableViewDelegate,UITableViewDataSource {

  fileprivate func  setTableView() {
    self.wordTableView.dataSource = self
    self.wordTableView.delegate = self
    self.wordTableView.separatorStyle = .none
    self.wordTableView.register(UINib(nibName: "WordsTableViewCell", bundle: nil), forCellReuseIdentifier: "WordsTableViewCell")
  }

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
