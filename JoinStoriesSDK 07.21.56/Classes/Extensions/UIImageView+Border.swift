//
//  UIImageView+Border.swift
//  JoinStoriesSDK
//
//  Created by JOIN on 10/02/2021.
//

import Foundation
import UIKit

extension UIView {
    
    // Here we use twice the width indicated via parameters to really the good size displayed
    // Note: here the line is half hidden due to bounds, so we need to multiply by 2 the width
    public func circleGradientBorder(withLineWidth width: CGFloat, andColors colors: [CGColor]) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: CGPoint.zero, size: bounds.size)
        
        if(colors.count == 1) {
            gradient.colors = [colors[0], colors[0]]
        } else {
            gradient.colors = colors
        }
        gradient.startPoint = CGPoint(x: 1, y: 0.5)
        gradient.endPoint = CGPoint(x: 0, y: 0.5)
        
        layer.cornerRadius = frame.size.width / 2
        layer.masksToBounds = true
        
        let shape = CAShapeLayer()
        let path = UIBezierPath(ovalIn: bounds)
        
        shape.lineWidth = width * 2
        shape.path = path.cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor // clear
        gradient.mask = shape
        return gradient
    }
    
    public func circleBorder(withLineWidth width: CGFloat, strokeColor: CGColor, opacity: Float = 1.0) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        layer.cornerRadius = frame.size.width / 2
        layer.masksToBounds = true
        
        shapeLayer.frame = CGRect(origin: CGPoint.zero, size: bounds.size)
        shapeLayer.path = UIBezierPath(ovalIn: bounds).cgPath
        shapeLayer.lineWidth = width * 2
        shapeLayer.strokeColor = strokeColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.opacity = opacity
        return shapeLayer
    }
    
}
