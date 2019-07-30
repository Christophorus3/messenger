//
//  ChatLogController.swift
//  Messenger
//
//  Created by Christoph Wottawa on 23.07.19.
//  Copyright © 2019 Christoph Wottawa. All rights reserved.
//

import UIKit

class ChatLogController: UICollectionViewController {
    
    private let cellId = "cellId"
    
    var user: User? {
        didSet {
            navigationItem.title = user?.name
            self.messages = user?.messages?.allObjects as? [Message]
            self.messages?.sort(by: { $0.date! < $1.date! })
        }
    }
    
    var messages: [Message]?
    
    let messageInputView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Message..."
        return textField
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleSend(sender:)), for: .touchUpInside)
        return button
    }()
    
    var bottomConstraint: NSLayoutConstraint?
    
    override var inputAccessoryView: UIView? {
        get {
            messageInputView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 48)
            return messageInputView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        //collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 48, right: 0)
        
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.keyboardDismissMode = .interactive
        
        setupViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupViews() {
        let borderView = UIView()
        borderView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        let views = [
            "inputView": messageInputView,
            "textField": inputTextField,
            "sendButton": sendButton,
            "borderView": borderView
        ]
        
        messageInputView.translatesAutoresizingMaskIntoConstraints = false
        
        messageInputView.addSubview(inputTextField)
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        messageInputView.addSubview(sendButton)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        messageInputView.addSubview(borderView)
        borderView.translatesAutoresizingMaskIntoConstraints = false
        messageInputView.addConstraintsWithFormat(format: "H:|-[textField]-[sendButton(50)]-|", views: views)
        messageInputView.addConstraintsWithFormat(format: "V:|[textField]|", views: views)
        messageInputView.addConstraintsWithFormat(format: "V:|[sendButton]|", views: views)
        messageInputView.addConstraintsWithFormat(format: "H:|[borderView]|", views: views)
        messageInputView.addConstraintsWithFormat(format: "V:|[borderView(0.5)]", views: views)
    }
    
    @objc private func handleKeyboardNotification(notification: Notification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            let isShowing = notification.name == UIResponder.keyboardWillShowNotification
            let didShow = notification.name == UIResponder.keyboardDidShowNotification
            
            bottomConstraint?.constant = isShowing ? -keyboardFrame.height : 0
            
            if didShow {
                let indexPath = IndexPath(item: self.messages!.count - 1, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
            }
            /*
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions(rawValue: animationCurve), animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                let indexPath = IndexPath(item: self.messages!.count - 1, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
            }*/
            
        }
    }
    
    @objc func handleSend(sender: UIButton) {
        print(inputTextField.text ?? "")
        
        let service = PersistenceService.shared
        service.createMessage(with: inputTextField.text!, user: self.user!, sentByMe: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //inputTextField.resignFirstResponder()
        //basically the same:
        inputTextField.endEditing(true)
    }
    
    // MARK: - UICollectionView
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MessageCell
        
        if let message = messages?[indexPath.row] {
            let viewModel = MessageViewModel(model: message)
            viewModel.frameWidth = 250
            viewModel.fontSize = 18
            cell.viewModel = viewModel
            
            
            let estimatedFrame = cell.viewModel!.estimatedFrame()
            
            if !cell.viewModel!.isSentByMe {
                cell.messageTextView.frame = CGRect(x: 48 + 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
            
                cell.bubbleView.frame = CGRect(x: 48, y: 0, width: estimatedFrame.width + 16 + 16, height: estimatedFrame.height + 20)
            } else {
                cell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 16, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                
                cell.bubbleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 8 - 16, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let message = messages?[indexPath.row] {
            let viewModel = MessageViewModel(model: message)
            viewModel.frameWidth = 250
            viewModel.fontSize = 18
            let estimatedFrame = viewModel.estimatedFrame()
            
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }
        
        return CGSize(width: view.frame.width, height: 100)
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }*/
}

extension ChatLogController: UICollectionViewDelegateFlowLayout {
    
}
