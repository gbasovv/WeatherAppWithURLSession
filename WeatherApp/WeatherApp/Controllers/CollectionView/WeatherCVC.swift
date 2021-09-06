//
//  WeatherCVC.swift
//  WeatherApp
//
//  Created by George on 5.09.21.
//

import UIKit

class WeatherCVC: UICollectionViewCell {
    
    static let identifier = "WeatherCVC"

    static func nib() -> UINib {
        return UINib(nibName: "WeatherCVC",
                     bundle: nil)
    }
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var tempLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    

    func configure(with model: Hourly) {
         
        let unixTime = NSDate(timeIntervalSince1970: TimeInterval(model.dt))
        let dateString = "\(unixTime)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        dateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
        let dateObj = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "HH:mm"
        self.timeLbl.text = "\(dateFormatter.string(from: dateObj!))"
        
        self.tempLbl.text = "\(Int(model.temp))°F"
        self.iconImageView.contentMode = .scaleAspectFit
        self.iconImageView.image = UIImage(named: model.weather[0].icon)
    }

}
