//
//  PhotoTableViewCell.swift
//  NASA_Project
//
//  Created by Said Alır on 16.02.2021.
//

import UIKit
import Kingfisher

class PhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImageView.layer.shadowColor = UIColor.black.cgColor
        photoImageView.layer.shadowRadius = 5.0
        photoImageView.layer.shadowOpacity = 0.8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(_ urlString: String) {
        let url = URL(string: urlString)
        guard self.photoImageView != nil else {
            return
        }
        self.photoImageView.kf.indicatorType = .activity
        self.photoImageView.kf.setImage(with: url)
    }
    
}
