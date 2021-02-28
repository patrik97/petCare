//
//  EventGalleryController.swift
//  petCare
//
//  Created by Patrik Pluhař on 26.02.2021.
//  Copyright © 2021 FI MU. All rights reserved.
//

import UIKit

class EventGalleryController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var event: Event? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return event?.photos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.size.width / 2) - 20
        var height = width * 1.3
        if let photoData = event?.photos[indexPath.row] {
            if let image = UIImage(data: photoData) {
                let ratio = image.size.height / image.size.width
                height = width * ratio
            }
        }
        
        return CGSize(width: width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? GalleryCell else {
            return UICollectionViewCell()
        }
        
        if let photoData = event?.photos[indexPath.row] {
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
