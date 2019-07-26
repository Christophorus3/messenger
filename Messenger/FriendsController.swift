//
//  ViewController.swift
//  Messenger
//
//  Created by Christoph Wottawa on 19.07.19.
//  Copyright © 2019 Christoph Wottawa. All rights reserved.
//

import UIKit
import CoreData

class FriendsController: UICollectionViewController {

    private let cellId = "Cell"
    
    var messages: [Message]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "Recent"
        
        setupData()
        
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.register(ThreadCell.self, forCellWithReuseIdentifier: cellId)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messages?.count {
            return count
        } else {
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ThreadCell
        
        if let message = messages?[indexPath.item] {
            cell.viewModel = MessageViewModel(model: message)
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chatLogVC = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogVC.user = messages?[indexPath.row].user
        navigationController?.pushViewController(chatLogVC, animated: true)
    }

}

// MARK: - FlowLayout Delegate

extension FriendsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
}

extension FriendsController {
    func setupData() {
        
        clearData()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = appDelegate?.persistentContainer.viewContext {
            let mark = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
            mark.name = "Mark Zuckerberg"
            mark.profileImageName = "zuckprofile"
            
            createMessage(with: "Hi, I'm Mark! Nice to meet you...", user: mark, time: "08:21, 24.07.2019", context: context)
            
            let steve = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
            steve.name = "Steve Jobs"
            steve.profileImageName = "steveprofile"
            
            createMessage(with: "Hi, Steve Jobs here! Hope you like our latest iStuff", user: steve, time: "12:03, 23.07.2019", context: context)
            createMessage(with: "Hey, how are you, Bro?", user: steve, time: "14:10, 25.07.2019", context: context)
            createMessage(with: "Come and check out the latest iPhone XII at your local Apple Store! You can even try it hands on, so you can see for yourself how magic it is!", user: steve, time: "14:30, 25.07.2019", context: context)
            
            //response
            createMessage(with: "Well, I will have a look!", user: steve, time: "14:40, 26.07.2019", context: context, sentByMe: true)
            
            let donald = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
            donald.name = "Donald Trump"
            donald.profileImageName = "donaldprofile"
            
            createMessage(with: "I'm the President!", user: donald, time: "18:20, 22.07.2019", context: context)
            
            let gandhi = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
            gandhi.name = "Mahatma Gandhi"
            gandhi.profileImageName = "gandhiprofile"
            
            createMessage(with: "Love, Peace and Joy!", user: gandhi, time: "0:20, 25.07.2019", context: context)
            
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
        
        loadData()
    }
    
    func createMessage(with text: String, user: User, time: String, context: NSManagedObjectContext, sentByMe: Bool = false) {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.user = user
        message.text = text
        message.date = Date(timeString: time)
        message.isSentByMe = sentByMe
    }
    
    func loadData() {
        //let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        //get the users:
        guard let users = fetchUsers() else { return }
        messages = [Message]()
        
        //get their latest message
        for user in users {
            guard let set = user.messages as? Set<Message>, set.count > 0 else { continue }
            let messages = set.sorted(by: { $0.date! < $1.date! })
            self.messages?.append(messages.last!)
        }
        
        messages?.sort(by: { $0.date! > $1.date! })
        
        /*
        for user in users {
            if let context = appDelegate?.persistentContainer.viewContext {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                fetchRequest.predicate = NSPredicate(format: "user.name = %@", user.name!)
                fetchRequest.fetchLimit = 1
                do {
                    //messages?.append(contentsOf: try context.fetch(fetchRequest) as? [Message] ?? [])
                    messages? += try context.fetch(fetchRequest) as? [Message] ?? []
                } catch let error {
                    print("Can not load data: \(error)")
                }
            }
        }*/
        
    }
    
    fileprivate func fetchUsers() -> [User]? {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = appDelegate?.persistentContainer.viewContext {
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            
            do {
                return try context.fetch(request) as? [User]
            } catch let error {
                print("Could not load Users: \(error)")
            }
        }
        
        return nil
    }
    
    func clearData() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = appDelegate?.persistentContainer.viewContext {
            do {
                let entityNames = ["Message", "User"]
                
                for entityName in entityNames {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                
                    let entities = try context.fetch(fetchRequest) as? [NSManagedObject]
                
                    for entity in entities! {
                        context.delete(entity)
                    }
                }
                try context.save()
            } catch let error {
                print("Unable to delete: \(error)")
            }
        }
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: [String: UIView]) {
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: format,
            metrics: nil,
            views: views))
    }
}

extension Date {
    init?(timeString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm, dd.MM.yyyy"
        if let date = formatter.date(from: timeString) {
            self = date
        } else {
            return nil
        }
    }
}
