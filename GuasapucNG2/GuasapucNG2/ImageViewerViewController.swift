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

        url = NSURL(string: urlString)
        if url != nil {
            data = NSData(contentsOfURL: url!)
        }
        if data != nil {
            ImageView.hidden = true
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if data != nil {
            img = UIImage(data: data!)
            ImageView.image = img
            ImageView.reloadInputViews()
        }
        ImageView.hidden = false
    }

}