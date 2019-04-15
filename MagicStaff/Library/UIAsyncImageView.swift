//
//  UIAsyncImageView.swift
//  MagicStaff
//
//  Created by Karol Polaszek on 13/04/2019.
//  Copyright © 2019 Karol Polaszek. All rights reserved.
//

import UIKit

class UIAsyncImageView: UIImageView {
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView?
    
    private var asyncImage: AsyncImage? {
        didSet {
            oldValue?.removeObserver()
        }
    }
    
    func setAsyncImage(image: AsyncImage?) {
        asyncImage = image
        image?.setObserver {[weak self] (value) in
            DispatchQueue.main.async {
                image?.isPlaceholder == true ? self?.activityIndicator?.startAnimating() : self?.activityIndicator?.stopAnimating()
                self?.image = value
            }
        }
    }
}
