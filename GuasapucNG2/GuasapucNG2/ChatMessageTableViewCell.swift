//
//  ChatMessageTableViewCell.swift
//  GuasapucNG2
//
//  Created by Nicolás Gebauer on 21-09-15.
//  Copyright © 2015 Nicolás Gebauer. All rights reserved.
//

import UIKit

class ChatMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var LabelMensaje: UILabel!
    var bubbleImageView: UIImageView!
    var firstBubbleLoadDone = false
    var bubbleString = ""
    var isSentBySelf = false
    
    func loadChatBubble() {
        if LabelMensaje.text == "" || LabelMensaje.text == nil { return }
        if firstBubbleLoadDone { return }
        if isSentBySelf {
            bubbleString = "ChatBubble2"
        } else {
            bubbleString = "ChatBubble"
        }
        let image = UIImage(named: bubbleString)?.resizableImageWithCapInsets(UIEdgeInsetsMake(10, 20, 10, 20))
        bubbleImageView = UIImageView(image: image)
        bubbleImageView.reloadInputViews()
        
        let x: CGFloat = 2
        let y: CGFloat = 4
        
        bubbleImageView.frame = CGRectMake(x, y, LabelMensaje.intrinsicContentSize().width + 28, LabelMensaje.intrinsicContentSize().height + 12)
        
        insertSubview(bubbleImageView, atIndex: 0)
        firstBubbleLoadDone = true
        reloadInputViews()
    }
    
    func destroyBubble() {
        for view in LabelMensaje.subviews {
            view.removeFromSuperview()
            bubbleImageView = nil
            firstBubbleLoadDone = false
        }
    }

}