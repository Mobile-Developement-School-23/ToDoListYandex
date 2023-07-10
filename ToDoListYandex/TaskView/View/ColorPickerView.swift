//
//  ColorPickerView.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 23.06.2023.
//

import UIKit


protocol ColorPickerDelegate: AnyObject {
    func colorPickerTouched(color: UIColor)
}

class ColorPicker: UIView {

    weak var delegate: ColorPickerDelegate?
    
    private let saturation = 1.0
    private let brightness = 1.0
    private let alphaValue = 1.0

    var elementSize: Double = 2.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        let touchGesture = UILongPressGestureRecognizer(target: self,
                                                        action: #selector(self.touchedColor(gestureRecognizer:)))
        touchGesture.minimumPressDuration = 0
        self.addGestureRecognizer(touchGesture)
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        for x in stride(from: (0 as CGFloat), to: rect.width, by: elementSize) {
            let hue = x / rect.width
            let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alphaValue)
            context?.setFillColor(color.cgColor)
            context?.fill(CGRect(x: x, y: 0, width: elementSize, height: self.bounds.height))
        }
    }

    func getColorAtPoint(point: CGPoint) -> UIColor {
        let hue = point.x / self.bounds.width
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alphaValue)
    }

    @objc func touchedColor(gestureRecognizer: UILongPressGestureRecognizer) {
        let point = gestureRecognizer.location(in: self)
        let color = getColorAtPoint(point: point)
        
        self.delegate?.colorPickerTouched(color: color)
    }
}
