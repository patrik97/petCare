//
//  EventGalleryController.swift
//  petCare
//
//  Created by Patrik Pluhař on 26.02.2021.
//  Copyright © 2021 FI MU. All rights reserved.
//

import UIKit

class EventGalleryController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class GalleryCell: UICollectionViewCell {
    @IBOutlet weak var photo: UIImageView!
}
