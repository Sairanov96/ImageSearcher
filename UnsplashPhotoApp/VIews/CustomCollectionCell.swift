//
//  CustomCell.swift
//  UnsplashPhotoApp
//
//  Created by Amir on 30.04.2022.
//

import UIKit

final class CustomCollectionCell: UICollectionViewCell {
    
    static let identifier = "CustomCollectionViewCell"
    
    private let padding = 2.0
    
    private var imageURL: URL? {
        didSet {
            imageView.image = nil
            updateImage()
        }
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Public methods
extension CustomCollectionCell {
    func configure(with photo: Photo) {
        guard let url = photo.urls else { return }
        imageURL = URL(string: url.thumb)
    }
}

//MARK: - Private Methods
extension CustomCollectionCell {
    private func setupView() {
        contentView.addSubview(imageView)
        contentView.backgroundColor = .black
        configureConstraints()
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
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
}

