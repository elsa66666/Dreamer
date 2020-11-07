//
//  AllDiariesViewController.swift
//  dreamer1
//
//  Created by Elsa on 2020/8/28.
//  Copyright © 2020 为所欲为. All rights reserved.
//

import UIKit
import OHMySQL
class AllDiariesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var selectedDream: UINavigationItem!
    
    var response: [[String : AnyObject]]? = []
    var connectTitle: String?
    let userName = Test.userD.LoginUserName()
    var ghostName = Diary.ghostName
    var id: [Int]?
    var favor:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectTitle = dreamToAllDiaries.dreamName
        ghostName = dreamToAllDiaries.dreamName
        favor = dreamToAllDiaries.dreamFavor
        trashButton.image = UIImage(systemName: "trash")
        selectedDream.title = connectTitle
        Diary.ghostName = connectTitle!
               
        response = Diary.getDB()
    }
    
    @IBAction func toHome(_ sender: UIBarButtonItem) {
        let mainBoard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
        let VCMain = mainBoard!.instantiateViewController(withIdentifier: "vcMain")
        UIApplication.shared.windows[0].rootViewController = VCMain
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return response!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        id = Diary.getpicID(name: ghostName)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "screenshot", for: indexPath) as! PhotoCell
        cell.imageView.image = Diary.LoadImage(id: id![indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if trashButton.image == UIImage(systemName: "trash"){
               //let userName = Test.LoginUserName()
            //let words = response![indexPath.row]["words"] as! String
            //let style = response![indexPath.row]["style"] as! String

            Diary.ghostName = response![indexPath.row]["ghostName"] as! String
               //Diary.query = Test.userD.getSpeDiary(userName: userName, ghostName: Diary.ghostName, words: words, style: style)
               Diary.new = false
            performSegue(withIdentifier: "toWriteDiary", sender: self)
        }else{
            let did = (response![indexPath.row]["id"] as? Int)!
            Test.userD.deleteARow(id: did)
            reloadView()
            collectionView.deleteItems(at: [indexPath])
            let time: TimeInterval = 0.5
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                let mainBoard:UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
                let VCMain = mainBoard!.instantiateViewController(withIdentifier: "vcMain")
                UIApplication.shared.windows[0].rootViewController = VCMain
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWriteDiary" {
            let destination = segue.destination as! DiaryViewController
            destination.ghostName = ghostName
            destination.ghostFavorability = favor!
        }
    }
    
    func reloadView(){
        id = []
        response = []

        //response = Test.userD.reload(userName: userName, ghostName: ghostName)
        id = Test.userD.getpicID(name: ghostName)
    }
    

    @IBOutlet weak var trashButton: UIBarButtonItem!
    @IBAction func toDelete(_ sender: Any) {
        if trashButton.image == UIImage(systemName: "trash"){
            trashButton.image = UIImage(systemName: "trash.fill")
        }else{
            trashButton.image = UIImage(systemName: "trash")
        }
    }
}
