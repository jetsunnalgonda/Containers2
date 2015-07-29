//
//  ViewController.swift
//  Containers
//
//  Created by Haluk Isik on 7/29/15.
//  Copyright (c) 2015 Haluk Isik. All rights reserved.
//

import UIKit

protocol BottomViewControllerDelegate: class {
    var bottomViewController: BottomViewController? { get set }
}

class ContainersViewController: UIViewController
{
    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - Properties
    weak var delegate: BottomViewControllerDelegate?
    var topViewController: TopViewController!
    var bottomViewController: BottomViewController!

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = topViewController
        delegate?.bottomViewController = bottomViewController
        
    }
    

    // MARK: - Navigation
    private struct Segue {
        static let Top = "Top"
        static let Bottom = "Bottom"
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        var destination: AnyObject = segue.destinationViewController
        if let navCon = destination as? UINavigationController {
            destination = navCon.visibleViewController
        }
        if let identifier = segue.identifier {
            switch identifier {
            case Segue.Top:
                if let tvc = destination as? TopViewController {
                    topViewController = tvc
                }
            case Segue.Bottom:
                if let bvc = destination as? BottomViewController {
                    bottomViewController = bvc
                }
            default: break
            }
        }
        
    }

    
}

