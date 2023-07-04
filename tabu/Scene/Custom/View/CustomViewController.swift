//
//  CustomViewController.swift
//  tabu
//
//  Created by İSMAİL AÇIKYÜREK on 25.06.2023.
//

import UIKit
import AVFoundation

final class CustomViewController: UIViewController {

  @IBOutlet weak var mainView: UIView!
  @IBOutlet weak var separatorView: UIView!
  @IBOutlet weak var roundTimeView: UIView!
  @IBOutlet weak var passCountView: UIView!
  @IBOutlet weak var roundCountView: UIView!
  @IBOutlet weak var readyButton: UIButton!
  @IBOutlet weak var musicView: UIView!

  @IBOutlet weak var volumeSlider: UISlider!
  @IBOutlet weak var vibrationSwitch: UISwitch!
  @IBOutlet weak var rountTimeLabel: UILabel!
  @IBOutlet weak var roundCountLabel: UILabel!
  @IBOutlet weak var passCountLabel: UILabel!

   lazy var roundTime = 60
   lazy var roundCount = 2
   lazy var passCount = 2

  private lazy var viewModel : CustomViewModelProtocol = CustomViewModel()
  override func viewDidLoad() {
    super.viewDidLoad()

    self.roundTime = UserDefaults.getTimeRound() ?? 60
    self.roundCount = UserDefaults.getNumberofRounds() ?? 2
    self.passCount = UserDefaults.getRightofPass() ?? 2
    rountTimeLabel.text = "\(roundTime)"
    roundCountLabel.text = "\(roundCount)"
    passCountLabel.text = "\(passCount)"
    setupUI()
  }


  @IBAction func readyButtonTapped(_ sender: Any) {
    viewModel.saveUserDefaults(roundTime: roundTime, roundCount: roundCount, passCount: passCount)
    dismiss(animated: true)
  }

  @IBAction func infoButtonTapped(_ sender: UIButton) {
    switch sender.tag {
    case 0 :
      ToastMessage.showToastMessage(message: "Anlatıcının anlatma süresi",
                                    font: UIFont.systemFont(ofSize: 14),
                                    y: roundTimeView.frame.maxY, vc: self)
    case 1 :
      ToastMessage.showToastMessage(message: "Her oyuncu bir kez anlatıcı olduğunda bir rauntta tamamlanmış olur.",
                                    font: UIFont.systemFont(ofSize: 14),
                                    y: roundCountView.frame.maxY, vc: self)
    case 2 :
      ToastMessage.showToastMessage(message: "Anlatıcının her rauntta puan cezası almadan pas geçebileceği kelime sayısı",
                                    font: UIFont.systemFont(ofSize: 14),
                                    y: passCountView.frame.maxY, vc: self)
    default:
      print("")
    }

  }

  @IBAction func buttonTapped(_ sender: Any) {
    let button = sender as! UIButton
    switch button.tag {
    case 0 :
      //Round Süresi -10
      if roundTime < 70 {
      } else {
        roundTime -= 10
      }
    case 1 :
      //Round Süresi +10
      if roundTime > 170 {
      } else {
        roundTime += 10
      }
    case 2 :
      //Round Sayısı -1
      if roundCount < 2{
      } else {
        roundCount -= 1
      }
    case 3 :
      //Round Sayısı +1
      roundCount += 1
    case 4 :
      //pass hakkı -1
      if passCount < 1 {
      } else {
        passCount -= 1
      }
    case 5 :
      //pass hakkı +1
      passCount += 1

    default:
      print("")
    }
    self.rountTimeLabel.text = "\(roundTime)"
    self.roundCountLabel.text = "\(roundCount)"
    self.passCountLabel.text = "\(passCount)"
  }

  @IBAction func exitButtonTapped(_ sender: Any) {
    dismiss(animated: true)
  }
  @IBAction func switchChanged(_ sender: UISwitch) {

    if sender.isOn {
      viewModel.saveUserDefaultsVibration(vibration: true)
    } else {
      viewModel.saveUserDefaultsVibration(vibration: false)
    }
  }

  @IBAction func sliderVolume(_ sender: UISlider) {
    viewModel.saveUserDefaultsVolume(value: sender.value/2)
  }
}
extension CustomViewController : GeneralProtocol {
  func addView() {}
  func addTarget() {}
  func setupUI() {

    mainView.layer.masksToBounds = true
    mainView.layer.cornerRadius = 20
    roundTimeView.layer.masksToBounds = true
    roundTimeView.layer.cornerRadius = roundTimeView.frame.height/2
    passCountView.layer.masksToBounds = true
    passCountView.layer.cornerRadius = passCountView.frame.height/2
    roundCountView.layer.masksToBounds = true
    roundCountView.layer.cornerRadius = roundCountView.frame.height/2
    readyButton.layer.masksToBounds = true
    readyButton.layer.cornerRadius = readyButton.frame.height/2
    musicView.layer.masksToBounds = true
    musicView.layer.cornerRadius = view.frame.height/45.45
    vibrationSwitch.transform = CGAffineTransform(scaleX: 0.40, y: 0.40)
    volumeSlider.setThumbImage(UIImage(systemName: "music.note"), for: .normal)
    volumeSlider.tintColor = .label

    if UserDefaults.getVabilition() == true {
      self.vibrationSwitch.isOn = true
    }

    if UserDefaults.getMusicVolume() == nil {
      self.volumeSlider.value = 1
    } else {
      self.volumeSlider.value = UserDefaults.getMusicVolume()!
    }

  }
  func layoutUI() {}

}
