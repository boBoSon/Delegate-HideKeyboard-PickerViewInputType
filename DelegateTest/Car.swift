//
//  Car.swift
//  DelegateTest
//
//  Created by 邱柏盛 on 2017/9/4.
//  Copyright © 2017年 BB. All rights reserved.
//

import UIKit

protocol CarDelegate: class {
    func moveForwardOnScreen(car: Car)
}

class Car: NSObject {
    
    var steps = 0
    weak var delegate: CarDelegate?
    
    
    func go() {
        // 最多走 5 步
        if steps == 5 {
            return
        }
        steps += 1
        delegate?.moveForwardOnScreen(car: self)
    }

}
