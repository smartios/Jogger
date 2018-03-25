//
//  ColorConstants.swift
//  Janeous
//
//  Created by singsys on 16/02/18.
//

import Foundation

let defaultGreenColorHex = "5AC7CC"
let defaultLinkedInColorHex = "007BCC"
let defaultDarkTextColorHex = "494B57"
let defaultLightTextColorHex = "A0ACC0"
let defaultWhiteTextColorHex = "ffffff"
let defaultLineColorHex = "72787F"
let defaultBtnColorHex = "ffffff"
let defaultWhiteButtonBackgroundHex = "F6F7F9"
let defaultErrorRedColorHex = "D3411A"
let defaultUnselectedColorHex = "D1D7E1"

func defaultGreenColor() -> UIColor
{
    return hexStringToUIColor(hex: defaultGreenColorHex)
}

func defaultLinkedInColor() -> UIColor
{
    return hexStringToUIColor(hex: defaultLinkedInColorHex)
}

func defaultDarkTextColor() -> UIColor
{
    return hexStringToUIColor(hex: defaultDarkTextColorHex)
}

func defaultLightTextColor() -> UIColor
{
    return hexStringToUIColor(hex: defaultLightTextColorHex)
}

func defaultLineColor() -> UIColor
{
    return hexStringToUIColor(hex: defaultLineColorHex)
}

func defaultWhiteTextColor() -> UIColor
{
    return hexStringToUIColor(hex: defaultWhiteTextColorHex)
}

func defaultErrorColor() -> UIColor
{
    return hexStringToUIColor(hex:defaultErrorRedColorHex)
}

func defaultWhiteButtonBackgroundColor() -> UIColor
{
    return hexStringToUIColor(hex: defaultWhiteButtonBackgroundHex)
}

func defaultUnselectedColor() -> UIColor
{
    return hexStringToUIColor(hex: defaultUnselectedColorHex)
}

