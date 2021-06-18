//
//  ListHeaderView.swift
//  MetaweatherApp
//
//  Created by Daniel Duran Schutz on 16/06/21.
//

import Foundation
import UIKit

class ListHeaderView: UIView {
    
    var customContainerViewHeader: UIView!
    var background:UIImageView!
    var containerBackground2:UIView!
    var mainTitle: UILabel!
    var headerSubSectionView:UIView!
    
    let height:CGFloat = 120
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addContainerViewHeader()
        addBackground2()
        addMainTitle()
        addHeaderSubSectionView()
        
        
        
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setConfigFromViewController(title:String, view:UIView) {
        setMainTitleConfig(title: title)
        setHeaderSubSectionView(view: view)
    }
    
    func setConfigFromTabBar(height:CGFloat){
        self.customContainerViewHeader.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height)
        self.background.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height)
        self.containerBackground2.frame =  CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height)
    }
    
    
    
    func addContainerViewHeader(){
        self.customContainerViewHeader = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height))
        self.background = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height))
        background.image = UIImage(named: "weatherBanner")
        self.customContainerViewHeader.addSubview(background)
        self.addSubview(customContainerViewHeader)
    }
    
    func addBackground2() {
        self.containerBackground2 = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height - 2))
        self.containerBackground2.backgroundColor = UIColor.white.withAlphaComponent(0.50)
        self.customContainerViewHeader.addSubview(containerBackground2)
        
    }
    
    func addMainTitle(){
        self.mainTitle = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 65))
        self.customContainerViewHeader.addSubview(mainTitle)
    }
    
    func addHeaderSubSectionView(){
        self.headerSubSectionView = UIView(frame: CGRect(x: 0, y: 45, width: UIScreen.main.bounds.width - 20, height: 60))
        self.customContainerViewHeader.addSubview(headerSubSectionView)
        
        self.headerSubSectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.headerSubSectionView.widthAnchor.constraint(equalToConstant: headerSubSectionView.frame.width),
            self.headerSubSectionView.heightAnchor.constraint(equalToConstant: 60),
            self.headerSubSectionView.bottomAnchor.constraint(equalTo: customContainerViewHeader.bottomAnchor, constant: -23),
            self.headerSubSectionView.centerXAnchor.constraint(equalTo: customContainerViewHeader.centerXAnchor)
        ])
    }
    
    
    func setMainTitleConfig(title:String){
        self.mainTitle.text = title
        self.mainTitle.textAlignment = .center
        self.mainTitle.font = UIFont(name: "Avenir", size: 20)
    }
    
    func setHeaderSubSectionView(view:UIView){
        view.frame = CGRect(x: headerSubSectionView.frame.origin.x, y: 0, width: headerSubSectionView.frame.width, height: view.frame.height)
        self.headerSubSectionView.addSubview(view)
    }
    
    
}
