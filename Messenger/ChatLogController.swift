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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: cellId)
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
}

extension ChatLogController: UICollectionViewDelegateFlowLayout {
    
}
