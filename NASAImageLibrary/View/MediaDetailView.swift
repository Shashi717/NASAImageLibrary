//
//  MediaDetailView.swift
//  NASAImageLibrary
//
//  Created by Shashi Liyanage on 2/24/24.
//

import UIKit

class MediaDetailView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var photographerLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    @IBOutlet weak var imageView: UIImageView!

    private var viewModel: MediaDetailViewModel?

    func configure(_ viewModel: MediaDetailViewModel) {
        self.viewModel = viewModel
        self.viewModel?.delegate = self
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        photographerLabel.text = viewModel.photographer
        locationLabel.text = viewModel.location
    }
}

extension MediaDetailView: MediaDetailViewModelDelegate {
    func didUpdate() {
        Task {
            await MainActor.run {
                // set the imageView image when the view model updates with the full image
                imageView.image = viewModel?.fullImage
            }
        }
    }
}
