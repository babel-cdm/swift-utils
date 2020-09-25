//
//  SUValidation.swift
//  SwiftUtils
//
//  Created by alvaro.grimal.local on 14/09/2020.
//  Copyright © 2020 Babel. All rights reserved.
//

import Foundation

public class SUValidation {

    public static func isValidMobilePhone(number: String) -> Bool {
        return !number.isEmpty && (NSPredicate(format: "SELF MATCHES %@", "\\d{9}").evaluate(with: number))
    }

    public static func isValidPhone(number: String) -> Bool {
        return !number.isEmpty && (NSPredicate(format: "SELF MATCHES %@", "\\d{9}").evaluate(with: number))
    }

    public static func isValidEmail(email: String) -> Bool {
        let regexFirstPart = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\"
        let regexSecondPart = ".[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|"
        let regexThirtPart = "(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)"
        let regexFourthPart = "(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])"
        let regexFifthPart = "|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|"
        let regexSixthPart = "(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;"
        let regexSeventhPart = "=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailRegEx = "\(regexFirstPart)\(regexSecondPart)\(regexThirtPart)\(regexFourthPart)\(regexFifthPart)\(regexSixthPart)\(regexSeventhPart)"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

    public static func isValidIdentificationDocument(value: String) -> Bool {
        let dniRegex = "([0-9]{8}[A-Z]$)"
        let nieRegex = "([X|Y|Z][0-9]{7}[A-Z]$)"
        let completeRegex = "\(dniRegex)|\(nieRegex)"
        return NSPredicate(format: "SELF MATCHES %@", completeRegex).evaluate(with: value)
    }
}
