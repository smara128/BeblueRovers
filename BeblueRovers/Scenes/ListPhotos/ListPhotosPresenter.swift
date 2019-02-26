//
//  ListPhotosPresenter.swift
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

protocol ListPhotosPresentationLogic
{
    func presentPhotos(response: ListPhotos.FetchPhotos.Response)
    func presentImage(response: ListPhotos.FetchImage.Response)
    func presentFetchError()
}

class ListPhotosPresenter: ListPhotosPresentationLogic
{
    weak var viewController: ListPhotosDisplayLogic?
    
    // MARK: Present Photos
    func presentPhotos(response: ListPhotos.FetchPhotos.Response)
    {
        var displayedPhotos: [ListPhotos.FetchPhotos.ViewModel.DisplayedPhoto] = []
        for photo in response.photos {
            let displayedPhoto = ListPhotos.FetchPhotos.ViewModel.DisplayedPhoto(photoId: photo.id, cameraName:"", cameraFullName:"", date: photo.earthDate, img_src: photo.imageSource, img_data: photo.imageData)
            displayedPhotos.append(displayedPhoto)
        }
        let viewModel = ListPhotos.FetchPhotos.ViewModel(displayedPhotos: displayedPhotos)
        viewController?.displayPhotos(viewModel: viewModel)
    }
    
    func presentFetchError() {
        
    }
    
    
    func presentImage(response: ListPhotos.FetchImage.Response) {
        if let imageResponse = UIImage(data: response.imageData) {
            let viewModel = ListPhotos.FetchImage.ViewModel(indexPath: response.indexPath, photoId: response.photoId, image: imageResponse)
            viewController?.displayImage(viewModel: viewModel)
        }
    }
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
}
