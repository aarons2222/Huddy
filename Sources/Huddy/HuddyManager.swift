//
//  File.swift
//  
//
//  Created by Aaron Strickland on 02/03/2023.
//


import Foundation
import UIKit
import SwiftUI

@available(iOS 14.0, *)
class HuddyManager {
    
    static func showHuddy(state: HuddyState, title: String, in viewController: UIViewController) {
        let huddyView = HuddyView(state: state, title: title)
        let huddyViewController = UIHostingController(rootView: huddyView)
        huddyViewController.view.backgroundColor = UIColor.clear
        huddyViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        viewController.addChild(huddyViewController)
        viewController.view.addSubview(huddyViewController.view)
        
        // Set up constraints for the huddy view
        NSLayoutConstraint.activate([
            huddyViewController.view.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            huddyViewController.view.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
            huddyViewController.view.heightAnchor.constraint(equalToConstant: 80),
        ])
        
        // Add the top constraint after the top layout guide has been set up
        let topConstraint = huddyViewController.view.topAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.topAnchor, constant: -80)
        NSLayoutConstraint.activate([topConstraint])
        
        // Layout the view hierarchy before animating the huddy view
        viewController.view.layoutIfNeeded()
        
        // Animate the huddy view sliding up
        UIView.animate(withDuration: 0.5, animations: {
            topConstraint.constant = 0
            viewController.view.layoutIfNeeded()
        }) { _ in
            // Use a DispatchQueue to introduce a delay before animating the huddy view sliding down
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                // Animate the huddy view sliding down
                topConstraint.constant = -80
                UIView.animate(withDuration: 1.0, animations: {
                }) { _ in
                    huddyViewController.willMove(toParent: nil)
                    huddyViewController.view.removeFromSuperview()
                    huddyViewController.removeFromParent()
                }
            }
        }
    }
}

