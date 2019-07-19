//
//  FFTopNotification.swift
//  Pods
//
//  Created by Fernando N. Frassia on 6/24/19.
//

import UIKit

extension UIView {
    public typealias FFCompletionHandler = () -> Void
    
    public func displayNotification(text: String, type: FFNotification, completion: FFCompletionHandler? = nil) {
        let font = UIFont(name: "OpenSans-SemiBold", size: 14)!
        let textColor = UIColor.white
        
        displayCustomNotification(text: text, font: font, textColor: textColor, backgroundColor: type.color, completion: completion)
    }
    
    public func displayCustomNotification(text: String, font: UIFont, textColor: UIColor, backgroundColor: UIColor, completion: FFCompletionHandler? = nil) {
        //notificationView
        let topView = createTopView()
        let notificationView = createNotificationView(color: backgroundColor, under: topView)
        
        //label
        addLabelToNotificationView(notificationView: notificationView, text: text, font: font, textColor: textColor)
        
        //animate
        layoutIfNeeded()
        animate(notificationView: notificationView, topView: topView, completion: completion)
    }
    
    private func createTopView() -> UIView {
        guard #available(iOS 11.0, *) else {return UIView()}
        
        let topView = UIView()
        topView.backgroundColor = .white
        addSubview(topView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        topView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        
        return topView
    }
    
    private func createNotificationView(color: UIColor, under topView: UIView) -> UIView {
        guard #available(iOS 11.0, *) else {return UIView()}
        
        let notificationView = UIView()
        notificationView.backgroundColor = color
        
        let notificationHeight: CGFloat = 40
        addSubview(notificationView)
        notificationView.translatesAutoresizingMaskIntoConstraints = false
        notificationView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        notificationView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        notificationView.heightAnchor.constraint(equalToConstant: notificationHeight).isActive = true
        notificationView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: -notificationHeight).isActive = true
        
        //reorder
        insertSubview(topView, aboveSubview: notificationView)
        
        return notificationView
    }
    
    private func addLabelToNotificationView(notificationView: UIView, text: String, font: UIFont, textColor: UIColor) {
        guard #available(iOS 9.0, *) else {return}
        
        let textLbl = UILabel()
        textLbl.text = text
        textLbl.font = font
        textLbl.textColor = textColor
        textLbl.textAlignment = .center
        
        notificationView.addSubview(textLbl)
        textLbl.translatesAutoresizingMaskIntoConstraints = false
        textLbl.topAnchor.constraint(equalTo: notificationView.topAnchor).isActive = true
        textLbl.bottomAnchor.constraint(equalTo: notificationView.bottomAnchor).isActive = true
        textLbl.leadingAnchor.constraint(equalTo: notificationView.leadingAnchor).isActive = true
        textLbl.trailingAnchor.constraint(equalTo: notificationView.trailingAnchor).isActive = true
    }
    
    private func animate(notificationView: UIView, topView: UIView, completion: FFCompletionHandler?) {
        let notificationHeight = notificationView.frame.size.height
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            let oldY = notificationView.frame.origin.y
            notificationView.frame = CGRect(x: notificationView.frame.origin.x,
                                            y: oldY+notificationHeight,
                                            width: notificationView.frame.size.width,
                                            height: notificationView.frame.size.height)
        }) { (finished) in
            UIView.animate(withDuration: 0.5, delay: 0.7, options: .curveEaseIn, animations: {
                let oldY = notificationView.frame.origin.y
                notificationView.frame = CGRect(x: notificationView.frame.origin.x,
                                                y: oldY-notificationHeight,
                                                width: notificationView.frame.size.width,
                                                height: notificationView.frame.size.height)
            }, completion: { (finished) in
                notificationView.removeFromSuperview()
                topView.removeFromSuperview()
                completion?()
            })
        }
    }
    
}

