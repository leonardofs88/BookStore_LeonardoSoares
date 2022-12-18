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
    // In a more complex code, this instatiation can be moved into an App Container (Singleton)
    fileprivate lazy var viewModel: MainShelfViewModel = MainShelfViewModel(service: BookStoreService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.register(UINib(nibName: "BookCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: BookCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: "BookLargeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: BookLargeCollectionViewCell.identifier)
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        }
        
        self.loadData()
    }
    
    fileprivate func loadData() {
        self.viewModel.loadData() {
            
        }
    }
    
    fileprivate func getNumberOfSections() -> Int {
        if let numberOfItems = dataSource?.count {
            return numberOfItems/2
        }
        return 0
    }
    
    /// Mark: Collection View Delegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // For this example purpose, it must be more elaborated for a real product
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.identifier, for: indexPath) as? BookCollectionViewCell {
                return cell
            }
            
        default:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookLargeCollectionViewCell.identifier, for: indexPath) as? BookLargeCollectionViewCell {
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.getNumberOfSections()
    }
}
