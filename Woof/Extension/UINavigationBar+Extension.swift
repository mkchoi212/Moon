//
//  UINavigationBar+Extension.swift
//  Woof
//
//  Created by Mike Choi on 2/21/22.
//

import Foundation
import UIKit

extension UINavigationController {
    // Remove back button text
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
