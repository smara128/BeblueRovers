//
//  ListPhotosInteractor.swift
//  BeblueRovers
//
//  Created by Silvia Florido on 24/02/19.
//  Copyright (c) 2019 Silvia Florido. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ListPhotosBusinessLogic
{
    func fetchPhotos(request: ListPhotos.FetchPhotos.Request)
}

protocol ListPhotosDataStore
{
    //var name: String { get set }
}

class ListPhotosInteractor: ListPhotosBusinessLogic, ListPhotosDataStore
{
    
    var presenter: ListPhotosPresentationLogic?
      var worker: PhotosWorker?
    //var name: String = ""
    
    
    
    // MARK: Fetch Photos
    
    func fetchPhotos(request: ListPhotos.FetchPhotos.Request) {
            worker = PhotosWorker(photosStore: PhotosAPI.sharedInstance())
        worker?.fetchPhotos(completionHandler: { (photos, error) in
            print(photos as Any)
        })
//        let response = ListPhotos.FetchPhotos.Response()
//        presenter?.presentPhotos(response: response)
        
    }
    
    
}
