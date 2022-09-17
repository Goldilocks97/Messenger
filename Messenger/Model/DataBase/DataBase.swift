//
//  DataBase.swift
//  Messenger
//
//  Created by Ivan Pavlov on 12.09.2022.
//

import Foundation
import SQLite3

struct DataBase: DataBasable {
    
    // MARK: - Queues
    
    private let readingQueue: DispatchQueue
    private let writingQueue: DispatchQueue
    
    // MARK: - Pointer to DataBase
    
    var dataBase: OpaquePointer?
    
    // MARK: - Initialization
    
    init(readingQueue: DispatchQueue, writingQueue: DispatchQueue) {
        self.readingQueue = readingQueue
        self.writingQueue = writingQueue
    }
    
    // MARK: - API
    
    mutating func openDataBase(for username: String) {
        if createDataBase(for: username) != SQLITE_OK {
            print("error on creating database \(username)")
        }
    }

    func hasTable(with name: String) -> Bool {
        let statement = """
        SELECT count(*) FROM SQLITE_MASTER WHERE type='table' AND name='\(name)';
        """
        var binaryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(dataBase, statement, -1, &binaryStatement, nil) == SQLITE_OK {
            if sqlite3_step(binaryStatement) == SQLITE_ROW {
                return sqlite3_column_int(binaryStatement, 0) == 1
            }
        }
        // if something went wrong.
        return false
    }
    
    // MARK: Writing Operations
    
    func writeChats(data: Chats) {
        if !hasTable(with: "Chats") {
            createChatsTable()
        }
        writingQueue.async {
            for chat in data.value {
                var binaryStatement: OpaquePointer? = nil
                let insertStatement = """
                INSERT INTO 'Chats' (id, name, host) \
                VALUES(\(chat.id), '\(chat.name)', \(chat.hostId));
                """
                sqlite3_prepare_v2(dataBase, insertStatement, -1, &binaryStatement, nil)
                if sqlite3_step(binaryStatement) == SQLITE_DONE {
                    print("data inserted for chat \(chat.name)")
                } else {
                    print("error on inserting data for chat \(chat.name)")
                }
                sqlite3_finalize(binaryStatement)
            }
        }
    }
    
    func writeMessages(data: Messages, to chatID: Int) {
        if !hasTable(with: "Messages\(chatID)") {
            createMessagesTable(for: chatID)
        }
        writingQueue.async {
            for message in data.value {
                var binaryStatement: OpaquePointer? = nil
                let insertStatement = """
                INSERT INTO 'Messages\(chatID)' \
                VALUES(\(chatID), '\(message.senderUsername)', \(message.senderID), '\(message.text)', '\(message.date)', '\(message.time)');
                """
                sqlite3_prepare_v2(dataBase, insertStatement, -1, &binaryStatement, nil)
                if sqlite3_step(binaryStatement) == SQLITE_DONE {
                    print("data inserted for messages\(chatID)")
                } else {
                    print("error on inserting data for messages\(chatID)")
                }
                sqlite3_finalize(binaryStatement)
            }
        }
    }
    
    // MARK: Reading Operations

    func readChats(completionHandler: @escaping ((Chats) -> Void)) {
        readingQueue.async {
            let statement = "SELECT * FROM 'Chats'"
            var binaryStatement: OpaquePointer? = nil
            var chats = [Chat]()
            if sqlite3_prepare_v2(dataBase, statement, -1, &binaryStatement, nil) == SQLITE_OK {
                while sqlite3_step(binaryStatement) == SQLITE_ROW {
                    let chatID = sqlite3_column_int(binaryStatement, 0)
                    let nameUnsafe = sqlite3_column_text(binaryStatement, 1)
                    let host = sqlite3_column_int(binaryStatement, 2)
                    let lastMsg = sqlite3_column_int(binaryStatement, 3)
                    
                    if let name = nameUnsafe {
                        let chat = Chat(id: Int(chatID), name: String(cString: name), hostId: Int(host))
                        chats.append(chat)
                    }
                }
            }
            completionHandler(Chats(value: chats))
        }
    }
    
