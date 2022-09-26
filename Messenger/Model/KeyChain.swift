//
//  KeyChain.swift
//  Messenger
//
//  Created by Ivan Pavlov on 25.09.2022.
//

import Foundation

final class KeyChain {
    
    // MARK: - Read Data
    
    func getClient(with id: String, nickname: String) -> Client? {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrAccount as String: kCFBooleanTrue,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne]

        var itemCopy: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &itemCopy)

        guard
            status != errSecItemNotFound,
            status == errSecSuccess,
            let existingItem = itemCopy as? [String : AnyObject],
            let login = existingItem[kSecAttrAccount as String] as? String,
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8),
            let idInt = Int(id)
        else {
            print(status.description)
            return nil
        }
        return Client(name: nickname, id: idInt, login: login, password: password)
    }
    
    // MARK: - Write Data
    
    func saveClient(_ client: Client) {
        guard let password = client.password.data(using: .utf8) else {
            return
        }
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrAccount as String: client.login as AnyObject,
            kSecValueData as String: password as AnyObject]
        let status = SecItemAdd(query as CFDictionary, nil)
        print(status.description)
    }
    
    // MARK: - Update Data
    
    func updateInformation(about client: Client) {
        guard let password = client.password.data(using: .utf8) else {
            return
        }
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword]
        let attributes: [String: Any] = [
            kSecAttrAccount as String: client.login,
            kSecValueData as String: password]
        SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
    }
    
    // MARK: - Delete Data
    
    func deleteInformation() {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword]
        SecItemDelete(query as CFDictionary)
    }
        
    private enum KeychainError: Error {
            // Attempted read for an item that does not exist.
            case itemNotFound
            
            // Attempted save to override an existing item.
            // Use update instead of save to update existing items
            case duplicateItem
            
            // A read of an item in any format other than Data
            case invalidItemFormat
            
            // Any operation result status than errSecSuccess
            case unexpectedStatus(OSStatus)
        }
    
}
