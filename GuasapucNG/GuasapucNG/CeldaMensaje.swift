//
//  CeldaMensaje.swift
//  GuasapucNG
//
//  Created by Nicolás Gebauer on 05-05-15.
//  Copyright (c) 2015 Nicolás Gebauer. All rights reserved.
//

import Foundation
import UIKit

/* TODO

 - Que las bubbles se vean bien. Hacer que tamaño y posición del Label se adapte al texto y a quien lo envía para darle ese mismo tamaño y posición al bubble
*/

class CeldaMensaje: UITableViewCell {
    @IBOutlet weak var LabelMensaje: UILabel!
    var bubbleImageView: UIImageView!
    var firstBubbleLoadDone = false
    var bubbleString = ""
    
    func loadChatBubble() {
        if LabelMensaje.text == "" || LabelMensaje.text == nil { return }
        if firstBubbleLoadDone { return }
        let image = UIImage(named: bubbleString)?.resizableImageWithCapInsets(UIEdgeInsetsMake(10, 20, 10, 20))
//        let image = UIImage(named: bubbleString)?.stretchableImageWithLeftCapWidth(20, topCapHeight: 10)
        bubbleImageView = UIImageView(image: image)
        
//        let myInsets: UIEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20)
        
        let width: CGFloat = self.LabelMensaje.frame.size.width
        let height: CGFloat = self.LabelMensaje.frame.size.height
        
        let x: CGFloat = 8
        let y: CGFloat = 4
        
        //self.bubbleImage.frame = CGRectMake(x, y, width + self.data.insets.left + self.data.insets.right, height + self.data.insets.top + self.data.insets.bottom);
        
        bubbleImageView.frame = CGRectMake(x, y, LabelMensaje.intrinsicContentSize().width + 28, LabelMensaje.intrinsicContentSize().height + 12)
        
//        bubbleImageView.frame = LabelMensaje.bounds
//        bubbleImageView.frame.size.width = tamanoTexto(LabelMensaje.text!)
//        bubbleImageView.frame.size.height += 5
//        bubbleImageView.frame.size.width += 5
//        bubbleImageView.frame.size.width = (LabelMensaje.text! as NSString).sizeWithAttributes(nil).width
//        bubbleImageView.frame.size.height = (LabelMensaje.text! as NSString).sizeWithAttributes(nil).height
//        bubbleImageView.frame.inset(dx: -5, dy: -5)
        
//        println(LabelMensaje.frame.size.width)
//        
//        if (LabelMensaje.textAlignment == .Right) {
//            bubbleImageView.frame.offset(dx: LabelMensaje.frame.size.width - tamanoTexto(LabelMensaje.text!), dy: 0)
//        }
        
        //bubbleImageView.image = bubbleImageView.image!.resizableImageWithCapInsets(myInsets)
        insertSubview(bubbleImageView, atIndex: 0)
        firstBubbleLoadDone = true
    }
    
    func tamanoTexto(t:String) -> CGFloat {
        var i:CGFloat = 0
        for l in t {
            i++
        }
        return i*9
    }
    
    func messageDidDissapear() {
        if bubbleImageView == nil { return }
        bubbleImageView.hidden = true
    }
    
    func messageDidAppear() {
        if bubbleImageView == nil { return }
        bubbleImageView.hidden = false
    }
}

/*

self.bubbleImage.frame = CGRectMake(x, y, width + self.data.insets.left + self.data.insets.right, height + self.data.insets.top + self.data.insets.bottom);
*/

//---Galemiri
//cell.mensaje.frame = CGRectMake(0, 0, CGFloat(count(mensajes[mensajes.count-indexPath.row-1].mensaje)), CGFloat(10))
//var imageView = UIImageView(frame:  CGRectMake(150, 7, CGFloat(count(mensajes[mensajes.count-indexPath.row-1].mensaje)*10), CGFloat(35)))
//imageView.image = UIImage (named : "ChatBubble")
//let myInsets : UIEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20)
//imageView.image = imageView.image!.resizableImageWithCapInsets(myInsets)
//imageView.userInteractionEnabled = true
//cell.insertSubview(imageView, atIndex : 0 )
///---fin


//cell.mensaje.frame = CGRectMake(0, 0, CGFloat(count(mensajes[mensajes.count-indexPath.row-1].mensaje)), CGFloat(10))
//        
//        
//        var imageView = UIImageView(frame:  CGRectMake(150, 7, CGFloat(count(mensajes[mensajes.count-indexPath.row-1].mensaje)*10), CGFloat(35)))
//        
//        
//        imageView.image = UIImage (named : "ChatBubble")
//        let myInsets : UIEdgeInsets = UIEdgeInsetsMake(10, 20, 10, 20)
//        imageView.image = imageView.image!.resizableImageWithCapInsets(myInsets)
//        
//         imageView.userInteractionEnabled = true
//        
//        cell.insertSubview(imageView, atIndex : 0 )