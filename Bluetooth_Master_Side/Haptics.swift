//
//  Haptics.swift
//  The Labyrinth
//
//  Created by Teymur Kazakov on 12/29/21.
//

import Foundation
import UIKit

// the buzzing, vibrating, and other tangible effects

final class HapticsManager{
    
    static let shared = HapticsManager()
    
    public func selectVibration(){
        DispatchQueue.main.async {
            let feedback = UISelectionFeedbackGenerator()
            feedback.prepare()
            feedback.selectionChanged()
        }
    }
    
    public func beginVibration(type: UINotificationFeedbackGenerator.FeedbackType){
        DispatchQueue.main.async {
            let notification = UINotificationFeedbackGenerator()
            notification.prepare()
            notification.notificationOccurred(type)
        }
    }
    
    
    
}
