//
//  LoginViewModel.swift
//  ChatApp
//
//  Created by Apple on 06/12/1944 Saka.
//

import UIKit

struct LoginViewModel {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false
            && password?.isEmpty == false
    }
}
