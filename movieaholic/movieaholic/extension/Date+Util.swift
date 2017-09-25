//
//  Date+Util.swift
//  movieaholic
//
//  Created by Victor Baleeiro on 24/09/17.
//  Copyright © 2017 Victor Baleeiro. All rights reserved.
//

import Foundation

extension Date {
    
    static func hoursBetween(initialDate: Date?, finalDate: Date?) -> Int {
        
        //Verifica se alguma das datas informadas é nula
        if (initialDate == nil || finalDate == nil) {
            return 0
        } else {
            
            //Realiza a verificação
            let calendar = NSCalendar.current
            
            // Remove a hora com 00:00 para
            let date1 = calendar.startOfDay(for: initialDate!)
            let date2 = calendar.startOfDay(for: finalDate!)
            let components = calendar.dateComponents([.hour], from: date1, to: date2)
            return components.hour!
        }
    }
}
