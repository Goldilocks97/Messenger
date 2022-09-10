//
//  TabBarableModuleBasse.swift
//  Messenger
//
//  Created by Ivan Pavlov on 10.09.2022.
//

import UIKit

class TabBarableControllerBase: UINavigationController {
    
    // MARK: - Initialization
    
    init(systemImage: String, imageColor: UIColor, title: String) {
        super.init(nibName: nil, bundle: nil)
        let config = UIImage.SymbolConfiguration(paletteColors: [imageColor])
        tabBarItem.image = UIImage(systemName: systemImage, withConfiguration: config)
        tabBarItem.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

