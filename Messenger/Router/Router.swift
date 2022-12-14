//
//  Router.swift
//  Messenger
//
//  Created by Ivan Pavlov on 03.09.2022.
//

import UIKit

final class Router: Routerable {
    
    // MARK: - Root Module for presentation other modules
    
    private let rootModule: PresentableObject
    
    // MARK: - Initialization
    
    init(rootModule: PresentableObject) {
        self.rootModule = rootModule
    }
    
    // MARK: - Present module methods
    
    func present(_ module: PresentableObject) {
        present(module, animated: false)
    }
    
    func present(_ module: PresentableObject, animated: Bool) {
        rootModule.toPresent().present(module.toPresent(), animated: animated)
        
    }
    
    // MARK: - Dismiss module methods

    func dismiss(animated: Bool = false) {
        rootModule.toPresent().dismiss(animated: animated)
    }
    
    // MARK: - Navigation module methods
    
    func push(_ module: PresentableObject, animated: Bool = false)  {
        guard
            rootModule is UINavigationController,
            module.toPresent() is UINavigationController == false
        else { return }
        (rootModule as! UINavigationController).pushViewController(module.toPresent(), animated: animated)
    }
    
    func setRootModule(_ module: PresentableObject, animated: Bool = false) {
        guard
            rootModule is UINavigationController,
            module.toPresent() is UINavigationController == false
        else { return }
        (rootModule as! UINavigationController).setViewControllers([module.toPresent()], animated: animated)
    }
    
    func pop(animated: Bool) {
        guard rootModule is UINavigationController else { return }
        (rootModule as! UINavigationController).popViewController(animated: animated)
    }
        
}
