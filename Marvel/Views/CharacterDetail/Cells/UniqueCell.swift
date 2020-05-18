//
//  UniqueCell.swift
//  Marvel
//
//  Created by MarvelDev on 17/05/2020.
//  Copyright © 2020 MarvelDev. All rights reserved.
//

import UIKit

class UniqueCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var envaseView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
}

//MARK: - private methods -
extension UniqueCell {
    private func configureUI() {
        DispatchQueue.main.async {
            self.envaseView.addRoundCornersView(corners: [UIRectCorner.bottomLeft, UIRectCorner.topLeft, UIRectCorner.bottomRight, UIRectCorner.topRight], radius: 4.0)
            self.shadowView.addRoundCornersView(corners: [UIRectCorner.bottomLeft, UIRectCorner.topLeft, UIRectCorner.bottomRight, UIRectCorner.topRight], radius: 4.0)
        }
    }
}
