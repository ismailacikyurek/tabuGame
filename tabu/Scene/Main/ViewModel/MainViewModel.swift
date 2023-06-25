//
//  MainViewModel.swift
//  tabu
//
//  Created by İSMAİL AÇIKYÜREK on 25.06.2023.
//

import Foundation

protocol MainViewModelProtocol : AnyObject {
  func customizationComplete()
}
class MainViewModel {
  var viewController = MainViewController()
  weak var delegate : MainViewModelProtocol?
}



