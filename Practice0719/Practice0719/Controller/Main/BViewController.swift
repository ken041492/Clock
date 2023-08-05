//
//  BViewController.swift
//  Practice0719
//
//  Created by imac-1682 on 2023/7/19.
//

import UIKit
import RealmSwift

class BViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var myPickerview: UIPickerView!
    @IBOutlet weak var myBTableview: UITableView!
    @IBOutlet weak var DeleteBTN: UIButton!
    
    
    // MARK: - Variables
    var sendMessagToADelegate: SendMessageToADelegate?
    var reloadAView: ReloadTableViewDelegate?
    var leftBarButton_cancle: UIBarButtonItem?
    var rightBarButton_save: UIBarButtonItem?
    let userDefaults = UserDefaults.standard
    var uuid: ObjectId!
    var weekSelect: String = ""
    let Period: [String] = ["上午", "下午"]
    let Hours = [Int](1...12)
    let Minutes = [Int](0...59)
    
    var SelectPeriod: String = "上午"
    var SelectHours: String = "1"
    var SelectMinutes: String = "00"
    
    var editedPeriod: String = "上午"
    var editedHours: String = "1"
    var editedMinutes: String = "00"
    
    var AViewWeek: String = ""
    var recieve_Mention: String = ""
    var catchMentionLabel: String = ""
    var SaveTextfield: String = ""
    var catchWeekSelect: String = ""
    var saveWeekToRPV: String = ""
    let addAlarmTitles = ["重複", "標籤", "提示聲", "稍後提醒"]
    let addAlarmDetails = ["永不", "鬧鐘", "雷達"]
    var clock_array: [ClockStruct] = []
    var save_RP_MT: [String] = []

    let week: [String] = ["星期日", "星期一", "星期二","星期三", "星期四", "星期五", "星期六"]
    var recieveA_clockArray: [ClockStruct] = []
    var recieve_Tag: String = ""
    var recieve_indexPath: Int = 0
    var recieve_IsEdit: Bool = false
    var recieve_switch: Bool = true
    
    var PickerViewSelected: Bool = false
    var PickPeriod: Bool = false
    var PickHours: Bool = false
    var PickMinutes: Bool = false
    
    var initialAmPmIndex: Int = 0
    var initialHourIndex: Int = 0
    var initialMinuteIndex: Int = 0
    
    var editedPeriodIndex: Int = 0
    var editedHoursIndex: Int = 0
    var editedMinutesIndex: Int = 0
    
    var register: String = ""
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        myBTableview.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sendMessagToADelegate?.sendMessage(period: SelectPeriod, hours: SelectHours, minutes: SelectMinutes, clock_array: clock_array, weekLabel: AViewWeek, MentionLabel: catchMentionLabel)
        reloadAView?.reloadtableview()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - UI Settings
    
    func setupBUI() {
        setupBNavigation()
        myPickerview.delegate = self
        myPickerview.dataSource = self

        myBTableview.register(UINib(nibName: "BTableViewCell", bundle: nil), forCellReuseIdentifier: BTableViewCell.identified)
        myBTableview.register(UINib(nibName: "BMTableViewCell", bundle: nil), forCellReuseIdentifier: BMTableViewCell.identified)
        myBTableview.register(UINib(nibName: "BLTableViewCell", bundle: nil), forCellReuseIdentifier: BLTableViewCell.identified)
        
        myBTableview.delegate = self
        myBTableview.dataSource = self
        myBTableview.isScrollEnabled = false
        
        if recieve_IsEdit && PickerViewSelected == false {
            initialAmPmIndex = Period.firstIndex(of: recieveA_clockArray[recieve_indexPath].DB_Period) ?? 0
            initialHourIndex = Hours.firstIndex(of: Int(recieveA_clockArray[recieve_indexPath].DB_Hours)!) ?? 0
            initialMinuteIndex = Minutes.firstIndex(of: Int(recieveA_clockArray[recieve_indexPath].DB_Minutes)!) ?? 0
            myPickerview.selectRow(initialAmPmIndex, inComponent: 0, animated: false)
            myPickerview.selectRow(initialHourIndex, inComponent: 1, animated: false)
            myPickerview.selectRow(initialMinuteIndex, inComponent: 2, animated: false)
            editedPeriod = Period[initialAmPmIndex]
            editedHours = String(Hours[initialHourIndex])
            if Minutes[initialMinuteIndex] < 10 {
                editedMinutes = "0\(Minutes[initialMinuteIndex])"
            } else {
                editedMinutes = "\(Minutes[initialMinuteIndex])"
            }
        }
    }
    
    func setupBNavigation() {
        
        if recieve_IsEdit {
            self.title = "編輯鬧鐘"
            DeleteBTN.isHidden = false
        } else {
            self.title = "加入鬧鐘"
            DeleteBTN.isHidden = true
        }

        leftBarButton_cancle = UIBarButtonItem(title: "取消", style: .done, target: self, action: #selector(cancle_BTN))
        rightBarButton_save = UIBarButtonItem(title: "儲存", style: .done, target: self, action: #selector(add_BTN))
        
        leftBarButton_cancle?.tintColor = UIColor.orange
        rightBarButton_save?.tintColor = UIColor.orange
        
        navigationItem.leftBarButtonItem = leftBarButton_cancle
        navigationItem.rightBarButtonItem = rightBarButton_save
        
    }
    
    func getSystemTime() -> String {
        
        let currectDate = Date()
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale.ReferenceType.system
        dateFormatter.timeZone = TimeZone.ReferenceType.system
        return dateFormatter.string(from: currectDate)
    }
    
    
    // MARK: - IBAction
    @IBAction func DeleteDT(_ sender: UIButton) {
        let realm = try! Realm()
        let del_UUID = recieveA_clockArray[recieve_indexPath].uuid
        let delect_cell = realm.objects(Clock.self).where {
            $0.uuid == del_UUID
        }[0]
        
        try! realm.write {
            realm.delete(delect_cell)
        }
        recieveA_clockArray.remove(at: recieve_indexPath)
        clock_array = recieveA_clockArray
        dismiss(animated: true)
    }
    
    @objc func cancle_BTN() {
        
        clock_array = []
        let realm = try! Realm()
        let Clock_DB = realm.objects(Clock.self)
        for clock in Clock_DB{
            let new_clock_struct = ClockStruct(uuid: clock["uuid"] as! ObjectId, DB_Period: clock["DB_Period"] as! String,DB_Hours: clock["DB_Hours"] as! String, DB_Minutes: clock["DB_Minutes"] as! String, CurrentTime: clock["CurrentTime"] as! String, WeekLabel: clock["WeekLabel"] as! String, MentionLabel: clock["MentionLabel"] as! String, TagText: clock["TagText"] as! String,
                SaveSwitch: clock["SaveSwitch"] as! Bool, SaveWeekNumber: clock["SaveWeekNumber"] as! String)
            clock_array.append(new_clock_struct)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func add_BTN() {
        let index: Int!
        let realm = try! Realm()
        let Clock_DB = realm.objects(Clock.self)
        if recieve_IsEdit {
            try! realm.write {
                Clock_DB[recieve_indexPath].DB_Period = editedPeriod
                Clock_DB[recieve_indexPath].DB_Hours = editedHours
                Clock_DB[recieve_indexPath].DB_Minutes = editedMinutes
                Clock_DB[recieve_indexPath].TagText = SaveTextfield
                Clock_DB[recieve_indexPath].WeekLabel = Clock_DB[recieve_indexPath].TagText + "," + AViewWeek
                Clock_DB[recieve_indexPath].MentionLabel = recieve_Mention
                Clock_DB[recieve_indexPath].SaveSwitch = recieve_switch
                Clock_DB[recieve_indexPath].SaveWeekNumber = weekSelect
            }
            index = recieve_indexPath
            recieve_IsEdit = false
        } else {
            try! realm.write {
                realm.add(Clock(DB_Period: editedPeriod, DB_Hours: editedHours, DB_Minutes: editedMinutes, CurrentTime: getSystemTime(), WeekLabel: "\(SaveTextfield), \(AViewWeek)", MentionLabel: recieve_Mention, TagText: SaveTextfield, SaveSwitch: recieve_switch, SaveWeekNumber: weekSelect))
            }
            index = Clock_DB.count - 1
        }
        clock_array = []
        for clock in Clock_DB{
            let new_clock_struct = ClockStruct(uuid: clock["uuid"] as! ObjectId, DB_Period: clock["DB_Period"] as! String,DB_Hours: clock["DB_Hours"] as! String, DB_Minutes: clock["DB_Minutes"] as! String, CurrentTime: clock["CurrentTime"] as! String, WeekLabel: clock["WeekLabel"] as! String, MentionLabel: clock["MentionLabel"] as! String, TagText: clock["TagText"] as! String, SaveSwitch: clock["SaveSwitch"] as! Bool, SaveWeekNumber: clock["SaveWeekNumber"] as! String)
            
            clock_array.append(new_clock_struct)
        }
        // 讓鬧鐘響

        let weeekNumber = clock_array[index].SaveWeekNumber
        uuid = clock_array[index].uuid
        let trimmedString = weeekNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        let numberStrings = trimmedString.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").components(separatedBy: ",")
        let weekNumber = numberStrings.compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        let today = Date()
        let dateComponents = Calendar.current.dateComponents(in: TimeZone.current, from: today)
        let weekday = dateComponents.weekday! - 1
        if weekNumber.count != 0 {
            for i in weekNumber {
                if i == weekday {
                    let content = UNMutableNotificationContent()
                    var dateComponents = DateComponents()
                    if clock_array[index].DB_Period == "上午" || clock_array[index].DB_Hours == "12" {
                        dateComponents.hour = Int(clock_array[index].DB_Hours)
                    } else {
                        dateComponents.hour = Int(clock_array[index].DB_Hours)! + 12
                    }
                    dateComponents.minute = Int(clock_array[index].DB_Minutes)

                    content.title = "\(clock_array[index].DB_Period), \(dateComponents.hour!) : \(dateComponents.minute!) 鬧鐘通知"
                    content.body = "該起床了！"
                    content.sound = .default
                    
                    print("\(dateComponents.hour!), \(dateComponents.minute!)")
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                    let request = UNNotificationRequest(identifier: "\(uuid!)", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request) { (error) in
                        if let error = error {
                            print("無法建立鬧鐘通知: \(error)")
                        }
                    }
                }
            }
        } else {
            let content = UNMutableNotificationContent()
            var dateComponents = DateComponents()
            if clock_array[index].DB_Period == "上午" || clock_array[index].DB_Hours == "12" {
                dateComponents.hour = Int(clock_array[index].DB_Hours)
            } else {
                dateComponents.hour = Int(clock_array[index].DB_Hours)! + 12
            }
            dateComponents.minute = Int(clock_array[index].DB_Minutes)

            content.title = "\(clock_array[index].DB_Period), \(dateComponents.hour!) : \(dateComponents.minute!) 鬧鐘通知"
            content.body = "該起床了！"
            content.sound = .default
            
            print("\(dateComponents.hour!), \(dateComponents.minute!)")
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: "\(uuid!)", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("無法建立鬧鐘通知: \(error)")
                }
            }
            
            register = "\(uuid!)"
        }
        dismiss(animated: true)
    }
}
// MARK: - Extension

extension BViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return Period.count
        } else if component == 1 {
            return Hours.count
        } else {
            return Minutes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView,
      titleForRow row: Int, forComponent component: Int)
    -> String? {
        if component == 0 {
            return Period[row]
        } else if component == 1 {
            return "\(Hours[row])"
        } else {
            if Minutes[row] < 10 {
                return "0\(Minutes[row])"
            } else {
                return "\(Minutes[row])"
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView,
      didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            SelectPeriod = Period[row]
            PickPeriod = true
        } else if component == 1 {
            SelectHours = "\(Hours[row])"
            PickHours = true
        } else {
            SelectMinutes = "\(Minutes[row])"
            PickMinutes = true
        }
        PickerViewSelected = true

        editedPeriodIndex = myPickerview.selectedRow(inComponent: 0)
        editedHoursIndex = myPickerview.selectedRow(inComponent: 1)
        editedMinutesIndex = myPickerview.selectedRow(inComponent: 2)
        
        editedPeriod = Period[editedPeriodIndex]
        editedHours = "\(Hours[editedHoursIndex])"
        if Minutes[editedMinutesIndex] < 10 {
            editedMinutes = "0\(Minutes[editedMinutesIndex])"
        } else {
            editedMinutes = "\(Minutes[editedMinutesIndex])"
        }
    }
}

