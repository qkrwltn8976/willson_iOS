//
//  AskerList2_FeelViewController.swift
//  Willson
//
//  Created by JHKim on 01/07/2019.
//  Copyright © 2019 JaehuiKim. All rights reserved.
//

import UIKit

class AskerList2_FeelViewController: UIViewController {
    
    // MARK: - properties
    let feelCollectionViewCellIdentifier: String = "FeelCollectionViewCell"
    
    var concernFeeling: ConcernFeeling?
    var concernFeelingData: ConcernFeelingData?
    
    // Concern Question Post
    var categoryListIdx: Int = 0
    
    // MARK: - IBOutlet
    @IBOutlet weak var feelCollectionView: UICollectionView!
    
    // MARK: - IBAction
    @IBAction func tappedCancelBarButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFeeling()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // UICollectionView delegate, datasource
        feelCollectionView.delegate = self
        feelCollectionView.dataSource = self
    }
    // MARK: - Methods
    
    func getFeeling() {
        ConcernFeelingService.shared.getFeeling() {
            concernFeeling, statusCode in
            switch statusCode {
            case 200:
                self.concernFeeling = concernFeeling
                self.concernFeelingData = self.concernFeeling?.data
                break;
            default:
                break;
            }
        }
    }
}

extension AskerList2_FeelViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = UIStoryboard(name: "AskerList", bundle: nil).instantiateViewController(withIdentifier: "AskerList3_ImpactViewController") as? AskerList3_ImpactViewController else { return }
        
        vc.categoryListIdx = self.categoryListIdx
        vc.feelingArray.append(concernFeelingData?.feelingList[indexPath.item].feelingIdx ?? 0)
    }
}

extension AskerList2_FeelViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (concernFeelingData?.feelingList.count) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: FeelCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: feelCollectionViewCellIdentifier, for: indexPath) as? FeelCollectionViewCell else { return UICollectionViewCell() }
        
        if let label = cell.feelLabel {
            label.text = "#\(concernFeelingData?.feelingList[indexPath.item].feelingName ?? "")"
        }
        
        cell.feelLabel.sizeToFit()
        cell.view.sizeToFit()
        
        return cell
    }
}

extension AskerList2_FeelViewController: UICollectionViewDelegateFlowLayout {
    
}
