//
//  PanDirectionGestureRecognizer.swift
//  Social_Network_Service
//
//  Created by Yoojin Park on 2020/07/24.
//  Copyright © 2020 Newbie_iOS_Developer. All rights reserved.
//

// PanGesture 좌/우, 상/하로만 이벤트 받을 수 있도록 한 Custom PanGesture

import UIKit

enum PanDirection {
    case vertical
    case horizontal
}

class PanDirectionGestureRecognizer: UIPanGestureRecognizer {
    let direction: PanDirection
    
    init(direction: PanDirection, target: AnyObject, action: Selector) {
        self.direction = direction
        super.init(target: target, action: action)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        
        if state == .began {
            let vel = velocity(in: view)
            
            switch direction {
            case .horizontal where abs(vel.y) > abs(vel.x):
                state = .cancelled
            case .vertical where abs(vel.x) > abs(vel.y):
                state = .cancelled
            default:
                break
            }
        }
    }
}
