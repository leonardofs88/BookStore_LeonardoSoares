//
//  MainShelfViewController.swift
//  BookStore_LeonardoSoares
//
//  Created by Leonardo Soares on 17/12/22.
//

import Foundation
import UIKit

class MainShelfViewController: UICollectionViewController {
    
    fileprivate var dataSource: [Book]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.register(UINib(nibName: "BookCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: BookCollectionViewCell.identifier)
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.identifier, for: indexPath) as? BookCollectionViewCell {
            return cell
        }
        
        return UICollectionViewCell()
    }
}
