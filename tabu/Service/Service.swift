//
//  Service.swift
//  tabu
//
//  Created by İSMAİL AÇIKYÜREK on 24.06.2023.
//

import Foundation

final class Service {

 static func fetchWords() -> WordsModelArray? {
    guard let sourcesURL = Bundle.main.path(forResource: "words", ofType: "json") else {
        fatalError("Could not find FlatColors.json")
    }
    let Url = URL(fileURLWithPath: sourcesURL)
    do {
      let data = try Data(contentsOf: Url)
      let json = try JSONDecoder().decode(WordsModel.self, from: data)
      return json.words.randomElement()
    } catch {
      print(error.localizedDescription)
    }
    return nil
  }

}
