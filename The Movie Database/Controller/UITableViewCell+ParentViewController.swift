//
//  UITableViewCell+ParentViewController.swift
//  The Movie Database
//
//  Created by NIKITA on 25.05.2024.
//


import UIKit

extension UITableViewCell {
    @objc var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
