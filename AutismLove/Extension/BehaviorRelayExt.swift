//
//  BehaviorRelayExt.swift
//  AutismLove
//
//  Created by BobbyPhtr on 26/05/21.
//

import Foundation
import RxCocoa
import RxSwift

extension BehaviorRelay where Element: RangeReplaceableCollection {

     func append(_ subElement: Element.Element) {
         var newValue = value
         newValue.append(subElement)
         accept(newValue)
//        print("Append \(newValue)")
     }

     func append(contentsOf: [Element.Element]) {
         var newValue = value
         newValue.append(contentsOf: contentsOf)
         accept(newValue)
//        print("Append \(newValue)")
     }
    
    func insert(_ subElement : Element.Element, at index : Element.Index){
        var newValue = value
        newValue.insert(subElement, at: index)
        accept(newValue)
//        print("Insert \(newValue)")
    }

     public func remove(at index: Element.Index) {
         var newValue = value
         newValue.remove(at: index)
         accept(newValue)
//        print("Remove \(newValue)")
     }

     public func removeAll() {
         var newValue = value
         newValue.removeAll()
         accept(newValue)
     }
}
