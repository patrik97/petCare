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
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return event?.photos.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? GalleryCell else {
            return UICollectionViewCell()
        }
        
        if let photoData =  event?.photos[indexPath.row] {
            cell.photo.image = UIImage(data: photoData)
        }
        
        return cell
    }
    
    @IBAction func cameraButtonClick(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
}

extension EventGalleryController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            return
        }
        
        if let selectedImageData: Data = selectedImage.pngData() {
            event?.photos.append(selectedImageData)
        }
        
        self.collectionView.reloadData()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

class GalleryCell: UICollectionViewCell {
    @IBOutlet weak var photo: UIImageView!
}
