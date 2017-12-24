//
//  ViewController.swift
//  CryptoTracker
//
//  Created by Maxwell Stein on 9/23/17.
//  Copyright © 2017 Maxwell Stein. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var etherValueLabel: UILabel!
    let apiURL = URL(string: "https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let apiURL = apiURL else {
            return
        }
        
        makeValueGETRequest(url: apiURL) {(value) in
            DispatchQueue.main.async {
                self.etherValueLabel.text = self.formatAsCurrencyString(value: value) ?? "Failed"
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    private func makeValueGETRequest(url: URL, completion: @escaping (_ value: NSNumber?) -> Void) {
        let request = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil)
                print(error?.localizedDescription ?? "")
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                    let value = json["USD"] as? NSNumber else {
                        completion(nil)
                        return
                }
                completion(value)
            } catch {
                completion(nil)
                print(error.localizedDescription)
            }
        }
        request.resume()
    }
    
    private func formatAsCurrencyString(value: NSNumber?) -> String? {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        
        guard let value = value,
            let formattedCurrencyAmount = formatter.string(from: value) else {
                return nil
        }
        
        return formattedCurrencyAmount
    }


}
