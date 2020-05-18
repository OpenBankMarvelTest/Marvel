//
//  HUDView.swift
//  Marvel
//
//  Created by MarvelDev on 14/05/2020.
//  Copyright © 2020 MarvelDev. All rights reserved.
//

import UIKit

class HUDView: UIVisualEffectView {
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    var activityIndicator: UIActivityIndicatorView?
    var label: UILabel = UILabel()
    let blurEffect = UIBlurEffect(style: .light)
    let vibrancyView: UIVisualEffectView
    
    init(text: String) {
        self.text = text
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(effect: blurEffect)
        self.setup()
        self.isHidden = false
    }
    
    init() {
        self.text = ""
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(effect: blurEffect)
        self.setup()
        self.isHidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.text = ""
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(coder: aDecoder)
        self.setup()
        self.isHidden = false
    }
    
    func setup() {
        if #available(iOS 13.0, *) {
            activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        } else {
            activityIndicator = UIActivityIndicatorView(style: .gray)
        }
        if text != "" {
            contentView.addSubview(label)
        }
        contentView.addSubview(vibrancyView)
        contentView.addSubview(activityIndicator!)
        activityIndicator!.startAnimating()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if text == "" {
            if let superview = self.superview {
                
                let width: CGFloat = 100.0
                let height: CGFloat = 100.0
                self.translatesAutoresizingMaskIntoConstraints = false
                
                // Width and height
                NSLayoutConstraint.activate([NSLayoutConstraint.init(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height), NSLayoutConstraint.init(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width)])
                
                // Center horizontaly and verticaly
                NSLayoutConstraint.activate([NSLayoutConstraint.init(item: self, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 0), NSLayoutConstraint.init(item: superview, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)])
                
                vibrancyView.frame = self.bounds
                let activityIndicatorSize: CGFloat = 85
                activityIndicator!.translatesAutoresizingMaskIntoConstraints = false
                // Width and height
                NSLayoutConstraint.activate([NSLayoutConstraint.init(item: activityIndicator!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: activityIndicatorSize), NSLayoutConstraint.init(item: activityIndicator!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: activityIndicatorSize)])
                
                // Center horizontaly and verticaly
                NSLayoutConstraint.activate([NSLayoutConstraint.init(item: activityIndicator!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0), NSLayoutConstraint.init(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator!, attribute: .centerY, multiplier: 1, constant: 0)])
                
                if #available(iOS 13.0, *) {
                    activityIndicator?.style = UIActivityIndicatorView.Style.large
                } else {
                    activityIndicator?.style = .whiteLarge
                }
                layer.cornerRadius = 8.0
                layer.masksToBounds = true
                layer.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.25).cgColor
            }
        } else {
            if let superview = self.superview {
                let height: CGFloat = 110.0
                self.translatesAutoresizingMaskIntoConstraints = false
                // Height
                NSLayoutConstraint.activate([NSLayoutConstraint.init(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)])
                
                // Center horizontaly and verticaly
                NSLayoutConstraint.activate([NSLayoutConstraint.init(item: self, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1, constant: 0), NSLayoutConstraint.init(item: superview, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)])
                
                vibrancyView.frame = self.bounds
                
                
                
                let activityIndicatorSize: CGFloat = 85
                activityIndicator?.translatesAutoresizingMaskIntoConstraints = false
                // Width and height
                NSLayoutConstraint.activate([NSLayoutConstraint.init(item: activityIndicator!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: activityIndicatorSize), NSLayoutConstraint.init(item: activityIndicator!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: activityIndicatorSize)])
                
                // Center horizontaly and verticaly
                NSLayoutConstraint.activate([NSLayoutConstraint.init(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)])
                
                NSLayoutConstraint.activate([NSLayoutConstraint.init(item: self, attribute: .top, relatedBy: .equal, toItem: activityIndicator, attribute: .top, multiplier: 1, constant: 0)])
                
                if #available(iOS 13.0, *) {
                    activityIndicator?.style = UIActivityIndicatorView.Style.large
                } else {
                    activityIndicator?.style = .whiteLarge
                }
                
                
                label.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([NSLayoutConstraint.init(item: label, attribute: .top, relatedBy: .equal, toItem: activityIndicator, attribute: .bottom, multiplier: 1, constant: -10), NSLayoutConstraint.init(item: label, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)])
                NSLayoutConstraint.activate([NSLayoutConstraint.init(item: label, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 15), NSLayoutConstraint.init(item: self, attribute: .trailing, relatedBy: .equal, toItem: label, attribute: .trailing, multiplier: 1, constant: 15)])
                NSLayoutConstraint.activate([NSLayoutConstraint.init(item: label, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: superview.frame.width / 1.5)])
                
                label.text = text
                label.textAlignment = NSTextAlignment.center
                label.numberOfLines = 1
                
                layer.cornerRadius = 8.0
                layer.masksToBounds = true
                layer.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.25).cgColor
            }
        }
    }
    
    func hide() {
        self.removeFromSuperview()
    }
}
