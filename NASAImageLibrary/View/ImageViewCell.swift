//
//  ImageViewCell.swift
//  NASAImageLibrary
//
//  Created by Shashi Liyanage on 2/24/24.
//

import UIKit

class ImageViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!

    var viewModel: MediaDetailViewModel? {
        didSet {
            viewModel?.delegate = self
        }
    }
}

extension ImageViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()

        // set image to nil for reusing
        imageView.image = nil
    }
}

extension ImageViewCell: MediaDetailViewModelDelegate {
    func didUpdate() {
        Task {
            await MainActor.run {
                // reset the image view if the view model has an update
                imageView.image = viewModel?.thumbnail
            }
        }
    }
}
