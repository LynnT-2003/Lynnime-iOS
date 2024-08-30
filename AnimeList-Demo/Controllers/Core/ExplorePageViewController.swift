//
//  ExplorePageViewController.swift
//  AnimeList-Demo
//
//  Created by Lynn Thit Nyi Nyi on 26/8/2567 BE.
//

import UIKit

class FooterView: UICollectionReusableView {
    
    // Define a closure to handle button tap events
    var onButtonTapped: (() -> Void)?
    
    // Button to "View All"
    let viewAllButton: UIButton = {
        let button = UIButton(type: .system)
        
        // Create the SF Symbol image with a specific font size
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .bold) // Adjust size and weight
        let symbolImage = UIImage(systemName: "chevron.right", withConfiguration: symbolConfig)
        button.setImage(symbolImage, for: .normal) // Set the SF Symbol image
        
        button.backgroundColor = UIColor(white: 0.9, alpha: 0.5) // Light gray with less opacity
        button.setTitleColor(.black, for: .normal) // Text color for contrast
        button.layer.cornerRadius = 20 // Adjust for rounded corners
        button.layer.masksToBounds = true // Ensure rounded corners are visible
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(viewAllButton)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            viewAllButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            viewAllButton.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -40), // Adjust if needed
            viewAllButton.widthAnchor.constraint(equalToConstant: 40),
            viewAllButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Add target for button tap
        viewAllButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped() {
        onButtonTapped?()
    }
}


/// A view controller that manages and displays anime collections.
class ExplorePageViewController: UIViewController {
    
    var options: [String: String] = [
        "Action": "1",
        "Adventure": "2",
        "Comedy": "4",
        "Drama": "8",
        "Fantasy": "10",
        "Mystery": "7",
        "Romance": "22",
        "Sci-Fi": "24",
        "Award Winning": "46",
        "Slice of Life": "36",
        "Ecchi": "9",
        "Hentai": "12",
    ]

    var timer: Timer?
    var currentImageIndex: Int?
    
    /// List of the latest anime.
    var latestAnimeList: [Anime] = []
    var allLatestAnimeList: [Anime] = []
    
    /// List of upcoming anime.
    var upcomingAnimeList: [Anime] = []
    var allUpcomingAnimeList: [Anime] = []
    
    @IBOutlet weak var headerImageView: UIImageView!
    
    /// Collection view for displaying latest anime.
    @IBOutlet weak var animeCollectionView: UICollectionView!
    
    /// Collection view for displaying upcoming anime.
    @IBOutlet weak var upcomingAnimeCollectionView: UICollectionView!
    
    @IBOutlet weak var genreAnimeTableView: UITableView!
    
    
    @IBOutlet weak var genreAnimeButton: UIButton!
    
    var menuChildren: [UIMenuElement] = []
    var tableViewResult: [Anime] = []

    
    /// Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sortedGenreOptions = options.sorted { $0.key < $1.key }
        
        let actionClosure = { [weak self] (action: UIAction) in
            guard let self = self else { return }
            if let query = options[action.title] {  // Lookup the query using the title
                print("Selected genre: \(action.title) with query: \(query)")
                self.searchGenreAnime(query: query)  // Pass the query value to the search function
            } else {
                print("Query not found for selected genre: \(action.title)")
            }
        }
        
        var menuChildren: [UIAction] = []
        for (title, _) in sortedGenreOptions {
            menuChildren.append(UIAction(title: title, handler: actionClosure))
        }

        genreAnimeButton.menu = UIMenu(options: .displayInline, children: menuChildren)
        genreAnimeButton.showsMenuAsPrimaryAction = true
        genreAnimeButton.changesSelectionAsPrimaryAction = true
        
        if let actionQuery = options["Action"] {
            searchGenreAnime(query: actionQuery)
            print("Default genre fetched: Action")
        }
        
        // Set up the tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerImageTapped))
        headerImageView.isUserInteractionEnabled = true
        headerImageView.addGestureRecognizer(tapGesture)
        
        // NavigationItem Title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.title = "Explore Page"
        
        // Set up delegates and data sources for collection views.
        animeCollectionView.delegate = self
        animeCollectionView.dataSource = self
        
        upcomingAnimeCollectionView.delegate = self
        upcomingAnimeCollectionView.dataSource = self
        
        genreAnimeTableView.delegate = self
        genreAnimeTableView.dataSource = self
        
