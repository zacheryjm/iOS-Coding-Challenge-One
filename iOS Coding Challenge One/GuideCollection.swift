//
//  GuideCollection.swift
//  iOS Coding Challenge One
//
//  Created by Zachery Miller on 1/28/19.
//  Copyright © 2019 Zachery Miller. All rights reserved.
//

import Foundation

class GuideCollection {
    
    var guides = [Guide]()
    var guidesByStartDate = [Date : [Guide]]()
    var guideStartDates : [Date] { return Array(guidesByStartDate.keys).sorted()}

    
    init(json : [String : Any]) {
                
        guard let data = json["data"] as? NSArray else {
            print("Error getting data")
            return
        }
                
        for index in 0..<data.count {
            
            guard let guideData  = data[index] as? [String : Any] else {
                print("Error parsing json")
                return
            }
            
            do {
                let guide = try Guide(json: guideData)
                guides.append(guide!)
            }
            catch {
                print("Error converting json to Guide object")
            }
            
        }
        //Sort the guides in ascending order by start date 
        guides = guides.sorted(by: { ($0 < $1) })
        organizeGuidesByStartDate()
    }
    
    private func organizeGuidesByStartDate() {
        for guide in guides {
            
            if let startDate = guide.startDate {
                if guidesByStartDate.keys.contains(startDate) {
                    guidesByStartDate[startDate]?.append(guide)
                }
                else {
                    guidesByStartDate[startDate] = [guide]
                }
            }
        }
    }
    
}
