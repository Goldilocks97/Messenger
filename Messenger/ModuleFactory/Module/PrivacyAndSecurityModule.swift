//
//  PrivacyAndSecurityModule.swift
//  Messenger
//
//  Created by Ivan Pavlov on 22.09.2022.
//

protocol PrivacyAndSecurityModule: ProfileSectionBaseModule {
    
    var onSelectedSection: ((PrivacyAndSecuritySection) -> Void)? { get set }
    
}
