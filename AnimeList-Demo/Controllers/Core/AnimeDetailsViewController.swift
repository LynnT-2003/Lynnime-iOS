//
//  AnimeDetailsViewController.swift
//  AnimeList-Demo
//
//  Created by Lynn Thit Nyi Nyi on 26/8/2567 BE.
//

import UIKit
import WebKit

class AnimeDetailsViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var animeDescription: UILabel!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var popularity: UILabel!
    
    var anime: Anime?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let anime = anime else { return }
        let imageUrlString = anime.images.jpg.largeImageURL
        let imageUrl = URL(string: imageUrlString)
        image.kf.setImage(with: imageUrl, placeholder: UIImage(named: "placeholder_image"))
        
        
        // Set the anime name
        name.text = anime.titleEnglish ?? anime.titleJapanese
        animeDescription.text = anime.synopsis
        rank.text = "Rank: #" + String(describing: anime.rank ?? 0)
        score.text = "Score: " + String(describing: anime.score ?? 0)
        popularity.text = "Popularity: " + String(describing: anime.popularity ?? 0)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


