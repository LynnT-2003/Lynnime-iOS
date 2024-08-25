//
//  ViewController.swift
//  AnimeList-Demo
//
//  Created by Lynn Thit Nyi Nyi on 25/8/2567 BE.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        let request = LNRequest(
//            endpoint: .latestAnime
//        )
//        print(request.url!)
        
//        LNService.shared.execute(.listLatestAnimesRequests, expecting: LNGetAllLatestAnimeResponse.self) { result in
//            switch result {
//            case .success(let model):
//                print(model)
//            case .failure(let error):
//                print(String(describing: error))
//            }
//        }
        LNService.shared.execute(.listLatestAnimesRequests, expecting: LNGetAllLatestAnimeResponse.self) { result in
            switch result {
            case .success(let model):
                print(model.data.count)
                for anime in model.data {
                    print(anime.titleEnglish)
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }

        
    }


}

