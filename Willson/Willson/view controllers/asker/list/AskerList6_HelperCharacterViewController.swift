//
//  AskerList6_HelperCharacterViewController.swift
//  Willson
//
//  Created by JHKim on 04/07/2019.
//  Copyright © 2019 JaehuiKim. All rights reserved.
//

import UIKit
import Toast_Swift

class AskerList6_HelperCharacterViewController: UIViewController {
    
    // MARK: - properties
    let characterCollectionViewCellIdentifier: String = "FeelCollectionViewCell"
    
    var concernPersonality: ConcernPersonality?
    var concernPersonalityData: ConcernPersonalityData?
    
    var SelectedIndex = [IndexPath]()
    var SelectedData = [String]()
    var cnt = 0
    //let characterArray = ["#신중한", "#호의적인", "#경쟁심있는", "#절제하는", "#열정적인", "#상냥한", "#단호한", "#내향적인", "#사교적인", "#충동적인", "#변덕스러운", "#독립적인", "#고집있는", "#모험적인", "#분석적인", "#주저하는", "#낙천적인", "#감성적인", "#대담한", "#우유부단한", "#솔직한" ,"#이끌어가는"]
    //var tabCnt: Int = 0
    
    // Concern Question Post
    var categoryListIdx: Int = 0
    var feelingArray: [Int] = []
    var weight: Int = 0
    var content: String = ""
    var gender: String = ""
    
    // MARK: - IBOutlet
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var characterCollectionView: UICollectionView!
    
    // MARK: - IBAction
    @IBAction func tappedCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        getPersonality()
        // UICollectionView delegate, datasource
        
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        //self.addGestureRecognizer(tapGesture)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        characterCollectionView.delegate = self
        characterCollectionView.dataSource = self
        
        characterCollectionView.reloadData()
    }
    
    func getPersonality() {
        ConcernPersonalityService.shared.getPersonality() {
            concernPersonality, statusCode in
            switch statusCode {
            case 200:
                self.concernPersonality = concernPersonality
                self.concernPersonalityData = self.concernPersonality?.data
                break;
            default:
                break;
            }
        }
    }
}

extension AskerList6_HelperCharacterViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        /*if collectionView.cellForItem(at: indexPath)?.isSelected ?? false {
            collectionView.deselectItem(at: indexPath, animated: true)
            tabCnt = tabCnt - 1
            print(tabCnt)
            return false
        }
        tabCnt = tabCnt + 1
        print(tabCnt)
        return true*/
        if let selectedItems = collectionView.indexPathsForSelectedItems {
            if selectedItems.contains(indexPath) {
                collectionView.deselectItem(at: indexPath, animated: true)
                return false
            }
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell: FeelCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: characterCollectionViewCellIdentifier, for: indexPath) as? FeelCollectionViewCell else { return }
        cell.view.backgroundColor = #colorLiteral(red: 0.3215686275, green: 0.3215686275, blue: 0.631372549, alpha: 1)
        cell.feelLabel.textColor = UIColor.white
        
        guard let vc = UIStoryboard(name: "AskerList", bundle: nil).instantiateViewController(withIdentifier: "AskerList7_HelperExperienceViewController") as? AskerList7_HelperExperienceViewController else { return }
        vc.categoryListIdx = self.categoryListIdx
        vc.feelingArray = self.feelingArray
        vc.weight = self.weight
        vc.content = self.content
        vc.gender = self.gender
        vc.personalityArray.append(concernPersonalityData?.personalityList[indexPath.item].personalityIdx ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
         guard let cell: FeelCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: characterCollectionViewCellIdentifier, for: indexPath) as? FeelCollectionViewCell else { return }
        cell.view.backgroundColor = UIColor.white
        cell.feelLabel.textColor = #colorLiteral(red: 0.3215686275, green: 0.3215686275, blue: 0.631372549, alpha: 1)
        
        print("You selected cell #\(indexPath.item)!")
        
      
        if SelectedIndex.contains(indexPath) {
            SelectedIndex = SelectedIndex.filter { $0 != indexPath }
            cnt = cnt-1
        }
        else {
            SelectedIndex.append(indexPath)
            //SelectedData.append(Data)
            cnt = cnt+1
        }
        if(cnt>3){
            nextBtn.backgroundColor = #colorLiteral(red: 0.6196078431, green: 0.6196078431, blue: 0.6196078431, alpha: 1)
            nextBtn.isEnabled = false
        } else {
            nextBtn.isEnabled = true
        }
        
        collectionView.reloadData()
    }
    
}

extension AskerList6_HelperCharacterViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (concernPersonalityData?.personalityList.count) ?? 0 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: FeelCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: characterCollectionViewCellIdentifier, for: indexPath) as? FeelCollectionViewCell else { return UICollectionViewCell() }
        if let label = cell.feelLabel {
            label.text = "#\(concernPersonalityData?.personalityList[indexPath.item].personalityName ?? "")"
        }
        
        
        //셀의 너비를 데이터의 크기에 따라 유동적 변경
        cell.feelLabel.sizeToFit()
        cell.view.sizeToFit()
        
        return cell
    }
}

extension AskerList6_HelperCharacterViewController: UICollectionViewDelegateFlowLayout {
    
}
