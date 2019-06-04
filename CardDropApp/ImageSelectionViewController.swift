//
//  ImageSelectionViewController.swift
//  CardDropApp
//
//  Created by Mozart Falcão on 30/05/19.
//  Copyright © 2019 Mozart Falcão. All rights reserved.
//

import UIKit

class ImageSelectionViewController: UIViewController {

    var image:UIImage?
    var category:Category?
    
    @IBOutlet weak var initialImageView: UIImageView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let availableImage = image, let availableCategory = category
        {
            initialImageView.image = availableImage
            categoryLabel.text = availableCategory.categoryName
        }
    
        
    }
    
}

extension ImageSelectionViewController : Scaling
{
    func scalingImageView(transition: ScaleTransitioningDelegate) -> UIImageView? {
        return initialImageView
    }
}
