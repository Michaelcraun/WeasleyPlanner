//
//  LocationCell.swift
//  Weasley Planner
//
//  Created by Michael Craun on 3/2/18.
//  Copyright © 2018 Craunic Productions. All rights reserved.
//

import UIKit
import MapKit

class LocationCell: UITableViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = .clear
    }
    
    func layoutLocationsHeader() -> UIView {
        let locationHeader: UIView = {
            let view = UIView()
            
            return view
        }()
        locationHeader.fillTo(self)
        return locationHeader
    }
    
    func layoutCell(forLocation location: MKMapItem) {
        clearCell()
        
        let cellView: UIView = {
            let view = UIView()
            view.addBorder(clipsToBounds: false)
            view.addLightShadows()
            view.backgroundColor = secondaryColor
            
            let locationLabel: UILabel = {
                let label = UILabel()
                label.font = UIFont(name: secondaryFontName, size: smallFontSize)
                label.textColor = secondaryTextColor
                label.text = {
                    guard let locationName = location.name else { return "" }
                    return locationName
                }()
                return label
            }()
            
            let addressLabel: UILabel = {
                let label = UILabel()
                label.font = UIFont(name: secondaryFontName, size: smallestFontSize)
                label.textColor = secondaryTextColor
                label.text = {
                    guard let locationAddress = location.placemark.title else { return "" }
                    return locationAddress
                }()
                return label
            }()
            
            view.addSubview(locationLabel)
            view.addSubview(addressLabel)
            
            locationLabel.anchor(top: view.topAnchor,
                                 leading: view.leadingAnchor,
                                 padding: .init(top: 5, left: 5, bottom: 0, right: 0))
            
            addressLabel.anchor(top: locationLabel.bottomAnchor,
                                leading: view.leadingAnchor,
                                trailing: view.trailingAnchor,
                                bottom: view.bottomAnchor,
                                padding: .init(top: 2, left: 5, bottom: 5, right: 5))
            
            return view
        }()
        self.addSubview(cellView)
        cellView.fillTo(self, withPadding: .init(top: 5, left: 5, bottom: 5, right: 5))
    }
}
