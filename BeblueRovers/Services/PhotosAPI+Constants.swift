//
//  PhotosAPI+Constants.swift
//  BeblueRovers
//
//  Created by Silvia Florido on 26/02/19.
//  Copyright © 2019 Silvia Florido. All rights reserved.
//

extension PhotosAPI {
    
    struct Constants {
        
        // MARK: API Key
        static let ApiKey = "DEMO_KEY"

        // MARK: URLs
        static let Scheme = "https"
        static let Host = "api.nasa.gov/mars-photos/api"
        static let ApiPath = "/v1"
    }
    
    struct Methods {
        static let Rovers = "/rovers/{rover}/photos"
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let Rover = "rover"
    }
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let ApiKey = "api_key"
        static let EarthDate = "earth_date"
    }
    
}
