//
//  ViewController.swift
//  scrollingMonths
//
//  Created by Jawaher Alagel on 8/30/20.
//  Copyright © 2020 Jawaher Alaggl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let arrayNumber: [Double] = [1000, 900, 800]
    let arrayColour = [UIColor(hex: "#F4B277"), UIColor(hex: "#6787BB"), UIColor(hex: "#6CA777")]
    
    let textCollection: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul",
                                    "Aug", "Sep", "Oct", "Nov", "Dec"]
    private var numberOfItem: Int = 1000
    var currentX: CGFloat = 0.0
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hex: "#1F2633")
        collectionView.backgroundColor = UIColor(hex: "#1F2633")
        
        
        // total amount (sum)
        let sum = Double(3000)
        let percantage = arrayNumber.map{($0/sum) * 100}
        var data = Array(zip(arrayColour, percantage))
        let validPercentage = percantage.reduce(0,+)
        
        if validPercentage < 100 {
            let emptyPercentage = 100 - validPercentage
            data.append((UIColor.clear, emptyPercentage))
        }
        
        shape(totalPercentage: 100, array: data)
        
        track()
        
        
        // collectionView Part
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
        
        collectionView.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    func shape(totalPercentage: Double, array: [(color: UIColor?, subpercentage: Double)]) {
        
        let startAngle = -CGFloat.pi / 4
        let totalLength = CGFloat.pi * 2 * CGFloat(totalPercentage) * 0.01
        var minusLength: CGFloat = 0.0
        var counter = 0
        
        for (color, subpercentage) in array.reversed() {
            let endAngle = startAngle + totalLength - minusLength
            minusLength += (totalLength * CGFloat(subpercentage) * 0.01)
            draw(startAngle: startAngle, endAngle: endAngle, color: color ?? .black)
            
            // to get square edge
            if counter != 1 {
                draw2(startAngle: (startAngle + endAngle)/2, endAngle: endAngle, color: color ?? .black)
            }
            counter += 1
        }
    }
    
    
    func draw(startAngle: CGFloat, endAngle: CGFloat, color: UIColor) {
        
        let shapeLayer = CAShapeLayer()
        let center = view.center
        
        let circlePath = UIBezierPath(arcCenter: center, radius: 100, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        shapeLayer.path = circlePath.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 15
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        view.layer.addSublayer(shapeLayer)
        
    }
    
    func draw2(startAngle: CGFloat, endAngle: CGFloat, color: UIColor) {
        
        let shapeLayer = CAShapeLayer()
        let center = view.center
        
        let circlePath = UIBezierPath(arcCenter: center, radius: 100, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        shapeLayer.path = circlePath.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 15
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.square
        
        view.layer.addSublayer(shapeLayer)
    }
    
    
    func track() {
        
        let trackLayer = CAShapeLayer()
        
        let circlePath = UIBezierPath(arcCenter: view.center, radius: 100, startAngle: -CGFloat.pi/2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        trackLayer.path = circlePath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
        trackLayer.lineWidth = 15
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        
        view.layer.addSublayer(trackLayer)
    }
    
}



extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.item)")
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        // Increase font size
        let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell
        cell?.textLabel.font = UIFont.boldSystemFont(ofSize: 30.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // Normal font size
        let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell
        cell?.textLabel.font = UIFont.systemFont(ofSize: 20.0)
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItem
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        
        cell.configure(with: textCollection[indexPath.row % textCollection.count])
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        var offset = collectionView.contentOffset
        let width = collectionView.contentSize.width
        if offset.x < width/4 {
            offset.x += width/2
            collectionView.setContentOffset(offset, animated: false)
        } else if offset.x > width/4 * 3 {
            offset.x -= width/2
            collectionView.setContentOffset(offset, animated: false)
        }
    }
    
}
