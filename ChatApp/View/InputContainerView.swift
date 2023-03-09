//
//  InputContainerView.swift
//  ChatApp
//
//  Created by Apple on 06/12/1944 Saka.
//

import UIKit

class InputContainerView : UIView {
    
    init(image: UIImage? , textField: UITextField){
        super.init(frame: .zero)
        
        setHeight(height: 50)
        
        let imageView = UIImageView()
        imageView.image = image
        imageView.tintColor = .white
        imageView.alpha = 0.87
        
        addSubview(imageView)
        imageView.centerY(inView: self)
        imageView.anchor(left: leftAnchor , paddingLeft: 8)
        imageView.setDimensions(height: 24, width: 24)
       
        addSubview(textField)
        textField.centerY(inView: self)
        textField.anchor(left: imageView.rightAnchor , bottom: bottomAnchor , right: rightAnchor , paddingLeft: 12 ,paddingBottom: -8)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        addSubview(dividerView)
        dividerView.anchor(left: leftAnchor , bottom: bottomAnchor, right: rightAnchor , paddingLeft: 8, height: 0.75)

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
