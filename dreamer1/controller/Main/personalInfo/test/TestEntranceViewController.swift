//
//  TestEntranceViewController.swift
//  dreamer1
//
//  Created by Elsa on 2020/8/11.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit
class TestEntranceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var fullView: UIView!
    @IBOutlet weak var leftTableView: UITableView!
    @IBOutlet weak var rightTableView: UITableView!
    let leftGName = ["幽灵不屑", "幽灵高兴", "幽灵期待"]
    let rightGName = ["幽灵吐舌头", "幽灵炫酷左", "幽灵抱歉"]


    var favor:[Int]?
    override func viewDidLoad() {
        super.viewDidLoad()
        leftTableView.delegate = self
        rightTableView.delegate = self
        leftTableView.rowHeight = 206
        rightTableView.rowHeight = 206
        leftTableView.register(UINib(nibName: "testGhostCell", bundle: nil), forCellReuseIdentifier: "TGReusableCell")
        rightTableView.register(UINib(nibName: "testGhostCell", bundle: nil), forCellReuseIdentifier: "TGReusableCell")

        fullView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        favor = MySql().getFavorForMentalTest()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == leftTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TGReusableCell", for: indexPath) as! testGhostCell
            cell.ghostImageView.image = UIImage(named: leftGName[indexPath.row])!
            cell.prograssView.progress = Float(favor![indexPath.row * 2]) / Float(200)
            cell.checkButton.tag = (indexPath.row + 1) * 2 - 1
            if cell.prograssView.progress == 1{
                cell.checkButton.addTarget(self, action: #selector(segueToNextView(_:)), for: .touchUpInside)
                cell.checkButton.setImage(UIImage(named: "锁2"), for: .normal)
                cell.checkButton.setImage(UIImage(named: "锁2"), for: .selected)
            }else{
                cell.checkButton.setImage(UIImage(named: "锁1"), for: .normal)
                cell.checkButton.setImage(UIImage(named: "锁1"), for: .selected)
            }

            cell.cellFullView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TGReusableCell", for: indexPath) as! testGhostCell
            cell.ghostImageView.image = UIImage(named: rightGName[indexPath.row])!
            cell.prograssView.progress = Float(favor![(indexPath.row + 1)*2-1]) / Float(200)
            cell.checkButton.tag = (indexPath.row + 1) * 2
            if cell.prograssView.progress == 1{
                cell.checkButton.addTarget(self, action: #selector(segueToNextView(_:)), for: .touchUpInside)
                cell.checkButton.setImage(UIImage(named: "锁2"), for: .normal)
                cell.checkButton.setImage(UIImage(named: "锁2"), for: .selected)
            }else{
                cell.checkButton.setImage(UIImage(named: "锁1"), for: .normal)
                cell.checkButton.setImage(UIImage(named: "锁1"), for: .selected)
            }

            cell.cellFullView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
     
            return cell
        }
    }
    @IBAction func toHome(_ sender: UIBarButtonItem) {
        let mainBoard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
        let VCMain = mainBoard!.instantiateViewController(withIdentifier: "vcMain")
        UIApplication.shared.windows[0].rootViewController = VCMain
    }
    
    @objc func segueToNextView(_ sender: Any) {
        performSegue(withIdentifier: "toTest", sender: sender)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toTest") {
            if let destination = segue.destination as? TestViewController {
               if let button:UIButton = sender as! UIButton? {
                   print(button.tag) //optional
                   destination.whichGhost = button.tag
               }
            }
        }
    }
}
