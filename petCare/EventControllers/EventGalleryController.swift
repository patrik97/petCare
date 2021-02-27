//
//  EventGalleryController.swift
//  petCare
//
//  Created by Patrik Pluhař on 26.02.2021.
//  Copyright © 2021 FI MU. All rights reserved.
//

import UIKit

class EventGalleryController: UICollectionViewController {
    var event: Event? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return event?.photos.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? GalleryCell else {
            return UICollectionViewCell()
        }
        
        if let photoData =  event?.photos[indexPath.row] {
            cell.photo.image = UIImage(data: photoData as Data)
        }
        
        return cell
    }
}

class GalleryCell: UICollectionViewCell {
    @IBOutlet weak var photo: UIImageView!
}
