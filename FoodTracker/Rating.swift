//
//  Rating.swift
//  FoodTracker
//
//  Created by Karen Kurpershoek on 2/1/18.
//  Copyright © 2018 Karen Kurpershoek. All rights reserved.
//

import UIKit

@IBDesignable class Rating: UIStackView {
    
//Mark: Properties
    
    private var ratingButtons = [UIButton]()
    
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    
    //define size of button and number of buttons
    //didSet functions adds new buttons using defined size/count
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setUpButtons()
        }
    }
    
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setUpButtons()
        }
    }
    
//Mark: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButtons()
        
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setUpButtons()
    }
    
//Mark: Button Actions
    
    func ratingButtonTapped(button: UIButton) {
        
        //finds the selected button in the array of buttons are returns its index
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        //calculate the rating of the selected buttons
        let selectedRating = index + 1
        
        if selectedRating == rating {
            // if the seletd star represents the current rating, reset the rating to 0.
            rating = 0
        } else {
            // otherwise set the rating to the selected star
            rating = selectedRating
        }
    }
    
//Mark: Private Methods
    
    private func setUpButtons() {
        
        //Clear any existing buttons
        
        for button in ratingButtons {
            //removes each button from list of views
            removeArrangedSubview(button)
            //removes button from stach view entirely
            button.removeFromSuperview()
        }
        
        //clears the ratingButtons array
        ratingButtons.removeAll()
        
        //Load button images
        
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        for index in 0..<starCount {
            
            //Create the button
            //keyword let defines button as a constant
        
            let button = UIButton()
            
            //Set the button images
            //use empty star image for normal state
            button.setImage(emptyStar, for: .normal)
            //use filled star for selected state
            button.setImage(filledStar, for: .selected)
            //use highlighted star for selected and highlighted state
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
        
            //Add Constraints
        
            button.translatesAutoresizingMaskIntoConstraints = false //disables automatically generated constraints
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            //set the accessibility label
            button.accessibilityLabel = "Set \(index + 1) star rating"
    
            //set up button action
        
            button.addTarget(self, action: #selector(Rating.ratingButtonTapped(button:)), for: .touchUpInside)
        
            //add button to stack
            
            addArrangedSubview(button) //adds button to list of views
            
            ratingButtons.append(button)
            
        }
        
        updateButtonSelectionStates()
        
    }
    
    private func updateButtonSelectionStates() {
        //iterates through buttons and sets each state based on its position and the rating
        for (index, button) in ratingButtons.enumerated() {
            
            // if the index of a button is less than the rating, that button should be selected
            button.isSelected = index < rating
            
            //set the hint string for the currently selected star
            let hintString: String?
            if rating == index + 1 {
                hintString = "Tap to reset teh rating to zero."
            } else {
                hintString = nil
            }
            
            //calculate the string value
            let valueString: String
            switch (rating) {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(rating) stars set."
            }
            
            //assign the hint string and value string
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }

}
