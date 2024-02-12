//  RefractometerDisplay.swift

import UIKit

fileprivate let displayHeight: CGFloat = 180.0

class RefractometerDisplay: ReadableWidthView {
    private let vLT = ValueDisplay()
    private let vLB = ValueDisplay()
    private let vMT = ValueDisplay()
    private let vMB = ValueDisplay()
    private let vRT = ValueDisplay()
    private let vRB = ValueDisplay()

    init() {
        super.init(frame: .zero)
        setup()
        registerForUpdateNotifications()
        update()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: FormulaInput.noIntrinsicMetric, height: displayHeight)
    }
}


// MARK: - Content Updates

extension RefractometerDisplay {
    private func registerForUpdateNotifications() {
        let notification = Settings.updateNotification
        let main = OperationQueue.main
        NotificationCenter.default.addObserver(forName: notification, object: nil, queue: main) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.update()
            }
        }
    }

    func update() {
        switch Settings.shared.displayScheme {
        case .Modern:
            vLT.setLabel("Original Gravity".localized)
            vLT.setValue(RefractometerModel.originalExtract, formattedWith: Formatter.plato, accessibilityFormatter: Formatter.accessiblePlato)

            vLB.setLabel("Final Gravity".localized)
            vLB.setValue(RefractometerModel.apparentExtract, formattedWith: Formatter.plato, accessibilityFormatter: Formatter.accessiblePlato)

            vMT.setLabel("Original Gravity".localized)
            vMT.setValue(RefractometerModel.originalGravity, formattedWith: Formatter.SG)

            vMB.setLabel("Final Gravity".localized)
            vMB.setValue(RefractometerModel.apparentGravity, formattedWith: Formatter.SG)

            vRT.setLabel("Attenuation".localized)
            vRT.setValue(RefractometerModel.apparentAttenuation, formattedWith: Formatter.attenuation)

            vRB.setLabel("Alcohol %vol".localized)
            vRB.setValue(RefractometerModel.alcohol, formattedWith: Formatter.abv)

        case .ClassicPlato:
            vLT.setLabel("Original Gravity".localized)
            vLT.setValue(RefractometerModel.originalExtract, formattedWith: Formatter.plato, accessibilityFormatter: Formatter.accessiblePlato)

            vLB.setLabel("Alcohol %vol".localized)
            vLB.setValue(RefractometerModel.alcohol, formattedWith: Formatter.abv)

            vMT.setLabel("Final Gravity".localized)
            vMT.setValue(RefractometerModel.apparentExtract, formattedWith: Formatter.plato, accessibilityFormatter: Formatter.accessiblePlato)

            vMB.setLabel("(actual)".localized)
            vMB.setValue(RefractometerModel.actualExtract, formattedWith: Formatter.plato, accessibilityFormatter: Formatter.accessiblePlato)

            vRT.setLabel("Attenuation".localized)
            vRT.setValue(RefractometerModel.apparentAttenuation, formattedWith: Formatter.attenuation)

            vRB.setLabel("(real)".localized)
            vRB.setValue(RefractometerModel.actualAttenuation, formattedWith: Formatter.attenuation)

        case .ClassicSG:
            vLT.setLabel("Original Gravity".localized)
            vLT.setValue(RefractometerModel.originalGravity, formattedWith: Formatter.SG)

            vLB.setLabel("Alcohol %vol".localized)
            vLB.setValue(RefractometerModel.alcohol, formattedWith: Formatter.abv)

            vMT.setLabel("Final Gravity".localized)
            vMT.setValue(RefractometerModel.apparentGravity, formattedWith: Formatter.SG)

            vMB.setLabel("(actual)".localized)
            vMB.setValue(RefractometerModel.actualGravity, formattedWith: Formatter.SG)

            vRT.setLabel("Attenuation".localized)
            vRT.setValue(RefractometerModel.apparentAttenuation, formattedWith: Formatter.attenuation)

            vRB.setLabel("(real)".localized)
            vRB.setValue(RefractometerModel.actualAttenuation, formattedWith: Formatter.attenuation)
        }
    }
}


// MARK: - View Setup

extension RefractometerDisplay {
    private func setup() {
        backgroundColor = Colors.displayBackground
        setContentHuggingPriority(.defaultHigh+1, for: .vertical)

        let display = wrapRow(wrapColumn(vLT, vLB), wrapColumn(vMT, vMB), wrapColumn(vRT, vRB))
        embedd(readableSubview: display)
    }

    func wrapColumn(_ topView: UIView, _ bottomView: UIView) -> UIView {
        let wrapper = UIView()
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        wrapper.setContentHuggingPriority(.defaultLow, for: .horizontal)
        wrapper.setContentHuggingPriority(.defaultLow, for: .vertical)
        wrapper.backgroundColor = Colors.displayBackground

        var constraints: [NSLayoutConstraint] = [
            bottomView.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor),
            topView.heightAnchor.constraint(equalTo: bottomView.heightAnchor) ]

        let _ = [ topView,
                  SeparatorLine(color: Colors.displaySeparator, direction: .horizontal, size: .small),
                  bottomView ]
            .reduce(wrapper.topAnchor) { anchor, view in
                wrapper.addSubview(view)
                constraints += [
                    view.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor),
                    view.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor),
                    view.topAnchor.constraint(equalTo: anchor)]
                return view.bottomAnchor
            }

        NSLayoutConstraint.activate(constraints)
        return wrapper
    }

    func wrapRow(_ leadingView: UIView, _ midView: UIView, _ trailingView: UIView) -> UIView {
        let wrapper = UIView()
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        wrapper.setContentHuggingPriority(.defaultLow, for: .horizontal)
        wrapper.setContentHuggingPriority(.defaultLow, for: .vertical)
        wrapper.backgroundColor = Colors.displayBackground

        var constraints: [NSLayoutConstraint] = [
            trailingView.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor),
            leadingView.widthAnchor.constraint(equalTo: midView.widthAnchor),
            leadingView.widthAnchor.constraint(equalTo: trailingView.widthAnchor) ]

        let _ = [ leadingView,
                  SeparatorLine(color: Colors.displaySeparator, direction: .vertical, size: .medium),
                  midView,
                  SeparatorLine(color: Colors.displaySeparator, direction: .vertical, size: .medium),
                  trailingView]
            .reduce(wrapper.leadingAnchor) { anchor, view in
                wrapper.addSubview(view)
                constraints += [
                    view.topAnchor.constraint(equalTo: wrapper.topAnchor),
                    view.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor),
                    view.leadingAnchor.constraint(equalTo: anchor)]
                return view.trailingAnchor
            }

        NSLayoutConstraint.activate(constraints)
        return wrapper
    }
}
