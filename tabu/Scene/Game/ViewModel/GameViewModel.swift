//
//  GameViewModel.swift
//  tabu
//
//  Created by İSMAİL AÇIKYÜREK on 24.06.2023.
//

import Foundation

protocol GameViewModelProtocol : AnyObject {
  func fetchWord()
}
final class GameViewModel {
  var viewController = GameViewController()
  weak var delegate : GameViewModelProtocol?
  var datam : WordsModelArray?
  var wordStringArray = [String]()

  var isFirstTeam : Bool = true
  var blueTeamScore : Int = 0
  var redTeamScore : Int = 0
  var passCount : Int = 0

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

  func scoreCalculator(count : Int, teamColor : teamColor ) {
    if teamColor == .blueTeam {
      blueTeamScore += count
    } else {
      redTeamScore += count
     
    }
  }

  func startTime() {
    viewController.timer = Timer.scheduledTimer(timeInterval: 1.0, target: viewController, selector: #selector(viewController.fireTimer), userInfo: nil, repeats: true)
    viewController.startTime()
  }

}


enum teamColor {
  case redTeam
  case blueTeam
}
