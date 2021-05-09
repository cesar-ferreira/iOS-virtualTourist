//
//  MyCollectionViewCell.swift
//  virtual tourist
//
//  Created by Altran3496 on 08/05/21.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    static let reuseIdentifier = "MyCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    public func configureCollectionCell(with url: String) {
        self.imageView.downloaded(from: url)
    }

    static func nib() -> UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
}
