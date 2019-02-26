//
//  PhotosAPI.swift
//  BeblueRovers
//
//  Created by Silvia Florido on 24/02/19.
//  Copyright © 2019 Silvia Florido. All rights reserved.
//

import Foundation


class PhotosAPI: PhotosStoreProtocol {
    
    var session = URLSession.shared
    
    class func sharedInstance() -> PhotosAPI {
        struct Singleton {
            static var sharedInstance = PhotosAPI()
        }
        return Singleton.sharedInstance
    }
    
    func fetchPhotos(rover:String, date:String, completionHandler: @escaping ([Photo]?, PhotosStoreError?) -> Void) {
        var parametersWithApiKey = [ParameterKeys.EarthDate: date]
        parametersWithApiKey[ParameterKeys.ApiKey] = Constants.ApiKey
        
        var mutableMethod: String = Methods.Rovers
        mutableMethod = substituteKeyInMethod(mutableMethod, key: URLKeys.Rover, value: rover)!
       
        let url = urlFromParameters(parametersWithApiKey,  withPathExtension: mutableMethod)// else {
        let request = URLRequest(url:url)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard (error == nil) else {
                completionHandler(nil, PhotosStoreError.CannotFetch("Task returned error \(error!)"))
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHandler(nil, PhotosStoreError.CannotFetch("Your request returned a status code other than 2xx!"))
                return
            }
            
            guard let data = data else {
                completionHandler(nil, PhotosStoreError.CannotFetch("No data was returned by the request!"))
                return
            }
            
            var parsedData: AnyObject? = nil
            do {
                parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
                if let parsedData = parsedData {
                    self.convertDataIntoPhotos(parsedData, completionHandlerForConvertData: completionHandler)
                }
                
            } catch {
                completionHandler(nil, PhotosStoreError.CannotFetch( "Could not parse the data as JSON: \(data)"))
            }

        }
        task.resume()
    }
        
    
    
    private func convertDataIntoPhotos(_ parsedData: AnyObject, completionHandlerForConvertData: ([Photo]?, PhotosStoreError?) -> Void) {
        
        guard let photosData = parsedData["photos"] as? [[String:AnyObject]] else {
            completionHandlerForConvertData(nil, PhotosStoreError.CannotFetch( "Could not parse the data into photos."))
            return
        }
        print(parsedData as Any)

        var photos = [Photo]()
        for photo in photosData {
            guard let id = photo["id"] as? Int,
                let earthDate = photo["earth_date"] as? String,
                let imageSource = photo["img_src"] as? String else {
                    continue
            }
            
            let photo = Photo(id: id, earthDate: earthDate, imageSource: imageSource, imageData: nil)
            print(photo as Any)
            photos.append(photo)
        }
        
        completionHandlerForConvertData(photos, nil)
        
    }
    
    func fetchImage(_ urlString: String, completionHandlerForImage: @escaping (Data?, PhotosStoreError?) -> Void) -> Void {
        guard let url = URL(string: urlString) else {
            completionHandlerForImage(nil, PhotosStoreError.CannotFetch(urlString))
            return
        }

        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard (error == nil) else {
                completionHandlerForImage(nil, PhotosStoreError.CannotFetch("There was an error with your request: \(error!)"))
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHandlerForImage(nil, PhotosStoreError.CannotFetch("Your request returned a status code other than 2xx!"))
                return
            }
            
            guard let data = data else {
                completionHandlerForImage(nil, PhotosStoreError.CannotFetch("No data was returned by the request!"))
                return
            }
            print("Image data: \(data)")
            completionHandlerForImage(data, nil)
        }
        task.resume()
        
    }
    
    
    
    
    // create a URL from parameters
    private func urlFromParameters(_ parameters: [String:String], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.Scheme
        components.host = Constants.Host
        components.path = Constants.Path + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
}
