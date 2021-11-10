//
//  ResultsCell.swift
//  CandyImage
//
//  Created by Matt Thomas on 06/11/2021.
//

import UIKit

class ResultsCell: UICollectionViewCell {
    weak var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        let imgView = UIImageView(frame: .zero)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(imgView)
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width / 3) - 15),
            contentView.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width / 3) - 15),
            imgView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        self.imageView = imgView
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Interface Builder is not supported!")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        fatalError("Interface Builder is not supported!")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
