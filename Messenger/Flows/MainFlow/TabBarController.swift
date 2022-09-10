//
//  TabBarController.swift
//  Messenger
//
//  Created by Ivan Pavlov on 08.09.2022.
//

import UIKit

final class TabBarController: UITabBarController, TabBarModule, UITabBarControllerDelegate {

    // navigation title for current module
    
    private var navigationTitle: String {
        let module = viewControllers?[self.selectedIndex] as? TabBarableBaseModule
        return module?.navigationTitle ?? ""
    }

    // MARK: - Initialization

    init(tabs: [TabBarableBaseModule]) {
        super.init(nibName: nil, bundle: nil)
        var forTabBar = [UIViewController]()
        for tab in tabs {
            let controller = tab.toPresent()
            let config = UIImage.SymbolConfiguration(paletteColors: [tab.systemImageColor])
            let image = UIImage(systemName: tab.systemImage, withConfiguration: config)
            
            controller.tabBarItem.image = image
            controller.tabBarItem.title = tab.itemTitle
            forTabBar.append(controller)
        }
        viewControllers = forTabBar
        selectedIndex = 1
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        navigationItem.title = navigationTitle
        delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Changing Navigation Title

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        navigationItem.title = navigationTitle
    }

}

