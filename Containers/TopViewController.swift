//
//  TopViewController.swift
//  Containers
//
//  Created by Haluk Isik on 7/29/15.
//  Copyright (c) 2015 Haluk Isik. All rights reserved.
//

import UIKit

class TopViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BottomViewControllerDelegate
{
    // MARK: - Properties
    var imageViewContentMode = UIViewContentMode.ScaleAspectFill
    private var _bottomViewController: BottomViewController?
    var bottomViewController: BottomViewController? {
        get {
            return _bottomViewController
        }
        set {
            _bottomViewController = newValue
        }
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Collection View Data Source
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 3
    }
    
    private struct Cell {
        static let Photo = "photo"
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Cell.Photo, forIndexPath: indexPath) as! ContainersCollectionViewCell
        
        cell.imageView.contentMode = imageViewContentMode
        cell.imageView.image = UIImage(named: "picture\(indexPath.row + 1)")
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("item no \(indexPath.row) selected")
        bottomViewController?.label.text = "\(indexPath.row)"
    }

}
