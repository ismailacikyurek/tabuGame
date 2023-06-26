//
//  AppDelegate.swift
//  tabu
//
//  Created by İSMAİL AÇIKYÜREK on 22.06.2023.
//

import UIKit
import AVFoundation
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var AudioPlayer = AVAudioPlayer()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

//MUSIC
    NotificationCenter.default.addObserver(self, selector: #selector(changedVolme(_:)), name: Notification.Name(rawValue: "volume_value"), object: nil)


    let AssortedMusics = NSURL(fileURLWithPath: Bundle.main.path(forResource: "Nova", ofType: "mp3")!)
    AudioPlayer = try! AVAudioPlayer(contentsOf: AssortedMusics as URL)
    AudioPlayer.prepareToPlay()
    AudioPlayer.numberOfLoops = -1
    AudioPlayer.volume = UserDefaults.getMusicVolume() ?? 0.4
    AudioPlayer.play()
    return true
  }
  @objc func changedVolme(_ notification: NSNotification) {
    guard let value = notification.userInfo?["volume"] as? Float else {return}
    self.AudioPlayer.volume = value
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }


}

