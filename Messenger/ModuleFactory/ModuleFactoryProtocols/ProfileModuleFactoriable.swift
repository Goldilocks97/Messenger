//
//  ProfileFactoriable.swift
//  Messenger
//
//  Created by Ivan Pavlov on 08.09.2022.
//

import UIKit

protocol ProfileModuleFactoriable {
    
    func makeProfileModule(systemImage: String, imageColor: UIColor, title: String) -> ProfileModule
    
}
