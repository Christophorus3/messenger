//
//  PersistenceService.swift
//  Messenger
//
//  Created by Christoph Wottawa on 30.07.19.
//  Copyright © 2019 Christoph Wottawa. All rights reserved.
//

import UIKit
import CoreData

class PersistenceService {
    static var shared = PersistenceService()
    
    let context: NSManagedObjectContext
    
    init() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        context = delegate.persistentContainer.viewContext
    }
    
    func createMessage(with text: String, user: User, time: String, sentByMe: Bool = false) {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.user = user
        message.text = text
        message.date = Date(timeString: time)
        message.isSentByMe = sentByMe
        saveContext()
    }
    
    func createMessage(with text: String, user: User, sentByMe: Bool = false) {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.user = user
        message.text = text
        message.date = Date()
        message.isSentByMe = sentByMe
        saveContext()
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch let error {
            print("Error saving: \(error)")
        }
    }
    
}
