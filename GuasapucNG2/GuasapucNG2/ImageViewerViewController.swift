//
//  ImageViewController.swift
//  GuasapucNG2
//
//  Created by Nicolás Gebauer on 21-09-15.
//  Copyright © 2015 Nicolás Gebauer. All rights reserved.
//

import UIKit

class ImageViewerViewController: UIViewController {

    @IBOutlet weak var ImageView: UIImageView!
    var urlString = "nothing"
    var url: NSURL?
    var data: NSData?
    var img: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //var urlPieces = urlString.componentsSeparatedByString(":")
        //urlPieces.removeAtIndex(0)
        //urlString = "https:" + urlPieces.joinWithSeparator(":")
        url = NSURL(string: urlString)
        if url != nil {
            data = NSData(contentsOfURL: url!)
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if data != nil {
            img = UIImage(data: data!)
            ImageView.image = img
            ImageView.reloadInputViews()
        }
    }

}