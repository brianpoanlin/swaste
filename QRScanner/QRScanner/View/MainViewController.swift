//
//  MainViewController.swift
//  QRScanner
//
//  Created by Nikos Mouchtaris on 9/7/19.
//  Copyright © 2019 KM, Abhilash. All rights reserved.
//

import UIKit


class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, serverCommDelegate  {
    var data : SwasteData? = nil
    @IBOutlet weak var circleImage: UIImageView!
    
    var isRefresh = false
    func gotData(data: SwasteData) {
        self.data = data
        trashHistory.reloadData()
        totalPoints.text = String(data.points)
//        if(!isRefresh){
        trashHistory.refreshControl?.endRefreshing()
//        }
    }
    
    @IBOutlet weak var totalPoints: UILabel!
    
    func getNumOfEach(data : disposalData) -> [Int]{
        
        var arr = [0,0,0]
        for stuff in data.actions{
            if(stuff == "recycle"){
                arr[0] += 1
            }
            if(stuff == "trash"){
                arr[1] += 1
            }
            if(stuff == "compost"){
                arr[2] += 1
            }
        }
        return arr
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath as IndexPath) as! TrashDataTableViewCell
//        cell.nameLabel.text = data[indexPath.row]
        
        var arr = getNumOfEach(data: data!.disposalHistory[indexPath.row])
        cell.compostNumber.text = "x" + String(arr[2])
        cell.recyclingNumber.text = "x" + String(arr[0])
        cell.trashNumber.text = "x" + String(arr[1])
        cell.pointsForTransaction.text = "+" + String((arr[2] + arr[1] + arr[0]))
        
        
        cell.timeLength.text = self.getTime(time: data!.disposalHistory[indexPath.row].time)
        return cell
    }
    
    func getTime(time: Int) -> String{
        let date = NSDate(timeIntervalSince1970: TimeInterval(time))
        let dateNow = NSDate()
        if(Calendar.current.isDate(date as Date, inSameDayAs:dateNow as Date)){
            let diff = (Int)(Date().timeIntervalSince1970) - time
            if(diff < 60*60){
                return String(diff / (60)) + "m"
            }
            else{
                return String(diff / (60*60)) + "h"
            }
        }
        else{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd"
            let dayNow = Int(dateFormatter.string(from: dateNow as Date))!
            let dayPrevious = Int(dateFormatter.string(from: date as Date))!
            let stringDate = String(dayNow - dayPrevious) + "d"
            
            return stringDate
        }
    }
    
    @IBOutlet weak var trashHistory: UITableView!
    
    func getUserData(){
        let d = ServerCommunication()
        d.getSwasteUserData(delegate: self)
    }
    
    func setupBar(){
        navigationController?.navigationBar.barTintColor = SwasteThemeColors.lavender
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        totalPoints.layer.cornerRadius = 0.5 * totalPoints.bounds.size.width
        totalPoints.layer.masksToBounds = true
        totalPoints.backgroundColor = SwasteThemeColors.lavender
        totalPoints.textColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    override func viewDidLoad() {
        self.setupBar()
        self.getUserData()

        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(refresh), for: .valueChanged)
        trashHistory.refreshControl = refreshControl
        
//        self.tableView.delgate = self
//        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.getUserData()
        self.setupBar()
        
    }

    
    @objc func refresh() {
        self.getUserData()
        self.isRefresh = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = data?.disposalHistory.count else{
            return 0
        }
        return count
    }

    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // cell selected code here
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
