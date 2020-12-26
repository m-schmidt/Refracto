//  RefractometerController.swift - Toplevel Controller of 'Refractometer' Tab

import UIKit

class RefractometerController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let initialPicker = RefractionInput(alignment: .right, refraction: Settings.shared.initialRefraction)
    private let finalPicker = RefractionInput(alignment: .left, refraction: Settings.shared.finalRefraction)

    private func setup() {
        view.backgroundColor = Colors.displayBackground

        let inputStack = UIStackView()

        let contentStack = UIStackView()
        contentStack.backgroundColor = Colors.displayBackground
        contentStack.alignment = .fill
        contentStack.axis = .vertical
        contentStack.addArrangedSubview(RefractometerDisplay())
        contentStack.addArrangedSubview(FormulaInput(formula: Settings.shared.formula))
        contentStack.addArrangedSubview(SeparatorLine(color: Colors.inputSeparator))
        contentStack.addArrangedSubview(inputStack)
        view.embedd(view: contentStack, layoutGuide: view.safeAreaLayoutGuide)

        inputStack.backgroundColor = Colors.inputSeparator
        inputStack.alignment = .fill
        inputStack.axis = .horizontal
        inputStack.distribution = .fillEqually
        inputStack.spacing = 1
        inputStack.addArrangedSubview(initialPicker)
        inputStack.addArrangedSubview(finalPicker)
    }
}


// MARK: Statusbar Style

extension RefractometerController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return Settings.shared.theme.statusBarStyle
    }
}

// MARK: - Picker Hint Animation

extension RefractometerController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if Settings.shared.isFirstLaunch {
            Settings.shared.isFirstLaunch = false
            animatePickerHint()
        }
    }

    private func animatePickerHint() {
        let initialRefraction = Settings.shared.initialRefraction
        let finalRefraction = Settings.shared.finalRefraction

        view.isUserInteractionEnabled = false
        UIView.animateKeyframes(withDuration: 0.6, delay: 0.3, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) { [weak self] in
                self?.initialPicker.scrollTo(refraction: initialRefraction + 0.2)
                self?.finalPicker.scrollTo(refraction: finalRefraction - 0.2)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) { [weak self] in
                self?.initialPicker.scrollTo(refraction: initialRefraction)
                self?.finalPicker.scrollTo(refraction: finalRefraction)
            }
        }, completion: { [weak self] _ in
            self?.view.isUserInteractionEnabled = true
        })
    }
}
