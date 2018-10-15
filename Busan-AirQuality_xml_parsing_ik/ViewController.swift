//
//  ViewController.swift
//  Busan-AirQuality_xml_parsing_ik
//
//  Created by D7702_10 on 2018. 10. 15..
//  Copyright © 2018년 jik. All rights reserved.
//

import UIKit

class ViewController: UIViewController, XMLParserDelegate, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var myTable: UITableView!
    var items = [AirQualityData]()
    var item = AirQualityData()
    var myPm10 = ""
    var myPm25 = ""
    var mySite = ""
    var myPm10Cai = ""
    var myPm25Cai = ""
    var currentElement = ""
    var currentTime = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        myTable.delegate = self
        myTable.dataSource = self
        
//        Timer.scheduledTimer(timeInterval: 3600, target: self, selector: #selector(ViewController.myParse), userInfo: nil, repeats: true)
        myParse()
    }
    
    @objc func myParse() {
        let skey = "wfNLEMEWY2HXXpx%2F2lvyAbIzGTzle8wzryRev8T%2BI9XfMG%2B7HflQ%2B4nhEhE%2Flbc6LvLREJotOzrTLx%2F%2Btg58KA%3D%3D"
        
        let strURL = "http://opendata.busan.go.kr/openapi/service/AirQualityInfoService/getAirQualityInfoClassifiedByStation?ServiceKey=\(skey)&Date_hour=2018091520&numOfRows=21"
        
        if URL(string: strURL) != nil {
            
            if let myParser = XMLParser(contentsOf: URL(string: strURL)!) {
                myParser.delegate = self
                
                if myParser.parse(){
                    print("파싱 성공")
                    print("PM10")
                    for i in 0..<items.count {
                        switch items[i].dPm10Cai {
                        case "1" : items[i].dPm10Cai = "좋음"
                        case "2" : items[i].dPm10Cai = "보통"
                        case "3" : items[i].dPm10Cai = "좋음"
                        case "4" : items[i].dPm10Cai = "매우좋음"
                        default : break
                        }
                        for i in 0..<items.count{
                            print("\(items[i].dSite) : \(items[i].dPm10)")
                        }
                        
                    }
                    
                    
                    
                } else {
                    print("파싱 실패")
                }
            }
        }
        
        
    }
    

    
    // XML Parser Delegate
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if !data.isEmpty {
            switch currentElement {
            case "pm10" : myPm10 = data
            case "site" : mySite = data
            case "pm10Cai" : myPm10Cai = data
            default : break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let myItem = AirQualityData()
            myItem.dPm10 = myPm10
            myItem.dPm10Cai = myPm10Cai
            myItem.dSite = mySite
            items.append(myItem)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTable.dequeueReusableCell(withIdentifier: "RE", for: indexPath)
        
        let myItem = items[indexPath.row]
        
        let site = cell.viewWithTag(1) as! UILabel
        let pm10 = cell.viewWithTag(2) as! UILabel
        let pm10cai = cell.viewWithTag(3) as! UILabel
        
        pm10.text = myItem.dPm10
        site.text = myItem.dSite
        pm10cai.text = myItem.dPm10Cai
        return cell
    }
}

