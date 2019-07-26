//
//  File.swift
//  Messenger
//
//  Created by Christoph Wottawa on 23.07.19.
//  Copyright © 2019 Christoph Wottawa. All rights reserved.
//

import UIKit

class MessageCell: BaseCell {
    
    var viewModel: MessageViewModel? {
        didSet {
            messageTextView.text = viewModel?.text
            profileImageView.image = viewModel?.profileImage
            profileImageView.isHidden = viewModel!.isSentByMe
            if viewModel!.isSentByMe {
                bubbleView.backgroundColor = self.tintColor
                messageTextView.textColor = .white
            }
        }
    }
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 18)
        textView.text = "Sample Message"
        textView.isEditable = false
        textView.backgroundColor = .clear
        return textView
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        //works as well as .layer.masksToBounds
        //imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        //self.backgroundColor = .lightGray
        
        let views = [
            "messageTextView": messageTextView,
            "bubbleView": bubbleView,
            "imageView": profileImageView
        ]
        
        addSubview(bubbleView)
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(messageTextView)
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        //addConstraintsWithFormat(format: "H:|-[messageTextView(250)]", views: views)
        //addConstraintsWithFormat(format: "V:|-(8)-[messageTextView]-(8)-|", views: views)
        addConstraintsWithFormat(format: "H:|-[imageView(30)]", views: views)
        addConstraintsWithFormat(format: "V:[imageView(30)]|", views: views)
    }
}
