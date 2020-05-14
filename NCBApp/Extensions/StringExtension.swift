//
//  StringExtension.swift
//  NCBApp
//
//  Created by Thuan on 4/10/19.
//  Copyright © 2019 tvo. All rights reserved.
//

import Foundation

enum CurrencyUnit: String {
    case vnd
    case usd
}

extension String {
    
    func convertCurrencyUnit() -> String {
        switch self.lowercased() {
        case CurrencyUnit.vnd.rawValue:
            return "vi_VN"
        case CurrencyUnit.usd.rawValue:
            return "en_US"
        default:
            return "vi_VN"
        }
    }
    
    var firstUppercased: String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    var firstUppercasedOnly: String {
        return prefix(1).uppercased() + self.dropFirst()
    }
    
    var removeSpecialCharacter: String {
        return self.replacingOccurrences(of: ",", with: "")
    }
    
    var removeDashSymbol: String {
        return self.replacingOccurrences(of: "-", with: "")
    }
    
    var passwordValid: Bool {
        let allowed = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[$&+,:;=\\?@#|/'<>.^*()%!-]).{8,20}$"
        return NSPredicate(format: "SELF MATCHES %@", allowed).evaluate(with: self)
    }
    
    var isPhoneNumber: Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }
    
    var isEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        var valid = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
        if valid {
            valid = !self.contains("..")
        }
        return valid
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    var cardHidden: String {
        if self.count < 8 {
            return self
        }
        
        let text = self.replacingOccurrences(of: " ", with: "")
        let first = text.prefix(4)
        let last = text.suffix(4)
        return first + " **** **** " + last
    }
    
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    var withoutHtmlTags: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options:
            .regularExpression, range: nil).replacingOccurrences(of: "&[^;]+;", with:
                "", options:.regularExpression, range: nil)
    }
    
    var trim: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func base64ToImage() -> UIImage? {
        let dataDecoded = Data(base64Encoded: self, options: .ignoreUnknownCharacters)!
        let image = UIImage(data: dataDecoded)
        return image
    }
    
    func getMessage() -> String? {
        if let messages = NCBShareManager.shared.messages,
            let message = messages.first(where: { $0.msg_code?.trim.lowercased() == self.trim.lowercased() }),
            let mes = message.mes_vn {
            return mes
        }
        return nil
    }
    
    func convertAlphaB() -> String {
        return self.uppercased().replacingOccurrences(of: "Đ", with: "D")
    }
    
    var replacingSpace: String {
        return self.replacingOccurrences(of: " ", with: "%20")
    }
    
}
