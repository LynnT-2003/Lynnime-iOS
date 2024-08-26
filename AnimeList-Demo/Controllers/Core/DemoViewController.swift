//
//  DemoViewController.swift
//  AnimeList-Demo
//
//  Created by Lynn Thit Nyi Nyi on 26/8/2567 BE.
//

import UIKit

class DemoViewController: UIViewController {
    
    var latestAnimeList: [Anime] = []
    
    @IBOutlet weak var AnimeCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AnimeCollectionView.delegate = self
        AnimeCollectionView.dataSource = self
        
        // Do any additional setup after loading the view.
        LNService.shared.execute(.listLatestAnimesRequests, expecting: LNGetAllLatestAnimeResponse.self) { result in
            switch result {
            case .success(let model):
                print(model.data.count)
                for anime in model.data {
                    print(anime.titleEnglish ?? "No title available")
                }
                self.latestAnimeList = model.data
                
                // Reload the collection view on the main thread
                DispatchQueue.main.async {
                    self.AnimeCollectionView.reloadData()
                }
                
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
}

extension DemoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == AnimeCollectionView {
            return latestAnimeList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let index = indexPath.item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DemoCollectionViewCell
        let anime = latestAnimeList[index]
        
        // Extract the image URL string safely
        let imageUrlString = anime.images.jpg.largeImageURL
        
        // Create a URL from the string
        if let imageUrl = URL(string: imageUrlString) {
            // Use Kingfisher to load the image from the URL
            cell.image.kf.setImage(with: imageUrl, placeholder: UIImage(named: "placeholder_image"))
        } else {
            // Use a placeholder image if the URL is invalid or missing
            cell.image.image = UIImage(named: "placeholder_image")
        }
        
        cell.name.text = anime.titleEnglish
        return cell
    }
    
    
}



// Implement the UICollectionViewDelegateFlowLayout methods
extension DemoViewController: UICollectionViewDelegateFlowLayout {
    
    // Define the size for each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Example: setting width to 128 and height to 192
        return CGSize(width: 128, height: 270)
    }
    
    // Optional: Adjust spacing between cells (if needed)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Adjust as needed
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Adjust as needed
    }
}
