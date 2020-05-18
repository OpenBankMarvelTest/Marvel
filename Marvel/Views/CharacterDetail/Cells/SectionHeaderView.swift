//
//  SectionHeaderView.swift
//  Marvel
//
//  Created by MarvelDev on 17/05/2020.
//  Copyright © 2020 MarvelDev. All rights reserved.
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var envaseView: UIView!
    @IBOutlet weak var shadowView: UIView!

    weak var delegate: SectionViewDelegate?

    override func draw(_ rect: CGRect) {
        configureUI()
    }
}

//MARK: - private methods -
extension SectionHeaderView {
    private func configureUI() {
        DispatchQueue.main.async {
            self.envaseView.addRoundCornersView(corners: [UIRectCorner.topLeft, UIRectCorner.topRight, UIRectCorner.bottomRight], radius: 4.0)
            self.shadowView.addRoundCornersView(corners: [UIRectCorner.topLeft, UIRectCorner.bottomLeft, UIRectCorner.topRight, UIRectCorner.bottomRight], radius: 4.0)
        }
    }
}

