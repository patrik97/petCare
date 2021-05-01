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
        
        //let size = (UIScreen.main.bounds.size.width - 20) / 2
        return CGSize(width: width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? GalleryCell else {
            return UICollectionViewCell()
        }
        
        if let photoData = event?.photos[indexPath.row] {
            if let image = UIImage(data: photoData) {
                cell.photo.image = image
            }
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
        
        if let selectedImageData: Data = selectedImage.jpegData(compressionQuality: 1) {
            event?.photos.append(selectedImageData)
            if let e = event {
                DataStorage.updateEvent(event: e)
            }
        }
        
        self.collectionView.reloadData()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Select as main event picture", style: .default, handler: { _ in self.event?.setPhotoAsMain(index: indexPath.row) } ))
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { _ in self.event?.removePhotoAt(index: indexPath.row)
            self.collectionView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}

class GalleryCell: UICollectionViewCell {
    @IBOutlet weak var photo: UIImageView!
}
