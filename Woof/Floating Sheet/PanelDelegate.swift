//
//  PanelDelegate.swift
//  Woof
//
//  Created by Mike Choi on 12/13/21.
//

import UIKit
import FloatingPanel

final class PanelDelegate: FloatingPanelControllerDelegate {
    class PanelLayout: FloatingPanelBottomLayout {
        override var initialState: FloatingPanelState {
            .tip
        }
        
        override var position: FloatingPanelPosition {
            .bottom
        }
    }
    
    func floatingPanelWillBeginDragging(_ vc: FloatingPanelController) {
        if vc.state == .full {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    func floatingPanel(_ fpc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        PanelLayout()
    }
}
