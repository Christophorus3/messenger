//
//  MessageViewModel.swift
//  Messenger
//
//  Created by Christoph Wottawa on 22.07.19.
//  Copyright © 2019 Christoph Wottawa. All rights reserved.
//

import UIKit

class MessageViewModel {
    private let model: Message
    
    init(model: Message, frameWidth: CGFloat = 250, fontSize: CGFloat = 18) {
        self.model = model
        self.frameWidth = frameWidth
        self.fontSize = fontSize
    }
    
    var text: String? {
        return model.text
    }
    
    var date: String? {
        if let date = model.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            let timeElapsedInSeconds = Date().timeIntervalSince(date)
            
            let secondsInDay: TimeInterval = 60 * 60 * 24
            
            if timeElapsedInSeconds > secondsInDay * 2 {
                dateFormatter.dateFormat = "dd.MM.yy"
                
            } else if timeElapsedInSeconds > secondsInDay {
                dateFormatter.dateFormat = "EEE"
            }
            
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    var senderName: String? {
        return model.user?.name
    }
    
    var profileImage: UIImage? {
        if let imageName = model.user?.profileImageName {
            return UIImage(named: imageName)
        } else {
            return nil
        }
    }
    
    var isSentByMe: Bool {
        return model.isSentByMe
    }
    
    var frameWidth: CGFloat
    
    var fontSize: CGFloat
    
    func estimatedFrame() -> CGRect {
        let size = CGSize(width: frameWidth, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]
        let estimatedFrame = NSString(string: self.text!).boundingRect(with: size, options: options, attributes: attributes, context: nil)
        return estimatedFrame
    }
}
