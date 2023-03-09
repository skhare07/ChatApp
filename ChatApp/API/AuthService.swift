//
//  AuthService.swift
//  ChatApp
//
//  Created by Apple on 06/12/1944 Saka.
//

import Firebase
import UIKit
struct RegistrationCredentials {
    let email : String
    let password: String
    let fullname : String
    let username: String
    let profileImage : UIImage
}
struct AuthService {
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, password: String, completion: @escaping (Error?) -> (Void)) {
        print("DEBUG: Handle log in here..")
        Auth.auth().signIn(withEmail: email, password: password){ result, error in
            completion(error)
        }
    }
    
    
    func createUser(credentials: RegistrationCredentials,completion: @escaping (Error?) -> (Void)){
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else {return}
        let filename = NSUUID().uuidString
        let ref = Firestore.firestore()
        
        
        
        Auth.auth().createUser(withEmail: credentials.email,  password:credentials.password) { result, error in
            if let error = error {
                print("DEBUG: Failed to create user with error: \(error.localizedDescription)")
                completion(error)
                return
            }
            
            guard let uid = result?.user.uid else { return }
            
            let data = ["email":credentials.email,
                        "username": credentials.username,
                        "fullname": credentials.fullname,
                        "uid" : uid] as [String: Any]
            
            Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)
           }
        }
        
    }

