//
//  WordsTableViewCell.swift
//  tabu
//
//  Created by İSMAİL AÇIKYÜREK on 23.06.2023.
//

import UIKit

class WordsTableViewCell: UITableViewCell {

  @IBOutlet weak var wordLabel: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

  func loadData(data : String ) {
    self.wordLabel.text = data
  }
    
}
