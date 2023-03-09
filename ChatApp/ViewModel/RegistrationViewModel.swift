//
//  RegistrationViewModel.swift
//  ChatApp
//
//  Created by Apple on 06/12/1944 Saka.
//

import Foundation

struct RegistrationViewModel {
    var email: String?
    var password: String?
    var username: String?
    var fullname: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false
            && password?.isEmpty == false
            && fullname?.isEmpty == false
            && username?.isEmpty == false
    }
}
