//
//  MessageCell.swift
//  ChatApp
//
//  Created by Apple on 09/12/1944 Saka.
//

import UIKit

class MessageCell :UICollectionViewCell{
    
    //MARK: - Properties
    
    var message : Message? {
        didSet{configure()}
    }
    
    var bubbleLeftAnchor : NSLayoutConstraint!
    var bubbleRightAnchor : NSLayoutConstraint!
    
    
    private let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.textColor = .white
        return textView
    }()
    
    private let bubbleContainer : UIView = {
        let bubbleView = UIView()
        bubbleView.backgroundColor = .systemPurple
        
        return bubbleView
    }()
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.anchor(left: leftAnchor , bottom: bottomAnchor , paddingLeft: 8 , paddingBottom: -4)
        profileImageView.setDimensions(height: 32, width: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        
        addSubview(bubbleContainer)
        
        bubbleContainer.layer.cornerRadius = 12
        
        bubbleContainer.anchor(top:topAnchor , bottom: bottomAnchor)
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
       
        bubbleLeftAnchor = bubbleContainer.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12)
        bubbleLeftAnchor.isActive = false
        
        bubbleRightAnchor = bubbleContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -12)
        bubbleRightAnchor.isActive = false
        
        bubbleContainer.addSubview(textView)
        textView.anchor(top: bubbleContainer.topAnchor ,left: bubbleContainer.leftAnchor   , bottom: bubbleContainer.bottomAnchor , right: bubbleContainer.rightAnchor ,paddingTop: 4, paddingLeft: 4 , paddingBottom: 4 , paddingRight: 12)
            
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configure(){
        guard let message = message else { return }
        let viewModel = MessageViewModel(message: message)
        
        bubbleContainer.backgroundColor = viewModel.messageBackgroundColor
        textView.textColor =  viewModel.messageTextColor
        textView.text = message.text
        
        bubbleLeftAnchor.isActive = viewModel.leftAnchorActive
        bubbleRightAnchor.isActive = viewModel.rightAnchorActive
        
        profileImageView.isHidden = viewModel.shouldHideProfleImage
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
    }
    
}
