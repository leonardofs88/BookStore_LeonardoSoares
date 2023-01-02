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
    fileprivate var isLoading: Bool = false
    fileprivate var isFilterActive: Bool = false
    fileprivate var paginationIndex: Int = 0
    
    @IBOutlet weak var favButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
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
        isLoading = true
        viewModel.loadData(pagination: paginationIndex) { [weak self] error in
            guard let self = self else { return }
            if let errorToDisplay = error {
                DispatchQueue.main.async {
                    self.alert(errorToDisplay)                    
                }
            } else {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.paginationIndex += 20
                    self.isLoading = false
                    SwiftSpinner.hide()
                }
            }
        }
    }
    
    fileprivate func alert(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.loadData()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func favorite(_ sender: Any) {
        if !isFilterActive {
            isFilterActive = true
            SwiftSpinner.show("Loading")
            viewModel.hasFilter = true
            viewModel.loadData() { [weak self] error in
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    self?.favButton.title = "Clear Filter"
                    self?.favButton.image = nil
                    SwiftSpinner.hide()
                }
            }
        } else {
            isFilterActive = false
            self.favButton.title = nil
            self.favButton.image = UIImage(systemName: "heart.fill")
            viewModel.hasFilter = false
            loadData()
        }
    }
    
    /// Mark: Collection View Delegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == (viewModel.numberOfSections - 1) {
            return viewModel.numberOfItems % 2 == 0 ? 2 : 1
        }
        
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // For this example purpose, it must be more elaborated for a real product
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.identifier, for: indexPath) as? BookCollectionViewCell {
                if let thumbURL = self.viewModel.getBook(for: indexPath)?.volumeInfo.imageLinks?.smallThumbnail,
                   let URL = URL(string: thumbURL.replacingOccurrences(of: "http", with: "https")) {
                    self.viewModel.getImage(from: URL) { [weak self] image, error in
                        if let errorToDisplay = error {
                            self?.alert(errorToDisplay)
                        } else {
                            DispatchQueue.main.async {
                                cell.imageView.image = image
                            }
                        }
                    }
                }
                
                if let isFav = viewModel.getBook(for: indexPath)?.isFav {
                    if isFav {
                        cell.favoriteButton.isHidden = false
                        cell.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    } else {
                        cell.favoriteButton.isHidden = true
                    }
                }
                
                cell.titleLabel.text = viewModel.getBook(for: indexPath)?.volumeInfo.title
                return cell
            }
            
        default:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookLargeCollectionViewCell.identifier, for: indexPath) as? BookLargeCollectionViewCell {
                if let thumbURL = viewModel.getBook(for: indexPath)?.volumeInfo.imageLinks?.smallThumbnail,
                   let URL = URL(string: thumbURL.replacingOccurrences(of: "http", with: "https")) {
                    viewModel.getImage(from: URL) { [weak self] image, error in
                        if let errorToDisplay = error {
                            self?.alert(errorToDisplay)
                        } else {
                            DispatchQueue.main.async {
                                cell.imageView.image = image
                            }
                        }
                    }
                }
                
                if let isFav = viewModel.getBook(for: indexPath)?.isFav {
                    if isFav {
                        cell.favoriteButton.isHidden = false
                        cell.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                    } else {
                        cell.favoriteButton.isHidden = true
                    }
                }
                
                cell.titleLabel.text = viewModel.getBook(for: indexPath)?.volumeInfo.title
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfSections
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == viewModel.numberOfSections - 1, !isLoading, !isFilterActive {
            self.loadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = viewModel.buildViewController(for: indexPath) {
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
