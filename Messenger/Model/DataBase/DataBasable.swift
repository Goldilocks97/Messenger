//
//  DataBasable.swift
//  Messenger
//
//  Created by Ivan Pavlov on 12.09.2022.
//

protocol DataBasable {
    
    mutating func openDataBase(for username: String)
        
    func writeChats(data: Chats)
    
    func readChats(completionHandler: @escaping ((Chats) -> Void))
}
