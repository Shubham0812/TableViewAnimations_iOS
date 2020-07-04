//
//  ViewController.swift
//  TableAnimations
//
//  Created by Shubham Singh on 04/07/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK:- outlets for the viewController
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    // MARK:- variables for the viewController
    var colors = [UIColor.systemRed, UIColor.systemBlue, UIColor.systemOrange,
                  UIColor.systemPurple,UIColor.systemGreen]
    var tableViewHeaderText = ""
    
    /// an enum of type TableAnimation - determines the animation to be applied to the tableViewCells
    var currentTableAnimation: TableAnimation = .fadeIn(duration: 0.85, delay: 0.03) {
        didSet {
            self.tableViewHeaderText = currentTableAnimation.getTitle()
        }
    }
    var animationDuration: TimeInterval = 0.85
    var delay: TimeInterval = 0.05
    var fontSize: CGFloat = 26
    
    // MARK:- lifecycle methods for the ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        self.colors.append(contentsOf: colors.shuffled())
        
        // registering the tableView
        self.tableView.register(UINib(nibName: TableAnimationViewCell.description(), bundle: nil), forCellReuseIdentifier: TableAnimationViewCell.description())
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.isHidden = true
        
        // set the separatorStyle to none and set the Title for the tableView
        self.tableView.separatorStyle = .none
        self.tableViewHeaderText = self.currentTableAnimation.getTitle()
        
        // set the button1 as selected and reload the data of the tableView to see the animation
        button1.setImage(UIImage(systemName: "1.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: fontSize, weight: .semibold, scale: .large)), for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
    // delegate functions for the tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TableAnimationViewCell().tableViewHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TableAnimationViewCell.description(), for: indexPath) as? TableAnimationViewCell {
            cell.color = colors[indexPath.row]
            return cell
        }
        fatalError()
    }
    
    // for displaying the headerTitle for the tableView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 42))
        headerView.backgroundColor = UIColor.systemBackground
        
        let label = UILabel()
        label.frame = CGRect(x: 24, y: 12, width: self.view.frame.width, height: 42)
        label.text = tableViewHeaderText
        label.textColor = UIColor.label
        label.font = UIFont.systemFont(ofSize: 26, weight: .medium)
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 72
    }
    
    //
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // fetch the animation from the TableAnimation enum and initialze the TableViewAnimator class
        let animation = currentTableAnimation.getAnimation()
        let animator = TableViewAnimator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
    }
    
    
    // MARK:- outlet functions for the viewController
    @IBAction func animationButtonPressed(_ sender: Any) {
        guard let senderButton = sender as? UIButton else { return }
        
        /// set the buttons symbol to the default unselected circle
        button1.setImage(UIImage(systemName: "1.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: fontSize, weight: .semibold, scale: .large)), for: .normal)
        button2.setImage(UIImage(systemName: "2.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: fontSize, weight: .semibold, scale: .large)), for: .normal)
        button3.setImage(UIImage(systemName: "3.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: fontSize, weight: .semibold, scale: .large)), for: .normal)
        button4.setImage(UIImage(systemName: "4.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: fontSize, weight: .semibold, scale: .large)), for: .normal)
        
        /// based on the tag of the button, set the symbol of the associated button to show it's selected and set the currentTableAnimation.
        switch senderButton.tag {
        case 1: senderButton.setImage(UIImage(systemName: "1.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: fontSize, weight: .semibold, scale: .large)), for: .normal)
        currentTableAnimation = TableAnimation.fadeIn(duration: animationDuration, delay: delay)
        case 2: senderButton.setImage(UIImage(systemName: "2.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: fontSize, weight: .semibold, scale: .large)), for: .normal)
        currentTableAnimation = TableAnimation.moveUp(rowHeight: TableAnimationViewCell().tableViewHeight, duration: animationDuration, delay: delay)
        case 3: senderButton.setImage(UIImage(systemName: "3.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: fontSize, weight: .semibold, scale: .large)), for: .normal)
        currentTableAnimation = TableAnimation.moveUpWithFade(rowHeight: TableAnimationViewCell().tableViewHeight, duration: animationDuration, delay: delay)
        case 4: senderButton.setImage(UIImage(systemName: "4.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: fontSize, weight: .semibold, scale: .large)), for: .normal)
        currentTableAnimation = TableAnimation.moveUpBounce(rowHeight: TableAnimationViewCell().tableViewHeight, duration: animationDuration + 0.2, delay: delay)
        default: break
        }
        
        /// reloading the tableView to see the animation
        self.tableView.reloadData()
    }
}

