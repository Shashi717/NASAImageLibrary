//
//  MediaDetailViewController.swift
//  NASAImageLibrary
//
//  Created by Shashi Liyanage on 2/24/24.
//

import UIKit

class MediaDetailViewController: UIViewController {
    @IBOutlet var mediaDetailView: MediaDetailView!

    var viewModel: MediaDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func loadView() {
        super.loadView()

        // configure the view with view model that is injected
        mediaDetailView.configure(viewModel)
    }

    @IBAction func doneButtonTapped(_ sender: Any) {
        // dismiss the detail with when the done button tapped
        self.dismiss(animated: true)
    }
}
