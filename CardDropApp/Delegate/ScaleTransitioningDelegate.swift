//
//  ScaleTransitioningDelegate.swift
//  CardDropApp
//
//  Created by Mozart Falcão on 31/05/19.
//  Copyright © 2019 Mozart Falcão. All rights reserved.
//

import UIKit

protocol Scaling {
    func scalingImageView(transition: ScaleTransitioningDelegate) -> UIImageView?
    
}

enum TransitionState {
    case begin
    case end
}

class ScaleTransitioningDelegate: NSObject {
    let animationDuration = 0.5
    var navigationControllerOperation: UINavigationController.Operation = .none
    
    
}

extension ScaleTransitioningDelegate : UIViewControllerAnimatedTransitioning
{
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    //custom animation transition
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        
        
        //get the container
        let containerView = transitionContext.containerView
        
        
        
        
        //getting the backgrondVC
        guard let fromVC = transitionContext.viewController(forKey: .from) else {return}
        
        //getting the foregrondVC
        guard let toVC = transitionContext.viewController(forKey: .to) else {return}
        
        var backgroundVC = fromVC
        var foregroundVC = toVC
        
        //cheking if is the navigation controller is backing to the first VC.
        if navigationControllerOperation == .pop {
            
            backgroundVC = toVC
            foregroundVC = fromVC
        }
        
        
        
        //unwrapping the BG to a scalingImageView
        guard let backgroundImageView = (backgroundVC as? Scaling)?.scalingImageView(transition: self) else {return}
        
        
        //unwrapping the FG to a scalingImageView
        guard let foregroundImageView = (foregroundVC as? Scaling)?.scalingImageView(transition: self) else {return}
        
        let imageViewSnapshot = UIImageView(image: backgroundImageView.image)
        
        //thi difine the content mode specifies how the cached bitmap of the view’s layer is adjusted when the view’s bounds change.
        imageViewSnapshot.contentMode = .scaleAspectFill
        
        //this define Core Animation to creates an implicit clipping mask that matches the bounds of the layer and includes any corner radius effects.
        imageViewSnapshot.layer.masksToBounds = true
        
        if navigationControllerOperation == .pop
        {
            imageViewSnapshot.layer.cornerRadius = 14
        }
        
        
        backgroundImageView.isHidden = true
        foregroundImageView.isHidden = true
        
        let foregroundBGColor =  foregroundVC.view.backgroundColor
        
        foregroundVC.view.backgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.white
        
        
        containerView.addSubview(backgroundVC.view)
        containerView.addSubview(foregroundVC.view)
        containerView.addSubview(imageViewSnapshot)
        
        var transitionStateA = TransitionState.begin
        var transitionStateB = TransitionState.end
        
        if navigationControllerOperation == .pop {
            transitionStateA = .end
            transitionStateB = .begin
        }
        
        
        prepareViews(for: transitionStateA, conteinerView: containerView, backgroundVC: backgroundVC, backgroudImageView: backgroundImageView, foregroundImageView: foregroundImageView, snapshotImageView: imageViewSnapshot)
        
        foregroundVC.view.layoutIfNeeded()
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.prepareViews(for: transitionStateB, conteinerView: containerView, backgroundVC: backgroundVC, backgroudImageView: backgroundImageView, foregroundImageView: foregroundImageView, snapshotImageView: imageViewSnapshot)
        }) { (_) in
            backgroundVC.view.transform = .identity
            imageViewSnapshot.removeFromSuperview()
            backgroundImageView.isHidden = false
            foregroundImageView.isHidden = false
            foregroundVC.view.backgroundColor = foregroundBGColor
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
            
            
            
        }
        
        
        
    }
    
    func prepareViews(for state: TransitionState, conteinerView: UIView, backgroundVC:UIViewController, backgroudImageView:UIImageView, foregroundImageView:UIImageView, snapshotImageView: UIImageView)
    {
        switch state{
        case .begin:
            backgroundVC.view.transform = .identity
            backgroundVC.view.alpha = 1
            
            snapshotImageView.frame = conteinerView.convert(backgroudImageView.frame, from: backgroudImageView.superview)
        
        case .end:
            backgroundVC.view.alpha = 0
            snapshotImageView.frame = conteinerView.convert(foregroundImageView.frame, from: foregroundImageView.superview)
            
        }
    }
    
    
}

extension ScaleTransitioningDelegate: UINavigationControllerDelegate{
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if fromVC is Scaling && toVC is Scaling
        {
            self.navigationControllerOperation = operation
            
            //making the navbar of the new VC hidden.
            let navbarVisible = operation == .pop
            navigationController.setNavigationBarHidden(!navbarVisible, animated: true)

            return self
        }
        else{
            return nil
        }
    }
    
}
