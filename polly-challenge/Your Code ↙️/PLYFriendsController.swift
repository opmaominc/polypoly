//
//  PLYFriendsController.swift
//  polly-challenge
//
//  Created by Vicc Alexander on 10/3/17.
//  Copyright © 2017 Polly Inc. All rights reserved.
//

import UIKit
import SnapKit

class PLYFriendsController: PLYController {

    //-----------------------------------
    // MARK: - Properties
    //-----------------------------------

    
    // Datasource
    fileprivate var usersToAdd: [PLYUser] = []
    fileprivate var usersInContacts: [PLYUser] = []
    
    fileprivate var datasource: [[PLYUser]] = []
    fileprivate var sectionTitles: [String] = []
    
    private var collectionView: UICollectionView!
    
    private let customCellIdentifier = "PlyFriendCell"
    private let headerCellIdentifier = "HeaderCell"

    //-----------------------------------
    // MARK: - View Lifecycle
    //-----------------------------------

    override func viewDidLoad() {

        // Super
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {

        // Super
        super.viewDidAppear(animated)

        // Refresh users
        refreshUsers()
    }

    //-----------------------------------
    // MARK: - Setup View
    //-----------------------------------

    override func setupUI() {

        // Super
        super.setupUI()

        /*
         NOTE: Instead of adding your subviews to the controller's view, make sure to add them to cardView.
         - i.e. cardView.addSubview(yourView)
         */
        
        // Setup the CollectionView!
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.5;
        layout.headerReferenceSize = CGSize(width: cardView.frame.width, height: 50)
        collectionView = UICollectionView(frame: cardView.frame, collectionViewLayout:  layout)
        collectionView.register(PLYFriendsCollectionViewCell.self, forCellWithReuseIdentifier: customCellIdentifier)
        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerCellIdentifier)
        collectionView.backgroundColor = UIColor.clear
        collectionView.layer.shadowColor = UIColor.black.cgColor
        collectionView.layer.shadowOffset = CGSize(width: 0, height: 4)
        collectionView.layer.shadowOpacity = 0.05
        collectionView.layer.shadowRadius = 10.0
        collectionView.clipsToBounds = false
        collectionView.layer.masksToBounds = false
        collectionView.delegate = self
        collectionView.dataSource = self
        cardView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        }
    }
    
    //-----------------------------------
    // MARK: - Refreshing Data
    //-----------------------------------

    fileprivate func refreshUsers() {

        /* NOTE: On refresh the number of users for each array may change (Simulating real world updates). Make sure to account for this.*/

        // Update users
        usersToAdd = PLYManager.shared.quickAdds()
        usersInContacts = PLYManager.shared.invites()
        
        if usersToAdd.count > 0 {
            sectionTitles.append("Quick Adds")
            datasource.append(usersToAdd)
        }
        
        if usersInContacts.count > 0 {
            sectionTitles.append("In Your Contacts")
            datasource.append(usersInContacts)
        }
        
        // Update the view here
        collectionView.reloadData()
    }

    //-----------------------------------
    // MARK: - Memory Management
    //-----------------------------------

    override func didReceiveMemoryWarning() {
        // Super
        super.didReceiveMemoryWarning()
    }
}


//-----------------------------------
// MARK: - UICollectionView Delegate & DataSource Extension
//-----------------------------------

extension PLYFriendsController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: customCellIdentifier, for: indexPath)
        if let c = cell as? PLYFriendsCollectionViewCell {
            if datasource[indexPath.section].count == 1 {
                c.roundCorners = RoundCorners.All(12)
            } else {
                if indexPath.row == 0 {
                    c.roundCorners = RoundCorners.Top(12)
                } else if indexPath.row == datasource[indexPath.section].count - 1 {
                    c.roundCorners = RoundCorners.Bottom(12)
                } else {
                    c.roundCorners = RoundCorners.Bottom(0)
                }
            }
            c.plyUser = datasource[indexPath.section][indexPath.row]

            return c
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {
        case UICollectionElementKindSectionHeader:
            let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerCellIdentifier, for: indexPath) as! UICollectionViewCell
            
            let label = UILabel()
            label.text = sectionTitles[indexPath.section]
            label.textColor = UIColor(red: 78/255, green: 72/255, blue: 104/255, alpha: 1)

            reusableview.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.center.equalToSuperview()
            })

            // Horizontal Lines next to the section title
            let line1 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
            reusableview.addSubview(line1)
            line1.snp.makeConstraints({ (make) in
                make.left.equalToSuperview()
                make.centerY.equalToSuperview()
                make.height.equalTo(0.5)
                make.right.equalTo(label.snp.left).offset(-8)
            })
            line1.backgroundColor = UIColor(red: 184/255, green: 187/255, blue: 193/255, alpha: 1)

            let line2 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
            reusableview.addSubview(line2)
            line2.snp.makeConstraints({ (make) in
                make.right.equalToSuperview()
                make.centerY.equalToSuperview()
                make.height.equalTo(0.5)
                make.left.equalTo(label.snp.right).offset(8)
            })
            line2.backgroundColor = UIColor(red: 184/255, green: 187/255, blue: 193/255, alpha: 1)
            
            return reusableview
        default:
            assert(false, "Unexpected element kind")
       }
    }
}
