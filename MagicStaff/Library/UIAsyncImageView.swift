//
//  UIImageViewExtensions.swift
//  MagicStaff
//
//  Created by Karol Polaszek on 13/04/2019.
//  Copyright © 2019 Karol Polaszek. All rights reserved.
//

import UIKit

class UIAsyncImageView: UIImageView {
    
    var asyncImage: AsyncImage?
    
    func setAsyncImage(image: AsyncImage?) {
        asyncImage?.removeObserver()
        asyncImage = image
        image?.setObserver {[weak self] (value) in
            DispatchQueue.main.async {
                self?.image = value
            }
        }
    }
}
