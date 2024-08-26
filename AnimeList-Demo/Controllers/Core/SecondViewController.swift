//
//  SecondViewController.swift
//  AnimeList-Demo
//
//  Created by Lynn Thit Nyi Nyi on 26/8/2567 BE.
//

import UIKit

class SecondViewController: UIViewController {

    var animeList: [Anime] = []
    
    @IBOutlet weak var detailCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupCollectionView()
        
        LNService.shared.execute(.listLatestAnimesRequests, expecting: LNGetAllLatestAnimeResponse.self) { result in
            switch result {
            case .success(let model):
                print(model.data.count)
                for anime in model.data {
                    print(anime.titleEnglish ?? "No title available")
                }
                self.animeList = model.data
            case .failure(let error):
                print(String(describing: error))
            }
        }

    }
    
    private func setupCollectionView() {
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
        detailCollectionView.collectionViewLayout = createCollectionViewLayout()
        
        detailCollectionView.register(AnimeCollectionViewCell.self, forCellWithReuseIdentifier: AnimeCollectionViewCell.reuseIdentifier)

    }

}

extension SecondViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .red
        cell.layer.cornerRadius = 8
        return cell
    }
}

extension SecondViewController: UICollectionViewDelegate {
    // Implement any delegate methods if needed
}


extension SecondViewController {
    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(128),
                    heightDimension: .absolute(128 * 1.5)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8)
            
            // Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(128),
                    heightDimension: .absolute(128 * 1.5)
                ),
                subitems: [item]
            )
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
            section.interGroupSpacing = 16

            // Center the group vertically within the section
            section.contentInsets = NSDirectionalEdgeInsets(
                top: (layoutEnvironment.container.effectiveContentSize.height - 192) / 2, // Centering calculation
                leading: 20,
                bottom: (layoutEnvironment.container.effectiveContentSize.height - 192) / 2,
                trailing: 20
            )
            
            return section
        }
    }
}
