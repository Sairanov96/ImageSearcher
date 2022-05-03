//
//  FavoriteViewController.swift
//  UnsplashPhotoApp
//
//  Created by Amir on 30.04.2022.
//

import UIKit
import RealmSwift

class FavoriteViewController: UIViewController {
    
    private let identifier = "cell"
    private var photos: Results<Photo>? = nil
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(updateData), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomTableCell.self, forCellReuseIdentifier: identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photos = StorageManager.shared.realm?.objects(Photo.self)
        setupView()
    }
}

// MARK: - Private methods
extension FavoriteViewController {
    private func setupView() {
        view.addSubview(tableView)
        tableView.addSubview(refreshControl)
        view.backgroundColor = .white
        configureConstraints()
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func updateData() {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}

// MARK: - UITableViewDataSource
extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let photosNumber = photos?.count else { return 0}
        return photosNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? CustomTableCell else { return UITableViewCell() }
        if let photo = photos?[indexPath.row] {
            cell.configure(with: photo)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reviewViewController = InfoViewController()
        reviewViewController.modalPresentationStyle = .fullScreen
        guard let photo = photos?[indexPath.row] else { return }
        reviewViewController.configureImageView(with: photo)
        self.navigationController?.pushViewController(reviewViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}
