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
            
            let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
            message.user = mark
            message.text = "Hello, my name is Mark. Nice to meet you..."
            message.date = Date()
            
            let steve = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
            steve.name = "Steve Jobs"
            steve.profileImageName = "steveprofile"
            
            let steveMessage = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
            steveMessage.user = steve
            steveMessage.text = "Hi, Steve Jobs here! Hope you like our latest iStuff"
            steveMessage.date = Date()
            
            do {
                try context.save()
            } catch let error {
                print(error)
            }
        }
        
        loadData()
    }
    
    func loadData() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = appDelegate?.persistentContainer.viewContext {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
            
            do {
                messages = try context.fetch(fetchRequest) as? [Message]
            } catch let error {
                print("Can not load data: \(error)")
            }
        }
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
