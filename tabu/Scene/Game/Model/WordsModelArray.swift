//
//  WordsModel.swift
//  tabu
//
//  Created by İSMAİL AÇIKYÜREK on 23.06.2023.
//

import Foundation

struct WordsModel : Decodable {
  var words : [WordsModelArray]

}
struct WordsModelArray : Decodable {
  var mainWord,firstWord,secondWord,thirdWord,fourthWord,fifthWord : String
}





