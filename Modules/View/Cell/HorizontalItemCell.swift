//
//  HorizontalItemCell.swift
//  SBINri
//
//  Created by Admin on 12/12/20.
//

import UIKit

class HorizontalItemCell: UICollectionViewCell {
    static let reuseIdentifer = "horizontal_identifier"
    let titleLabel = UILabel()
    let imageCountLabel = UILabel()
    let featuredPhotoView = UIImageView()
    let contentContainer = UIView()

    var title: String? {
      didSet {
        configure()
      }
    }

    var totalNumberOfImages: Int? {
      didSet {
        configure()
      }
    }

    var featuredPhotoURL: String? {
      didSet {
        configure()
      }
    }

    override init(frame: CGRect) {
      super.init(frame: frame)
      configure()
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }

  extension HorizontalItemCell {
    func configure() {
      contentContainer.translatesAutoresizingMaskIntoConstraints = false

      contentView.addSubview(featuredPhotoView)
      contentView.addSubview(contentContainer)

      featuredPhotoView.translatesAutoresizingMaskIntoConstraints = false
      if let featuredPhotoURL = featuredPhotoURL {
        featuredPhotoView.image = UIImage(named: featuredPhotoURL)
      }
      featuredPhotoView.layer.cornerRadius = 4
      featuredPhotoView.clipsToBounds = true
      contentContainer.addSubview(featuredPhotoView)

      titleLabel.translatesAutoresizingMaskIntoConstraints = false
      titleLabel.text = title
      titleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
      titleLabel.adjustsFontForContentSizeCategory = true
      contentContainer.addSubview(titleLabel)

      imageCountLabel.translatesAutoresizingMaskIntoConstraints = false
      if let totalNumberOfImages = totalNumberOfImages {
        imageCountLabel.text = "\(totalNumberOfImages) photos"
      }
      imageCountLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
      imageCountLabel.adjustsFontForContentSizeCategory = true
      imageCountLabel.textColor = .placeholderText
      contentContainer.addSubview(imageCountLabel)

      let spacing = CGFloat(10)
      NSLayoutConstraint.activate([
        contentContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        contentContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        contentContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
        contentContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

        featuredPhotoView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
        featuredPhotoView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
        featuredPhotoView.topAnchor.constraint(equalTo: contentContainer.topAnchor),

        titleLabel.topAnchor.constraint(equalTo: featuredPhotoView.bottomAnchor, constant: spacing),
        titleLabel.leadingAnchor.constraint(equalTo: featuredPhotoView.leadingAnchor),
        titleLabel.trailingAnchor.constraint(equalTo: featuredPhotoView.trailingAnchor),

        imageCountLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
        imageCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
        imageCountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        imageCountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
      ])
    }
  }
