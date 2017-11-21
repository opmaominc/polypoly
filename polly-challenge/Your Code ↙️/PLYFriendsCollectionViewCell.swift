//
//  PLYFriendsCollectionViewCell.swift
//  polly-challenge
//
//  Created by Omer Ayubi on 11/20/17.
//  Copyright © 2017 Polly Inc. All rights reserved.
//

import UIKit

class PLYFriendsCollectionViewCell: UICollectionViewCell {
    
    //-----------------------------------
    // MARK: - Properties
    //-----------------------------------
    
    private var avatarImageView: UIImageView = {
        return UIImageView()
    }()
    private var profileNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "ProximaNova-Semibold", size: 12)
        label.textColor = UIColor(red: 78/255, green: 72/255, blue: 104/255, alpha: 1)
        return label
    }()
    private var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(12)
        label.textColor = UIColor(red: 184/255, green: 187/255, blue: 193/255, alpha: 1)

        return label
    }()
    private var actionButton: UIButton = {
        let button = UIButton(type: UIButtonType.roundedRect)
        button.clipsToBounds = true
        return button
    }()
    
    var plyUser: PLYUser? {
        didSet {
            updateUI()
        }
    }
    
    var roundCorners: RoundCorners = RoundCorners.All(0)
    
    var view: UIView = {
        return UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }()
    
    //-----------------------------------
    // MARK: - View Lifecycle
    //-----------------------------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        actionButton.layer.cornerRadius = actionButton.frame.height/2
        switch roundCorners {
        case let .Top(radius):
            view.roundCorners([.topLeft, .topRight], radius: radius)
        case let .Bottom(radius):
            view.roundCorners([.bottomLeft, .bottomRight], radius: radius)
        case let .All(radius):
            view.roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], radius: radius)
        }
    }
    
    //-----------------------------------
    // MARK: - Setup UI
    //-----------------------------------
    
    private func setupUI() {
        backgroundColor = UIColor.clear
        
        addSubview(view)
        view.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height)
        view.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        view.backgroundColor = UIColor.white

        view.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(8)
            make.width.equalTo(35)
            make.height.equalTo(35)
        }
        
        view.addSubview(profileNameLabel)
        profileNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImageView.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }
        
        view.addSubview(phoneNumberLabel)
        phoneNumberLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileNameLabel.snp.bottom)
            make.left.equalTo(avatarImageView.snp.right).offset(10)
            make.right.lessThanOrEqualToSuperview()
        }
        
        view.addSubview(actionButton)
        actionButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(60)
        }
    }
    
    //-----------------------------------
    // MARK: - Update UI
    //-----------------------------------
    
    private func updateUI() {
        avatarImageView.image = plyUser?.avatar
        profileNameLabel.text = plyUser!.firstName! + " " + plyUser!.lastName!
        phoneNumberLabel.text = plyUser?.phoneNumber
        if plyUser?.phoneNumber != nil {
            profileNameLabel.snp.updateConstraints({ (make) in
                make.centerY.equalToSuperview().offset(-7)
            })
            actionButton.setTitle("+ Invite", for: UIControlState.normal)
            actionButton.backgroundColor = UIColor.clear
            actionButton.setTitleColor(UIColor(red: 184/255, green: 187/255, blue: 193/255, alpha: 1), for: UIControlState.normal)
            actionButton.layer.borderColor = UIColor(red: 184/255, green: 187/255, blue: 193/255, alpha: 1).cgColor
            actionButton.layer.borderWidth = 1
        } else {
            actionButton.setTitle("+ Add", for: UIControlState.normal)
            actionButton.backgroundColor = UIColor(red: 13/255, green: 173/255, blue: 255/255, alpha: 1)
            actionButton.setTitleColor(.white, for: UIControlState.normal)
        }
    }
}

//-----------------------------------
// MARK: - Round Corners Enum
//-----------------------------------

enum RoundCorners {
    case Top(CGFloat)
    case Bottom(CGFloat)
    case All(CGFloat)
}

//-----------------------------------
// MARK: - UIView Extension For Round Corners
//-----------------------------------

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
