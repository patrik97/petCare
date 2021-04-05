//
//  DropDownInitializer.swift
//  petCare
//
//  Created by Patrik Pluhař on 05.04.2021.
//  Copyright © 2021 FI MU. All rights reserved.
//

import Foundation
import DropDown

class DropDownInitializer {
    
    /**
     Initialize drop down
     
     - Parameter dataSource: data source represented by string
     - Parameter anchorView: element where drop down starts
     - Parameter width: width of drop down
     - Parameter selectedRow: default selection
     - Returns DropDown object
     */
    public static func Initialize(dataSource: [String], anchorView: AnchorView?, width: CGFloat, selectedRow: Int) -> DropDown {
        let dropDown = DropDown()
        dropDown.direction = .bottom
        dropDown.dataSource = dataSource
        dropDown.cellHeight = 43.5
        dropDown.anchorView = anchorView
        dropDown.width = width
        dropDown.bottomOffset = CGPoint(x: 10, y: 0)
        dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            cell.optionLabel.textAlignment = .center
            cell.optionLabel.font = UIFont(name: "System", size: 21)
        }
        dropDown.selectRow(selectedRow)
        dropDown.selectionBackgroundColor = UIColor.lightGray
        return dropDown
    }
}
