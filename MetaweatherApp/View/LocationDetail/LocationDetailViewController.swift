//
//  LocationDetailViewController.swift
//  MetaweatherApp
//
//  Created by Daniel Duran Schutz on 17/06/21.
//

import Foundation
import NVActivityIndicatorView
import UIKit
import MapKit

class LocationDetailViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewBack: UIView!
    @IBOutlet weak var activeBody: UIView!
    @IBOutlet weak var inactiveHeader: UIView!
    @IBOutlet weak var todayWeatherIconView: UIView!
    @IBOutlet weak var weatherLocationTitle: UILabel!
    @IBOutlet weak var weatherTempContainerView: UIView!
    @IBOutlet weak var weatherLocationTempLabel: UILabel!
    @IBOutlet weak var weatherTempIcon: UIImageView!
    @IBOutlet weak var dateOnBoardLabel: UILabel!
    @IBOutlet weak var windSpeedContainerView: UIView!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windSpeedIcon: UIImageView!
    @IBOutlet weak var humidityContainerView: UIView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var humidityIcon: UIImageView!
    @IBOutlet weak var userSmokeImage: UIImageView!
    @IBOutlet weak var layerOrnamentImageProfile: UIView!
    @IBOutlet weak var todaysWeatherIcon: UIImageView!
    @IBOutlet weak var headerWeatherName: UILabel!
    @IBOutlet weak var headerWeatherButton: UIButton!
    @IBOutlet weak var headerWeatherImageView: UIImageView!
    @IBOutlet weak var headerIconContainerView: UIView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet var weatherPronosticStackView: UIStackView!
    @IBOutlet weak var topConstraintCounters: NSLayoutConstraint!
    
    var newHeightHeader:CGFloat!
    let maxHeaderHeight: CGFloat = 300
    let minHeaderHeight: CGFloat = 44
    var previousScrollOffset: CGFloat = 0
    var minLocationDetailCellHeight:CGFloat = 414
        
    private var locationSearchModel: LocationSearchModel?
    private var locationDetailViewModel: LocationDetailViewModelProtocol?
    private var weatherTodayObject: WeatherModel?
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backButton()
        setupViewModel()
        setupDelegates()
        registerTableViewCells()
        setHeaderBehavior(headerActive: false)
        setupStackViewFeatures()
        setHeaderViewConfig()
        setColoredBackHeader()
        getWeatherToday()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDefaultStateViews()
    }
}

extension LocationDetailViewController {
    func setControllerData(locationSearchModel: LocationSearchModel){
        self.locationSearchModel = locationSearchModel
        self.title = "Weather in \(locationSearchModel.title)"
    }
    
    func setupViewModel(){
        let locationDetailViewModel = LocationDetailViewModel()
        NetworkService.get.afSessionManager = AFSessionManager()
        locationDetailViewModel.networkService = NetworkService.get
        locationDetailViewModel.delegate = self
        self.locationDetailViewModel = locationDetailViewModel as LocationDetailViewModelProtocol
    }
    
    func setupDelegates(){
        tableView.delegate = self
        tableView.dataSource = self
        mapView.delegate = self
    }
    
    func setHeaderData(tapFromBar: Bool = false) {
        if let weatherLocationObject = locationDetailViewModel?.weatherLocationDetail.first, let todaysWeather = locationDetailViewModel?.todaysWeather {
            let locationDetailFacade = LocationDetailsVCFacade(vc: self,
                                                               weatherLocationObject: weatherLocationObject, todaysWeather: todaysWeather, locationDetailViewModel: locationDetailViewModel as! LocationDetailViewModelProtocol)
            locationDetailFacade.setHeaderData(tapFromBar: tapFromBar)
        }
    }
    
    func setDefaultStateViews(){
        //Pending refactor
        self.weatherLocationTitle.isHidden = true
        self.weatherLocationTitle.layer.cornerRadius = weatherLocationTitle.bounds.height / 2
        self.weatherTempContainerView.layer.cornerRadius = weatherTempContainerView.bounds.height / 2
        self.windSpeedContainerView.layer.cornerRadius = windSpeedContainerView.bounds.height / 2
        self.humidityContainerView.layer.cornerRadius = humidityContainerView.bounds.height / 2
        self.headerIconContainerView.layer.cornerRadius = headerIconContainerView.bounds.height / 2
        headerWeatherName.isHidden = true
        headerIconContainerView.isHidden = true
        
    }
    
