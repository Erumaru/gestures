//
//  ViewController.swift
//  Gestures
//
//  Created by erumaru on 10/9/19.
//  Copyright © 2019 KBTU. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    // MARK: - Constants
    let initialSize = CGSize(width: 100, height: 100)
    
    // MARK: - Outlets
    lazy var newView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        
//        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapHappened(_:)))
//        view.addGestureRecognizer(gestureRecognizer)
        
        let panGestureRec = UIPanGestureRecognizer(target: self, action: #selector(panRecognized(_:)))
        view.addGestureRecognizer(panGestureRec)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapRec))
        doubleTapRecognizer.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapRecognizer)
        
        return view
    }()
    
    // MARK: - Actions
    @objc private func doubleTapRec() {
        newView.backgroundColor = .random
        
        UIView.animateKeyframes(withDuration: 2, delay: 0, options: [.autoreverse], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                self.newView.frame.size = CGSize(width: self.initialSize.width * 1.5, height: self.initialSize.height * 1.5)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                self.newView.transform = CGAffineTransform(rotationAngle: .pi)
            }
            
        }) { finished in
            self.newView.transform = .identity
        }
    }
    
    @objc private func tapHappened(_ gestureRecognizer: UITapGestureRecognizer) {
        let currentSize = newView.frame.size
        newView.snp.updateConstraints() {
            $0.size.equalTo(CGSize(width: currentSize.width * 1.5, height: currentSize.height * 1.5))
        }
        
        UIView.animate(withDuration: 1) {
            self.newView.backgroundColor = .random
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func panRecognized(_ panRecognizer: UIPanGestureRecognizer) {
        let translation = panRecognizer.translation(in: newView)
        switch panRecognizer.state {
        case .began:
            print("began")
        case .changed:
            newView.snp.updateConstraints() {
                $0.centerY.equalToSuperview().offset(translation.y)
                $0.centerX.equalToSuperview().offset(translation.x)
            }
        case .ended:
            newView.snp.updateConstraints() {
                $0.centerX.equalToSuperview()
                $0.centerY.equalToSuperview()
            }
            
            UIView.animate(withDuration: 1) {
                self.view.layoutIfNeeded()
            }
        default: break
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        markup()
    }
    
    // MARK: - Markup
    private func markup() {
        view.backgroundColor = .random
        view.addSubview(newView)
        
        newView.snp.makeConstraints() {
            $0.size.equalTo(initialSize)
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1), alpha: 1)
    }
}

