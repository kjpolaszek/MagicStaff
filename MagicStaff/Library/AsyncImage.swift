//
//  AsyncImage.swift
//  MagicStaff
//
//  Created by Karol Polaszek on 14/04/2019.
//  Copyright © 2019 Karol Polaszek. All rights reserved.
//

import UIKit

class AsyncImage {
    
    private(set) var isPlaceholder: Bool = false
    
    private(set) var value: UIImage?
    
    private var updateHandler: ((UIImage?) -> ())?
    
    func setObserver(_ handler: ( (UIImage?) -> ())?) {
        handler?(value)
        self.updateHandler = handler
    }
    
    func removeObserver() {
        self.updateHandler = nil
    }
    
    func update(_ value: UIImage?) {
        isPlaceholder = false
        self.value = value
        updateHandler?(value)
    }
    
    init(placeholder: UIImage?) {
        self.isPlaceholder = true
        self.value = placeholder
    }
    
    init(image: UIImage) {
        self.value = image
    }
}
