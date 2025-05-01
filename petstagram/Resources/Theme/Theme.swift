//
//  Theme.swift
//  petstagram
//
//  Created by Parama Artha on 25/04/25.
//

import SwiftUICore

struct Theme {
    struct Colors {
        static let primary1 = Color(hex: "#5250E1")
        static let primary2 = Color(hex: "#4240B4")
        static let primary3 = Color(hex: "#DCDCF9")
        static let secondary1 = Color(hex: "#5BCF95")
        static let secondary2 = Color(hex: "#DEF5EA")
        static let secondary3 = Color(hex: "#FC7171")
        static let secondary4 = Color(hex: "#FFF9F8")
        static let dark1 = Color(hex: "#20242B")
        static let dark2 = Color(hex: "#303742")
        static let greyDisable = Color(hex: "#C4C4C4")
        static let grey1 = Color(hex: "#EBF0F0")
        static let grey2 = Color(hex: "#EBF0F0")
        static let grey3 = Color(hex: "#FDFDFD")
    }
    
    struct Fonts {
        static let h1 = Font.system(size: 42, weight: .bold)
        static let h2 = Font.system(size: 34, weight: .bold)
        static let h3 = Font.system(size: 28, weight: .bold)
        static let h4 = Font.system(size: 24, weight: .bold)
        static let h5 = Font.system(size: 20, weight: .bold)
        static let h6 = Font.system(size: 18, weight: .bold)
        static let bodyXLargeBold = Font.system(size: 18, weight: .bold)
        static let bodyXLargeSemiBold = Font.system(size: 18, weight: .semibold)
        static let bodyXLargeMedium = Font.system(size: 18, weight: .medium)
        static let bodyXLargeRegular = Font.system(size: 18, weight: .regular)
        static let bodyLargeBold = Font.system(size: 16, weight: .bold)
        static let bodyLargeSemiBold = Font.system(size: 16, weight: .semibold)
        static let bodyLargeMedium = Font.system(size: 16, weight: .medium)
        static let bodyLargeRegular = Font.system(size: 16, weight: .regular)
        static let bodyBold = Font.system(size: 14, weight: .bold)
        static let bodySemiBold = Font.system(size: 14, weight: .semibold)
        static let bodyMedium = Font.system(size: 14, weight: .medium)
        static let bodyRegular = Font.system(size: 14, weight: .regular)
        static let bodySmallBold = Font.system(size: 12, weight: .bold)
        static let bodySmallSemiBold = Font.system(size: 12, weight: .semibold)
        static let bodySmallMedium = Font.system(size: 12, weight: .medium)
        static let bodySmallRegular = Font.system(size: 12, weight: .regular)
    }
}
