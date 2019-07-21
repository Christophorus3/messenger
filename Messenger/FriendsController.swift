//
//  ViewController.swift
//  Messenger
//
//  Created by Christoph Wottawa on 19.07.19.
//  Copyright © 2019 Christoph Wottawa. All rights reserved.
//

import UIKit

class FriendsController: UICollectionViewController {

    private let cellId = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "Recent"
        
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.register(FriendCell.self, forCellWithReuseIdentifier: cellId)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        
        return cell
    }

}

// MARK: - FlowLayout Delegate

extension FriendsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
}

class FriendCell: BaseCell {
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Mark Zuckerberg"
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Your friend's message and stuff..."
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "10:09"
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .right
        return label
    }()
    
    let hasReadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override func setupViews() {
        //super.setupViews()
        
        let views = [
        "profileImageView": profileImageView,
        "dividerLineView": dividerLineView
        ]

        addSubview(profileImageView)
        addSubview(dividerLineView)

        setupContainerView()

        profileImageView.image = UIImage(named: "zuckprofile")
        hasReadImageView.image = UIImage(named: "zuckprofile")
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        dividerLineView.translatesAutoresizingMaskIntoConstraints = false

        addConstraintsWithFormat(format: "H:|-[profileImageView(68)]", views: views)
        addConstraintsWithFormat(format: "V:[profileImageView(68)]", views: views)
        addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0))

        addConstraintsWithFormat(format: "V:[dividerLineView(1)]|", views: views)
        addConstraintsWithFormat(format: "H:|-82-[dividerLineView]|", views: views)
    }
    
    private func setupContainerView() {
        let containerView = UIView()
        //containerView.backgroundColor = .gray
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        let views = [
            "containerView": containerView,
            "nameLabel": nameLabel,
            "messageLabel": messageLabel,
            "timeLabel": timeLabel,
            "hasRead": hasReadImageView
        ]
        
        addConstraintsWithFormat(format: "H:|-90-[containerView]|", views: views)
        addConstraintsWithFormat(format: "V:[containerView(60)]", views: views)
        addConstraint(NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(nameLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(messageLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(timeLabel)
        hasReadImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(hasReadImageView)
        
        containerView.addConstraintsWithFormat(format: "H:|[nameLabel][timeLabel(80)]-12-|", views: views)
        containerView.addConstraintsWithFormat(format: "V:|[nameLabel]-[messageLabel(24)]|", views: views)
        containerView.addConstraintsWithFormat(format: "H:|[messageLabel]-8-[hasRead(20)]-12-|", views: views)
        containerView.addConstraintsWithFormat(format: "V:|[timeLabel(24)]", views: views)
        containerView.addConstraintsWithFormat(format: "V:[hasRead(20)]|", views: views)
    }
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = .blue
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
