//
//  NumberViewController.swift
//  GuasapucNG2
//
//  Created by Nicolás Gebauer on 18-10-15.
//  Copyright © 2015 Nicolás Gebauer. All rights reserved.
//

import UIKit

class NumberViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        user = User.currentUser
        textField.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if user.number == "" {
            textField.hidden = false
        } else {
            user.getToken()
            performSegueWithIdentifier("IDMoveOn", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setNumber(sender: AnyObject) {
        user.number = textField.text!
        saveDatabase()
        user.getToken()
        performSegueWithIdentifier("IDMoveOn", sender: self)
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
