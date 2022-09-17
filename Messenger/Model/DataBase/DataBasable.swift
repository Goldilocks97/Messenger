//
//  DataBasable.swift
//  Messenger
//
//  Created by Ivan Pavlov on 12.09.2022.
//

protocol DataBasable {
    
    mutating func openDataBase(for username: String)
        
    func writeChats(data: Chats)
    func writeMessages(data: Messages, to chatID: Int)
    
    func readChats(completionHandler: @escaping ((Chats) -> Void))
    func readMessages(for chatID: Int, completionHandler: @escaping ((Messages) -> Void))
    
    func hasTable(with name: String) -> Bool
    func createMessagesTable(for chatID: Int)
    func createChatsTable()
}
