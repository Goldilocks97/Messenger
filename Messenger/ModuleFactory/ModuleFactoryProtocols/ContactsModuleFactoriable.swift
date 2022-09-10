//
//  ContactsFactoriable.swift
//  Messenger
//
//  Created by Ivan Pavlov on 08.09.2022.
//

import UIKit

protocol ContactsModuleFactoriable {
    
    func makeContactsModule(systemImage: String, imageColor: UIColor, title: String) -> ContactsModule
    
}
