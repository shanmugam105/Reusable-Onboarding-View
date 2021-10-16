//
//  OnboardingCell.swift
//  Reusable-Onboarding-View
//
//  Created by Mac on 14/10/21.
//

import UIKit

class OnboardingCell: UICollectionViewCell {
    @IBOutlet private weak var contentImageView: OnboardingImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    func configureView(for item: OnboardingItem) {
        if let imageContent = item.image {
            contentImageView.image = imageContent
        } else if let imageContent = item.itemUrl {
            contentImageView.setImage(from: imageContent)
        }
        contentImageView.contentMode = .scaleAspectFill
        titleLabel.text = item.itemTitle
        descriptionLabel.text = item.itemDescription
    }
}
