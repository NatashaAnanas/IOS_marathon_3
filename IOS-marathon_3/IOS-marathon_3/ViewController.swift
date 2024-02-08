//
//  ViewController.swift
//  IOS-marathon_3
//
//  Created by Наталья Коновалова on 07.02.2024.
//

import UIKit

final class ViewController: UIViewController {
    
    private let squareView: UIView = {
        let view = UIView()
        view.backgroundColor = .magenta
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let slider: UISlider = {
        let slider = UISlider()
        slider.tintColor = .magenta
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private var viewPropertyAnimator = UIViewPropertyAnimator()
    private var squareViewLeadingAnchor: NSLayoutConstraint?
    private var squareViewTrailingAnchor: NSLayoutConstraint?

    /// Размеры фигуры
    private let shapeSize = (width: 80, height: 80)
    /// Вертикальный отступ между view
    private lazy var space = (shapeSize.height / 2)
    /// Коэффициент увеличения сторон
    private lazy var scaledBy = (x: 1.5, y: 1.5)
    /// Считаем отступ для увеличенной фигуры (Формула работает только для квадратов)
    private lazy var trailingSpace: Double = (Double(shapeSize.width) * scaledBy.x - Double(shapeSize.width)) / 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
    }
    
    private func setupInitialState() {
        addActions()
        addSubviews()
        setupConstraints()
        setupViewPropertyAnimator()
    }
    
    private func addActions() {
        slider.addTarget(self, action: #selector(valueChangedAction), for: .valueChanged)
        slider.addTarget(self, action: #selector(lastTouchAction), for: .touchUpInside)
    }
    
    private func addSubviews() {
        view.addSubviews(squareView, slider)
    }
    
    private func setupViewPropertyAnimator() {
        viewPropertyAnimator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut, animations: {
            self.slider.tintColor = .systemPurple
            self.squareView.backgroundColor = .systemPurple
            self.squareView.transform = CGAffineTransform(rotationAngle: .pi / 2)
            self.squareView.transform = self.squareView.transform.scaledBy(x: self.scaledBy.x, y: self.scaledBy.y)
            self.setupLeadingTrailinglConstraints(ignoreTrailingAnchor: false)
            self.view.layoutIfNeeded()
        })
    }
    
    private func setupLeadingTrailinglConstraints(ignoreTrailingAnchor isActive: Bool = true) {
        self.squareViewLeadingAnchor?.isActive = isActive
        self.squareViewTrailingAnchor?.isActive = !isActive
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            squareView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: CGFloat(space)),
            squareView.heightAnchor.constraint(equalToConstant: CGFloat(shapeSize.height)),
            squareView.widthAnchor.constraint(equalToConstant: CGFloat(shapeSize.width)),
            slider.topAnchor.constraint(equalTo: squareView.bottomAnchor, constant: CGFloat(space)),
            slider.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
        
        squareViewTrailingAnchor = squareView.trailingAnchor
            .constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -CGFloat(trailingSpace))
        
        squareViewLeadingAnchor = squareView.leadingAnchor
            .constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
        
            setupLeadingTrailinglConstraints()
    }
    
    @objc private func valueChangedAction(sender: UISlider) {
        viewPropertyAnimator.pausesOnCompletion = true
        viewPropertyAnimator.fractionComplete = CGFloat(sender.value)
    }
    
    @objc private func lastTouchAction(sender: UISlider) {
        sender.setValue(sender.maximumValue, animated: true)
        viewPropertyAnimator.continueAnimation(withTimingParameters: .none, durationFactor: 0)
    }
}
