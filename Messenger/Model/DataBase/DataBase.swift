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

    // MARK: - Operations
    
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
        writingQueue.async {
            for chat in data.value {
                var statement = """
                INSERT INTO 'Chats' \
                VALUES(\(chat.id), '\(chat.name)', \(chat.hostId), '\(chat.date)', '\(chat.time)');
                """
                write(statement: statement)
                statement = "INSERT INTO 'LastMessage' (chat_id) VALUES (\(chat.id));"
                write(statement: statement)
            }
        }
    }

    func writeMessages(data: Messages, to chatID: Int) {
        writingQueue.async {
            for message in data.value {
                let statement = """
                INSERT INTO 'Messages\(chatID)' VALUES(\(chatID), '\(message.senderUsername)', \
                \(message.senderID), '\(message.text)', '\(message.date)', '\(message.time)');
                """
                write(statement: statement)
            }
            if let last = data.value.last {
                let lastMessage = LastMessage(
                    chatID: last.chatID,
                    text: last.text,
                    date: last.date,
                    time: last.time)
                writeLastMessage(lastMessage)
            }
        }
    }
    
    func writeLastMessage(_ message: LastMessage) {
        let statement = """
            UPDATE LastMessage\
            SET text = '\(message.text)', date = '\(message.date)', time = '\(message.time)' \
            WHERE chat_id = \(message.chatID);
        """
        writingQueue.async { write(statement: statement) }
    }
    
    private func write(statement: String) {
        var binaryStatement: OpaquePointer? = nil
        sqlite3_prepare_v2(dataBase, statement, -1, &binaryStatement, nil)
        if sqlite3_step(binaryStatement) == SQLITE_DONE {
            //print("data inserted")
        } else {
            print("error on inserting data")
        }
        sqlite3_finalize(binaryStatement)
    }
    
    // MARK: Reading Operations

    func readChats(completionHandler: @escaping ((Chats) -> Void)) {
        readingQueue.async {
            let statement = """
                SELECT Chats.id, Chats.name, Chats.host, Chats.date, Chats.time, \
                       LastMessage.text, LastMessage.date, LastMessage.time \
                 FROM 'Chats'  Join 'LastMessage' on LastMessage.chat_id = Chats.id
            """
            var binaryStatement: OpaquePointer? = nil
            var chats = [Chat]()
            if sqlite3_prepare_v2(dataBase, statement, -1, &binaryStatement, nil) == SQLITE_OK {
                while sqlite3_step(binaryStatement) == SQLITE_ROW {
                    guard
                        let name = sqlite3_column_text(binaryStatement, 1),
                        let text = sqlite3_column_text(binaryStatement, 5),
                        let msgDate = sqlite3_column_text(binaryStatement, 6),
                        let msgTime = sqlite3_column_text(binaryStatement, 7),
                        let chatDate = sqlite3_column_text(binaryStatement, 3),
                        let chatTime = sqlite3_column_text(binaryStatement, 4)
                    else { continue }
                    let chatID = sqlite3_column_int(binaryStatement, 0)
                    let host = sqlite3_column_int(binaryStatement, 2)
                    
                    let lastMsg = LastMessage(
                        chatID: Int(chatID),
                        text: String(cString: text),
                        date: String(cString: msgDate),
                        time: String(cString: msgTime))
                    let message = String(cString: msgDate) != "-1" ? lastMsg : nil
                    let chat = Chat(
                        id: Int(chatID),
                        name: String(cString: name),
                        hostId: Int(host),
                        date: String(cString: chatDate),
                        time: String(cString: chatTime),
                        lastMessage: message)
                    chats.append(chat)
                }
            }
            completionHandler(Chats(value: chats))
        }
    }
    
    func readMessages(for chatID: Int, completionHandler: @escaping (Messages) -> Void) {
        readingQueue.async {
            let statement = "SELECT * FROM 'Messages\(chatID)'"
            var binaryStatement: OpaquePointer? = nil
            var messages = [Message]()
            if sqlite3_prepare_v2(dataBase, statement, -1, &binaryStatement, nil) == SQLITE_OK {
                while sqlite3_step(binaryStatement) == SQLITE_ROW {
                    guard
                        let senderName = sqlite3_column_text(binaryStatement, 1),
                        let text = sqlite3_column_text(binaryStatement, 3),
                        let date = sqlite3_column_text(binaryStatement, 4),
                        let time = sqlite3_column_text(binaryStatement, 5)
                    else { continue }
                    let chatID = sqlite3_column_int(binaryStatement, 0)
                    let senderID = sqlite3_column_int(binaryStatement, 2)
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
            completionHandler(Messages(value: messages))
        }
    }
    
//    func readChatMembers(of chatID: Int, completionHandler: @escaping (Users) -> Void) {
//
//    }

    // MARK: - Tables Creation
    
    func createChatsTable() {
        let fields = [
            "id INTEGER",
            "name TEXT",
            "host INTEGER",
            "date TEXT",
            "time TEXT"]
        let name = "Chats"
        createTable(name, with: fields)
        createLastMessageTable()
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
    
//    func createChatsMembersTable() {
//        let fields = [
//            "chat_id INTEGER",
//            "user_id INTEGER",
//            "nickname TEXT"]
//        let name = "ChatsMembers"
//        createTable(name, with: fields)
//    }
    
    private func createUsersTable() {
        let fields = [
            "user_id INTEGER",
            "name TEXT"]
        let name = "Users"
        createTable(name, with: fields)
    }
    
    private func createLastMessageTable() {
        let fields = [
            "chat_id INTEGER",
            "text TEXT DEFAULT '-1'",
            "date TEXT DEFAULT '-1'",
            "time TEXT DEFAULT '-1'"
        ]
        let name = "LastMessage"
        createTable(name, with:fields)
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
            //print("table \(name) created")
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
