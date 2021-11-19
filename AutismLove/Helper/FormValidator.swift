//
//  FormValidator.swift
//  AutismLove
//
//  Created by BobbyPhtr on 02/05/21.
//

import Foundation

class FormValidator {
    
    func validate(text : String?, with rules : [Rule]) -> FormError?{
        return rules.compactMap({$0.check(text)}).first
    }
    
}

struct Rule {
    let  check : (String?)->FormError?
    
    static let notEmpty = Rule { (input) -> FormError? in
        guard let input = input else { return .fieldIsEmpty }
        return  input.isEmpty ? .fieldIsEmpty : nil
    }
    
    static let validEmail = Rule { input -> FormError? in
        guard let input = input else { return nil }
        
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        let isValid = regex.firstMatch(in: input, options: [], range: NSRange(location: 0, length: input.count)) != nil
        
        if isValid { return nil }
        else { return .emailIsNotValid(msg: Strings.Email_Is_Not_Valid) }
    }
    
    static let validPassword = Rule { input -> FormError? in
        guard let input = input else { return nil }
        
        if  input.count >= 6 {
            return nil
        } else {
            return .passwordIsNotValid(msg: Strings.Must_be_equal_to_or_longer_than_6_letters)
        }
    }
    
    // ^(^\+62|62|^08)(\d{3,4}-?){2}\d{3,4}$
    static let validPhone = Rule { (input) -> FormError? in
        
        guard let ipt = input else { return nil }
        // Minimal sama dengan 10 maksimal sama dengan 15
//        if  ipt.count >= 10 && ipt.count <= 15 {} else {
//            return .phoneNumberIsNotValid(msg: Strings.Phone_Must_Between_Characters)
//        }
        
        if ipt.prefix(1) != "0" {
            return .phoneNumberIsNotValid(msg: Strings.Phone_Must_Begin_With_0)
        } else {
            return nil
        }
        
        // Harus mulai dari 08
//        let prefix = ipt.prefix(2)
//        if String(prefix) != "08" {
//            return .phoneNumberIsNotValid(msg: "Nomor telepon harus dimulai dari \"08\"")
//        }
//        return nil
    }
    
}
