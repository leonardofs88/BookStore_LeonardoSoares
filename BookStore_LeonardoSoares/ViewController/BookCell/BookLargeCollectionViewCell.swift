//
//  BookLargeCollectionViewCell.swift
//  BookStore_LeonardoSoares
//
//  Created by Leonardo Soares on 17/12/22.
//

import UIKit

class BookLargeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!

    public static let identifier = "BookLargeCollectionViewCell"
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = UIImage.init(systemName: "text.book.closed")
        self.titleLabel.text = ""
    }
    
}
