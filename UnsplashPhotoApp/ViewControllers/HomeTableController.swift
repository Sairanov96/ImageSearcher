//
//  HomeTableController.swift
//  UnsplashPhotoApp
//
//  Created by Amir on 29.04.2022.
//

import UIKit

class HomeTableController: UIViewController {
    
    private var photos: [Photo] = []
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        searchBar.sizeToFit()
        searchBar.setShowsCancelButton(false, animated: false)
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CustomCollectionCell.self, forCellWithReuseIdentifier: CustomCollectionCell.identifier)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPhotos()
        setupView()
    }

}

// MARK: - Private methods
extension HomeTableController {
    private func setupView() {
        view.addSubview(collectionView)
        view.backgroundColor = .white
        navigationItem.titleView = searchBar
        
        configureConstraints()
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func fetchPhotos() {
        NetworkManager.shared.fetchRandomPhoto { result in
            switch result {
            case .success(let photos):
                self.photos = photos
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - UICollectionViewDataSource
extension HomeTableController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionCell.identifier, for: indexPath) as? CustomCollectionCell else { return UICollectionViewCell() }
        let photo = photos[indexPath.row]
        cell.configure(with: photo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let reviewViewController = InfoViewController()
        reviewViewController.modalPresentationStyle = .fullScreen
        let photo = photos[indexPath.row]
        reviewViewController.configureImageView(with: photo)
        self.navigationController?.pushViewController(reviewViewController, animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout, UICollectionViewDelegate
extension HomeTableController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.frame.size.width
        return .init(width: collectionWidth / 3,
                     height: collectionWidth / 3)
    }
}

//MARK: - UISearchBarDelegate
extension HomeTableController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text?.replacingOccurrences(of: " ", with: "") ?? ""
        NetworkManager.shared.fetchSearchPhoto(with: searchText) { result in
            switch result {
            case .success(let photos):
                self.photos = photos.results
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}
