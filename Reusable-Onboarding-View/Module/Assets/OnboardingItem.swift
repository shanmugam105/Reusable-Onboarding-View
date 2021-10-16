//
//  OnboardingItem.swift
//  Image-Slider-Using-CollectionView
//
//  Created by Mac on 18/09/21.
//  Copyright © 2021 Success Resource Pte Ltd. All rights reserved.
//

import UIKit

struct OnboardingItem {
    let id: String?
    let itemUrl: String?
    let image: UIImage?
    let itemTitle: String?
    let itemDescription: String?
    
    init(id: String? = nil,
         itemUrl: String? = nil,
         image: UIImage? = nil,
         title: String? = nil,
         description: String? = nil) {
        self.id = id
        self.itemUrl = itemUrl
        self.image = image
        self.itemTitle = title
        self.itemDescription = description
    }
}
