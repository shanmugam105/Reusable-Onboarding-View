//
//  OnboardingView.swift
//  Reusable-Onboarding-View
//
//  Created by Mac on 14/10/21.
//

import UIKit

final public class OnboardingView: UIView {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet weak var trailingButton: UIButton!
    @IBOutlet weak var leadingButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    private let bundle: Bundle? = Bundle(identifier: "Sparkout-Tech-Solution.OnboardingView")
    public var onboardingItems: [OnboardingItem] = [OnboardingItem]() {
        didSet{
            pageControl.numberOfPages = onboardingItems.count
        }
    }
    public var onboardingTheme: OnboardingTheme?
    {
        didSet{
            controlButtonConfiguration(onboardingTheme)
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
    @objc public var itemFinished: (()->Void)?
    
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
            let nib = bundle?.loadNibNamed("\(Self.self)", owner: self, options: nil)?.first as? UIView
        else { fatalError("Unexpected error!") }
        nib.frame = bounds
        addSubview(nib)
        collectionView.delegate = self
        collectionView.dataSource = self
        let sliderViewNib = UINib(nibName: "OnboardingCell", bundle: bundle)
        collectionView.register(sliderViewNib,
                                forCellWithReuseIdentifier: "OnboardingCell")
        controlButtonConfiguration(nil)
    }
    
    private func controlButtonConfiguration(_ onboardingTheme: OnboardingTheme?) {
        var theme: OnboardingTheme!
        // Default theme
        if let newTheme = onboardingTheme {
            theme = newTheme
        } else {
            theme = OnboardingTheme(color: .systemBlue,
                                    style: .fill(textColor: .white, backgroundColor: .systemBlue),
                                    font: .systemFont(ofSize: 12))
        }
        // Page control
        pageControl.isUserInteractionEnabled        = false
        pageControl.pageIndicatorTintColor          = theme?.color.withAlphaComponent(0.5) ?? UIColor.white.withAlphaComponent(0.5)
        pageControl.currentPageIndicatorTintColor   = theme?.color ?? UIColor.white
        
        // Button colors
        let btnStyle                = theme?.style.value
        let cornerRadius: CGFloat   = 8
        // Control buttons
        leadingButton.setTitle("Previous", for: .normal)
        leadingButton.setTitleColor(btnStyle?.textColor, for: .normal)
        leadingButton.setImage(UIImage(named: "left-chevron", in: bundle, compatibleWith: nil), for: .normal)
        leadingButton.titleLabel?.font = .systemFont(ofSize: 14)
        leadingButton.addTarget(self, action: #selector(leadingButtonTapped), for: .touchUpInside)
        leadingButton.backgroundColor = btnStyle?.backgroundColor
        leadingButton.layer.cornerRadius = cornerRadius
        
        trailingButton.setTitle("Next", for: .normal)
        trailingButton.setTitleColor(btnStyle?.textColor, for: .normal)
        trailingButton.setImage(UIImage(named: "right-chevron", in: bundle, compatibleWith: nil), for: .normal)
        trailingButton.semanticContentAttribute = .forceRightToLeft
        trailingButton.titleLabel?.font = .systemFont(ofSize: 14)
        trailingButton.addTarget(self, action: #selector(trailingButtonTapped), for: .touchUpInside)
        trailingButton.backgroundColor = btnStyle?.backgroundColor
        trailingButton.layer.cornerRadius = cornerRadius
        
        skipButton.setTitleColor(btnStyle?.textColor, for: .normal)
        skipButton.setTitle("Skip", for: .normal)
        skipButton.titleLabel?.font = .systemFont(ofSize: 14)
        skipButton.addTarget(self, action: #selector(onboardingItemFinished), for: .touchUpInside)
        skipButton.backgroundColor = btnStyle?.backgroundColor
        skipButton.layer.cornerRadius = cornerRadius
        
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
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        onboardingItems.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell",
                                                      for: indexPath) as! OnboardingCell
        cell.configureView(for: onboardingItems[indexPath.item])
        return cell
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: frame.height - 56)
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentSlide = Int(scrollView.contentOffset.x / width)
        pageControl.currentPage = currentSlide
    }
}
