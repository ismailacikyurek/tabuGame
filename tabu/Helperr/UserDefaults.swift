//
//  UserDefaults.swift
//  tabu
//
//  Created by İSMAİL AÇIKYÜREK on 25.06.2023.
//

import Foundation

extension UserDefaults {

    // raound süresi
    public static func setTimeRound(second:Int?){
        UserDefaults.standard.set(second, forKey: "time_second")
        UserDefaults.standard.synchronize()
    }
    public static func getTimeRound() -> Int? {
        let second:Int? = UserDefaults.standard.value(forKey: "time_second") as! Int?
        return second
    }


    // raound sayısı
    public static func setNumberofRounds(number:Int?) {
        UserDefaults.standard.set(number, forKey: "number_of_rounds")
        UserDefaults.standard.synchronize()
    }
    public static func getNumberofRounds() -> Int? {
        let number:Int? = UserDefaults.standard.value(forKey: "number_of_rounds") as! Int?
        return number
    }


   //pas Hakkı
    public static func setRightofPass(number:Int?) {
        UserDefaults.standard.set(number, forKey: "rightof_pass")
        UserDefaults.standard.synchronize()
    }

    public static func getRightofPass() -> Int? {
        let number:Int? = UserDefaults.standard.value(forKey: "rightof_pass") as! Int?
        return number
    }

  //titreşim
   public static func setVabilition(value:Bool?) {
       UserDefaults.standard.set(value, forKey: "vabilition")
       UserDefaults.standard.synchronize()
   }

   public static func getVabilition() -> Bool? {
       let value:Bool? = UserDefaults.standard.value(forKey: "vabilition") as! Bool?
       return value
   }

  //Müzik Seviyesi
   public static func setMusicVolume(value:Float?) {
       UserDefaults.standard.set(value, forKey: "music_volume")
       UserDefaults.standard.synchronize()
   }

   public static func getMusicVolume() -> Float? {
       let value:Float? = UserDefaults.standard.value(forKey: "music_volume") as! Float?
       return value
   }

  //Sıra Hangi Takımda
  public static func setWhichTeam(value:String?) {
       UserDefaults.standard.set(value, forKey: "which_team")
       UserDefaults.standard.synchronize()
   }

   public static func getWhichTeam() -> String? {
       let value:String? = UserDefaults.standard.value(forKey: "which_team") as! String?
       return value
   }

  //mavi takım puan
   public static func setBlueTeamScore(value:Int) {
       UserDefaults.standard.set(value, forKey: "blue_team_score")
       UserDefaults.standard.synchronize()
   }

   public static func getBlueTeamScore() -> Int {
       let value:Int? = UserDefaults.standard.value(forKey: "blue_team_score") as! Int?
     return value ?? 0
   }

  //kırmızı takım puan
   public static func setRedTeamScore(value:Int) {
       UserDefaults.standard.set(value, forKey: "red_team_score")
       UserDefaults.standard.synchronize()
   }

   public static func getRedTeamScore() -> Int {
       let value:Int? = UserDefaults.standard.value(forKey: "red_team_score") as! Int?
     return value ?? 0
   }
  
  //kacıncı raounddayım
   public static func setWhichRound(value:Int) {
       UserDefaults.standard.set(value, forKey: "which_round")
       UserDefaults.standard.synchronize()
   }

   public static func getWhichRound() -> Int {
       let value:Int? = UserDefaults.standard.value(forKey: "which_round") as! Int?
     return value ?? 1
   }

}
