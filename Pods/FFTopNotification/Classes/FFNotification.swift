//
//  Notification.swift
//  Pods
//
//  Created by Fernando N. Frassia on 7/1/19.
//

import Foundation


public enum FFNotification {
    case success
    case failure
    case warning
    
    var color: UIColor {
        var returnColor: UIColor
        switch self {
        case .success:
            returnColor = UIColor(red: (118.0/255.0), green: (214.0/255.0), blue: (114.0/255.0), alpha: 1)
        case .failure:
            returnColor = UIColor(red: (254.0/255.0), green: (75.0/255.0), blue: (76.0/255.0), alpha: 1)
        case .warning:
            returnColor = UIColor(red: (245.0/255.0), green: (204.0/255.0), blue: (84.0/255.0), alpha: 1)
        }
        return returnColor
    }
}
