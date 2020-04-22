//
//  ContainerViewController.swift
//  AddEditPerson
//
//  Created by Elena Kacharmina on 16.04.2020.
//  Copyright © 2020 Elena Kacharmina. All rights reserved.
//

import UIKit
import QuartzCore

import Firebase

class ContainerViewController: UIViewController {
    enum SlideOutState {
        case bothCollapsed
        case leftPanelExpanded
    }
    
    var root: RootViewProtocol!
    var centerNavigationController: UINavigationController!
    var centerViewController: CenterViewProtocol!
    
    var userID = Auth.auth().currentUser?.uid
    
    var currentState: SlideOutState = .bothCollapsed {
        didSet {
            let shouldShowShadow = currentState != .bothCollapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    var leftViewController: SidePanelViewController?
    
    let centerPanelExpandedOffset: CGFloat = 90
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerViewController = CenterViewController()

        centerViewController.delegate = self

        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        view.addSubview(centerNavigationController.view)
        addChild(centerNavigationController)

        centerNavigationController.didMove(toParent: self)
        
        let panGestureRecognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(handlePanGesture(_:)))
        centerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
    }
}

// MARK: CenterViewController delegate

extension ContainerViewController: CenterViewControllerDelegate {
    
    func toggleLeftPanel() {
        let notAlreadyExpanded = (currentState != .leftPanelExpanded)
        
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func logOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        root.popToRoot()
    }
    
    
    func addLeftPanelViewController() {
        guard leftViewController == nil else { return }
        let vc = SidePanelViewController()
        
        addChildSidePanelController(vc)
        leftViewController = vc
        leftViewController?.delegate = self
        leftViewController?.view.backgroundColor = UIColor(red: 224/255, green: 255/255, blue: 169/255, alpha: 1)
    }
    
    func animateLeftPanel(shouldExpand: Bool) {
        if shouldExpand {
            currentState = .leftPanelExpanded
            animateCenterPanelXPosition(
                targetPosition: centerNavigationController.view.frame.width
                    - centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { _ in
                self.currentState = .bothCollapsed
                self.leftViewController?.view.removeFromSuperview()
                self.leftViewController = nil
            }
        }
    }
    
    func collapseSidePanels() {
        switch currentState {
        case .leftPanelExpanded:
            toggleLeftPanel()
        case .bothCollapsed:
            break
        }
    }
    
    func addChildSidePanelController(_ sidePanelController: SidePanelViewController) {
        view.insertSubview(sidePanelController.view, at: 0)
        
        addChild(sidePanelController)
        sidePanelController.didMove(toParent: self)
    }
    
    func animateCenterPanelXPosition(
        targetPosition: CGFloat,
        completion: ((Bool) -> Void)? = nil) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: .curveEaseInOut,
            animations: {
                self.centerNavigationController.view.frame.origin.x = targetPosition
        },
            completion: completion)
    }
    
    func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
        if shouldShowShadow {
            centerNavigationController.view.layer.shadowRadius = 10
            centerNavigationController.view.layer.masksToBounds = false
            centerNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
}

// MARK: Gesture recognizer

extension ContainerViewController: UIGestureRecognizerDelegate {
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let gestureIsDraggingFromLeftToRight = (recognizer.velocity(in: view).x > 0)
        
        switch recognizer.state {
        case .began:
            if currentState == .bothCollapsed {
                if gestureIsDraggingFromLeftToRight {
                    addLeftPanelViewController()
                    showShadowForCenterViewController(true)
                }
                
            }
            
        case .changed:
            if let rview = recognizer.view {
                if rview.center.x + recognizer.translation(in: view).x > view.frame.width / 2 {
                    rview.center.x = rview.center.x + recognizer.translation(in: view).x
                    recognizer.setTranslation(CGPoint.zero, in: view)
                }
            }
            
        case .ended:
            if let _ = leftViewController,
                let rview = recognizer.view {
                // animate the side panel open or closed based on whether the view
                // has moved more or less than halfway
                let hasMovedGreaterThanHalfway = rview.center.x > view.bounds.size.width
                animateLeftPanel(shouldExpand: hasMovedGreaterThanHalfway)
            }
            
        default:
            break
        }
    }
}

extension ContainerViewController: SidePanelViewControllerDelegate {
    
    func changeCenterView(to newMode: CenterViewMode, objectIndex: Int?) {
        
        let new: CenterViewProtocol!
        
        switch newMode {
        case .editMode:
            new = CenterViewController()
            if let new = new as? CenterViewController {
                new.objectIndex = objectIndex
            }
        case .viewMode:
            new = ViewModeViewController()
        default:
            new = AboutAppViewController()
        }
        
        centerViewController = new
        
        guard new != nil else { return }
        
        let newNav = UINavigationController(rootViewController: new)
        
        centerNavigationController.willMove(toParent: nil)
        addChild(newNav)
        toggleLeftPanel()
        
        newNav.view.frame = view.bounds
        view.addSubview(newNav.view)
        newNav.didMove(toParent: self)
        centerNavigationController.view.removeFromSuperview()
        centerNavigationController.removeFromParent()
        centerNavigationController = newNav
        
        centerViewController.delegate = self
        
        let panGestureRecognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(handlePanGesture(_:)))
        centerNavigationController.view.addGestureRecognizer(panGestureRecognizer)
    }
}


extension ContainerViewController: ViewModeDelegateProtocol {
    
}
