//
//  ImageViewerViewController.swift
//  GuasapucNG
//
//  Created by Nicolás Gebauer on 14-09-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import UIKit

class ImageViewerViewController: UIViewController {

    @IBOutlet weak var Image: UIImageView!
    var urlString = "nothing"
    var url: NSURL?
    var data: NSData?
    var img: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        url = NSURL(string: urlString)
        if url != nil {
            println(url)
            println(urlString)
            data = NSData(contentsOfURL: url!)
            println(data)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if data != nil {
            println(data)
            img = UIImage(data: data!)
            Image.image = img
            Image.reloadInputViews()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
