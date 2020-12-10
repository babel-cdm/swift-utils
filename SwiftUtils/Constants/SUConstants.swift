//
//  SUConstants.swift
//  SwiftUtils
//
//  Created by alvaro.grimal.local on 14/09/2020.
//  Copyright © 2020 Babel. All rights reserved.
//

import UIKit

public struct SUConstants {

    public struct Framework {
        public static let name = "es.babel.cdm.utils"
    }

    public struct Corner {
        public static let none: CGFloat = 0
        public static let small: CGFloat = 2
        public static let smallPlus: CGFloat = 5
        public static let medium: CGFloat = 8
        public static let mediumPlus: CGFloat = 11
        public static let big: CGFloat = 15
        public static let bigPlus: CGFloat = 20
    }

    public struct Border {
        public static let none: CGFloat = 0
        public static let small: CGFloat = 1
        public static let smallPlus: CGFloat = 2.5
        public static let medium: CGFloat = 4
        public static let mediumPlus: CGFloat = 5.5
        public static let big: CGFloat = 7
        public static let bigPlus: CGFloat = 8.5
    }

    public struct Map {
        static let annotationId = "AnnotationIdentifier"
    }

    public struct FileExtension {
        public static let jpg = ".jpg"
        public static let png = ".png"
        public static let jpeg = ".jpeg"
        public static let txt = ".txt"
        public static let pdf = ".pdf"
        public static let doc = ".doc"
        public static let docx = ".docx"
    }
}
