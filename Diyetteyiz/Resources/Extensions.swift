//
//  Extensions.swift
//  Diyetteyiz
//
//  Created by Nizamet Özkan on 24.02.2021.
//

import Foundation
import UIKit

extension UIView {
    public var width: CGFloat{
        return frame.size.width
    }
    public var height: CGFloat{
        return frame.size.height
    }
    public var top: CGFloat{
        return frame.origin.y
    }
    public var bottom: CGFloat{
        return frame.size.height + frame.origin.y
    }
    public var left: CGFloat{
        return frame.origin.x
    }
    public var right: CGFloat{
        return frame.size.width + frame.origin.x
    }
    
    public static func configureHeaderView(with headerView: UIView){
        guard headerView.subviews.count == 1 else{
            return
        }
        guard let backgoundView = headerView.subviews.first else {
            return
        }
        backgoundView.frame = headerView.bounds
        
        backgoundView.layer.zPosition = 1
    }
}

