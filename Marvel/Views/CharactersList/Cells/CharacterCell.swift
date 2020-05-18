//
//  CharacterCell.swift
//  Marvel
//
//  Created by MarvelDev on 14/05/2020.
//  Copyright © 2020 MarvelDev. All rights reserved.
//

import UIKit

class CharacterCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imageCharacter: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
}

//MARK: - private methods -
extension CharacterCell {
    private func configureUI() {
        imageCharacter.layer.cornerRadius = 5
        imageCharacter.layer.masksToBounds = true
    }
}
