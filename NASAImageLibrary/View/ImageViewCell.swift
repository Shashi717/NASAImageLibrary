//
//  ImageViewCell.swift
//  NASAImageLibrary
//
//  Created by Shashi Liyanage on 2/24/24.
//

import UIKit

class ImageViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!

}

extension ImageViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()

        // set image to nil for reusing
        imageView.image = nil
    }
}
