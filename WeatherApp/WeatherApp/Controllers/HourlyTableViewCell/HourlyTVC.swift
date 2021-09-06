//
//  HourlyTVC.swift
//  WeatherApp
//
//  Created by George on 5.09.21.
//

import UIKit

class HourlyTVC: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionView: UICollectionView!
    
    var models = [Hourly]()

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(WeatherCVC.nib(), forCellWithReuseIdentifier: WeatherCVC.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static let identifier = "HourlyTVC"

    static func nib() -> UINib {
        return UINib(nibName: "HourlyTVC",
                     bundle: nil)
    }
    
    func configure(with models: [Hourly]) {
        self.models = models
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCVC.identifier, for: indexPath) as! WeatherCVC
        cell.configure(with: models[indexPath.row])
        return cell
    }
}

