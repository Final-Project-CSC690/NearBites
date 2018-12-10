//
//  AnnotationInfo.swift
//  NearBites
//
//  Created by Simon on 12/9/18.
//  Copyright © 2018 Paul Ancajima. All rights reserved.
//

import UIKit
import MapKit
import CDYelpFusionKit

class AnnotationLauncher : NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    var businessesReturned : Businesses!
    var currBusiness : CDYelpBusiness!
    var annotationView: MKAnnotationView!
    var currBusinessInfo : [String]!
    let cellId = "cellId"
    let blackView = UIView()
    let collectionView: UICollectionView =
    {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    
    func showInfo()
    {
        setCurrBusiness()
        if let window = UIApplication.shared.keyWindow
        {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            window.addSubview(blackView)
            blackView.frame = window.frame
            blackView.alpha = 0
            
            window.addSubview(collectionView)
            let height: CGFloat = 300
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations:{
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                }, completion: nil)
        }
        var name : String = currBusiness.name!
        var address : String = (currBusiness.location?.addressOne)!
        var city : String = (currBusiness.location?.city)!
        var state : String = (currBusiness.location?.state)!
        var zip : String = (currBusiness.location?.zipCode)!
        var fulladdress : String = address + ", " + city + " " + state + ", " + zip
       // var phone

        currBusinessInfo = [name, fulladdress]
        collectionView.reloadData()
    }
    
    @objc func handleDismiss(_ recognizer: UITapGestureRecognizer)
    {
        self.blackView.alpha = 0
        
        if let window = UIApplication.shared.keyWindow{
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }, completion: nil)
        }
    }
    
    func setCurrBusiness()
    {
        for businesses in self.businessesReturned!.businesses
        {
            if ((annotationView.annotation?.title)!! == businesses.name)
            {
                self.currBusiness = businesses
                return
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return currBusinessInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! InfoCell
        let info = currBusinessInfo[indexPath.item]
        cell.info = info
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override init()
    {
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(InfoCell.self, forCellWithReuseIdentifier: cellId)
    }
}
