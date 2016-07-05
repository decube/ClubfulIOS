//
//  PhotoAlbumCustom.swift
//  Jundan
//
//  Created by guanho on 2016. 5. 6..
//  Copyright © 2016년 guanho. All rights reserved.
//

import Foundation
import Photos
import AssetsLibrary

enum PhotoAlbumUtilResult {
    case SUCCESS, ERROR, DENIED
}

class PhotoAlbumUtil: NSObject {
    
    class func saveImageInAlbum(image: UIImage, albumName: String, completion: ((result: PhotoAlbumUtilResult) -> ())?) {
        
        // 사진첩 폴더 생성
        var eventAlbum: PHAssetCollection?
        let albumName = albumName
        let albums = PHAssetCollection.fetchAssetCollectionsWithType(PHAssetCollectionType.Album, subtype: PHAssetCollectionSubtype.Any, options: nil)
        albums.enumerateObjectsUsingBlock { (album, index, stop) in
            if album.localizedTitle == albumName {
                eventAlbum = album as? PHAssetCollection
                stop.memory = true
            }
        }
        
        //폴더 생성 유무 확인
        //첫 생성 시 eventAlbum == nil
        
        if  eventAlbum != nil {
            completion?(result: .DENIED)
        }else{
            //eventAlbum == nil 경우 폴더 생성
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(albumName)
                }, completionHandler: { (succeeded, error) -> Void in
                    
                    if succeeded {
                        //성공 시 폴더 생성 후 함수 재호출
                        self.saveImageInAlbum(image, albumName: albumName, completion: completion)
                        
                    } else {
                        // 에러
                        completion?(result: .ERROR)
                    }
            })
        }
        
        // 생성 확인 됐을 시 이미지 저장 작업
        if let albumdex = eventAlbum {
            
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                let result = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
                let assetPlaceholder = result.placeholderForCreatedAsset
                let albumChangeRequset = PHAssetCollectionChangeRequest(forAssetCollection: albumdex)
                let enumeration: NSArray = [assetPlaceholder!]
                albumChangeRequset!.addAssets(enumeration)
                
                }, completionHandler: { (succeeded, error) -> Void in
                    if succeeded {
                        completion?(result: .SUCCESS)
                    } else{
                        print(error!.localizedDescription)
                        completion?(result: .ERROR)
                    }
            })
        }
    }
}