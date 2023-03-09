//
//  ProfileCell.swift
//  ChatApp
//
//  Created by Apple on 10/12/1944 Saka.
//

import UIKit

class ProfileCell : UITableViewCell {
    
    var viewModel : ProfileViewModel? {
        didSet { configure() }
    }
    
    private lazy var iconView : UIView = {
        let view = UIView()
        view .addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.centerY(inView: view)
        view.backgroundColor = .systemPurple
        view.setDimensions(height: 40, width: 40)
        view.layer.cornerRadius = 40 / 2
        return view
        
    }()
    
    let iconImage : UIImageView = {
       let imageView = UIImageView()
       imageView.contentMode = .scaleAspectFit
       imageView.clipsToBounds = true
       imageView.setDimensions(height: 28, width: 28)
        imageView.tintColor = .white
       return imageView
   }()
    
     let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    
    
   
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
 
        let stack = UIStackView(arrangedSubviews: [iconImage, titleLabel])
        stack.spacing = 8
        stack.axis = .horizontal
        
        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: leftAnchor , paddingLeft: 12 )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        guard let viewModel = viewModel else { return }
        
        iconImage.image = UIImage(systemName: viewModel.iconImageName)
        titleLabel.text = viewModel.description
        
    }
}
