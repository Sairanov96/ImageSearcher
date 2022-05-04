//
//  InfoViewController.swift
//  UnsplashPhotoApp
//
//  Created by Amir on 30.04.2022.
//

import UIKit
import RealmSwift

enum PhotoStatus: String {
    case favorite = "heart.fill"
    case unfavorite = "heart"
}

class InfoViewController: UIViewController {
    
    private var photoInfo: Photo!
    private var favoritePhoto: Results<Photo>? = nil
    private var imageName = ""
    
    private lazy var favoriteButton: UIBarButtonItem = {
        configureFavoriteButton()
        let favoriteButton = UIBarButtonItem(
            image: UIImage(systemName: self.imageName),
            style: .plain,
            target: self,
            action: #selector(addToFavorites)
        )
        return favoriteButton
    }()
    
    private lazy var info = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(showAlert))
    
    private var imageURL: URL? {
        didSet {
            imageView.image = nil
            updateImage()
        }
    }

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Public methods
extension InfoViewController {
    func configureImageView(with photo: Photo){
        guard let url = photo.urls else { return }
        imageURL = URL(string: url.small)
        photoInfo = photo
    }
}

// MARK: - Private methods
extension InfoViewController {
    private func setupView() {
        view.addSubview(imageView)
        view.backgroundColor = .white
        navigationItem.rightBarButtonItems = [favoriteButton, info]
        configureConstraints()
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func updateImage() {
        guard let imageURL = imageURL else { return }
        getImage(from: imageURL) { result in
            switch result {
            case .success(let image):
                if imageURL == self.imageURL {
                    self.imageView.image = image
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getImage(from url: URL, completion: @escaping(Result<UIImage, Error>) -> Void){
        NetworkManager.shared.fetchImage(from: url) { result in
            switch result {
            case .success(let imageData):
                guard let image = UIImage(data: imageData) else { return }
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    @objc func addToFavorites() {
        if imageName == PhotoStatus.unfavorite.rawValue {
            StorageManager.shared.save(photoInfo)
            favoriteButton.image = UIImage(systemName: PhotoStatus.favorite.rawValue)
            imageName = PhotoStatus.favorite.rawValue
        } else {
            StorageManager.shared.delete(photoInfo)
            favoriteButton.image = UIImage(systemName: PhotoStatus.unfavorite.rawValue)
            imageName = PhotoStatus.unfavorite.rawValue
        }
    }
    
    @objc func showAlert() {
        let name = photoInfo?.user?.name ?? "Unknown"
        let date = formatDate(from: photoInfo?.created_at)
        let location = photoInfo?.user?.location ?? "Unknown"
        let downloads = String(photoInfo?.downloads ?? 0)
        let message = "Name: \(name)\n Created at: \(date)\n Location: \(location)\n Downloads: \(downloads)"
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func formatDate(from string: String?) -> String {
        guard let string = string else { return "Unknown"}
        var convertedString = ""
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        let dateFormatterSet = DateFormatter()
        dateFormatterSet.dateFormat = "MMM dd, yyyy"
        dateFormatterSet.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = dateFormatterGet.date(from: string) else { return "" }
        convertedString = dateFormatterSet.string(from: date)
        
        return convertedString
    }
    
    private func configureFavoriteButton() {
        if let _ = StorageManager.shared.realm?.object(ofType: Photo.self, forPrimaryKey: photoInfo.id) {
            imageName = PhotoStatus.favorite.rawValue
        } else {
            imageName = PhotoStatus.unfavorite.rawValue
        }
    }
}
