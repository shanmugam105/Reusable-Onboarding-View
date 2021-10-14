//
//  OnboardingView.swift
//  Reusable-Onboarding-View
//
//  Created by Mac on 14/10/21.
//

import UIKit

final class OnboardingView: UIView {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet weak var trailingButton: UIButton!
    @IBOutlet weak var leadingButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    var onboardingItems: [SliderItem] = [SliderItem]() {
        didSet{
            pageControl.numberOfPages = onboardingItems.count
        }
    }
    var themeColor: UIColor = .blue {
        didSet{
            controlButtonConfiguration(themeColor)
        }
    }
    
    private var currentSlide: Int = 0 {
        didSet{
            let indexPath: IndexPath = IndexPath(item: currentSlide, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            pageControl.currentPage = currentSlide
            checkButtonStatus()
        }
    }
    @objc var itemFinished: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionViewConfiguration()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        collectionViewConfiguration()
    }
    
    private func collectionViewConfiguration(){
        guard
            let nib = Bundle.main.loadNibNamed("\(Self.self)", owner: self, options: nil)?.first as? UIView
        else { fatalError("Unexpected error!") }
        nib.frame = bounds
        addSubview(nib)
        collectionView.delegate = self
        collectionView.dataSource = self
        let sliderViewNib = UINib(nibName: "OnboardingCell", bundle: nil)
        collectionView.register(sliderViewNib,
                                forCellWithReuseIdentifier: "OnboardingCell")
        controlButtonConfiguration()
    }
    
    private func controlButtonConfiguration(_ color: UIColor? = .systemBlue) {
        // Page control
        pageControl.isUserInteractionEnabled = false
        pageControl.pageIndicatorTintColor = color?.withAlphaComponent(0.5) ?? UIColor.white.withAlphaComponent(0.5)
        pageControl.currentPageIndicatorTintColor = color ?? UIColor.white
        // Control buttons
        leadingButton.setTitle("Previous", for: .normal)
        leadingButton.setTitleColor(color, for: .normal)
        leadingButton.setImage(#imageLiteral(resourceName: "left-chevron"), for: .normal)
        leadingButton.titleLabel?.font = .systemFont(ofSize: 14)
        leadingButton.addTarget(self, action: #selector(leadingButtonTapped), for: .touchUpInside)
        
        trailingButton.setTitle("Next", for: .normal)
        trailingButton.setTitleColor(color, for: .normal)
        trailingButton.setImage(#imageLiteral(resourceName: "right-chevron"), for: .normal)
        trailingButton.semanticContentAttribute = .forceRightToLeft
        trailingButton.titleLabel?.font = .systemFont(ofSize: 14)
        trailingButton.addTarget(self, action: #selector(trailingButtonTapped), for: .touchUpInside)
        
        skipButton.setTitleColor(color, for: .normal)
        skipButton.setTitle("Skip", for: .normal)
        skipButton.titleLabel?.font = .systemFont(ofSize: 14)
        skipButton.addTarget(self, action: #selector(onboardingItemFinished), for: .touchUpInside)
        
        checkButtonStatus()
    }
    
    @objc private func leadingButtonTapped () {
        if currentSlide > 0 {
            currentSlide -= 1
        } else {
            print("Starting Screen")
        }
    }
    @objc private func trailingButtonTapped () {
        if onboardingItems.count > currentSlide + 1 {
            currentSlide += 1
        } else {
            onboardingItemFinished()
        }
    }
    
    @objc private func onboardingItemFinished() { itemFinished?() }
    
    private func checkButtonStatus() {
        if currentSlide == 0 {
            leadingButton.isHidden = true
        }else{
            leadingButton.isHidden = false
        }
        
        if currentSlide == onboardingItems.count - 1{
            trailingButton.setTitle("Start", for: .normal)
        }else{
            trailingButton.setTitle("Next", for: .normal)
        }
    }
}

extension OnboardingView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        onboardingItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell",
                                                      for: indexPath) as! OnboardingCell
        if let imageContent = onboardingItems[indexPath.item].image {
            cell.contentImageView.image = imageContent
        } else if let imageContent = onboardingItems[indexPath.item].itemUrl {
            cell.contentImageView.setImage(from: imageContent)
        }
        cell.contentMode = .scaleAspectFill
        cell.titleLabel.text = onboardingItems[indexPath.item].itemTitle
        cell.descriptionLabel.text = onboardingItems[indexPath.item].itemDescription
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: frame.height - 56)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentSlide = Int(scrollView.contentOffset.x / width)
        pageControl.currentPage = currentSlide
    }
}
