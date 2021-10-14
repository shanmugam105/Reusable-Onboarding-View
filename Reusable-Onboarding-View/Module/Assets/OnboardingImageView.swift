//
//  OnboardingImageView.swift
//  Reusable-Onboarding-View
//
//  Created by Mac on 14/10/21.
//

import UIKit

final class OnboardingImageView: UIImageView {
    private let imageCache: NSCache<NSString, UIImage> = NSCache<NSString, UIImage>()
    func setImage(from url: URL,
                  contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        
        contentMode = mode
        if let imageCached = imageCache.object(forKey: url.absoluteString as NSString) {
            image = imageCached
            return
        }else{
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else { return }
                DispatchQueue.main.async() { [weak self] in
                    self?.image = image
                    self?.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                }
            }.resume()
        }
    }
    func setImage(from link: String,
                  contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        setImage(from: url, contentMode: mode)
    }
}
