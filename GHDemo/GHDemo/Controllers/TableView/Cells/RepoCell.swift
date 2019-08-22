//
//  RepoCell.swift
//  GHDemo
//
//  Created by user on 14/08/19.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit

class RepoCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgAccessLevel: UIImageView!
    
    
    func configure(repo: Repository) {
        lblName.text = repo.name
        lblDescription.text = repo.description
        imgAccessLevel.image = repo.private ?? false ? #imageLiteral(resourceName: "lock") : #imageLiteral(resourceName: "unlock")
    }
}