    func registerTableViewCells(){
        tableView.register(UINib(nibName: "WeatherLocationDetailsTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "WeatherLocationDetailsTableViewCell")
        tableView.register(UINib(nibName: "SelectedWeatherDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectedWeatherDetailsTableViewCell")
        tableView.register(UINib(nibName: "WeatherLocationSourcesTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherLocationSourcesTableViewCell")
    }
    
    func getWeatherLocationDetail(woeid: String){
        locationDetailViewModel?.getWeatherLocationDetail(woeid: woeid) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .Success(_, _):
                self.reloadAll()
            case .Error(let message, let statusCode):
                print("Error \(message) \(statusCode ?? 0)")
                UIAlertController.init(title: "getWeatherLocationDetail Error \(statusCode)", message: message, preferredStyle: .alert)
            }
        }
        
    }
    
    func getWeatherToday(){
        if let woeid = self.locationSearchModel?.woeid.description {
            let queryString = "\(woeid)/\(Date().getTodaysDateString(format: "yyyy/MM/dd"))"
            locationDetailViewModel?.getWeatherByDate(woeidPlusDateString: queryString) { [weak self]
                (result) in
                guard let self = self else { return }
                switch result {
                case .Success(_, _):
                    print("EXITO")
                    self.getWeatherLocationDetail(woeid: woeid)
                case .Error(let message, let statusCode):
                    print("Error \(message) \(statusCode ?? 0)")
                    UIAlertController.init(title: "getWeatherToday Error \(statusCode)", message: message, preferredStyle: .alert)
                    
                }
            }
        }
    }
    
    func reloadAll(tapFromBar: Bool = false){
        self.setHeaderData(tapFromBar: tapFromBar)
        self.headerView.layoutIfNeeded()
        self.tableView?.reloadData()
    }
    
}
extension LocationDetailViewController: LocationDetailViewModelDelegate {
    func onSelectedWeather() {
        reloadAll(tapFromBar: true)
    }
    
}

extension LocationDetailViewController: MKMapViewDelegate {}

extension LocationDetailViewController: UITableViewDelegate {
    
    func canAnimateHeader (_ scrollView: UIScrollView) -> Bool {
        let scrollViewMaxHeight = scrollView.frame.height + self.headerViewHeight.constant - minHeaderHeight
        return scrollView.contentSize.height > scrollViewMaxHeight
    }
    
    func setScrollPosition() {
        self.tableView.contentOffset = CGPoint(x:0, y: 0)
    }
}

extension LocationDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch indexPath.section {
        case 0:
            cell = getSelectedWeatherDetailsTableViewCell()
        case 1:
            cell = getWeatherLocationDetailsTableViewCell()
        default:
            cell = getWeatherLocationSourcesTableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            minLocationDetailCellHeight = 500
        case 1:
            minLocationDetailCellHeight = 370
        default:
            minLocationDetailCellHeight = 0
        }
        
        return minLocationDetailCellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        return footerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
}

extension LocationDetailViewController {
    
    func getWeatherLocationDetailsTableViewCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherLocationDetailsTableViewCell") as? WeatherLocationDetailsTableViewCell else { return UITableViewCell() }
        
        if let weatherLocationObject = locationDetailViewModel?.weatherLocationDetail.first {
            cell.setValuesToWeatherDetails(weatherLocationModel: weatherLocationObject)
        }
        
        return cell
    }
    
    func getSelectedWeatherDetailsTableViewCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedWeatherDetailsTableViewCell") as? SelectedWeatherDetailsTableViewCell else { return UITableViewCell() }
        guard let weather = locationDetailViewModel?.getSelectedWeather() else { return UITableViewCell() }
        cell.setDataValuesFromModel(weather: weather)
        
        return cell
    }
    
    func getWeatherLocationSourcesTableViewCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherLocationSourcesTableViewCell") as? WeatherLocationSourcesTableViewCell else { return UITableViewCell() }
        return cell
    }
    
}

