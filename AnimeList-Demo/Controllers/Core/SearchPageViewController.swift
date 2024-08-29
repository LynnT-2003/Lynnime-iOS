//
//  SearchPageViewController.swift
//  AnimeList-Demo
//
//  Created by Lynn Thit Nyi Nyi on 30/8/2567 BE.
//

import UIKit

class SearchPageViewController: UIViewController {

    
    @IBOutlet weak var searchResultTableView: UITableView!
    @IBOutlet weak var searchBarTextField: UITextField!
    
    var searchResult: [Anime] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.title = "Search"
        
        searchBarTextField.delegate = self
        
        // Set up the table view
        searchResultTableView.dataSource = self
        searchResultTableView.delegate = self

        // Do any additional setup after loading the view.
        
    }
    
    private func searchAnime(query: String) {
        let request = LNRequest.searchAnimeRequest(query: query)
        LNService.shared.execute(request, expecting: LNAnimeGetSearchResponse.self) { result in
            switch result {
            case .success(let searchResults):
                print("Found anime: ")
                for anime in searchResults.data {
                    print(anime.titleEnglish ?? anime.titleJapanese)
                }
                self.searchResult = searchResults.data
                // Handle the search results (e.g., update UI)
                
                // Reload the table view with the new search results
                DispatchQueue.main.async {
                    self.searchResultTableView.reloadData()
                }
            case .failure(let error):
                print("Failed to search anime: \(error)")
             }
        }
    }
}

extension SearchPageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let query = textField.text, !query.isEmpty else {
            return false
        }
        searchAnime(query: query)
        textField.resignFirstResponder() // Hide the keyboard
        return true
    }
}

extension SearchPageViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LNLatestAnimeTableViewCell
        cell.animeName.text = searchResult[index].titleEnglish
        cell.animeScore.text = "Score: " + String(describing: searchResult[index].score ?? 0)
        cell.animeRank.text =  "Rank: #" + String(describing: searchResult[index].rank ?? 0)
        cell.animeSypnosis.text = searchResult[index].synopsis
        
        // Extract the image URL string safely
        let imageUrlString = searchResult[index].images.jpg.largeImageURL
        
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
        
        let selectedAnime = searchResult[indexPath.item]
        
        let detailPage = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "detailsPage") as! AnimeDetailsViewController
        
        detailPage.anime = selectedAnime
        
        // Navigate to DetailViewController
        navigationController?.pushViewController(detailPage, animated: true)
        
    }
    
}
