//
//  ChatController.swift
//  ChatApp
//
//  Created by Apple on 08/12/1944 Saka.
//

import UIKit

private let reuseIdentifier = "MessageCell"

class ChatController : UICollectionViewController{
    
    //MARK: - Properties
    private let user: User
    private var messages = [Message]()
    private var fromCurrentUser : Bool = false
    
   private lazy var customInputView : CustomInputAccessoryView = {
        let iv = CustomInputAccessoryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        
        iv.delegate = self
        return iv
    }()
    //MARK: - LifeCycle
    
    init(user: User){
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchMessage()
    }
    
    override var inputAccessoryView: UIView? {
        get { return customInputView}
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    //MARK: - API
    
    func fetchMessage(){
        showLoader(true)
        
        Service.fetchMessage(forUser: user) { messages in
            self.showLoader(false)
            self.messages = messages
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: [0, self.messages.count-1] , at: .bottom, animated: true)
        }
    }
    
    //MARK: Helpers
    func configureUI(){
        
        collectionView.backgroundColor = .white
        
        configureNavigationBar(withTitle: user.fullname, prefersLargeTitles: false)
        
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.alwaysBounceVertical =  true
        collectionView.keyboardDismissMode = .interactive
    }
    
}

extension ChatController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MessageCell
        cell.message = messages[indexPath.row]
        cell.message?.user = user
        return cell
    }
}

extension ChatController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let estimatedSizeCell = MessageCell(frame: frame)
        estimatedSizeCell.message = messages[indexPath.row]
        estimatedSizeCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(targetSize)
        
        return .init(width: view.frame.width, height: estimatedSize.height)
    }
}

extension ChatController: CustomInputAccessoryViewDelegate{
    func inputView(_ inputView: CustomInputAccessoryView, wantsToSend message: String) {
        
        Service.uploadMessage(message, to: user) { error in
            if let error = error {
                print("DEBUG: Failed to upload message with error\(error.localizedDescription)")
                return
            }
        
        inputView.clearMessageText() 
        }
        
    }
    
    
}
