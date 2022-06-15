//
//  UIStoryboard+Extension.swift
//  Presentation
//
//  Created by josh.fn7 on 2022/06/15.
//

import UIKit

extension UIStoryboard {

    static let main = UIStoryboard(name: "Main", bundle: .current)
    
}

extension UIStoryboard {
    
    func createInstance<VC>() -> VC where VC : UIViewController & StoryboardIdentifiable {
        instantiateViewController(withIdentifier: VC.storyboardID) as! VC
    }
    
}
