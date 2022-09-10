//
//  ChatsFactoriable.swift
//  Messenger
//
//  Created by Ivan Pavlov on 08.09.2022.
//

import UIKit

protocol ChatsModuleFactoriable {
    
    func makeChatsModule(systemImage: String, imageColor: UIColor, title: String) -> ChatsModule
    
}
