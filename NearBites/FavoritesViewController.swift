//
//  FavoritesViewController.swift
//  NearBites
//
//  Created by Paul Ancajima on 12/11/18.
//  Copyright © 2018 Paul Ancajima. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class FavoritesViewController: UIViewController {
    
    var favoritesList = [Business]()
    @IBOutlet weak var favoritesTableView: UITableView!
    
    override func viewDidLoad() {
        //Fetech objects from core data
        let fetchRequest: NSFetchRequest<Business> = Business.fetchRequest()
        do {
            let favList = try PersistenceService.context.fetch(fetchRequest)
            self.favoritesList = favList
            self.favoritesTableView.reloadData()
        } catch { }
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let business = favoritesList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell") as! FavoritesViewCell
        cell.restaurantName.text = business.name
        cell.restaurantAddress.text = business.address
        cell.phone.text = business.phoneNumber
        cell.restaurantImage.image = UIImage(data: business.image as! Data)
        cell.starRating.image = UIImage(data: business.starRating as! Data)
        
        return cell
    }
    
    //Delete favorites
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            //Must delete from coredata
            PersistenceService.context.delete(favoritesList[indexPath.row])
            favoritesList.remove(at: indexPath.row)
        }
        PersistenceService.saveContext()
        tableView.reloadData()
    }
    
    
    func convertImageToNSdata(image: UIImageView) -> NSData {
        let returnData = image.image?.pngData()! as! NSData
        return returnData
    }
}
