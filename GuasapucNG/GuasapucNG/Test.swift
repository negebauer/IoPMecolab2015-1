import UIKit
class UploadController {

/*
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
*/
    
    class func UploadNative(image:UIImage, id:Int, sender:String) {
        let url:NSURL? = NSURL(string: "http://guasapuc.herokuapp.com/api/v2/conversations/send_file_message")
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        var request = NSMutableURLRequest(URL: url!, cachePolicy: cachePolicy, timeoutInterval: 60*5*1.0)
        request.HTTPMethod = "POST"
        
        // Set Content-Type in HTTP header.
        let boundaryConstant = "Boundary-7MA4YWxkTLLu0UIW"; // This should be auto-generated.
        let contentType = "multipart/form-data; boundary=" + boundaryConstant
        
        let contentTypeBody = "octect/stream"
        let mimeType = "image/jpeg"
        let fieldName = "uploadFile"
        let fileName = "image.jpg"
        
        request.setValue("form-data", forHTTPHeaderField: "Content-Disposition")
        request.setValue("file", forHTTPHeaderField: "name")
        request.setValue("filename", forHTTPHeaderField: "fileName")
        request.setValue("octect/stream", forHTTPHeaderField: "Content-Type")
        request.setValue(Common.tokenFormatted, forHTTPHeaderField: "Authorization")
        request.setValue("binary", forHTTPHeaderField: "Content-Transfer-Encoding")

        // Set data
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        var error: NSError?
        var dataString = "--\(boundaryConstant)\r\n"
        //dataString += "Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n"
        //dataString += "Content-Type: \(contentTypeBody)\r\n\r\n"
        dataString += "file: \(String(stringInterpolationSegment: imageData))\r\n\r\n"
        dataString += "sender: \(sender)"
        dataString += "conversation_id: \(id)"
        dataString += "file_mime_type: \(mimeType)"
        dataString += "--\(boundaryConstant)--\r\n"
        
        
        
        //.data(imageData, fieldName:"file", data:["conversation-id":chatRoomToShow.id, "sender":Common.userNumber, "mime-type":"image/jpg"])
        
        println(dataString) // This would allow you to see what the dataString looks like.
        
        // Set the HTTPBody we'd like to submit
        let requestBodyData = (dataString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody = requestBodyData
        
        // Make an asynchronous call so as not to hold up other processes.
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response, dataObject, error) in
            if let apiError = error {
                print(apiError)
            } else {
                print(response)
            }
        })
    }
    
}