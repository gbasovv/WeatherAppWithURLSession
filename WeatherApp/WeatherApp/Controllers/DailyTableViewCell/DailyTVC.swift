//
//  DailyTVC.swift
//  WeatherApp
//
//  Created by George on 5.09.21.
//

import UIKit

class DailyTVC: UITableViewCell {
    
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var maxTempLbl: UILabel!
    @IBOutlet weak var minTempLbl: UILabel!
    
    static let identifier = "DailyTVC"

    static func nib() -> UINib {
        return UINib(nibName: "DailyTVC",
                     bundle: nil)
    }
    
    func configure(with model: Daily) {
        
        let unixTime = NSDate(timeIntervalSince1970: TimeInterval(model.dt))
        let dateString = "\(unixTime)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        dateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
        let dateObj = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "EEEE"
        self.dayLbl.text = "\(dateFormatter.string(from: dateObj!))"
        
        self.weatherImage.image = UIImage(named: model.weather[0].icon)
        self.maxTempLbl.text = "\(Int(model.temp.max))°F"
        self.minTempLbl.text = "\(Int(model.temp.min))"
    }    
}
