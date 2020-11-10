//
//  TimeLineViewController.swift
//  dreamer1
//
//  Created by Elsa on 2020/5/25.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit
import SwipeCellKit
import ChameleonFramework

class TimeLineViewController : UITableViewController {
    
    @IBOutlet var searchBack: UITableView!
    
    @IBOutlet weak var addBack: UIBarButtonItem!
    
    @IBOutlet weak var lightBack: UIBarButtonItem!
    
    var textField = UITextField()
    
    var queryresult: [[String : Any]]? = nil

    var style = 0
    func data(){
        let sqlite = SQliteManager.sharedInstance
        if !sqlite.openDB() { return }
        queryresult = MySql().getAllNotes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data()
        tableView.rowHeight = 80
    }
    
    
    @IBAction func toHome(_ sender: Any) {
        let mainBoard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
        let VCMain = mainBoard!.instantiateViewController(withIdentifier: "vcMain")
        UIApplication.shared.windows[0].rootViewController = VCMain
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queryresult?.count ?? 0
    }
    
    func getColor() -> UIColor {
        switch style {
        case 0:
            return FlatRed()
        case 1:
            return FlatOrange()
        case 2:
            return FlatYellow()
        case 3:
            return FlatSand()
        case 4:
            return FlatSkyBlue()
        case 5:
            return FlatGreen()
        case 6:
            return FlatMint()
        case 7:
            return FlatWhite()
        case 8:
            return FlatPurple()
        case 9:
            return FlatWatermelon()
        case 10:
            return FlatLime()
        case 11:
            return FlatPink()
        case 12:
            return FlatPowderBlue()
        default:
            return FlatPowderBlue()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timelineCell", for: indexPath) as! SwipeTableViewCell
        let cellContent = String(data: queryresult?[indexPath.row]["content"] as! Data, encoding: String.Encoding.utf8)!
        cell.textLabel?.text = cellContent
        cell.backgroundColor = getColor().darken(byPercentage: CGFloat(indexPath.row) / CGFloat(queryresult!.count))
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        cell.delegate = self
        return cell
    }
    
    

    @IBAction func changeStyle(_ sender: UIBarButtonItem) {
        style = (style + 1) % 13
        self.data()
        self.tableView.reloadData()
    }
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "加入随手记", message: "", preferredStyle: .alert)
        let alertAction2 = UIAlertAction(title: "取消", style: .default, handler: nil)
        let color = UIColor.randomFlat().hexValue()
        let action = UIAlertAction(title: "确定", style: .default) { (action) in
            //Test.AddTimelineItem(content: textField.text!, color: color)
            MySql().AddNewNote(content: textField.text!, color: color)
            self.data()
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "（随手记与dream不互通）"
            textField = alertTextField
        }
        alert.addAction(action)
        alert.addAction(alertAction2)
        present(alert, animated: true, completion: nil)
    }
}


// MARK: - swipe cell delegate methods
extension TimeLineViewController: SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else {
            return nil
        }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            print("选中列：\(indexPath.row)")
            // 不能选择提示行
            //Test.DeleteTimelineItem(time: self.dateArray[indexPath.row])
            let id = self.queryresult![indexPath.row]["id"] as! Int
            MySql().deleteNote(id: id)
            self.data()
            self.tableView.reloadData()
            tableView.reloadData()
            print("Item Deleted")
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        
        return [deleteAction]
    }
    
}