extension LocationDetailViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollDiff = (scrollView.contentOffset.y - previousScrollOffset)
        let isScrollingDown = scrollDiff > 0
        let isScrollingUp = scrollDiff < 0
        if canAnimateHeader(scrollView) {
            newHeightHeader = headerViewHeight.constant
            
            if isScrollingDown {
                newHeightHeader = max(minHeaderHeight, headerViewHeight.constant - abs(scrollDiff))
            } else if isScrollingUp {
                newHeightHeader = min(maxHeaderHeight, headerViewHeight.constant + abs(scrollDiff))
            }
            
            if newHeightHeader != headerViewHeight.constant {
                headerViewHeight.constant = newHeightHeader
                setScrollPosition()
                previousScrollOffset = scrollView.contentOffset.y
                if headerViewHeight.constant == minHeaderHeight {
                    setHeaderBehavior(headerActive: true)
                }else{
                    setHeaderBehavior(headerActive: false)
                }
    
//               let originFrame = weatherPronosticStackView.frame
//                if newHeightHeader <= maxHeaderHeight - footerView.frame.height{
//                    weatherPronosticStackView.frame = self.inactiveHeader.frame
//                }else{
//                    weatherPronosticStackView.frame = originFrame
//                }
                
                if newHeightHeader <= maxHeaderHeight - (footerView.frame.height + todayWeatherIconView.frame.height){
                    todayWeatherIconView.fadeOut()
                    weatherLocationTitle.fadeOut()
                }else{
                    todayWeatherIconView.fadeIn()
                    weatherLocationTitle.fadeIn()
                }
                                                
            }
        }
    }

    
    func setHeaderBehavior(headerActive: Bool = false){
        inactiveHeader.backgroundColor = UIColor.init(red: 0/255, green: 33/255, blue: 58/255, alpha: 1.0)
        setWeatherIconSettings()

        if headerActive {
            inactiveHeader.isHidden = false
            inactiveHeader.fadeIn()

            headerView.clipsToBounds = false
    
        }else {
            inactiveHeader.fadeOut()
            inactiveHeader.isHidden = true
            
            headerView.clipsToBounds = true
  
        }
        
    }
    
    func setWeatherIconSettings(){
        self.todayWeatherIconView.clipsToBounds = true
//        self.todayWeatherIconView.layer.borderWidth = 1.0
//        self.todayWeatherIconView.layer.borderColor = UIColor.gray.cgColor.copy(alpha: 0.1)
        self.todayWeatherIconView.layer.cornerRadius = todayWeatherIconView.frame.height / 2
        self.todayWeatherIconView.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.9)
        self.userSmokeImage.clipsToBounds = true
        self.userSmokeImage.layer.cornerRadius = self.userSmokeImage.frame.height / 2
        
        self.todaysWeatherIcon.clipsToBounds = true
        self.todaysWeatherIcon.layer.cornerRadius = self.todaysWeatherIcon.frame.height / 2
        
        
//        self.layerOrnamentImageProfile.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.4)
        self.layerOrnamentImageProfile.clipsToBounds = true
//        self.layerOrnamentImageProfile.layer.borderColor = UIColor.white.cgColor.copy(alpha: 0.9)
//        self.layerOrnamentImageProfile.layer.borderWidth = 1.0
        
        self.layerOrnamentImageProfile.layer.cornerRadius = self.layerOrnamentImageProfile.frame.height / 2
        
    }
    
    func setHeaderViewConfig(){
        headerView.clipsToBounds = true
        headerView.layer.cornerRadius = 25
        headerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    func setColoredBackHeader(){
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.headerView.frame.height)
        layer.colors = [UIColor.init(red: 105/255, green: 72/255, blue: 243/255, alpha: 1.0).cgColor, UIColor.init(red: 125/255, green: 74/255, blue: 244/255, alpha: 1.0).cgColor, UIColor.init(red: 143/255, green: 75/255, blue: 241/255, alpha: 1.0).cgColor]
        headerViewBack.clipsToBounds = true
        headerViewBack.layer.addSublayer(layer)
    }
    
    func setupStackViewFeatures(){
        weatherPronosticStackView.backgroundColor = UIColor.init(white: 1.0, alpha: 0.1)
        weatherPronosticStackView.clipsToBounds = true
        weatherPronosticStackView.layer.cornerRadius = 16
        
    }
}
