//
//  ViewController.swift
//  NASAImageLibrary
//
//  Created by Shashi Liyanage on 2/24/24.
//

import UIKit

class ImageCollectionViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var mediaCollectionView: UICollectionView!

    private let imageCollectionViewModel = ImageCollectionViewModel(apiClient: APIClient(apiService: APIService()))

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        searchBar.placeholder = "Search Images"
        navigationItem.titleView = searchBar
        imageCollectionViewModel.delegate = self

        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: 100, height: 100)
        mediaCollectionView.collectionViewLayout = collectionViewLayout

        // load the initial items without a query
        imageCollectionViewModel.loadMediaItems()
    }
}

extension ImageCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCollectionViewModel.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageViewCell", for: indexPath) as? ImageViewCell, indexPath.row < imageCollectionViewModel.items.count {
            let mediaDetailViewModel = imageCollectionViewModel.items[indexPath.row]
            cell.viewModel = mediaDetailViewModel
            cell.imageView.image = mediaDetailViewModel.thumbnail
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        // navigate to detail view controller when a user taps on a cell
        if let mediaDetailViewController = storyboard?.instantiateViewController(identifier: "MediaDetailViewController") as? MediaDetailViewController, indexPath.row < imageCollectionViewModel.items.count {
            let mediaDetailViewModel = imageCollectionViewModel.items[indexPath.row]
            mediaDetailViewModel.loadFullImage()
            mediaDetailViewController.viewModel = mediaDetailViewModel

            // present with a custom animation
            let navController = UINavigationController(rootViewController: mediaDetailViewController)
            navController.modalPresentationStyle = .custom
            navController.transitioningDelegate = self
            present(navController, animated: true, completion: nil)
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !imageCollectionViewModel.items.isEmpty, indexPath.item > imageCollectionViewModel.items.count - 10 {
            // load next page if we scroll close to the bottom
            imageCollectionViewModel.loadNextPage()
        }
    }
}

extension ImageCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // use the search text to query media items
        imageCollectionViewModel.loadMediaItems(searchText)
    }
}

extension ImageCollectionViewController: ImageCollectionViewModelDelegate {
    func didUpdate() {
        Task {
            await MainActor.run {
                // reload collection view in main thread
                mediaCollectionView.reloadData()
            }
        }
    }
}

extension ImageCollectionViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomTransitionAnimator()
    }
}
