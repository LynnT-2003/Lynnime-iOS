//
//  ViewController.swift
//  AnimeList-Demo
//
//  Created by Lynn Thit Nyi Nyi on 25/8/2567 BE.
//

import UIKit
import Kingfisher

class AnimeCollectionViewController: UIViewController {
    
    @IBOutlet weak var AnimeListTableView: UITableView!
    @IBOutlet weak var sortingSegmentedControl: UISegmentedControl!
    
    var animeList: [Anime] = []
    
    enum SortingOption {
        case popularity
        case rank
    }

    
    // Enum to specify the request type
    enum AnimeRequestType {
        case latest
        case upcoming
    }
    
    // Property to store the request type
    var requestType: AnimeRequestType = .latest
    
    // Property to store the current sorting option
    var sortingOption: SortingOption = .popularity
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AnimeListTableView.delegate = self
        AnimeListTableView.dataSource = self
        
        sortingSegmentedControl.setTitle("Popularity", forSegmentAt: 0)
        sortingSegmentedControl.setTitle("Rank", forSegmentAt: 1)
        
        // Fetch data based on the request type
        switch requestType {
        case .latest:
            fetchLatestAnimes()
            self.navigationItem.title = "Latest Animes"
        case .upcoming:
            fetchUpcomingAnimes()
            self.navigationItem.title = "Upcoming Animes"
        }
        
        
        // Set the initial sorting option in segmented control
        sortingSegmentedControl.selectedSegmentIndex = 0
        
    }
    
    @IBAction func sortingOptionChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            sortingOption = .popularity
            animeList.sort { ($0.popularity ?? 0) < ($1.popularity ?? 0) }
        case 1:
            sortingOption = .rank
            animeList.sort { $0.rank ?? 0 < $1.rank ?? 0}
        default:
            break
        }
        AnimeListTableView.reloadData()
            AnimeListTableView.reloadData()
    }
    
    
    private func fetchLatestAnimes() {
        LNService.shared.execute(.listLatestAnimesRequests, expecting: LNGetAllLatestAnimeResponse.self) { result in
            switch result {
            case .success(let model):
                print(model.data.count)
                self.animeList = model.data
                
                // Reload the table view on the main thread
                DispatchQueue.main.async {
                    self.AnimeListTableView.reloadData()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    private func fetchUpcomingAnimes() {
        LNService.shared.execute(.listUpcomingAnimesRequests, expecting: LNGetAllUpcomingAnimeResponse.self) { result in
            switch result {
            case .success(let model):
                print(model.data.count)
                self.animeList = model.data
                
                // Reload the table view on the main thread
                DispatchQueue.main.async {
                    self.AnimeListTableView.reloadData()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
}



extension AnimeCollectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LNLatestAnimeTableViewCell
        cell.animeName.text = animeList[index].titleEnglish ?? animeList[index].titleJapanese
        cell.animeScore.text = "Score: " + String(describing: animeList[index].score ?? 0)
        cell.animeRank.text =  "Rank: #" + String(describing: animeList[index].rank ?? 0)
        cell.animeSypnosis.text = animeList[index].synopsis
        
        // Extract the image URL string safely
        let imageUrlString = animeList[index].images.jpg.largeImageURL
        
        // Create a URL from the string
        if let imageUrl = URL(string: imageUrlString) {
            // Use Kingfisher to load the image from the URL
            cell.animeImage.kf.setImage(with: imageUrl, placeholder: UIImage(named: "placeholder_image"))
        } else {
            // Use a placeholder image if the URL is invalid or missing
            cell.animeImage.image = UIImage(named: "placeholder_image")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)
    -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedAnime = animeList[indexPath.item]
        
        let detailPage = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "detailsPage") as! AnimeDetailsViewController
        
        detailPage.anime = selectedAnime
        
        // Navigate to DetailViewController
        navigationController?.pushViewController(detailPage, animated: true)
        
    }
    
    
}

