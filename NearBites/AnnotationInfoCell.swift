//
//  AnnotationInfoCell.swift
//  NearBites
//
//  Created by Simon on 12/10/18.
//  Copyright © 2018 Paul Ancajima. All rights reserved.
//

import UIKit

class InfoCell : BaseCell
{
    var info: String? {
        didSet {
                nameLabel.text = info
            }
        }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Setting"
        return label
    }()
    
//    let iconImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "phone")
//        imageView.contentMode = .scaleAspectFill
//        return imageView
//    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(nameLabel)
//        addSubview(iconImageView)
        
        addConstraintsWithFormat(format: "H:|-8-[v0]|", views: nameLabel)
        
        addConstraintsWithFormat(format: "V:|[v0]|", views: nameLabel)
        
//        addConstraintsWithFormat(format: "V:[v0(20)]", views: iconImageView)
//
//        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}

class BaseCell : UICollectionViewCell
{
    override init(frame: CGRect)
    {
        super.init(frame : frame)
        setupViews()
    }
     
    func setupViews()
    {
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
