//
//  Transition.swift
//  Marvel
//
//  Created by MarvelDev on 15/05/2020.
//  Copyright © 2020 MarvelDev. All rights reserved.
//

import UIKit

enum AnimationCase {
    case dragToDismiss
    case peekAndPop
    case rightToLeft
    case swipeGesture
}

class Transition: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
    
    var isPresenting: Bool!
    var animationType: AnimationCase!
    var addBackgroundImage = false
    
    private var enterPanGesture: UIScreenEdgePanGestureRecognizer!
    private var maxWidth: CGFloat = UIScreen.main.bounds.width
    var interactionInProgress = false

    let backgroundView = UIView()
    
    var sourceViewController: UIViewController! {
        didSet {
            self.enterPanGesture = UIScreenEdgePanGestureRecognizer()
            self.enterPanGesture.addTarget(self, action:#selector(handleGesture(_:)))
            self.enterPanGesture.edges = .right
            self.sourceViewController.view.addGestureRecognizer(self.enterPanGesture)
        }
    }
    
    func removeGesture() {
        self.sourceViewController.view.removeGestureRecognizer(self.enterPanGesture)
    }
    
    func addGesture() {
        self.sourceViewController.view.addGestureRecognizer(self.enterPanGesture)
    }
    
    @objc func handleGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view)
        
        let movementOnAxis = -translation.x / gestureRecognizer.view!.bounds.width
        
        let progress = CGFloat(movementOnAxis)

        switch gestureRecognizer.state {
            
        case .began:
            interactionInProgress = true
            break
        case .changed:
            update(progress)
            break
        case .cancelled:
            interactionInProgress = false
            cancel()
            break
        default:

            self.interactionInProgress = false
            
            if progress < 0.4 {
                cancel()
            }
            else {
                finish()
            }
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return TimeInterval(0.5)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)
        
        
        if isPresenting == true {
            
            self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.backgroundView.alpha = 0
            self.backgroundView.frame = CGRect(x: 0, y: 0, width: fromViewController!.view.frame.width, height: fromViewController!.view.frame.height)
            
            if addBackgroundImage {
                transitionContext.containerView.addSubview(self.backgroundView)
            }
            
            if animationType == .rightToLeft {
                let endFrame = CGRect(x: (fromViewController?.view.frame.origin.x)!, y: (fromViewController?.view.frame.origin.y)!, width: (fromViewController?.view.frame.size.width)!, height: (fromViewController?.view.frame.size.height)!)
                
                transitionContext.containerView.addSubview((toViewController?.view)!)
                
                toViewController?.view.frame = CGRect(x: (fromViewController?.view.frame.size.width)!, y: 0, width: (fromViewController?.view.frame.size.width)!, height: (fromViewController?.view.frame.size.height)!)
                
                
                UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
                    
                    toViewController?.view.frame = endFrame
                    self.backgroundView.alpha = 1
                }, completion: { (Bool) in
                    
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
                
            } else if animationType == .peekAndPop {
                transitionContext.containerView.addSubview((toViewController?.view)!)
                
                toViewController?.view.frame = (fromViewController?.view.frame)!
                
                toViewController?.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                
                UIView.animate(withDuration: 0.2, animations: {
                    toViewController?.view.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.backgroundView.alpha = 1
                }) { (completed) in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            }
        } else {
            
             if animationType == .rightToLeft {
                let endFrame = CGRect(x: ((fromViewController?.view.frame.size.width)!), y: 0, width: (fromViewController?.view.frame.size.width)!, height: (fromViewController?.view.frame.size.height)!)
                
                transitionContext.containerView.addSubview((fromViewController?.view)!)
                fromViewController?.view.superview?.bringSubviewToFront((fromViewController?.view)!)
                
                UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
                    self.backgroundView.alpha = 0
                    fromViewController?.view.frame = endFrame
                }, completion: { (Bool) in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
                
             } else if animationType == .peekAndPop {
                transitionContext.containerView.addSubview((fromViewController?.view)!)
                fromViewController?.view.superview?.bringSubviewToFront((fromViewController?.view)!)
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.backgroundView.alpha = 0
                    fromViewController?.view.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                }, completion: { (Bool) in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                })
            }
        }
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactionInProgress ? self : nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactionInProgress ? self : nil
    }
}

extension Transition: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.isPresenting = true
        self.addBackgroundImage = true
        
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        self.isPresenting = false
        self.addBackgroundImage = true
        
        return self
    }
    
}