    func readMessages(for chatID: Int, completionHandler: @escaping ((Messages) -> Void)) {
        readingQueue.async {
            let statement = "SELECT * FROM 'Messages\(chatID)'"
            var binaryStatement: OpaquePointer? = nil
            var messages = [Message]()
            if sqlite3_prepare_v2(dataBase, statement, -1, &binaryStatement, nil) == SQLITE_OK {
                while sqlite3_step(binaryStatement) == SQLITE_ROW {
                    let chatID = sqlite3_column_int(binaryStatement, 0)
                    let senderNameUnsafe = sqlite3_column_text(binaryStatement, 1)
                    let senderID = sqlite3_column_int(binaryStatement, 2)
                    let textUnsafe = sqlite3_column_text(binaryStatement, 3)
                    let dateUnsafe = sqlite3_column_text(binaryStatement, 4)
                    let timeUnsafe = sqlite3_column_text(binaryStatement, 5)
                    
                    if let time = timeUnsafe,
                       let senderName = senderNameUnsafe,
                       let text = textUnsafe,
                       let date = dateUnsafe
                    {
                        let message = Message(
                            chatID: Int(chatID),
                            text: String(cString: text),
                            senderID: Int(senderID),
                            senderUsername: String(cString: senderName),
                            date: String(cString: date),
                            time: String(cString: time))
                        messages.append(message)
                    }
                }
            }
            completionHandler(Messages(value: messages))
        }
    }
    
    // MARK: Tables Creation
    
    func createChatsTable() {
        let fields = [
            "id INTEGER",
            "name TEXT",
            "host INTEGER",
            "last_msg INTEGER DEFAULT NULL"]
        let name = "Chats"
        createTable(name, with: fields)
    }
    
    func createMessagesTable(for chatID: Int) {
        let fields = [
            "chat_id INTEGER",
            "sender_name TEXT",
            "sender_id INTEGER",
            "text TEXT",
            "date TEXT",
            "time TEXT"]
        let name = "Messages\(chatID)"
        createTable(name, with: fields)
    }
    
    private func createChatsMembersTable() {
        let fields = [
            "chat_id INTEGER",
            "user_id INTEGER"]
        let name = "ChatsMembers"
        createTable(name, with: fields)
    }
    
    private func createUsersTable() {
        let fields = [
            "user_id INTEGER",
            "name TEXT"]
        let name = "Users"
        createTable(name, with: fields)
    }
    
    private func createTable(_ name: String, with fields: [String]) {
        var parameters = "("
        if fields.count != 1 {
            for index in 0...fields.count-2 {
                parameters += fields[index] + ","
            }
            parameters += fields[fields.count-1]
        } else {
            parameters += fields[0]
        }
        parameters += ")"
        let statement = "CREATE TABLE IF NOT EXISTS \(name) \(parameters);"
        if sqlite3_exec(dataBase, statement, nil, nil, nil) == SQLITE_OK {
            print("table \(name) created")
        } else {
            print("error on creating table \(name)")
        }
    }
    
    // MARK: - DataBase Creation
    
    private mutating func createDataBase(for username: String) -> Int32 {
        var documentURL: URL
        do {
            documentURL = try FileManager().url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true)
        } catch {
            print("error while creating dataBase.")
            return SQLITE_FAIL
        }
        let dataBaseURL = documentURL.appendingPathComponent("\(username).sqlite")
        print(dataBaseURL)
        let encodedURL = dataBaseURL.absoluteString.cString(using: .utf8)
        let flag = SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE | SQLITE_OPEN_FULLMUTEX
        let status = sqlite3_open_v2(encodedURL, &dataBase, flag, nil)
        return status
    }
    
}
