//
//  AnimeCollectionViewCell.swift
//  AnimeList-Demo
//
//  Created by Lynn Thit Nyi Nyi on 26/8/2567 BE.
//

import UIKit

class AnimeCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "AnimeCollectionViewCell"

    let animeImage: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(animeImage)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            animeImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            animeImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            animeImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            animeImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        // Optional: Add corner radius
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Configure cell with image
    func configure(with image: UIImage) {
        animeImage.image = image
    }
}

