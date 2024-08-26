//
//  LNLatestAnimeTableViewCell.swift
//  AnimeList-Demo
//
//  Created by Lynn Thit Nyi Nyi on 26/8/2567 BE.
//

import UIKit

class LNLatestAnimeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var animeImage: UIImageView!
    @IBOutlet weak var animeName: UILabel!
    @IBOutlet weak var animeScore: UILabel!
    @IBOutlet weak var animeRank: UILabel!
    @IBOutlet weak var animePopularity: UILabel!
    @IBOutlet weak var animeSypnosis: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
