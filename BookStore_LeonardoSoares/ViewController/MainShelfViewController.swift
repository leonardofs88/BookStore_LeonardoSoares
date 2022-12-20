//
//  MainShelfViewController.swift
//  BookStore_LeonardoSoares
//
//  Created by Leonardo Soares on 17/12/22.
//

import Foundation
import UIKit
import SwiftSpinner

class MainShelfViewController: UICollectionViewController {
    
    // In a more complex code, this instatiation can be moved into an App Container (Singleton)
    fileprivate lazy var viewModel: MainShelfViewModel = MainShelfViewModel(service: BookStoreService())
    fileprivate var isLoading = false
    fileprivate var isFilterActive = false
    
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
        SwiftSpinner.show("Loading")
        self.isLoading = true
        self.viewModel.loadData() { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.isLoading = false
                SwiftSpinner.hide()
            }
        }
    }
    
    @IBAction func favorite(_ sender: Any) {
        if !isFilterActive {
            isFilterActive = true
            SwiftSpinner.show("Loading")
            viewModel.filterFavorites() { [weak self] in
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    SwiftSpinner.hide()
                }
            }
        } else {
            isFilterActive = false
            loadData()
        }
    }
    
    /// Mark: Collection View Delegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // For this example purpose, it must be more elaborated for a real product
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.identifier, for: indexPath) as? BookCollectionViewCell {
                if let thumbURL = self.viewModel.getBook(for: indexPath)?.volumeInfo.imageLinks?.smallThumbnail,
                   let URL = URL(string: thumbURL.replacingOccurrences(of: "http", with: "https")) {
                    self.viewModel.getImage(from: URL) { image in
                        DispatchQueue.main.async {
                            cell.imageView.image = image
                        }
                    }
                }
                
                if let isFav = self.viewModel.getBook(for: indexPath)?.isFav {
                    cell.favoriteButton.setImage(UIImage(systemName: "heart\(isFav ? ".fill" : "")"), for: .normal)
                }
                
                cell.titleLabel.text = self.viewModel.getBook(for: indexPath)?.volumeInfo.title
                return cell
            }
            
        default:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookLargeCollectionViewCell.identifier, for: indexPath) as? BookLargeCollectionViewCell {
                if let thumbURL = self.viewModel.getBook(for: indexPath)?.volumeInfo.imageLinks?.smallThumbnail,
                   let URL = URL(string: thumbURL.replacingOccurrences(of: "http", with: "https")) {
                    self.viewModel.getImage(from: URL) { image in
                        DispatchQueue.main.async {
                            cell.imageView.image = image
                        }
                    }
                }
                
                if let isFav = self.viewModel.getBook(for: indexPath)?.isFav {
                    cell.favoriteButton.setImage(UIImage(systemName: "heart\(isFav ? ".fill" : "")"), for: .normal)
                }
                
                cell.titleLabel.text = self.viewModel.getBook(for: indexPath)?.volumeInfo.title
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.viewModel.numberOfSections
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == self.viewModel.numberOfSections - 1, !isLoading, !isFilterActive {
            self.loadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = self.viewModel.buildViewController(for: indexPath) {
            vc.delegate = self
            self.navigationController?.present(vc, animated: true)
        }
    }
}

extension MainShelfViewController: FavButtonDelegate {
    func favoritedAction() {
        collectionView.reloadData()
    }
}
