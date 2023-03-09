//
//  RegistrationController.swift
//  ChatApp
//
//  Created by Apple on 05/12/1944 Saka.
//

import UIKit
import Firebase



class RegistrationController : UIViewController {
    
    // MARK: - Properties
    
    private var viewModel = RegistrationViewModel()
    private var profileImage: UIImage?
    
    weak var delegate : AuthenticationDelegate?

    private let plusPhotoButton : UIButton = {
        let button = UIButton(type: .system)
        //button. = UIImage(systemName: "person.fill.badge.plus")
        button.setImage(#imageLiteral(resourceName: "Copy of plus_photo"), for: .normal)
        button.tintColor = .white
        
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        
        return button
        
    }()
    
    private lazy var emailContainerView : UIView = {
        return InputContainerView(image: UIImage(systemName: "envelope"), textField: emailTextField)

    }()
    
    private lazy var fullNameContainerView : UIView = {
        return InputContainerView(image: UIImage(systemName: "person.fill"), textField: fullnameTextField)

    }()
 
    private lazy var usernameContainerView : UIView = {
        return InputContainerView(image: UIImage(systemName: "person.fill"), textField: usernameTextField)

    }()
 
    private lazy var passwordContainerView : InputContainerView = {
        return InputContainerView(image: UIImage(systemName: "lock"), textField: passwordTextField)
    }()
 
    private let emailTextField = CustomTextField(placeholder: "Email")
    private let fullnameTextField = CustomTextField(placeholder: "Fullname")
    private let usernameTextField = CustomTextField(placeholder: "Username")
   
    private let passwordTextField : CustomTextField = {
        let textField = CustomTextField(placeholder: "Password")
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    private let signUpButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.setHeight(height: 50)
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Already have an account? ", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white])
        attributedTitle.append(NSAttributedString(string: "Log In", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        
        return button
        
    
    }()
   
   
    //  MARK: - LifeCycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    //MARK: - Selectors
    
    @objc func handleRegistration(){
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let username = usernameTextField.text?.lowercased() else {return}
        guard let fullname = fullnameTextField.text else {return}
        guard let profileImage = profileImage else {return}
        
        guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else {return}

        let filename = NSUUID().uuidString
 //       let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
//
//        ref.putData(imageData, metadata: nil) { (meta, error) in
//            if let error = error {
//                print("DEBUG: Failed to upload image with error \(error.localizedDescription)")
//                return
//            }
//
//            ref.downloadURL { (url , error ) in
//                guard let profileImageURL = url?.absoluteString else { return}
//            }
//        }
        
        let credentials = RegistrationCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
        
        showLoader(true, withText: "Signing you up")
        
        AuthService.shared.createUser(credentials: credentials) { error in
            if let error = error {
                self.showLoader(false)
                self.showError(error.localizedDescription)
                return
            }
            self.showLoader(false)
            self.delegate?.authenticationComplete()
        }
        
        
    }
    
    @objc func handleSelectPhoto(){
     
        print("Please select a photo")
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func handleShowLogin(){
        navigationController?.popViewController(animated: true)
    }
    
    //  MARK: - Helpers
    
    func configureUI(){
        
        configureGradientLayer()
    
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view)
        plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        plusPhotoButton.setDimensions(height: 200, width: 200)
        
       
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   fullNameContainerView,
                                                   usernameContainerView,passwordContainerView,
                                                   signUpButton])
        
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor ,left: view.leftAnchor , right: view.rightAnchor, paddingTop: 32 , paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.leftAnchor ,bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 32 , paddingRight: 32)
        
        
    }
    
    
}

extension RegistrationController :  UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("imagepickercontroller")
        let image = info[.originalImage] as? UIImage
            profileImage = image
            plusPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            plusPhotoButton.layer.borderColor = UIColor.white.cgColor
            plusPhotoButton.layer.borderWidth = 3.0
            plusPhotoButton.layer.cornerRadius = 200 / 2
            
            dismiss(animated: true,completion: nil)
        
        
    }
}

    
