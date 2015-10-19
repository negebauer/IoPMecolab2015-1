//
//  ChatRoomViewController.swift
//  GuasapucNG2
//
//  Created by Nicolás Gebauer on 31-08-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import UIKit

/// View that manages the display of a chatRoom
class ChatRoomViewController: UIViewController, ChatMessageListDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    var tableDelegate: TablaChatRoomDelegate!
    weak var refChatRoomToShow: ChatRoom!
    weak var refChatViewController: ChatViewController!
    var kbHeight: CGFloat = 0
    var imagePicker : UIImagePickerController!
    var imageMimeType = "image/jpeg"
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        crearTabla()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        textField.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollToBottom()
    }
    
    func crearTabla() {
        tableDelegate = TablaChatRoomDelegate()
        
        tableDelegate.refChatRoomViewController = self
        tableDelegate.refChatRoomToShow = refChatRoomToShow
        tableView.delegate = tableDelegate
        tableView.dataSource = tableDelegate
    }
    
    // MARK: - UICalls
    
    @IBAction func sendImageOptions(sender: AnyObject) {
        if imagePicker == nil {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
        }
        
        let alert = UIAlertController(title: "Enviar imagen", message: "", preferredStyle: .ActionSheet)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in }
        
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Take Picture", style: .Default) { action -> Void in
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .Camera
            //self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(.Camera)!
            
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Choose From Camera Roll", style: .Default) { action -> Void in
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .PhotoLibrary
            //self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(.PhotoLibrary)!
            
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(takePictureAction)
        alert.addAction(choosePictureAction)
        
        alert.popoverPresentationController?.sourceView = sender as? UIView;
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func sendMessage(sender: AnyObject) {
        let newMessage = ChatMessage.new((UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!,
            sender: User.currentUser!.number, content: textField.text!, createdAt: getStringFromDate(NSDate()),
            id: Int(refChatRoomToShow.id), isFile: false, fileURL: "", mimeType: "", chatRoom: refChatRoomToShow)
        refChatRoomToShow.addChatMessageToChat(newMessage)
        
        let request = CreateRequest.sendMessageToConversation(newMessage.content,
            sender: newMessage.content, id: Int(refChatRoomToShow.id))
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            
            let jsonContainer = JSONObjectCreator(data: data, type: JSONObject.TiposDeJSON.ChatMessage, error: error)
            print(jsonContainer.description)
            for _ in jsonContainer.arrayJSONObjects {
                dispatch_async(dispatch_get_main_queue(), {
                    
                })
            }
            
        }
        task.resume()
        textField.text = ""
    }
    
    // MARK: - Table scrolling
    
    func scrollToBottom() {
        let numberOfSections = tableView.numberOfSections - 1
        let numberOfRows = tableView.numberOfRowsInSection(numberOfSections) - 1
        let indexPath = NSIndexPath(forRow: numberOfRows, inSection: numberOfSections)
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
    }
    
    // MARK: - Image sending support
    
    func sendImage(image:UIImage){
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        // Obtained from https://github.com/sraj/Swift-SRWebClient
        SRWebClient.POST(CreateRequest.sendFileMessageURL)
            .data(imageData!, fieldName:"file",
                data:[
                    "file_mime_type": imageMimeType,
                    "conversation_id": refChatRoomToShow.id.stringValue,
                    "sender": User.currentUser!.number
                ])
            .headers(["Authorization": CreateRequest.tokenFormatted])
            .send({(response:AnyObject!, status:Int) -> Void in
                //process success response
                NSLog(response.description)
                NSLog("\(response)")
                },failure:{(error:NSError!) -> Void in
                    //process failure response
                    NSLog(error.description)
            })
    }
    
    // MARK: - UITextFieldDelegate methods
    
    func animateTextField(up: Bool) {
        let movement = (up ? -kbHeight : kbHeight)
        
        UIView.animateWithDuration(0.3, animations: {
            self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        })
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y = -keyboardSize.height + 50
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y = 0
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - UIImagePickerControllerDelegate methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        /* Available options for info
        UIImagePickerControllerMediaType
        UIImagePickerControllerOriginalImage
        UIImagePickerControllerEditedImage
        UIImagePickerControllerCropRect
        UIImagePickerControllerMediaURL
        UIImagePickerControllerReferenceURL
        UIImagePickerControllerMediaMetadata
        */
        if let pickedEditedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            sendImage(pickedEditedImage)
        } else if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            sendImage(pickedImage)
        } else if let _ = info[UIImagePickerControllerMediaURL] as? NSURL {
            
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UINavigationControllerDelegate
    
    // MARK: - ChatMessageListDelegate methods
    
    var table: UITableView {
        return tableView
    }
    
    func reloadChatRoom() {
        
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "IDMostrarImagen" {
            let chatMessage = sender as? ChatMessage
            let imageViewer = segue.destinationViewController as? ImageViewerViewController
            imageViewer?.urlString = (chatMessage?.fileURL)!
        }
    }

}
