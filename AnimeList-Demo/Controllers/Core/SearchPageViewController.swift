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
    
    var searchTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the placeholder text
        if let magnifyingGlassImage = UIImage(systemName: "magnifyingglass") {
            // Create the attachment for the image
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = magnifyingGlassImage
            imageAttachment.bounds = CGRect(x: 0, y: -2, width: 20, height: 16) // Adjust the bounds as needed
            
            // Create an attributed string with the image and text
            let attributedString = NSMutableAttributedString(attachment: imageAttachment)
            let text = NSAttributedString(string: "  Search for anime..", attributes: [
                .font: UIFont.systemFont(ofSize: 16)
            ])
            attributedString.append(text)
            
            // Set the attributed placeholder
            searchBarTextField.attributedPlaceholder = attributedString
        }
        
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
    
    private func scheduleSearch(query: String) {
        // Invalidate the previous timer
        searchTimer?.invalidate()
        
        // Schedule a new timer
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.75, repeats: false, block: { [weak self] _ in
            self?.searchAnime(query: query)
        })
    }
}

extension SearchPageViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let updatedText = (text as NSString).replacingCharacters(in: range, with: string)
        
        // Cancel previous search and clear results if query is empty
        if updatedText.isEmpty {
            searchTimer?.invalidate()
            searchResult = [] // Clear search results
            DispatchQueue.main.async {
                self.searchResultTableView.reloadData()
            }
            return true
        }
        
        // Schedule the search when the text changes
        scheduleSearch(query: updatedText)
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
        cell.animeName.text = searchResult[index].titleEnglish ?? searchResult[index].titleJapanese
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
