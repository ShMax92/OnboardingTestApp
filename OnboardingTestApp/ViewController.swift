//
//  ViewController.swift
//  OnboardingTestApp
//
//  Created by Maxim Shirko on 24.09.2018.
//  Copyright © 2018 com.MaximShirko. All rights reserved.
//

import UIKit
import QuartzCore

fileprivate let firstString = "Welcome! Here is the first step!"
fileprivate let secondString = "Nice! You are on the second step!"
fileprivate let thirdString = "You are close to using the App"


class ViewController: UIViewController {
    
    @IBOutlet weak var continueOrCloseButton: UIButton!
    lazy var onboardingStep = 1
    
    override func viewDidLoad() {
        
        //check if user saw onboarding then
        stepSwitching()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //check if user saw onboarding then
        AppDelegate.AppUtility.lockOrientation(.portrait)
    }
    
    private func stepSwitching() {
        switch onboardingStep {
        case 1:
            createViewFor(onboardingStep: 3)
            createViewFor(onboardingStep: 2)
            createViewFor(onboardingStep: 1)
        case 2:
            if let view = self.view.subviews.last {
                self.animation(view: view)
        }
        case 3:
            if let view = self.view.subviews.last {
                self.animation(view: view)
            }
            self.continueOrCloseButton.setTitle("Close", for: .normal)
        case 4:
            if let view = self.view.subviews.last {
                self.animation(view: view)
            }
            AppDelegate.AppUtility.lockOrientation(.all)
            
        default:
            break
        }
    }
    
    private func createViewFor (onboardingStep: Int) {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeLeft))
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.right
        
        let topConstant = CGFloat(10 * onboardingStep + 100)
        let bottonConstant = CGFloat(-100 + 10 * onboardingStep)
        let leftConstant = CGFloat(10 * onboardingStep + 15)
        let rect = CGRect(origin: CGPoint.zero, size: CGSize.zero)
        let view = UIView(frame: rect)
        view.restorationIdentifier = "onboardingView\(onboardingStep)"
        view.backgroundColor = UIColor.white
        addContentFor(onboardingStep: onboardingStep, to: view)
        self.view.addSubview(view)
        
        //constraints
        view.translatesAutoresizingMaskIntoConstraints = false
        //top
        let topConstraint = view.topAnchor.constraint(equalTo: self.view.topAnchor,
                                  constant: topConstant)
        topConstraint.identifier = "topConstraint"
        topConstraint.isActive = true
        //bottom
        let bottomConstraint = view.bottomAnchor.constraint(equalTo: self.continueOrCloseButton.topAnchor,
                                                      constant: bottonConstant)
        bottomConstraint.identifier = "bottomConstraint"
        bottomConstraint.isActive = true
        //leading
        let leadingConstraint = view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                      constant: leftConstant)
        leadingConstraint.identifier = "leadingConstraint"
        leadingConstraint.isActive = true
        //trailing
        let trailingConstraint = view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
                                                            constant: -leftConstant)
        trailingConstraint.identifier = "trailingConstraint"
        trailingConstraint.isActive = true
        
        //shadow
        view.layer.masksToBounds = false;
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowRadius = 5;
        view.layer.shadowOpacity = 0.5;
        //swipe left
        view.addGestureRecognizer(leftSwipe)
    }

    private func addContentFor (onboardingStep: Int, to view: UIView) {
        let stackView = UIStackView(frame: CGRect(origin: CGPoint.zero, size: CGSize.zero))
        stackView.contentMode = .center
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        view.addSubview(stackView)
        //constraints
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        //image
        let image = UIImage(named: "Image\(onboardingStep)")
        if let image = image {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            stackView.addArrangedSubview(imageView)
        }
        //text
        let textLabel = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize.zero))
        switch onboardingStep {
        case 1:
            textLabel.text = firstString
        case 2:
            textLabel.text = secondString
        case 3:
            textLabel.text = thirdString
        default:
            break
        }
        textLabel.textColor = UIColor.black
        textLabel.numberOfLines = 8
        textLabel.font = textLabel.font.withSize(20)
        textLabel.textAlignment = .center
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.minimumScaleFactor = 0.4
        
        stackView.addArrangedSubview(textLabel)
    }
    
    private func animation (view: UIView) {
        UIView.animate(withDuration: 0.5, animations: {
            view.transform = CGAffineTransform(translationX: 400, y: -40)
            if (self.onboardingStep == 4) {
                self.view.backgroundColor = UIColor.white
                self.continueOrCloseButton.transform = CGAffineTransform(translationX: 0, y: 100)
            }
        }) { (_) in
            //removing views
            view.removeFromSuperview()
            if (self.onboardingStep == 4) {
                self.continueOrCloseButton.removeFromSuperview()
            }
            //updating constraints
            for constriant in self.view.constraints {
                if (constriant.identifier == "bottomConstraint" ||
                    constriant.identifier == "topConstraint" ||
                    constriant.identifier == "leadingConstraint") {
                    constriant.constant = constriant.constant - 10
                } else if (constriant.identifier == "trailingConstraint") {
                    constriant.constant = constriant.constant + 10
                }
            }
        }
    }

    @IBAction func continueOrCloseButtonPressed(_ sender: Any) {
        self.onboardingStep += 1
        stepSwitching()

    }
    
    @objc func swipeLeft () {
        self.onboardingStep += 1
        stepSwitching()
    }
}

