//
//  SectionView.swift
//  Marvel
//
//  Created by MarvelDev on 16/05/2020.
//  Copyright © 2020 MarvelDev. All rights reserved.
//

import UIKit

protocol SectionViewDelegate: AnyObject {
    func arrowClicked(section: Int)
}

class SectionView: UITableViewHeaderFooterView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var envaseView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    weak var delegate: SectionViewDelegate?
    
    override func draw(_ rect: CGRect) {
        configureUI()
    }
    
    @IBAction func arrowAction(_ sender: Any) {
        delegate?.arrowClicked(section: tag)
    }
}

//MARK: - private methods -
extension SectionView {
    private func configureUI() {
        DispatchQueue.main.async {
            self.envaseView.addRoundCornersView(corners: [UIRectCorner.topLeft, UIRectCorner.bottomLeft, UIRectCorner.topRight, UIRectCorner.bottomRight], radius: 4.0)
            self.shadowView.addRoundCornersView(corners: [UIRectCorner.topLeft, UIRectCorner.bottomLeft, UIRectCorner.topRight, UIRectCorner.bottomRight], radius: 4.0)
        }
    }
}
