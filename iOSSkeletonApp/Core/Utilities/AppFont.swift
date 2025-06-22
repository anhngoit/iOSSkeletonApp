//
//  AppFont.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import SwiftUI

enum AppFont: String, CaseIterable {
    case recoletaAltBold        = "RecoletaAlt-Bold"
    case recoletaAltMedium      = "RecoletaAlt-Medium"
    case recoletaAltRegular     = "RecoletaAlt-Regular"
    case recoletaAltSemiBold    = "RecoletaAlt-SemiBold"
    
    func of(size: CGFloat, relativeTo textStyle: Font.TextStyle = .body) -> Font {
        Font.custom(rawValue, size: size, relativeTo: textStyle)

    }
}

extension Font {
    static var themeBody: Font {
        AppFont.recoletaAltRegular.of(size: 16, relativeTo: .body)
    }
    
    static var themeTitle: Font {
        AppFont.recoletaAltSemiBold.of(size: 20, relativeTo: .title)
    }
    
    static var themeHeading: Font {
        AppFont.recoletaAltBold.of(size: 20, relativeTo: .headline)
    }
}
