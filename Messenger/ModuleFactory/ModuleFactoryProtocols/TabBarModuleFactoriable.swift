//
//  TabBarFactoriable.swift
//  Messenger
//
//  Created by Ivan Pavlov on 08.09.2022.
//

protocol TabBarModuleFactoriable {
    
    func makeTabBarModule(tabs: [TabBarableBaseModule]) -> TabBarModule
    
}
