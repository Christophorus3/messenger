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
                bubbleView.tintColor = self.tintColor
                bubbleView.image = UIImage(named: "bubble_blue")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
                messageTextView.textColor = .white
            }
            setConstraints()
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
    
    let bubbleView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bubble_gray")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
        //imageView.contentMode = .scaleToFill
        //imageView.clipsToBounds = true
        imageView.tintColor = UIColor(white: 0.95, alpha: 1)
        return imageView
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
        
    }
    
    private func setConstraints() {
        let views = [
            "messageTextView": messageTextView,
            "bubbleView": bubbleView,
            "imageView": profileImageView,
            //"bubbleImageView": bubbleImageView
        ]
        
        let metrics = [
            "textWidth": viewModel!.estimatedFrame().width + 16,
            "textHeight": viewModel!.estimatedFrame().height
        ]
        
        //dunno if that is needed
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(bubbleView)
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        
        bubbleView.addSubview(messageTextView)
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.addConstraintsWithFormat(format: "H:|-(16)-[messageTextView(textWidth)]-(16)-|", views: views, metrics: metrics)
        bubbleView.addConstraintsWithFormat(format: "V:|[messageTextView]|", views: views)
        if self.viewModel!.isSentByMe {
            addConstraintsWithFormat(format: "H:[imageView(30)]-[bubbleView]-|", views: views)
        } else {
            addConstraintsWithFormat(format: "H:|-[imageView(30)]-[bubbleView]", views: views)
        }
        addConstraintsWithFormat(format: "V:[imageView(30)]|", views: views)
        
        //bubbleView.addSubview(bubbleImageView)
        //bubbleImageView.translatesAutoresizingMaskIntoConstraints = false
        //bubbleView.addConstraintsWithFormat(format: "H:|[bubbleImageView]|", views: views)
        addConstraintsWithFormat(format: "V:|[bubbleView]|", views: views)
    }
}
