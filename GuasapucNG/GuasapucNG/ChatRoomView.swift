//
//  ChatRoomView.swift
//  GuasapucNG
//
//  Created by Nicolás Gebauer on 04-05-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import UIKit

class ChatRoomView: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var chatRoomToShow : ChatRoom!
    var kbHeight: CGFloat = 0
    weak var referenciaAlViewController: ViewController!
    weak var referenciaAlViewControllerGroups: ViewControllerGroups!
    var content = ""
    var delegateTablaMensajes: TablaChatRoomDelegate?
    var delegateTablaMensajesGroups: TablaChatsDelegateGroups?
    var imagePicker : UIImagePickerController!
    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var TablaMensajes: UITableView!
    @IBOutlet weak var BottomConstraint: NSLayoutConstraint!
    
    @IBAction func UpdateChatRoom(sender: AnyObject) {
        updateChatRoom()
    }
    
    @IBAction func SendImage(sender: AnyObject) {
        if imagePicker == nil {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
        }
        
        func useCamera() {
        }
        
        func selectImage() {
            
        }
        
        var alert = UIAlertController(title: "Enviar imagen", message: "", preferredStyle: .ActionSheet)
        
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
        
        alert.popoverPresentationController?.sourceView = sender as! UIView;
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        func availableOptionsForInfo() {
            UIImagePickerControllerMediaType
            UIImagePickerControllerOriginalImage
            UIImagePickerControllerEditedImage
            UIImagePickerControllerCropRect
            UIImagePickerControllerMediaURL
            UIImagePickerControllerReferenceURL
            UIImagePickerControllerMediaMetadata
            
        }
        if let pickedEditedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            //NSLog("Deberia enviar una imagen editada")
            sendImage(pickedEditedImage)
        }
        else if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //NSLog("Deberia enviar una imagen")
            sendImage(pickedImage)
        }
        else if let pickedVideo = info[UIImagePickerControllerMediaURL] as? NSURL {
            //NSLog("Deberia enviar un video")
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func procesarImagenEnviada(response:AnyObject) {
        /* Algo mas simple (arcaico) */
        let stringCompleto = response.description
            /* Formato string
                [{
                    "id":963,
                    "sender":"56962448489",
                    "conversation_id":103,
                    "file":
                        {
                            "url":"http://guasapuc.herokuapp.com/system/message_contents/contents/000/000/125/original/1441598558291.jpg?1441598562",
                            "mime_type":"image/jpeg"
                        },
                    "created_at":"2015-09-07T04:02:42.874Z"
                }]
            */
        let firstCut = stringCompleto.componentsSeparatedByString("url")
        if firstCut.count < 2 { return }
        let stringCompletoCortado:String? = firstCut[1]
        if stringCompletoCortado == nil { return }
        
        var i = 0
        var limit = 10000
        var url1 = ""
        for c in stringCompletoCortado! {
            if i < 3 || i > limit { i++ }
            else if c == "," { i++; limit = i }
            else { i++; url1 = url1 + String(c) }
        }
        
        i = 0
        limit = count(url1) - 2
        var url2 = ""
        for c in url1 {
            if i < limit { url2 = url2 + String(c); i++ }
        }
        
        sendMessageURL(url2)
        
        /* Primer approach
        let jsonSwift : AnyObject? = NSJSONSerialization.JSONObjectWithData(response.data, options: NSJSONReadingOptions.MutableContainers, error: nil)
        if let jsonArray = jsonSwift as? NSArray {
            for jsonMensaje in jsonArray {
                /* Formato de cada json
                "id": 664,
                "sender": "123456789",
                "content": "prueba con archivo",
                "conversation_id": 31,
                "file": {
                    "url":"el link del archivo",
                    "mime_type":"el mime type del archivo"
                },
                "created_at": "2015-06-16T23:32:49.915Z"
                */
                if let diccionarioMensaje = jsonMensaje as? Dictionary<String, NSObject> {
                    let file = diccionarioMensaje["file"] as? Dictionary<String, String>
                    if file != nil {
                        let url:String? = file!["url"]
                        if url != nil {
                            sendMessageURL(url!)
                        }}}}}
        */
    }
    
    func sendImage(image:UIImage){
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        SRWebClient.POST("http://guasapuc.herokuapp.com/api/v2/conversations/send_file_message")
            .data(imageData, fieldName:"file",
                data:[
                    "file_mime_type":"image/jpeg",
                    "conversation_id":chatRoomToShow.id.description,
                    "sender":Common.userNumber
                ])
            .headers(["Authorization":"Token token=jQQNqGlnI2gvLKOG4KeMaQtt"])
            .send({(response:AnyObject!, status:Int) -> Void in
                    //process success response
                    NSLog(response.description)
                    NSLog("\(response)")
                    self.procesarImagenEnviada(response)
                },failure:{(error:NSError!) -> Void in
                    //process failure response
                    NSLog(error.description)
            })
        
        //params.put("file[content]", file);
        //params.put("file[mime_type]", getMimeType(uriFile));
        //params.put("conversation_id", conversationId);
        //params.put("sender", MY_NUMBER);
        
        
        //UploadController.UploadNative(image, id:chatRoomToShow.id, sender:Common.userNumber)
        
        //var m = MultipartFormData()
        
        //params.put("file", file)
        //params.put("file_mime_type", mimeType)
        
        /*
        params.put("file[content]", file);
        params.put("file[mime_type]", getMimeType(uriFile));
        params.put("conversation_id", conversationId);
        params.put("sender", MY_NUMBER);
        AsyncHttpClient client = new AsyncHttpClient();
        client.addHeader("Authorization", "Token token=" + TOKEN);
        */

//        let imageData = UIImageJPEGRepresentation(image, 1)
//        let idData = NSData(bytes: &chatRoomToShow.id, length: sizeof(Int))
//        let senderData = Common.userNumber.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
//        
//        m.appendBodyPart(data: UIImageJPEGRepresentation(image, 1), name: "image", mimeType: "image/jpeg")
//        m.appendBodyPart(data: idData, name: "id")
//        m.appendBodyPart(data: senderData!, name: "sender")
        //m.appendBodyPart(stream: <#NSInputStream#>, length: <#UInt64#>, headers: <#[String : String]#>)
        
        //request.addValue(self.tokenFormatted, forHTTPHeaderField: "Authorization")
        
        
//        upload(
//            .POST,
//            URLString: "http://guasapuc.herokuapp.com/api/v2/conversations/send_file_message",
//            multipartFormData: { multipartFormData in
//                multipartFormData.appendBodyPart(fileURL: unicornImageURL, name: "unicorn")
//                
//            },
//            encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .Success(let upload, _, _):
//                    upload.responseJSON { request, response, JSON, error in
//                        println(JSON)
//                    }
//                case .Failure(let encodingError):
//                    println(encodingError)
//                }
//            }
//        )
        
//        let imageData:NSData = NSData(data:UIImageJPEGRepresentation(image, 1.0))
//        SRWebClient.POST("http://guasapuc.herokuapp.com/api/v2/conversations/send_file_message")
//            .headers(["Authorization":Common.tokenFormatted])
//            .data(imageData, fieldName:"file", data:["conversation-id":chatRoomToShow.id, "sender":Common.userNumber, "mime-type":"image/jpg"])
//            .send({(response:AnyObject!, status:Int) -> Void in
//                //process success response
//                print(response)
//                },failure:{(error:NSError!) -> Void in
//                    //process failure response
//                    println(error)
//            })
        
        
//        let request = NSMutableURLRequest(URL: NSURL(string: "http://guasapuc.herokuapp.com/api/v2/conversations/send_photo_attachment")!)
//        request.addValue(Common.tokenFormatted, forHTTPHeaderField: "Authorization")
//        request.HTTPMethod = "POST"
//        
//        let imageData = NSData(data: UIImageJPEGRepresentation(image, 1.0))
//        
//        var byte: Int = 0
//        imageData.getBytes(&byte, length: 1)
//        var mimeType = ""
//        switch (byte) {
//        case 0xFF:
//            mimeType = "image/jpeg"
//        case 0x89:
//            mimeType = "image/png"
//        case 0x47:
//            mimeType = "image/gif"
//        case 0x49:
//            mimeType = ""
//        case 0x4D:
//            mimeType = "image/tiff"
//        default:
//            mimeType = ""
//        }
//        
//        let file = ["contents":imageData, "mime-type":mimeType]
//        let obj = ["conversation-id":chatRoomToShow.id, "sender":Common.userNumber, "file":file]
//        println("json: \(obj)")
//        var jsonData = NSJSONSerialization.dataWithJSONObject(obj, options: NSJSONWritingOptions.allZeros, error: nil)
//        var jsonString = NSString(data: jsonData!, encoding: NSUTF8StringEncoding) as! String
//        
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
//            data, response, error in
//            
//            if error != nil {
//                println("error=\(error)")
//                return
//            }
//            else {
//                println(response)
//            }
//        }
//        task.resume()
        //UploadController.UploadNative(image)
        //UploadController.sendFile("http://guasapuc.herokuapp.com/api/v2/conversations/send_file_message", fileName: "foto.jpg", data: imageData)
    }
    
    func sendMessageURL(url:String) {
        let newMessage = ChatMessage.new(Common.moc!, _sender: Common.userNumber, _content: "Click to view image", _hasURL: true, _url: url, _id: -1)
        chatRoomToShow.addMessageToChat(newMessage)
        println("Content: " + newMessage.content)
        println("Sender: "+newMessage.sender)
        println("id: " + String(chatRoomToShow.id))
        let request = Common.getRequestSendMessageToConversation(TextField.text!, sender: Common.userNumber, id: chatRoomToShow.id)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                println("error=\(error)")
                return
            }
            
            let jsonSwift: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
            
            if let jsonArray = jsonSwift as? NSArray {
                for jsonMensaje in jsonArray {
                    if let diccionarioMensaje = jsonMensaje as? Dictionary<String, NSObject> {
                        newMessage.id = diccionarioMensaje["id"] as! Int
                        newMessage.createdAt = Common.getDateFromString(diccionarioMensaje["created_at"] as! String)
                        if Common.isDateGreaterThanDate(newMessage.createdAt, date2: self.chatRoomToShow.updatedAt) { self.chatRoomToShow.updatedAt = newMessage.createdAt }
                        self.updateChatRoom()
                        self.TablaMensajes.reloadData()
                    }}}
        }
        task.resume()
    }
    
    @IBAction func SendMessage(sender: AnyObject) {
        let newMessage = ChatMessage.new(Common.moc!, _sender: Common.userNumber, _content: TextField.text)
        chatRoomToShow.addMessageToChat(newMessage)
        println("Content: " + newMessage.content)
        println("Sender: "+newMessage.sender)
        println("id: " + String(chatRoomToShow.id))
        let request = Common.getRequestSendMessageToConversation(TextField.text!, sender: Common.userNumber, id: chatRoomToShow.id)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                println("error=\(error)")
                return
            }
            
            let jsonSwift: AnyObject? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil)
            
            if let jsonArray = jsonSwift as? NSArray {
                for jsonMensaje in jsonArray {
                    if let diccionarioMensaje = jsonMensaje as? Dictionary<String, NSObject> {
                        newMessage.id = diccionarioMensaje["id"] as! Int
                        newMessage.createdAt = Common.getDateFromString(diccionarioMensaje["created_at"] as! String)
                        if Common.isDateGreaterThanDate(newMessage.createdAt, date2: self.chatRoomToShow.updatedAt) { self.chatRoomToShow.updatedAt = newMessage.createdAt }
                        self.updateChatRoom()
                        self.TablaMensajes.reloadData()
                    }}}
        }
        TextField.text = ""
        task.resume()
        
        func deprecated() {
//            let request = NSMutableURLRequest(URL: NSURL(string: Common.messagesURL)!)
//            request.HTTPMethod = "POST"
//            request.addValue(Common.tokenFormatted, forHTTPHeaderField: "Authorization")
//            let postString = Common.generateJSONFormatMessage(chatRoomToShow!.getChatNumbers().first!, content: TextField.text)
//            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
//            content = TextField.text
//            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
//                data, response, error in
//
//                if error != nil {
//                    println("error=\(error)")
//                    return
//                }
//
//                //println("response = \(response)")
//
//                let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
//                //println("responseString = \(responseString)")
//                
//                
//                let newMessage = ChatMessage.new(Common.moc!, _sender: Common.getCurrentUser().numero, _recipient: self.chatRoomToShow!.getChatNumbers().first!, _content: self.content)
//                self.content = ""
//                Common.synced(self.chatRoomToShow, closure: { self.chatRoomToShow!.addMessageToChat(newMessage) })
//                Common.saveData()
//                self.updateChatRoom()
        task.resume()
        TextField.text = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = chatRoomToShow?.nombreChat
        TextField.delegate = self
        delegateTablaMensajes = TablaChatRoomDelegate()
        delegateTablaMensajes?.referenciaAlChatRoomViewController = self
        delegateTablaMensajes?.chatRoom = chatRoomToShow
        TablaMensajes.delegate = delegateTablaMensajes
        TablaMensajes.dataSource = delegateTablaMensajes
    }
    
    func updateChatRoom() {
        if let ref = referenciaAlViewController {
            ref.delegateChatTable?.chatManager.updateChat(chatRoomToShow)
        }
        if let ref = referenciaAlViewControllerGroups {
            ref.delegateChatTableGroups?.chatManager.updateChat(chatRoomToShow)
        }
        TablaMensajes.reloadData()
    }
    
    func animateTextField(up: Bool) {
        var movement = (up ? -kbHeight : kbHeight)

        UIView.animateWithDuration(0.3, animations: {
            self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        })
    }
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.BottomConstraint.constant = keyboardFrame.size.height - 45
        })
    }

    func keyboardWillHide(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.BottomConstraint.constant = 6.0
        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "IDShowImage" {
            let s = sender as? TablaChatRoomDelegate
            if s != nil {
                let imgView = segue.destinationViewController as? ImageViewerViewController
                if imgView != nil {
                    imgView!.urlString = s!.urlToShow
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}