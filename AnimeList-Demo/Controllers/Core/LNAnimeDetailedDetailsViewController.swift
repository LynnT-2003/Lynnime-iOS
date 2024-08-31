//
//  LNAnimeDetailedDetailsViewController.swift
//  AnimeList-Demo
//
//  Created by Lynn Thit Nyi Nyi on 1/9/2567 BE.
//

import UIKit

class LNAnimeDetailedDetailsViewController: UIViewController {
    
    var desc = "Hi"

    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        descriptionLabel.text = desc
        
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
