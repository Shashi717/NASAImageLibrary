//
//  CustomTransitionAnimator.swift
//  NASAImageLibrary
//
//  Created by Shashi Liyanage on 2/27/24.
//

import Foundation
import UIKit

class CustomTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard transitionContext.viewController(forKey: .from) != nil,
              let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }

        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)

        toVC.view.alpha = 0.0
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            toVC.view.alpha = 1.0
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
}
