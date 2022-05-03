//
//  CustomTableCell.swift
//  UnsplashPhotoApp
//
//  Created by Amir on 30.04.2022.
//

import UIKit

class CustomTableCell: UITableViewCell {
    
    private lazy var imageViewCell: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 20)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Public methods
extension CustomTableCell {
    func configure(with photo: Photo?) {
        guard let photo = photo else { return }
        guard let url = photo.urls?.thumb else { return }
        guard let url = URL(string: url) else { return }
        getImage(from: url) { result in
            switch result {
            case .success(let image):
                self.imageViewCell.image = image
            case .failure(let error):
                print(error)
            }
        }
        nameLabel.text = photo.user?.name
        
    }
}

// MARK: - Private methods
extension CustomTableCell {
    private func setupView() {
        contentView.addSubview(imageViewCell)
        contentView.addSubview(nameLabel)
        configureConstraints()
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            imageViewCell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageViewCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            imageViewCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            imageViewCell.widthAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: imageViewCell.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    private func getImage(from url: URL, completion: @escaping(Result<UIImage, Error>) -> Void) {
        
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
