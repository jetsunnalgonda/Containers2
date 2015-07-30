//
//  BottomViewController.swift
//  Containers
//
//  Created by Haluk Isik on 7/29/15.
//  Copyright (c) 2015 Haluk Isik. All rights reserved.
//

import UIKit

class BottomViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate
{
    // MARK: - Outlets
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!    
    
    // MARK: - Properties
    var selectedCellLayer: CAShapeLayer!
    var emptyCellLayer: CAShapeLayer!
    
    private var imageViewContentMode = UIViewContentMode.ScaleAspectFill
    private var selectedImageView: UIImageView?
    var maximumSelectableImages = 4
    var cellImages: [UIImage?] = []
    var selectedImageDropRow = 0 {
        didSet {
            selectedImageDropRow = selectedImageDropRow % maximumSelectableImages
        }
    }
    private var cellOrigins: [CGPoint] = []

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        println("view did load")
        cellImages = [UIImage?](count: maximumSelectableImages, repeatedValue: nil)
        label.text = "Select Photos (Maximum \(maximumSelectableImages))"

    }
    // MARK: - Actions
    @IBAction func done() {
        println("done")
    }
    // MARK: - Methods
    func updateCellCoordinates()
    {
        println("updateCellCoordinates")
        for i in 0..<maximumSelectableImages {
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Cell.SelectedPhotoCell, forIndexPath: indexPath) as! ContainersCollectionViewCell
            let frame = collectionView.convertRect(cell.frame, toView: view)
            cellOrigins[i] = frame.origin
        }
    }
    
    // MARK: - Scroll View Delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        updateCellCoordinates()
    }

    // MARK: - Collection View Data Source
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return maximumSelectableImages
    }
    
    private struct Cell {
        static let SelectedPhotoCell = "selected photo cell"
        static let EmptyPhotoCell = "empty photo cell"
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(Cell.SelectedPhotoCell, forIndexPath: indexPath) as! ContainersCollectionViewCell
        
        if cellOrigins.count <= 3 {
            let frame = collectionView.convertRect(cell.frame, toView: view)
            cellOrigins.append(frame.origin)
        }
        
        switch indexPath.row {
        case selectedImageDropRow:
            setUpEmptyLayer(cell.layer)
            drawDashedBorderAroundView(cell, selected: true)
            if selectedImageView != nil {
//                cell.imageView.image = selectedImageView?.image
                cellImages[selectedImageDropRow] = selectedImageView?.image
                setUpLayer(cell.layer)
                cell.imageView.contentMode = imageViewContentMode
                selectedImageView = nil
                selectedImageDropRow++
            }
        default:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(Cell.EmptyPhotoCell, forIndexPath: indexPath) as! ContainersCollectionViewCell
            
            setUpEmptyLayer(cell.layer)
            drawDashedBorderAroundView(cell)
            
            if cellImages[indexPath.row] != nil {
                setUpLayer(cell.layer)
                cell.imageView.contentMode = imageViewContentMode
            }
            
        }
        cell.imageView.image = cellImages[indexPath.row]

        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("item no \(indexPath.row) selected")
        selectedImageDropRow = indexPath.row
        collectionView.reloadData()
    }

    // MARK: - Collection View Cell
    func setUpLayer(layer: CALayer)
    {
        layer.backgroundColor = UIColor.clearColor().CGColor
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.whiteColor().CGColor
        layer.cornerRadius = 10.0
        
//        layer.shadowOpacity = 0.7
//        layer.shadowRadius = 10.0
        //        l.contents = UIImage(named: "star")?.CGImage
        layer.contentsGravity = kCAGravityCenter
        //        l.cornerRadius = margin
        layer.masksToBounds = true
        
    }
    func setUpEmptyLayer(layer: CALayer)
    {
        layer.backgroundColor = UIColor.clearColor().CGColor
        layer.borderWidth = 0.0
        layer.borderColor = UIColor.whiteColor().CGColor
        layer.cornerRadius = 10.0
        
        //        layer.shadowOpacity = 0.7
        //        layer.shadowRadius = 10.0
        //        l.contents = UIImage(named: "star")?.CGImage
        layer.contentsGravity = kCAGravityCenter
        //        l.cornerRadius = margin
        layer.masksToBounds = true
        
    }
    func borderAroundView(v: UIView) -> CAShapeLayer
    {
        let layer: CAShapeLayer = CAShapeLayer(layer: v.layer)
        
        layer.backgroundColor = UIColor.clearColor().CGColor
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.whiteColor().CGColor
        layer.cornerRadius = 10.0
        
        //        layer.shadowOpacity = 0.7
        //        layer.shadowRadius = 10.0
        //        l.contents = UIImage(named: "star")?.CGImage
        layer.contentsGravity = kCAGravityCenter
        //        l.cornerRadius = margin
        layer.masksToBounds = true
        
        return layer
        
    }
    func drawDashedBorderAroundView(v: UIView, selected: Bool = false)
    {
        //border definitions
        let cornerRadius: CGFloat = 10
        let borderWidth: CGFloat = 2
        let dashPattern1: NSInteger = 8
        let dashPattern2: NSInteger = 8
        let lineColor = selected ? UIColor.orangeColor() : UIColor.whiteColor()
        
        //drawing
        let frame = v.bounds
        
        let _shapeLayer: CAShapeLayer = CAShapeLayer(layer: v.layer)
        
        //creating a path
        let path = CGPathCreateMutable()
        
        //drawing a border around a view
        CGPathMoveToPoint(path, nil, 0, frame.size.height - cornerRadius)
        CGPathAddLineToPoint(path, nil, 0, cornerRadius)
        CGPathAddArc(path, nil, cornerRadius, cornerRadius, cornerRadius, CGFloat(M_PI), -CGFloat(M_PI_2), false)
        CGPathAddLineToPoint(path, nil, frame.size.width - cornerRadius, 0);
        CGPathAddArc(path, nil, frame.size.width - cornerRadius, cornerRadius, cornerRadius, CGFloat(-M_PI_2), 0, false)
        CGPathAddLineToPoint(path, nil, frame.size.width, frame.size.height - cornerRadius);
        CGPathAddArc(path, nil, frame.size.width - cornerRadius, frame.size.height - cornerRadius, cornerRadius, 0, CGFloat(M_PI_2), false)
        CGPathAddLineToPoint(path, nil, cornerRadius, frame.size.height)
        CGPathAddArc(path, nil, cornerRadius, frame.size.height - cornerRadius, cornerRadius, CGFloat(M_PI_2), CGFloat(M_PI), false)
        
        //path is set as the _shapeLayer object's path
        _shapeLayer.path = path
        
        _shapeLayer.backgroundColor = UIColor.clearColor().CGColor
        _shapeLayer.frame = frame
        _shapeLayer.masksToBounds = false
        _shapeLayer.setValue(NSNumber(bool: false), forKey: "isCircle")
        _shapeLayer.fillColor = UIColor.clearColor().CGColor
        _shapeLayer.strokeColor = lineColor.CGColor
        _shapeLayer.lineWidth = borderWidth
        _shapeLayer.lineDashPattern = [NSNumber(integer: dashPattern1), NSNumber(integer: dashPattern2)]
        _shapeLayer.lineCap = kCALineCapRound
        
        //_shapeLayer is added as a sublayer of the view, the border is visible
        v.layer.addSublayer(_shapeLayer)
        v.layer.cornerRadius = cornerRadius
//        return _shapeLayer
    }
    
    // MARK: - Image drop animation
    func animateImageDrop(imageView: UIImageView, position: CGPoint)
    {
        view.addSubview(imageView)
        
        imageView.frame.origin = position

        UIImageView.animateWithDuration(0.3, animations: { () -> Void in
            imageView.frame.origin = self.cellOrigins[self.selectedImageDropRow]
        }) { (Bool) -> Void in
            self.selectedImageView = imageView
            imageView.removeFromSuperview()
            self.collectionView.reloadData() //ItemsAtIndexPaths([NSIndexPath(forRow: self.selectedImageDropRow, inSection: 0)])
        }
        println("cellOrigins[self.selectedImageDropRow] = \(cellOrigins[self.selectedImageDropRow])")

    }

    
}
