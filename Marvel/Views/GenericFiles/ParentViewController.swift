//
//  ParentViewController.swift
//  Marvel
//
//  Created by MarvelDev on 14/05/2020.
//  Copyright © 2020 MarvelDev. All rights reserved.
//

import UIKit

public class ParentViewController: UIViewController {

    private var hudView: HUDView?
    private var shadow: UIView!
    private var alert: CustomAlertViewController?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }
    
    func showHUD(_ text: String? = nil) {
        if !self.view.isUserInteractionEnabled {
            self.view.isUserInteractionEnabled = false
        }
        
        DispatchQueue.main.async {
            guard let window = self.view.window else { return }
            if let text = text, let _ = self.hudView {
                self.updateHUDText(text: text)
                return
            }
            
            if let text = text, self.hudView == nil {
                self.hudView = HUDView.init(text: text)
                
            } else if self.hudView == nil {
                self.hudView = HUDView.init()
            }
            
            if self.shadow == nil {
                self.shadow = UIView()
            }
            
            window.addSubview(self.shadow)
            self.shadow.translatesAutoresizingMaskIntoConstraints = false
            self.shadow.backgroundColor = .clear
            NSLayoutConstraint.activate([NSLayoutConstraint(item: self.shadow!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: window, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0), NSLayoutConstraint(item: self.shadow!, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: window, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0), NSLayoutConstraint(item: self.shadow!, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: window, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0), NSLayoutConstraint(item: self.shadow!, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: window, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)])
            
            self.hudView?.activityIndicator?.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            window.addSubview(self.hudView!)
            
            UIView.animate(withDuration: 0.2, animations: {
                self.hudView?.activityIndicator?.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }, completion: { (completed) in
                UIView.animate(withDuration: 0.2, animations: {
                    self.hudView?.activityIndicator?.transform = CGAffineTransform.identity
                })
            })
        }
    }
    
    func hideHUD() {
        if self.view.isUserInteractionEnabled {
        self.view.isUserInteractionEnabled = true
        }
        
        DispatchQueue.main.async {
            if let shadow = self.shadow {
                shadow.removeFromSuperview()
                self.shadow = nil
            }
            if let hud = self.hudView {
                hud.hide()
                self.hudView = nil
            }
        }
    }
    
    func alertError(error: ErrorModel) {
        alert = CustomAlertViewController(imageViewName: "error", titleText: nil, descriptionText: error.message, leftButtonTitle: nil, rightButtonTitle: "ok".localized)
        alert?.delegate = self
        self.present(alert!, animated: true)
    }
    
    @objc func dismissPresentedView() {
        navigationController?.popViewController(animated: true)
    }
    
    func openURL(url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
}

//MARK: - private methods -
extension ParentViewController {
    private func setNavigationBar() {
        let logo = UIImage(named: "marvel")?.resized(to: CGSize(width: 75, height: 25))
        let imageView = UIImageView(image:logo)
        let backgroundColor = UIColor.init(displayP3Red: 241/255, green: 30/255, blue: 34/255, alpha: 1)
       if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = backgroundColor
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.compactAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            navigationController?.navigationBar.prefersLargeTitles = false
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.tintColor = backgroundColor
            navigationItem.titleView = imageView
        } else {
            navigationController?.navigationBar.barTintColor = backgroundColor
            navigationController?.navigationBar.tintColor = backgroundColor
            navigationController?.navigationBar.isTranslucent = false
            if #available(iOS 11.0, *) {
                navigationController?.navigationBar.prefersLargeTitles = false
            }
            navigationItem.titleView = imageView
        }
        
        if let viewController = navigationController?.visibleViewController as? CharacterDetailViewController {
            let closeButton = UIButton()
            closeButton.setImage(UIImage(named: "arrowleft"), for: .normal)
            closeButton.imageView?.tintColor = UIColor.white
            closeButton.addTarget(self, action: #selector(dismissPresentedView), for: .touchUpInside)
            closeButton.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
            closeButton.imageEdgeInsets.bottom = 8
            closeButton.imageEdgeInsets.left = 8
            closeButton.imageEdgeInsets.top = 8
            closeButton.imageEdgeInsets.right = 8
            closeButton.widthAnchor.constraint(equalToConstant: 33).isActive = true
            closeButton.heightAnchor.constraint(equalToConstant: 33).isActive = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
        }
    }
      
    private func updateHUDText(text: String) {
        if let hud = self.hudView {
            hud.label.text = text
        } else {
            self.showHUD(text)
        }
    }
}

// MARK: - CustomAlertViewDelegate
extension ParentViewController: CustomAlertViewDelegate {
    public func leftAlertButtonClicked(tag: Int) {
        
    }
    
    public func rightAlertButtonClicked(tag: Int) {
        alert?.dismiss(animated: true)
    }
}
