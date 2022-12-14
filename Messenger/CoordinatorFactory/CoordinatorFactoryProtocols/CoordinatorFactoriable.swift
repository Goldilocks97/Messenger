//
//  CoordinatorFactoriable.swift
//  Messenger
//
//  Created by Ivan Pavlov on 03.09.2022.
//

protocol CoordinatorFactoriable:
    MainCoordinatorFactoriable,
    AuthorizationCoordinatorFactoriable,
    ChatsCoordinatorFactoriable,
    ProfileCoordinatorFactoriable
{}
