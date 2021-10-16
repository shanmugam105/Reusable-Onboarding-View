//
//  OnboardingTheme.swift
//  Reusable-Onboarding-View
//
//  Created by Mac on 16/10/21.
//

import UIKit


struct OnboardingTheme {
    let color: UIColor
    let style: ButtonStyle
    let font: UIFont?
    
    enum ButtonStyle {
        case fill(textColor: UIColor, backgroundColor: UIColor)
        case textOnly(textColor: UIColor)
        var value: (textColor: UIColor, backgroundColor: UIColor) {
            switch self {
            case .fill(textColor: let textColor, backgroundColor: let backgroundColor):
                return (textColor, backgroundColor)
            case .textOnly(textColor: let textColor):
                return (textColor, .clear)
            }
        }
    }
}


