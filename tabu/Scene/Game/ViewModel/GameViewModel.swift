//
//  GameViewModel.swift
//  tabu
//
//  Created by İSMAİL AÇIKYÜREK on 24.06.2023.
//

import Foundation

public enum teams : String {
  case redTeam = "redTeam"
  case blueTeam = "blueTeam"
}

protocol GameViewModelOutputProtocol : AnyObject {
  func fetchWord()
  func fetchScore(redTeamScore : Int, blueTeamScore: Int)
}
protocol GameViewModelProtocol : AnyObject {
  func nextWordCart()
  func scoreCalculator(count : Int, teamColor : teams )
  func fetchScore()
  func startTime()
  func musicVolume(_ valume : Float)
  func otherTeam()
}

final class GameViewModel {
  
  var viewController = GameViewController()
  weak var delegate : GameViewModelOutputProtocol?
  var datam : WordsModelArray?
  var wordStringArray = [String]()
  var blueTeamScore : Int = 0
  var redTeamScore : Int = 0


}


extension GameViewModel : GameViewModelProtocol {
  func nextWordCart() {
   DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
   guard let data = Service.fetchWords() else {return}
   self.wordStringArray.removeAll()
   self.wordStringArray.append(data.mainWord)
   self.wordStringArray.append(data.firstWord)
   self.wordStringArray.append(data.secondWord)
   self.wordStringArray.append(data.thirdWord)
   self.wordStringArray.append(data.fifthWord)
   self.wordStringArray.append(data.fourthWord)
   delegate?.fetchWord()
   }
 }

 func scoreCalculator(count : Int, teamColor : teams ) {
   redTeamScore = UserDefaults.getRedTeamScore()
   blueTeamScore = UserDefaults.getBlueTeamScore()
   if teamColor == .blueTeam {
     blueTeamScore += count
     UserDefaults.setBlueTeamScore(value: blueTeamScore)
   } else {
     redTeamScore += count
     UserDefaults.setRedTeamScore(value: redTeamScore)
   }
   fetchScore()
 }

 func fetchScore() {
   redTeamScore = UserDefaults.getRedTeamScore()
   blueTeamScore = UserDefaults.getBlueTeamScore()
   delegate?.fetchScore(redTeamScore: redTeamScore, blueTeamScore: blueTeamScore)
 }

 func startTime() {
   viewController.timer = Timer.scheduledTimer(timeInterval: 1.0, target: viewController, selector: #selector(viewController.fireTimer), userInfo: nil, repeats: true)
 }

 func musicVolume(_ valume : Float) {
   var volumeUserInfo = ["volume" : valume]
   NotificationCenter.default.post(name: Notification.Name(rawValue: "volume_value"), object: nil,userInfo: volumeUserInfo)
 }
  func otherTeam() {
   if UserDefaults.getWhichTeam() == teams.blueTeam.rawValue {
     UserDefaults.setWhichTeam(value: teams.redTeam.rawValue)
     let gameVC = ReadyViewController()
     gameVC.modalPresentationStyle = .fullScreen
     viewController.navigationController?.pushViewController(gameVC, animated: true)
   } else {
     UserDefaults.setWhichTeam(value: teams.blueTeam.rawValue)
     let gameVC = ReadyViewController()
     let whichRoundCount = UserDefaults.getWhichRound()
     UserDefaults.setWhichRound(value: whichRoundCount+1)
     gameVC.modalPresentationStyle = .fullScreen
     viewController.navigationController?.pushViewController(gameVC, animated: true)
   }
 }
}
