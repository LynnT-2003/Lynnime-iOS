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
    @IBOutlet weak var trailerWebView: WKWebView!
    
    var anime: Anime?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Details"

        guard let anime = anime else { return }
        let imageUrlString = anime.images.jpg.largeImageURL
        let imageUrl = URL(string: imageUrlString)
        image.kf.setImage(with: imageUrl, placeholder: UIImage(named: "placeholder_image"))
        
        // Set the anime details
        name.text = anime.titleEnglish ?? anime.titleJapanese
        animeDescription.text = anime.synopsis
        rank.text = "Rank: #" + String(describing: anime.rank ?? 0)
        score.text = "Score: " + String(describing: anime.score ?? 0)
        popularity.text = "Popularity: " + String(describing: anime.popularity ?? 0)
        
        // Load the trailer URL
        if let trailerUrlString = anime.trailer?.embedURL ?? anime.trailer?.url {
            let modifiedUrlString = modifyAutoplayParameter(for: trailerUrlString, autoplay: 0)
            if let myURL = URL(string: modifiedUrlString) {
                let myRequest = URLRequest(url: myURL)
                trailerWebView.load(myRequest)
            }
        }
    }
    
    func modifyAutoplayParameter(for url: String, autoplay: Int) -> String {
        // Check if the URL contains an autoplay parameter
        if url.contains("autoplay=") {
            // Replace the existing autoplay parameter
            return url.replacingOccurrences(of: "autoplay=1", with: "autoplay=\(autoplay)")
        } else {
            // Append the autoplay parameter if it's not present
            return url.contains("?") ? "\(url)&autoplay=\(autoplay)" : "\(url)?autoplay=\(autoplay)"
        }
    }
}
