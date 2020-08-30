//
//  CollectionViewCell.swift
//  scrollingMonths
//
//  Created by Jawaher Alagel on 8/30/20.
//  Copyright © 2020 Jawaher Alaggl. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var textLabel: UILabel!
    static let identifier =  "CollectionViewCell"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    public func configure(with text: String ) {
        textLabel.text = text
        textLabel.textColor = .white
        textLabel.font = UIFont.systemFont(ofSize: 20.0)
        
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "CollectionViewCell", bundle: nil)
    }
    
}
