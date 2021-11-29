//
//  CollectionViewCell.swift
//  MaybeYes
//
//  Created by Nikita Nesporov on 17.09.2021.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
  
    @IBOutlet var imageCategory: UIImageView!
    
    @IBOutlet var categoryName: UILabel!
     
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGradientOverlay()
    }
     
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageCategory.image = nil
    }
     
    func setupCell(category: Category) {
        self.imageCategory.image = category.image
        self.categoryName.text = category.forLabel
    }
    
    func addGradientOverlay() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.imageCategory.bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        self.imageCategory.layer.addSublayer(gradientLayer)
        
        self.imageCategory.layer.masksToBounds = true
        self.imageCategory.layer.cornerRadius = self.imageCategory.frame.width / 12.0
    }
}
