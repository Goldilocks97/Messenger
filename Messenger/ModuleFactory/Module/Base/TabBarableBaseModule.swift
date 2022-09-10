//
//  TabBarBaseModule.swift
//  Messenger
//
//  Created by Ivan Pavlov on 10.09.2022.
//

import UIKit

protocol TabBarableBaseModule: BaseModule {
    
    var systemImage: String { get }
    var systemImageColor: UIColor { get }
    var itemTitle: String { get }
    
    var navigationTitle: String { get }
    
}
