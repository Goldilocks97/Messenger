//
//  ProfileSectionBase.swift
//  Messenger
//
//  Created by Ivan Pavlov on 22.09.2022.
//

protocol ProfileSectionBaseModule: BaseModule {
    
    var onBackButton: (() -> Void)? { get set }
    
}
