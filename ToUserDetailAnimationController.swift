//
//  ToUserDetailAnimationController.swift
//  github_fellows
//
//  Created by nacnud on 1/24/15.
//  Copyright (c) 2015 nanud. All rights reserved.
//

import UIKit

class ToUserDetailAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.35
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as UserSearchViewController
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as UserDetailViewController
        
        
        //MARK: make snapshot of cell
        let containderView = transitionContext.containerView()
        let selectedIndexPath = fromVC.collectionView.indexPathsForSelectedItems().first as NSIndexPath
        let cell = fromVC.collectionView.cellForItemAtIndexPath(selectedIndexPath) as UserCollectionViewCell
        let snapshotOfSelectedCell = cell.userImage.snapshotViewAfterScreenUpdates(false)
        cell.userImage.hidden = true
        snapshotOfSelectedCell.frame = containderView.convertRect(cell.userImage.frame, fromView: cell.userImage.superview)
        
        
        toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
        toVC.view.alpha = 0
        toVC.userImageView.hidden = true
        
        containderView.addSubview(toVC.view)
        containderView.addSubview(snapshotOfSelectedCell)
        
        toVC.view.setNeedsLayout()
        toVC.view.layoutIfNeeded()
        
        let duration = self.transitionDuration(transitionContext)
        
//        UIView.animateWithDuration(duration, animations: { () -> Void in
//            toVC.view.alpha = 1.0
//        })
        
            //            let frame = containderView.convertRect(toVC.userImageView.frame, fromView: toVC.view)
            //        }) { (finished) -> Void in
            //            toVC.userImageView.hidden = false
            //            cell.userImage.hidden = false
            //            snapshotOfSelectedCell.removeFromSuperview()
            //            transitionContext.completeTransition(true)
            //        }
        UIView.animateKeyframesWithDuration(duration, delay: 0.0, options: nil, animations: { () -> Void in
            UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.5, animations: { () -> Void in
                toVC.view.alpha = 0.5
                snapshotOfSelectedCell.center = containderView.center
                
            })
            UIView.addKeyframeWithRelativeStartTime(0.5, relativeDuration: 0.5, animations: { () -> Void in
                toVC.view.alpha = 1.0
                let frame = containderView.convertRect(toVC.userImageView.frame, fromView: toVC.view)
                snapshotOfSelectedCell.frame = frame
            })
            }) { (finished) -> Void in
                

                toVC.userImageView.hidden = false
                snapshotOfSelectedCell.removeFromSuperview()
                transitionContext.completeTransition(true)
                //unhide the original cell
                cell.userImage.hidden = false
                
        }
    }


}
            







