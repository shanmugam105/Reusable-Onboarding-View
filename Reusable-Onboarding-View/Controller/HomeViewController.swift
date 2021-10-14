//
//  HomeViewController.swift
//  Reusable-Onboarding-View
//
//  Created by Mac on 14/10/21.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet private weak var onboardingView: OnboardingView!
    private let onboardingItems: [SliderItem] = [
        SliderItem(id: "1",
                   itemUrl: "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",
                   title: "Welcome!",
                   description: "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout."),
        SliderItem(id: "2",
                   itemUrl: "https://neilpatel.com/wp-content/uploads/2017/09/image-editing-tools.jpg",
                   title: "Step 1",
                   description: "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration"),
        SliderItem(id: "3",
                   image: #imageLiteral(resourceName: "stock-photo-142984111-1500x1000"),
                   title: "Step 3",
                   description: "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC. There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration"),
        SliderItem(id: "4",
                   itemUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png",
                   title: "Step 3",
                   description: "Start now!"),
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingView.onboardingItems = onboardingItems
        onboardingView.itemFinished = gotoHomeScreen
    }
    func gotoHomeScreen() {
        print("Goto home screen!")
    }
}
