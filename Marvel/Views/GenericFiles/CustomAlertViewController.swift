//
//  CustomAlertViewController.swift
//  Marvel
//
//  Created by MarvelDev on 14/05/2020.
//  Copyright © 2020 MarvelDev. All rights reserved.
//

import UIKit

public protocol CustomAlertViewDelegate: class {
    func leftAlertButtonClicked(tag: Int)
    func rightAlertButtonClicked(tag: Int)
}

public final class CustomAlertViewController: UIViewController {

    @IBOutlet weak var alphaView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var topToContainerTitleConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingToContainerRightButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingToContainerLeftButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingRightButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingLeftButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleSeparatorView: UIView!
    
    private var imageViewName: String?
    private var titleText: String?
    private var descriptionText: String?
    private var leftButtonTitle: String?
    private var rightButtonTitle: String?
    private var alertTag = 0
    
    private var animator: Transition? = Transition()
    
    weak var delegate: CustomAlertViewDelegate?

    init(imageViewName: String?, titleText: String?, descriptionText: String?, leftButtonTitle: String?, rightButtonTitle: String?, alertTag: Int = 0) {
        self.imageViewName = imageViewName
        self.titleText = titleText
        self.descriptionText = descriptionText
        self.leftButtonTitle = leftButtonTitle
        self.rightButtonTitle = rightButtonTitle
        self.alertTag = alertTag
        animator?.animationType = .peekAndPop
        
        super.init(nibName: String(describing: CustomAlertViewController.self), bundle: nil)
        
        self.transitioningDelegate = animator
        self.modalPresentationStyle = .custom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async {
            self.containerView.layer.cornerRadius = 5.0
            
            self.leftButton.layer.cornerRadius = 17.0
            self.leftButton.layer.borderWidth = 1.0
            self.leftButton.layer.borderColor = UIColor.red.cgColor
            self.rightButton.layer.cornerRadius = 17.0
            self.rightButton.layer.borderWidth = 1.0
            self.rightButton.layer.borderColor = UIColor.red.cgColor
        }
    }
    
    func setup() {
        if let imageViewName = imageViewName {
            topImageView.image = UIImage(named: imageViewName)
        } else {
            topImageView.isHidden = true
            topToContainerTitleConstraint.priority = UILayoutPriority(rawValue: 999)
        }
        
        if let titleText = titleText {
            titleLabel.text = titleText
        } else {
            titleLabel.text = ""
            titleSeparatorView.isHidden = true
        }
        
        if let descriptionText = descriptionText {
            descriptionLabel.text = descriptionText
        } else {
            descriptionLabel.text = ""
        }
        
        if let leftButtonTitle = leftButtonTitle {
            leftButton.setTitle(leftButtonTitle, for: .normal)
        } else {
            leftButton.isHidden = true
            trailingRightButtonConstraint.constant = 70.0
            leadingToContainerRightButtonConstraint.priority = UILayoutPriority(rawValue: 999)
        }
        
        if let rightButtonTitle = rightButtonTitle {
            rightButton.setTitle(rightButtonTitle, for: .normal)
        } else {
            rightButton.isHidden = true
            leadingLeftButtonConstraint.constant = 70.0
            trailingToContainerLeftButtonConstraint.priority = UILayoutPriority(rawValue: 999)
        }
        
        view.layoutIfNeeded()
    }
    
    @IBAction func leftButtonAction(_ sender: Any) {
        delegate?.leftAlertButtonClicked(tag: alertTag)
        dismiss(animated: true)
    }
    
    @IBAction func rightButtonAction(_ sender: Any) {
        delegate?.rightAlertButtonClicked(tag: alertTag)
    }
}

