//
//  ListCell.swift
//  DebugOverlay
//
//  Created by Pavel Kondrashkov on 11/19/20.
//

import UIKit

final class ListCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: ListCell.self)

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.minimumScaleFactor = 0.4
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    lazy var disclosureIndicatorImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage.bundled(named: "arrow_right")
        view.tintColor = .init(red: 0.235294, green: 0.235294, blue: 0.262745, alpha: 0.29)
        return view
    }()

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(
                withDuration: isHighlighted ? 0.3 : 0.1, delay: 0,
                options: [.allowUserInteraction],
                animations: {
                    self.contentView.alpha = self.isHighlighted ? 0.4 : 1
                },
                completion: nil
            )
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .groupTableViewBackground
        contentView.layer.cornerRadius = 8

        let titleStackView = UIStackView()
        titleStackView.axis = .vertical

        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleStackView)
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor),
            titleStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])

        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        subTitleLabel.setContentHuggingPriority(.required, for: .vertical)

        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(subTitleLabel)

        disclosureIndicatorImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(disclosureIndicatorImageView)
        NSLayoutConstraint.activate([
            disclosureIndicatorImageView.leadingAnchor.constraint(greaterThanOrEqualTo: titleStackView.trailingAnchor, constant: 8),
            disclosureIndicatorImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            disclosureIndicatorImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subTitleLabel.text = nil
    }
}
