//
//  BookDetailViewController.swift
//  BookStore_LeonardoSoares
//
//  Created by Leonardo Soares on 17/12/22.
//

import Foundation
import UIKit

class BookDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var infoCell: UITableViewCell!
    
    internal var viewModel: BookDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        loadImage()
    }
    
    fileprivate func loadImage() {
        if let thumbURL = self.viewModel?.book?.volumeInfo.imageLinks?.thumbnail,
        let URL = URL(string: thumbURL.replacingOccurrences(of: "http", with: "https")) {
            self.viewModel?.getImage(from: URL) { image in
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    }
    
    fileprivate func getNumberOfRows() -> Int {
        1
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
            return 120.0
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
            cell.textLabel!.text = "Title"
            cell.detailTextLabel!.text =  viewModel?.book?.volumeInfo.title
        }
        if indexPath.row == 1 {
            cell.textLabel!.text = "Author(s)"
            cell.detailTextLabel!.text =  viewModel?.book?.volumeInfo.authors?.joined(separator: ", ")
        }
        if indexPath.row == 2 {
            cell.textLabel!.text = viewModel?.book?.volumeInfo.description
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
                saleability = "Not available"
                detail = ""
            }
            
            cell.textLabel!.text = saleability
            cell.detailTextLabel!.text = detail
        }
        return cell
    }
    
}
