//
//  LogoutModuleFactoriable.swift
//  Messenger
//
//  Created by Ivan Pavlov on 22.09.2022.
//

import UIKit

protocol LogoutModuleFactoriable {
    
    func makeLogoutModule(
        title: String?,
        message: String?,
        preferredStyle: UIAlertController.Style,
        actions: [UIAlertAction]
    ) -> LogoutModule
    
}

