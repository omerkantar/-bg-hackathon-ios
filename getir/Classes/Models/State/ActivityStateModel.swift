//
//  UserRequestModel.swift
//  getir
//
//  Created by omer kantar on 17.02.2018.
//  Copyright © 2018 cool. All rights reserved.
//

import UIKit
import ObjectMapper

enum ActivityStateType {
    case request
    case deal
}

class ActivityStateModel: BaseModel {

    var travel: TravelModel?
    var pack: PackModel?
    var status: String?
    
    var type: ActivityStateType = ActivityStateType.request
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        travel <- map["travel"]
        pack <- map["pack"]
        status <- map["status"]
    }
    
    
    var parameters: [String: Any] {
        
        var params = [String: Any]()
        if let id = UserModel.current.id {
            params["send_from"] = id
        }
        
        if let pack = pack {
            if pack.isMe {
                if let id = travel?.id {
                    params["send_to"] = id
                }
            } else {
                if let id = pack.id {
                    params["send_to"] = id
                }
            }
        }
        
        if let id = travel?.id {
            params["travel"] = id
        }
        if let id = pack?.id {
            params["pack"] = id
        }
//        if let id = UserModel.current.id {
//            params["user"] = id
//        }
        
        return params
    }
}
