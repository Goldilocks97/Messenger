//
//  ServerCommunicator.swift
//  Messenger
//
//  Created by Ivan Pavlov on 05.09.2022.
//

import Foundation
import Network

class ServerCommunicator: NSObject, StreamDelegate {
    
    // MARK: - Events Handlers
    
    var onDidReceiveData: ((Data) -> Void)?
    
    // MARK: - Connection
    
    private let connection: NWConnection
    
    // MARK: - Server Adress
    
    private let host: NWEndpoint.Host
    private let port: NWEndpoint.Port
    
    // MARK: - Initialization
    
    init(host: String, port: UInt16) {
        self.host = NWEndpoint.Host(host)
        self.port = NWEndpoint.Port(rawValue: port)! // force unwrapping
        self.connection = NWConnection(host: self.host, port: self.port, using: .tcp)
    }
    
    // MARK: - API
    
    func start() {
        connection.stateUpdateHandler = stateDidChange(to:)
        startReceiving()
        connection.start(queue: DispatchQueue.global(qos: .utility))
    }

    func send(message: Data) {
        connection.send(content: message, completion: .contentProcessed { error in
            if let error = error {
                print(error.localizedDescription)
            }
        })
    }
    
    // MARK: - Connection Setup
    
    private func stateDidChange(to state: NWConnection.State) {
        print(state)
        switch state {
        case .ready:
            print("Client connection ready")
        case .waiting(let error):
            //connectionDidFail(error: error)
            print(error.localizedDescription)
        case .failed(let error):
            //connectionDidFail(error: error)
            print(error.localizedDescription)
        default:
            break
        }
    }
    
    private func startReceiving() {
        connection.receive(
            minimumIncompleteLength: ModelConstants.minimumIncompleteLength,
            maximumLength: ModelConstants.minimumIncompleteLength)
        {
            [weak self] (content, contentContext, isComplete, error) in
            
            if let data = content,
               !data.isEmpty
            {
                self?.onDidReceiveData?(data)
            }
            if isComplete {
                //self.connectionDidEnd()
                return
            }
            if let error = error {
                //self.connectionDidFail(error: error)
                print(error.localizedDescription)
                return
            }
            self?.startReceiving()
        }
    }
    
    // MARK: - Constants
    
    private enum ModelConstants {

        static let minimumIncompleteLength = 1
        static let maximumLength = 1024

    }
    
}

//enum Response {
//    case succes
//    case error
//}
