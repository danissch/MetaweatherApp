//
//  SearchUtil.swift
//  MetaweatherApp
//
//  Created by Daniel Duran Schutz on 16/06/21.
//

import Foundation
import UIKit

class SearchUtil: UISearchBar {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.autoresizingMask = [.flexibleWidth]
        self.autoresizesSubviews = true
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func getSearchBar(delegate:UISearchBarDelegate) -> UISearchBar{
        self.delegate = delegate
        customizeSearchField()
        return self
    }
    
    fileprivate func customizeSearchField(){
        UISearchBar.appearance().setSearchFieldBackgroundImage(UIImage(), for: .normal)
        self.backgroundColor = UIColor.clear
        self.searchBarStyle = .minimal
        if let searchTextField = self.value(forKey: "searchField") as? UITextField {
            NSLayoutConstraint.activate([
                searchTextField.heightAnchor.constraint(equalToConstant: 50),
                searchTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
                searchTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                searchTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
            ])
            
            searchTextField.clipsToBounds = true
            searchTextField.layer.cornerRadius = (self.frame.height / 2) - 22
            searchTextField.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.92)
            
            searchTextField.placeholder = "Search"

        }
        
    }
        
        
    func setNoResultsMessageSearch(viewController:UIViewController){
        let alert = UIAlertController(title: "No results", message: "“Your search does not exist", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
        self.text = ""
    }
        
    
}
