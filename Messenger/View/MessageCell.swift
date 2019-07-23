//
//  File.swift
//  Messenger
//
//  Created by Christoph Wottawa on 23.07.19.
//  Copyright © 2019 Christoph Wottawa. All rights reserved.
//

import UIKit

class MessageCell: BaseCell {
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.text = "Sample Message"
        return textView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        let views = [
            "messageTextView": messageTextView
        ]
        
        self.backgroundColor = .blue
        
        addSubview(messageTextView)
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintsWithFormat(format: "H:|-[messageTextView]-|", views: views)
        addConstraintsWithFormat(format: "V:|-[messageTextView]-|", views: views)
    }
}
