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
    private var cellOrigins: [CGPoint] = []
    private var selectedImageRow = 0

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
        
        if cellOrigins.count <= 3 {
            let frame = collectionView.convertRect(cell.frame, toView: view)
            cellOrigins.append(frame.origin)
        }
        
        cell.imageView.contentMode = imageViewContentMode
        cell.imageView.image = UIImage(named: "picture\(indexPath.row + 1)")
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("item no \(indexPath.row) selected")
//        bottomViewController?.label.text = "\(indexPath.row)"
        selectedImageRow = indexPath.row
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath)!
        
        let snapShotImage = cell.takeSnapshot()
        let animatedView = UIImageView(frame: cell.frame)
        animatedView.image = snapShotImage
        
        let frame = cell.convertRect(cell.bounds, toView: view)
        
        let offsetX = frame.origin.x
        let offsetY = frame.origin.y - view.bounds.size.height
        let position = CGPointMake(offsetX, offsetY)
        
        let snapShotImage2 = cell.takeSnapshot()
        let animatedView2 = UIImageView(frame: cell.frame)
        animatedView2.image = snapShotImage2

        let destinationIndexPath = NSIndexPath(forRow: bottomViewController!.selectedImageDropRow, inSection: 0)
        let destinationCell = bottomViewController?.collectionView.cellForItemAtIndexPath(destinationIndexPath)
        
        let destinationFrame = destinationCell?.convertRect(destinationCell!.bounds, toView: bottomViewController!.view)
        let offsetX2 = destinationFrame!.origin.x
        let offsetY2 = destinationFrame!.origin.y - offsetY
        let destination = CGPointMake(offsetX2, offsetY2)

        println("destinationFrame = \(destinationFrame)")

        println("destination = \(destination)")
        
        bottomViewController?.animateImageDrop(animatedView, position: position)
        animateImageDrop(animatedView2, destination: destination)

    }
    // MARK: - Image drop animation
    func animateImageDrop(imageView: UIImageView, destination: CGPoint)
    {
        view.addSubview(imageView)
        imageView.frame.origin = cellOrigins[self.selectedImageRow]
        
        UIImageView.animateWithDuration(0.3, animations: { () -> Void in
            imageView.backgroundColor = UIColor.redColor()
            imageView.frame.origin = destination
        })
    }
}
