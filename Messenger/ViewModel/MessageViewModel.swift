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
    
    init(model: Message) {
        self.model = model
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
}