extension BViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addAlarmTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 3:
            let cell = myBTableview.dequeueReusableCell(withIdentifier: BMTableViewCell.identified, for: indexPath) as! BMTableViewCell
            cell.mentionLabel.text = addAlarmTitles[indexPath.row]
            recieve_switch = cell.mentionSwitch.isOn
            if recieve_IsEdit {
                cell.mentionSwitch.isOn = recieve_switch
            }
            recieve_switch = cell.mentionSwitch.isOn
            return cell
        case 1:
            let cell = myBTableview.dequeueReusableCell(withIdentifier: BLTableViewCell.identified, for: indexPath) as! BLTableViewCell
            cell.WeekTextField.delegate = self
            cell.Label.text = addAlarmTitles[indexPath.row]
            SaveTextfield = cell.WeekTextField.text!
            if SaveTextfield != ""{
                SaveTextfield = cell.WeekTextField.text!
            } else {
                cell.WeekTextField.text = addAlarmDetails[indexPath.row]
            }
            if recieve_IsEdit {
                cell.WeekTextField.text = recieve_Tag
            }
            if SaveTextfield != "" {
                cell.WeekTextField.text = SaveTextfield
            } else {
                SaveTextfield = cell.WeekTextField.text!
            }
            
            if cell.WeekTextField.text == "" {
                cell.WeekTextField.text = "鬧鐘"
                SaveTextfield = cell.WeekTextField.text!
            }
            return cell
        default:
            let cell = myBTableview.dequeueReusableCell(withIdentifier: BTableViewCell.identified, for: indexPath) as! BTableViewCell
            
            if indexPath.row == 0 || indexPath.row == 2 {
                cell.addArrowSymbol()
            } else {
                cell.removeArrowSymbol()
            }
            
            cell.titlelabel.text = addAlarmTitles[indexPath.row]
            if catchWeekSelect == "" {
                if recieve_IsEdit {
                    let saveWeek = recieveA_clockArray[recieve_indexPath].WeekLabel.components(separatedBy: ",")[1]
                    let savemention = recieveA_clockArray[recieve_indexPath].MentionLabel
                    if saveWeek == " " || saveWeek == ""  {
                        if indexPath.row == 0 {
                            cell.optionlabel.text = addAlarmDetails[0]
                        }
                    } else {
                        if indexPath.row != 2 {
                            cell.optionlabel.text = saveWeek
                            AViewWeek = cell.optionlabel.text!
                        } else {
                            cell.optionlabel.text = addAlarmDetails[indexPath.row]
                        }
                    }
                    if indexPath.row == 2 {
                        if savemention != "" {
                            cell.optionlabel.text = savemention
                            recieve_Mention = cell.optionlabel.text!
                        } else {
                            cell.optionlabel.text = addAlarmDetails[indexPath.row]
                        }
                    }
                } else {
                    cell.optionlabel.text = addAlarmDetails[indexPath.row]
                    recieve_Mention = cell.optionlabel.text!  // test
                }
            } else {
                cell.optionlabel.text = catchWeekSelect
                AViewWeek = cell.optionlabel.text!
                catchWeekSelect = ""
            }
            
            if AViewWeek != "" {
                if indexPath.row == 0 {
                    cell.optionlabel.text = AViewWeek
                }
                if AViewWeek == "從不" {
                    AViewWeek = "" 
                }
            }
            
            if catchMentionLabel != "" {
                if indexPath.row == 2 {
                    cell.optionlabel.text = String(catchMentionLabel.prefix(2))
                    recieve_Mention = cell.optionlabel.text!
                }
            }
            
            if recieve_IsEdit {
                weekSelect = recieveA_clockArray[recieve_indexPath].SaveWeekNumber
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let repeatVC = RepeatViewController()
            repeatVC.sendWeekToBDelegate = self
            repeatVC.selectWeek = self
            repeatVC.getBweekLabel = AViewWeek
            let newBackButton = UIBarButtonItem()
            newBackButton.title = "返回"
            navigationItem.backBarButtonItem = newBackButton
            navigationController?.navigationBar.tintColor = .orange
            navigationController?.pushViewController(repeatVC, animated: true)
        case 2:
            let MentionVC = MentionViewController()
            MentionVC.sendMentionToBDelegate = self
            MentionVC.saveBMention = recieve_Mention
            let newBackButton = UIBarButtonItem()
            newBackButton.title = "返回"
            navigationItem.backBarButtonItem = newBackButton
            navigationController?.navigationBar.tintColor = .orange
            navigationController?.pushViewController(MentionVC, animated: true)
        default:
            break
        }
    }
}

extension BViewController: sendWeekToBDelegate, ReloadTableViewDelegate, sendMentionToBDelegate {
    func sendWeek(weekSelect: String) {
        catchWeekSelect = weekSelect
    }

    func reloadtableview() {
        myBTableview.reloadData()
    }
    
    func sendMention(MentionSelect: String) {
        catchMentionLabel = MentionSelect
    }
}
extension BViewController: SelectWeek {
    func sendSelect(select_week_number: String) {
        weekSelect = select_week_number
    }
}

// MARK: - Protocol

protocol SendMessageToADelegate {
    func sendMessage(period: String, hours: String, minutes: String, clock_array: [ClockStruct], weekLabel: String, MentionLabel: String)
}

