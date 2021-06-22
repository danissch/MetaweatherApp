//
//  LocationSearchViewController.swift
//  MetaweatherApp
//
//  Created by Daniel Duran Schutz on 16/06/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class LocationSearchViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var locationSearchViewModel: LocationSearchViewModelProtocol?
    
    let heightForHeader:CGFloat = 120
    let heightForCells:CGFloat = 90
    var searchView:SearchUtil?
    private let searchBarHeight:Int = 80
    
    private var isPullingUp = false
    private var loadingData = false
    private let preloadCount = 20
    private var _noFurtherData = false
    private var _page = -1
    var isSearching : Bool = false
    
    var window: UIWindow?
    var loading:NVActivityIndicatorView!
    var coverView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        registerViewsTableView()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            super.viewWillTransition(to: size, with: coordinator)
            if UIDevice.current.orientation.isLandscape {
                print("Landscape")

            } else {
                print("Portrait")
                
            }
        }

}

extension LocationSearchViewController {
    func registerViewsTableView(){
        let headernib = UINib(nibName: "ListHeaderView", bundle: nil)
        tableView.register(headernib, forHeaderFooterViewReuseIdentifier: "listHeaderView")
        
        tableView.register(UINib(nibName: "MetaweatherListTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "MetaweatherListTableViewCell")
        
        tableView.register(UINib(nibName:"NoRecordsFoundTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "NoRecordsFoundTableViewCell")
        
    }
    
    func setupViewModel(){
        let locationSearchViewModel = LocationSearchViewModel()
        NetworkService.get.afSessionManager = AFSessionManager()
        locationSearchViewModel.networkService = NetworkService.get
        self.locationSearchViewModel = locationSearchViewModel as LocationSearchViewModelProtocol
    }
    
    func searchLocation(toLookFor: String){
        self.locationSearchViewModel?.searchByTerm(termToSearch: toLookFor) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .Success(_, _):
//                    let filteredListCount = self.locationSearchViewModel?.filteredLocationSearchList.count
//                    let listCount = self.locationSearchViewModel?.locationSearchList.count
//                _ = self.isSearching ? filteredListCount : listCount
                self.tableView?.reloadData()
            case .Error(let message, let statusCode):
                print("Error \(message) \(statusCode ?? 0)")
            }
        }
    }
    
    
    
    
}

extension LocationSearchViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching{
            return locationSearchViewModel?.filteredLocationSearchList.count ?? 1
        }
        return self.locationSearchViewModel?.locationSearchList.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let listCount = isSearching ? locationSearchViewModel?.filteredLocationSearchList.count ?? 0 : locationSearchViewModel?.locationSearchList.count ?? 0

        if listCount == 0  {
            let noRowsCell = tableView.dequeueReusableCell(withIdentifier: "NoRecordsFoundTableViewCell", for: indexPath) as! NoRecordsFoundTableViewCell
            noRowsCell.noFoundLabel.text = ""
            return noRowsCell
        }
        
        guard let metaweatherListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MetaweatherListTableViewCell") as? MetaweatherListTableViewCell else {
            return UITableViewCell()
        }
        metaweatherListTableViewCell.selectedBackgroundView = setBackgroundCellView()
        
        if let viewModelItem = isSearching ? locationSearchViewModel?.filteredLocationSearchList[indexPath.row] : locationSearchViewModel?.locationSearchList[indexPath.row] {
            metaweatherListTableViewCell.setCellData(locationSearchModel: viewModelItem)
        }
        
        return metaweatherListTableViewCell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightForCells
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = ListHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: heightForHeader))
        headerView.setConfigFromViewController(title: "Location Search", view: addSearch() ?? UISearchBar())
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForHeader
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 70
        }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 70))
        footerView.backgroundColor = .clear
        return footerView
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if locationSearchViewModel?.locationSearchList.count == 0 { return }
        let list = isSearching ? locationSearchViewModel?.filteredLocationSearchList : locationSearchViewModel?.locationSearchList

        if let dataItem = list?[indexPath.row] {
            let vc = LocationDetailViewController.instantiateFromXIB() as LocationDetailViewController
            vc.setControllerData(locationSearchModel: dataItem)
            pushVc(vc, animated: true, navigationBarIsHidden: false)
        }
        
    }
    
    func setBackgroundCellView() -> UIView {
        let backGroundSelectedView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: heightForCells))
        let topColor = UIColor.init(red: 105/255, green: 185/255, blue: 227/255, alpha: 1.0).cgColor
        let bottomColor = UIColor.init(red: 151/255, green: 205/255, blue: 239/255, alpha: 1.0).cgColor
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: backGroundSelectedView.frame.height)
        layer.colors = [topColor, bottomColor]
        layer.locations = [0.0, 1.0]
        
        backGroundSelectedView.clipsToBounds = true
        backGroundSelectedView.layer.addSublayer(layer)
        return backGroundSelectedView
    }
}

extension LocationSearchViewController: UISearchBarDelegate{
    
    func addSearch() -> SearchUtil? {
        searchView = SearchUtil.init(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: searchBarHeight))
        searchView = searchView?.getSearchBar(delegate: self as UISearchBarDelegate) as? SearchUtil
        searchView?.resignFirstResponder()
        return searchView
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isEditing = true
        if searchBar.text == "" {
            searchLocation(toLookFor: "")
            self.tableView.reloadData()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isEditing = false
        if searchBar.text == "" {
            searchLocation(toLookFor: "")
            self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isEditing = false
        searchBar.text = ""
        self.tableView.reloadData()
        searchLocation(toLookFor: "")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isEditing = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            self.searchLocation(toLookFor: "")
            self.tableView.reloadData()
        } else {
            isEditing = true
            self.searchLocation(toLookFor: searchBar.text ?? "")
//            self.tableView.reloadData()
        }
        
    }
    
}

