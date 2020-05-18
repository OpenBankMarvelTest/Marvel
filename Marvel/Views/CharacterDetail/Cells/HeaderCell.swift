//
//  HeaderCell.swift
//  Marvel
//
//  Created by MarvelDev on 16/05/2020.
//  Copyright © 2020 MarvelDev. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var envaseView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
}

//MARK: - private methods -
extension HeaderCell {
    private func configureUI() {
        DispatchQueue.main.async {
            self.envaseView.addRoundCornersView(corners: [UIRectCorner.topLeft, UIRectCorner.topRight, UIRectCorner.bottomRight], radius: 4.0)
            self.shadowView.addRoundCornersView(corners: [UIRectCorner.topLeft, UIRectCorner.topRight, UIRectCorner.bottomRight], radius: 4.0)
        }
    }
}
