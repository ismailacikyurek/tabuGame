//
//  CustomViewModel.swift
//  tabu
//
//  Created by İSMAİL AÇIKYÜREK on 4.07.2023.
//

import Foundation

protocol CustomViewModelProtocol {
  func saveUserDefaults(roundTime : Int,roundCount : Int,passCount : Int)
  func saveUserDefaultsVibration(vibration : Bool)
  func saveUserDefaultsVolume(value : Float)
}



final class CustomViewModel{
  var viewController = CustomViewController()

}

extension CustomViewModel : CustomViewModelProtocol {
  func saveUserDefaults(roundTime : Int,roundCount : Int,passCount : Int) {
    UserDefaults.setTimeRound(second: roundTime)
    UserDefaults.setNumberofRounds(number: roundCount)
    UserDefaults.setRightofPass(number: passCount)
    NotificationCenter.default.post(name: Notification.Name(rawValue: "custom_changed"), object: nil,userInfo: nil)
  }

  func saveUserDefaultsVibration(vibration : Bool) {
    UserDefaults.setVabilition(value: vibration)
  }

  func saveUserDefaultsVolume(value : Float) {
    var volumeUserInfo = ["volume" : value/2]
    UserDefaults.setMusicVolume(value: value/2)
    NotificationCenter.default.post(name: Notification.Name(rawValue: "volume_value"), object: nil,userInfo: volumeUserInfo)
  }
}
