//
//  ExplorePageViewController.swift
//  AnimeList-Demo
//
//  Created by Lynn Thit Nyi Nyi on 26/8/2567 BE.
//

import UIKit

/// A view controller that manages and displays anime collections.
class ExplorePageViewController: UIViewController {
    
    /// List of the latest anime.
    var latestAnimeList: [Anime] = []
    
    /// List of upcoming anime.
    var upcomingAnimeList: [Anime] = []
    
    /// Collection view for displaying latest anime.
    @IBOutlet weak var animeCollectionView: UICollectionView!
    
    /// Collection view for displaying upcoming anime.
    @IBOutlet weak var upcomingAnimeCollectionView: UICollectionView!
    
    /// Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up delegates and data sources for collection views.
        animeCollectionView.delegate = self
        animeCollectionView.dataSource = self
        
        upcomingAnimeCollectionView.delegate = self
        upcomingAnimeCollectionView.dataSource = self
        
        // Fetch and display the latest anime list.
        LNService.shared.execute(.listLatestAnimesRequests, expecting: LNGetAllUpcomingAnimeResponse.self) { result in
            switch result {
            case .success(let model):
                self.latestAnimeList = model.data
                DispatchQueue.main.async {
                    self.animeCollectionView.reloadData()
                }
                
            case .failure(let error):
                print(String(describing: error))
            }
        }
        
        // Fetch and display the upcoming anime list.
        LNService.shared.execute(.listUpcomingAnimesRequests, expecting: LNGetAllUpcomingAnimeResponse.self) { result in
            switch result {
            case .success(let model):
                self.upcomingAnimeList = model.data
                for anime in model.data {
                    print(anime.titleEnglish ?? anime.titleJapanese)
                }
                DispatchQueue.main.async {
                    self.upcomingAnimeCollectionView.reloadData()
                }
                
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

/// Extension to handle collection view data source and delegate methods.
extension ExplorePageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    /// Returns the number of items in the specified section of the collection view.
    /// - Parameters:
    ///   - collectionView: The collection view requesting this information.
    ///   - section: The section of the collection view.
    /// - Returns: The number of items in the specified section.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == animeCollectionView {
            return latestAnimeList.count
        } else if collectionView == upcomingAnimeCollectionView {
            return upcomingAnimeList.count
        }
        return 0
    }
    
    /// Returns the cell that is displayed at the specified index path.
    /// - Parameters:
    ///   - collectionView: The collection view requesting this information.
    ///   - indexPath: The index path specifying the location of the cell.
    /// - Returns: The cell to be displayed.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        
        if collectionView == animeCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DemoCollectionViewCell
            let anime = latestAnimeList[index]

            // Configure cell for latest anime.
            let imageUrlString = anime.images.jpg.largeImageURL
            if let imageUrl = URL(string: imageUrlString) {
                cell.image.kf.setImage(with: imageUrl, placeholder: UIImage(named: "placeholder_image"))
            } else {
                cell.image.image = UIImage(named: "placeholder_image")
            }
            cell.name.text = anime.titleEnglish ?? anime.titleJapanese

            return cell

        } else if collectionView == upcomingAnimeCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "upcomingCell", for: indexPath) as! DemoCollectionViewCell
            let anime = upcomingAnimeList[index]

            // Configure cell for upcoming anime.
            let imageUrlString = anime.images.jpg.largeImageURL
            if let imageUrl = URL(string: imageUrlString) {
                cell.image.kf.setImage(with: imageUrl, placeholder: UIImage(named: "placeholder_image"))
            } else {
                cell.image.image = UIImage(named: "placeholder_image")
            }
            cell.name.text = anime.titleEnglish ?? anime.titleJapanese
 
            return cell
        }

        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == animeCollectionView {
            
            let selectedAnime = latestAnimeList[indexPath.item]
            
            let detailPage = UIStoryboard(name: "Main", bundle: .main)
                .instantiateViewController(withIdentifier: "detailsPage") as! AnimeDetailsViewController
            
            detailPage.anime = selectedAnime
            
            // Navigate to DetailViewController
            navigationController?.pushViewController(detailPage, animated: true)
            
        } else if collectionView == upcomingAnimeCollectionView {
            
            let selectedAnime = upcomingAnimeList[indexPath.item]
            
            let detailPage = UIStoryboard(name: "Main", bundle: .main)
                .instantiateViewController(withIdentifier: "detailsPage") as! AnimeDetailsViewController
            
            detailPage.anime = selectedAnime
            
            // Navigate to DetailViewController
            navigationController?.pushViewController(detailPage, animated: true)
            
        }
        
        
        
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

/// Extension to handle collection view layout methods.
extension ExplorePageViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Example: setting width to 128 and height to 270.
        return CGSize(width: 128, height: 270)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Adjust as needed.
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Adjust as needed.
    }
    
    
}
