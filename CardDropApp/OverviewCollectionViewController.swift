//
//  OverviewCollectionViewController.swift
//  CardDropApp
//
//  Created by Mozart Falcão on 30/05/19.
//  Copyright © 2019 Mozart Falcão. All rights reserved.
//
import UIKit

class OverviewCollectionViewController: UICollectionViewController {
    
    let categoryDataRequest = DataRequest<Category>(dataSource: "Categories")
    var categoryData = [Category]()
    
    var selectedIndexPath: IndexPath?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    func loadData()
    {
        //calling a data from Data source of a plist.
        categoryDataRequest.getData { [weak self] dataResult in
            switch dataResult {
            case .failure:
                print("Could not Load categories")
            case .success(let categories):
                self?.categoryData = categories
                self?.collectionView.reloadData()
            }
        }
    }
    
    //preparing for segue.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"
        {
            //getting the category array and unwrapping sender as Category
            let category = sender as! Category
            guard let image = UIImage(named: category.categoryImageName) else {return}
            
            
            let imageSelectionVC = segue.destination as! ImageSelectionViewController
            imageSelectionVC.image = image
            imageSelectionVC.category = category
            
            
        }
    }
    
}

// MARK: - CollectionView DataSource

extension OverviewCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryData.count
    }
    
    //here we configure each cell of collection
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let category = categoryData[indexPath.item]
        
        
        //make a UNWRAP CollectionView to CategoryCollectionView
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CategoryCollectionViewCell
            else {fatalError("Could not create proper category for collection view")}
        
        
        guard let image = UIImage(named: category.categoryImageName) else {
            fatalError("Coud not load image for cell")
        }
        
        cell.backgroundImageView.image = image
        cell.categoryLabel.text = category.categoryName
        
        //cell.categoryLabel.text = category.categoryName
        
        
        return cell
        
    }
}

// MARK: - CollectionView Delegate

extension OverviewCollectionViewController {
    
    //function to set the collectionview layout
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        cell.layer.cornerRadius = 14
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let category = categoryData[indexPath.item]
        selectedIndexPath = indexPath
        self.performSegue(withIdentifier: "showDetail", sender: category)
        
    }
}

// MARK: - CollectionView Layout Delegate
extension OverviewCollectionViewController : UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
     
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
     }
    
}

// MARK: Transitioning Anumation Delegate
extension OverviewCollectionViewController : Scaling
{
    func scalingImageView(transition: ScaleTransitioningDelegate) -> UIImageView? {
        if let indexPath = selectedIndexPath {
            guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell
                else{return nil}
            
            return cell.backgroundImageView
            
        }
        
        return nil
    }
    
    
}
