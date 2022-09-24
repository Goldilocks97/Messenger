//
//  NewChatModule.swift
//  Messenger
//
//  Created by Ivan Pavlov on 20.09.2022.
//

protocol NewChatModule: BaseModule {

    var onCreatePublicChat: ((String, [Int]) -> Void)? { get set }
    var onCreatePrivateChat: ((Int) -> Void)? { get set }
    var onFindUser: ((String) -> Void)? { get set }
    
    func userSearchResponse(response: FindUserID.Response)
}
