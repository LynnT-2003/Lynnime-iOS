//
//  LNAnimeDetailedDetailsViewController.swift
//  AnimeList-Demo
//
//  Created by Lynn Thit Nyi Nyi on 1/9/2567 BE.
//

import UIKit

class LNAnimeDetailedDetailsViewController: UIViewController {
    
    var desc = "Hi"

    
    @IBOutlet weak var allDetailsCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Desc: \(desc)")
        
        allDetailsCollection.delegate = self
        allDetailsCollection.dataSource = self
        
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

extension LNAnimeDetailedDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailedDetailsCell", for: indexPath) as! LNAnimeDetailedDetailsCollectionViewCell
        cell.desc.text = desc
        
        return cell
    }
}