        animeCollectionView.register(FooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footerView")
        upcomingAnimeCollectionView.register(FooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footerView")
        
        
        // Fetch and display the latest anime list.
        LNService.shared.execute(.listLatestAnimesRequests, expecting: LNGetAllUpcomingAnimeResponse.self) { result in
            switch result {
            case .success(let model):
                // Trim the list to only include the first 5 items
                self.allLatestAnimeList = Array(model.data)
                self.latestAnimeList = Array(model.data.prefix(10))
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
                self.allUpcomingAnimeList = Array(model.data)
                self.upcomingAnimeList = Array(model.data.prefix(10))
                DispatchQueue.main.async {
                    self.startImageRotation(with: model.data)
                    self.genreAnimeTableView.reloadData()  // here
                    self.upcomingAnimeCollectionView.reloadData()
                }
                
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    func startImageRotation(with data: [Anime]) {
        
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            let randomIndex = Int.random(in: 0..<data.count)
            self.currentImageIndex = randomIndex
            let randomImageUrlString = data[randomIndex].images.jpg.largeImageURL
            if let randomImageUrl = URL(string: randomImageUrlString) {
                UIView.transition(with: self.headerImageView, duration: 0.7, options: .transitionCrossDissolve, animations: {
                    self.headerImageView.kf.setImage(with: randomImageUrl)
                }, completion: nil)
            }
        }
    }
    
    @objc func headerImageTapped() {
        guard let currentIndex = currentImageIndex else { return }
        let selectedAnime = allUpcomingAnimeList[currentIndex]
        
        let detailPage = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "detailsPage") as! AnimeDetailsViewController
        
        detailPage.anime = selectedAnime
        detailPage.navigationItem.largeTitleDisplayMode = .never
        
        // Navigate to DetailViewController
        navigationController?.pushViewController(detailPage, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Ensure the large title is displayed
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footerView", for: indexPath) as! FooterView
            
            // Configure the button tap closure based on the collection view
            footerView.onButtonTapped = {
                let detailPage = UIStoryboard(name: "Main", bundle: .main)
                    .instantiateViewController(withIdentifier: "animeCollectionPage") as! AnimeCollectionViewController
                
                // Check which collection view's button was tapped and set the request type
                if collectionView == self.animeCollectionView {
                    detailPage.requestType = .latest
                } else if collectionView == self.upcomingAnimeCollectionView {
                    detailPage.requestType = .upcoming
                }
                
                // Navigate to AnimeCollectionViewController
                self.navigationController?.pushViewController(detailPage, animated: true)
            }
            
            return footerView
        }
        return UICollectionReusableView()
    }
    
    private func searchGenreAnime(query: String) {
        let request = LNRequest.genreAnimeRequest(query: query)
        LNService.shared.execute(request, expecting: LNAnimeGetSearchResponse.self) { result in
            switch result {
            case .success(let genreSearchResults):
                print("Found anime:", query)
                for anime in genreSearchResults.data {
                    print(anime.titleEnglish ?? anime.titleJapanese)
                }
                self.tableViewResult = genreSearchResults.data
                
                DispatchQueue.main.async {
                    self.genreAnimeTableView.reloadData()
                }
            case .failure(let error):
                print("Failed to search anime: \(error)")
            }
        }
    }
    
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "View All", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
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
            detailPage.navigationItem.largeTitleDisplayMode = .never
            
            // Navigate to DetailViewController
            navigationController?.pushViewController(detailPage, animated: true)
            
        } else if collectionView == upcomingAnimeCollectionView {
            
            let selectedAnime = upcomingAnimeList[indexPath.item]
            
            let detailPage = UIStoryboard(name: "Main", bundle: .main)
                .instantiateViewController(withIdentifier: "detailsPage") as! AnimeDetailsViewController
            
            detailPage.anime = selectedAnime
            detailPage.navigationItem.largeTitleDisplayMode = .never
            
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 90, height: 270) // Adjust height as needed
    }
    
    
}

// MARK: - UITableViewDelegate

extension ExplorePageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        let index = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "genreAnimeCell") as! LNLatestAnimeTableViewCell
        cell.animeName.text = tableViewResult[index].titleEnglish ?? allUpcomingAnimeList[index].titleJapanese
        cell.animeScore.text = "Score: " + String(describing: tableViewResult[index].score ?? 0)
        cell.animeRank.text =  "Rank: #" + String(describing: tableViewResult[index].rank ?? 0)
        cell.animeSypnosis.text = tableViewResult[index].synopsis
        
        // Extract the image URL string safely
        let imageUrlString = tableViewResult[index].images.jpg.largeImageURL
        
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
    
}
