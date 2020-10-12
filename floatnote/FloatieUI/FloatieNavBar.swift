//
//  FloatieNavBar.swift
//  floatnote
//
//  Created by Michaela Barcia on 7/19/20.
//  Copyright © 2020 cascade.ai. All rights reserved.
//

import Foundation
import UIKit

class FloatieNavBar {
    
    static let appearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [
            .font: UIFont(name: FloatieFont.floatieBoldFont, size: 40)!,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        appearance.titleTextAttributes = [
            .font: UIFont(name: FloatieFont.floatieFont, size: 20)!,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        return appearance
    }()
    
}
