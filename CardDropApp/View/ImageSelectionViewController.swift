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
    
    let imageDataRequest = DataRequest<Image>(dataSource:"Images")
    
    var imageData = [Image]()
    
    
    @IBOutlet weak var initialImageView: UIImageView!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var initialDimView: UIView!
    
    var currentScrollViewPage: Int = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialDimView.alpha = 0
        backButton.alpha = 0
        
        if let availableImage = image, let availableCategory = category
        {
            initialImageView.image = availableImage
            categoryLabel.text = availableCategory.categoryName
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadData()
        
    }
    
    func loadData()  {
        
        imageDataRequest.getData { [weak self] dataResult in
            
            switch  dataResult
            {
            case .failure :
                print("Could not load Images")
                
            case .success(let images):
                self?.imageData = images
                
                //the load images is not using the main threat so here we are forcing it.`
                DispatchQueue.main.async {
                    self?.setupUI()
                }
                
                
            }
        }
        
    }
    
    func setupUI(){
        
        
        UIView.animate(withDuration: 0.5) {
            self.initialDimView.alpha = 1
            self.backButton.alpha = 1
        }
        
        scrollView.delegate = self
        scrollView.contentSize.width = self.scrollView.frame.width * CGFloat(imageData.count + 1)
        
        
        //for each image that we have in the data base or whatever, here we setting up the image view for them.
        for (i, image) in imageData.enumerated()
        {
            let frame = CGRect(x: self.scrollView.frame.width * CGFloat(i + 1) , y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
            
            //getting the photoView.xib
            guard let photoView = Bundle.main.loadNibNamed("PhotoViews", owner: self, options: nil)?.first as? PhotoViews else {return}
            
            photoView.frame = frame
            photoView.imageView.image = UIImage(named: image.imageName)!
            
            photoView.descriptionLabel.text = image.description
            photoView.photographerLabel.text = image.photographer
            
            //adding the photoview to the scrollview.
            scrollView.addSubview(photoView)
            
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ImageSelectionViewController.didPRessOnScrollView(recognizer:)))
        
        scrollView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    func didPRessOnScrollView (recognizer: UITapGestureRecognizer)
    {
        if currentScrollViewPage != 0 {
         
            self.performSegue(withIdentifier: "showCard", sender: self)
            
        }else{
            scrollView.setContentOffset(CGPoint(x: self.view.frame.width, y: 0), animated: true)
            currentScrollViewPage = 1
        }
        
    }
    
    
    @IBAction func goBack(_ sender: UIButton) {
        
        
        //this whole thing makes a animation to back to the fisrt viewController
        UIView.animate(withDuration: 0.3, animations: {
            
            self.scrollView.setContentOffset(CGPoint.zero, animated: false)
            
            
        }) { _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.initialDimView.alpha = 0
                sender.alpha = 0
            }, completion: { _ in
                
                self.navigationController?.popViewController(animated: true)
                
            })
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCard"
        {
            guard let sendCardVC = segue.destination as? ShareCardViewController else {return}
            guard let imageToSend = UIImage(named: imageData[currentScrollViewPage - 1].imageName) else {return}
            
            sendCardVC.backgroundImage = imageToSend
            sendCardVC.modalTransitionStyle = .crossDissolve
            
        }
    }
    
}

extension ImageSelectionViewController : Scaling
{
    func scalingImageView(transition: ScaleTransitioningDelegate) -> UIImageView? {
        return initialImageView
    }
}

//getting the image selected throgh the scrollView.
extension ImageSelectionViewController : UIScrollViewDelegate
{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentScrollViewPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
}
