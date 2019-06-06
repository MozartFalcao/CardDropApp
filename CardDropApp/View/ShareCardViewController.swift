//
//  SendCardViewController.swift
//  CardDropApp
//
//  Created by Mozart Falcão on 06/06/19.
//  Copyright © 2019 Mozart Falcão. All rights reserved.
//

import UIKit

class ShareCardViewController: UIViewController {

//    @IBOutlet weak var backgroundImageView: UIImageView!
//    @IBOutlet weak var textContainerView: UIView!
//    @IBOutlet weak var quoteLabel: UILabel!
//    @IBOutlet weak var authorLabel: UILabel!
    
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var textContainerView: UIView!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    
    var backgroundImage:UIImage?
    let quoteDataRequest = DataRequest<Quote>(dataSource: "Quotes")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let image = backgroundImage else {return}
        backgroundImageView.image = image
        
        loadData()
        
    }
    
    func loadData() {
        
        quoteDataRequest.getData{ [weak self] dataResult in
            switch dataResult {
            case .failure:
                print("Could not load images")
            case .success (let quotes):
                let randomNumber = Int.random(in: 0 ..< quotes.count)
                DispatchQueue.main.async {
                    self?.authorLabel.text = quotes[randomNumber].author
                    self?.quoteLabel.text = quotes[randomNumber].quote
                }
            }
        }
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        
        self.dismiss(animated: true)
        
    }
    
    @IBAction func shareCard(_ sender: UIButton) {
        //getting all that inside the View and hide the objects that you want.
        _ = textContainerView.subviews.filter({$0 is UIButton}).map({$0.isHidden = true})
        //take a screenshot
        let image = self.view.screenshot()
       
        _ = textContainerView.subviews.filter({$0 is UIButton}).map({$0.isHidden = false})
        
        let activityVC = UIActivityViewController(activityItems:[image], applicationActivities: nil)
        self.present(activityVC, animated: true)
        
    }
    
    
    

}


extension UIView {
    
    func screenshot() -> UIImage {
        return UIGraphicsImageRenderer(size: bounds.size).image { _ in
            drawHierarchy(in: CGRect(origin: .zero, size: bounds.size), afterScreenUpdates: true)
        }
    }
    
}
