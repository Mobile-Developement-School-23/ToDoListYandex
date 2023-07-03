//
//  UIColor+Extension.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 6/23/23.
//

import UIKit


extension UIColor {
    static let supportSeparator: UIColor = UIColor(named: "supportSeparator")!
    static let supportOverlay: UIColor = UIColor(named: "supportOverlay")!
    static let supportNavBarBlur: UIColor = UIColor(named: "supportNavBarBlur")!
    
    static let labelPrimary: UIColor = UIColor(named: "labelPrimary")!
    static let labelSecondary: UIColor = UIColor(named: "labelSecondary")!
    static let labelTertiary: UIColor = UIColor(named: "labelTertiary")!
    static let labelDisable: UIColor = UIColor(named: "labelDisable")!
    
    static let colorRed: UIColor = UIColor(named: "colorRed")!
    static let colorGreen: UIColor = UIColor(named: "colorGreen")!
    static let colorBlue: UIColor = UIColor(named: "colorBlue")!
    static let colorGray: UIColor = UIColor(named: "colorGray")!
    static let colorGrayLight: UIColor = UIColor(named: "colorGrayLight")!
    static let colorWhite: UIColor = UIColor(named: "colorWhite")!
    
    static let backiOSPrimary: UIColor = UIColor(named: "backiOSPrimary")!
    static let backPrimary: UIColor = UIColor(named: "backPrimary")!
    static let backSecondary: UIColor = UIColor(named: "backSecondary")!
    static let backElevated: UIColor = UIColor(named: "backElevated")!
}

public extension UIColor {
    func setBrightness(brightness: CGFloat = 0) -> UIColor {
        var currentHue: CGFloat = 0.0
        var currentSaturation: CGFloat = 0.0
        var currentBrigthness: CGFloat = 0.0
        var currentAlpha: CGFloat = 0.0

        if getHue(&currentHue, saturation: &currentSaturation, brightness: &currentBrigthness, alpha: &currentAlpha) {
            return UIColor(hue: currentHue ,
                       saturation: currentSaturation,
                       brightness: brightness,
                       alpha: currentAlpha)
        } else {
            return self
        }
    }
    
    func getColorCode() -> String {
        guard let components = self.cgColor.components else {
            return ""
        }

        let red = components[0]
        let green = components[1]
        let blue = components[2]
        let alpha = components[3]

        let redInt = Int(red * 255)
        let greenInt = Int(green * 255)
        let blueInt = Int(blue * 255)
        let alphaInt = Int(alpha * 255)

        let colorCode = String(format: "#%02X%02X%02X%02X", redInt, greenInt, blueInt, alphaInt)
        return colorCode
    }
    
    convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
