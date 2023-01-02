//
//  BookDetailViewController.swift
//  BookStore_LeonardoSoares
//
//  Created by Leonardo Soares on 17/12/22.
//

import Foundation
import UIKit

protocol FavButtonDelegate: AnyObject {
    func favoritedAction()
}

class BookDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var favButton: UIButton!
    
    weak var delegate: FavButtonDelegate?
    
    var viewModel: BookDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadData()
    }
    
    fileprivate func loadData() {
        if let thumbURL = viewModel?.book?.volumeInfo.imageLinks?.thumbnail,
           let URL = URL(string: thumbURL.replacingOccurrences(of: "http", with: "https")) {
            self.viewModel?.getImage(from: URL) { [weak self] image, error in
                if let errorToDisplay = error {
                    DispatchQueue.main.async {
                        self?.alert(errorToDisplay)                        
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                    }
                }
            }
        }
        
        configureFavButton()
    }
    
    fileprivate func alert(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] action in
            self?.loadData()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func getNumberOfRows() -> Int {
        1
    }
    
    fileprivate func configureFavButton() {
        if let isFav = viewModel?.book?.isFav {
            favButton.setImage(UIImage(systemName: "heart\(isFav ? ".fill" : "")"), for: .normal)
        }
    }
    
    @IBAction func favButtonPressed(_ sender: UIButton) {
        if let bookID = viewModel?.book?.id, let isFav = viewModel?.book?.isFav {
            UserDefaults.standard.setValue(!isFav, forKey: bookID)
            sender.setImage(UIImage(systemName: "heart\(!isFav ? ".fill" : "")"), for: .normal)
            self.delegate?.favoritedAction()
        }
    }
}

extension BookDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let link = viewModel?.book?.saleInfo?.buyLink,
           let url = URL(string: link),
           indexPath.row == 3 {
            UIApplication.shared.open(url)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            if viewModel?.book?.volumeInfo.description != nil {
                return 120.0
            }
            return 0.0
        } else {
            return 43.5
        }
    }
}

extension BookDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath)
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Title"
            cell.detailTextLabel!.text =  viewModel?.book?.volumeInfo.title
        }
        if indexPath.row == 1 {
            cell.textLabel?.text = "Author(s)"
            cell.detailTextLabel!.text =  viewModel?.book?.volumeInfo.authors?.joined(separator: ", ")
        }
        if indexPath.row == 2 {
            cell.textLabel?.text = viewModel?.book?.volumeInfo.description
            cell.detailTextLabel!.text =  ""
        }
        if indexPath.row == 3 {
            var saleability = "No information"
            var detail = "Open in browser"
            switch viewModel?.book?.saleInfo?.saleability {
            case .available:
                saleability = "Buy link"
            case .free:
                saleability = "Buy for free"
            default:
                saleability = "Not available to buy"
                detail = ""
            }
            
            cell.textLabel?.text = saleability
            cell.detailTextLabel?.text = detail
        }
        return cell
    }
    
}
