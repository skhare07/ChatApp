//
//  ProfileHeader.swift
//  ChatApp
//
//  Created by Apple on 10/12/1944 Saka.
//

import UIKit

protocol ProfileHeaderDelegate : class{
    func dismissController()
}

class ProfileHeader : UIView {
    
    //MARK: - Properties
    
    var user: User? {
        didSet { populateUserData() }
    }
    
    weak var delegate : ProfileHeaderDelegate?
   
    private let dismissButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        button.imageView?.setDimensions(height: 22, width: 22)
        
        return button
        
    }()
    
  
    
     let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 4.0
        
        return imageView
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
   
    
     let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
       
        return label
    }()
    
    
    
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      //  configureGradientLayer()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func handleDismissal(){
        delegate?.dismissController()
    }
    
    //MARK: - Helper
    
    func populateUserData(){
        guard let user = user else { return }
        
        fullnameLabel.text = user.fullname
        usernameLabel.text = "@" + user.username
        
        guard let url = URL(string: user.profileImageUrl) else { return }
        profileImageView.sd_setImage(with: url)
    }
    
    func configureUI(){
        
        
        
        profileImageView.setDimensions(height: 200, width: 200)
        profileImageView.layer.cornerRadius = 200 / 2
        addSubview(profileImageView)
      
        profileImageView.centerX(inView: self)
        profileImageView.anchor(top: topAnchor , paddingTop: 96)
        
        //configureGradientLayer()
        
        let stack = UIStackView(arrangedSubviews: [fullnameLabel,usernameLabel])
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top: profileImageView.bottomAnchor , paddingTop: 16)
        
        addSubview(dismissButton)
        dismissButton.anchor(top: topAnchor , left: leftAnchor , paddingTop: 44,paddingLeft: 12)
        dismissButton.setDimensions(height: 48, width: 48)
    }
    
    func configureGradientLayer(){
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemPurple.cgColor , UIColor.systemPink.cgColor]
        gradient.locations = [0, 1]
        gradient.addSublayer(gradient)
        gradient.frame = bounds
    }
    
}
