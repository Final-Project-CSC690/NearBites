//
//  AnnotationInfoCell.swift
//  NearBites
//
//  Created by Simon on 12/10/18.
//  Copyright © 2018 Paul Ancajima. All rights reserved.
//

import UIKit

class ImageCell : BaseCell
{
    override var isHighlighted: Bool {
        didSet{
            
            let orange = UIColor(displayP3Red: 1, green: 0.592157, blue: 0.0588235, alpha: 1)
            let blue = UIColor(displayP3Red: 0.26309, green: 0.359486, blue: 0.445889, alpha: 1)
            
            backgroundColor = isHighlighted ? orange : blue
            nameLabel.textColor = isHighlighted ? .white : .black
            iconImageView.tintColor = isHighlighted ? .white : .black
        }
    }
    var info: Info? {
        didSet {
            nameLabel.text = info?.name
            if let imageName = info?.imageName {
                iconImageView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
                iconImageView.tintColor = .black
            }
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func setupViews() {
        addSubview(nameLabel)
        addSubview(iconImageView)
        
        addConstraintsWithFormat(format: "H:|-8-[v0(20)]-8-[v1]|", views: iconImageView, nameLabel)
        
        addConstraintsWithFormat(format: "V:|[v0]|", views: nameLabel)
        
        addConstraintsWithFormat(format: "V:[v0(20)]", views: iconImageView)

        addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}


class TextCell : BaseCell
{
    var info: Info? {
        didSet {
                nameLabel.text = info?.name
            }
        }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(nameLabel)
        addConstraintsWithFormat(format: "H:|-8-[v0]|", views: nameLabel)
        addConstraintsWithFormat(format: "V:|[v0]|", views: nameLabel)
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
