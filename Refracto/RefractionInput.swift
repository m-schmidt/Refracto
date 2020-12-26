//  RefractometerInput.swift

import UIKit

fileprivate let minRefraction: Int = 0
fileprivate let maxRefraction: Int = 50

fileprivate let needleInset: CGFloat = 2.0

fileprivate let valueFontSize: CGFloat = 26.0
fileprivate let labelFontSize: CGFloat = 12.0

class RefractionInput: UIView, UICollectionViewDelegate {
    let alignment: RefractionPickerAlignment

    var refraction: Double {
        didSet {
            valueLabel.text = Formatter.brix.formattedString(for: refraction)

            let settings = Settings.shared
            if alignment == .right {
                settings.initialRefraction = refraction
            } else {
                settings.finalRefraction = refraction
            }
        }
    }

    private let collectionView: UICollectionView
    private let valueLabel = UILabel()

    private var lastFeedbackOffset: CGFloat = .nan
    private var updateRefractionOnScrollEvents = false

    init(alignment: RefractionPickerAlignment, refraction: Double) {
        self.alignment = alignment
        self.refraction = refraction
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: RefractionInputLayout(alignment: alignment))
        super.init(frame: .zero)
        setup()
        setupAccessibility()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        collectionView.backgroundColor = Colors.inputBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(RefractionInputCell.self, forCellWithReuseIdentifier: RefractionInputCell.identifier)
        collectionView.register(RefractionInputLabel.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RefractionInputLabel.identifier)
        embedd(view:collectionView)

        let needle = RefractionInputNeedle(alignment: alignment)
        needle.translatesAutoresizingMaskIntoConstraints = false
        addSubview(needle)

        let stack = UIStackView()
        stack.backgroundColor = Colors.inputBackground
        stack.alignment = .fill
        stack.axis = .vertical
        stack.spacing = 2
        stack.isUserInteractionEnabled = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        let nameLabel = UILabel()
        nameLabel.text = alignment == .left ? "FG".localized : "OG".localized
        nameLabel.font = UIFont.systemFont(ofSize: labelFontSize, weight: .light)
        nameLabel.textAlignment = .center
        nameLabel.textColor = Colors.inputSecondaryForeground
        nameLabel.backgroundColor = Colors.inputBackground
        nameLabel.isAccessibilityElement = false
        stack.addArrangedSubview(nameLabel)

        valueLabel.text = Formatter.brix.formattedString(for: refraction)
        valueLabel.font = UIFont.systemFont(ofSize: valueFontSize).monospacedDigitFontVariant
        valueLabel.textAlignment = .center
        valueLabel.textColor = Colors.inputForeground
        valueLabel.backgroundColor = Colors.inputBackground
        valueLabel.isAccessibilityElement = false
        stack.addArrangedSubview(valueLabel)

        let unitLabel = UILabel()
        unitLabel.text = "°Brix".localized
        unitLabel.font = UIFont.systemFont(ofSize: labelFontSize, weight: .light)
        unitLabel.textAlignment = .center
        unitLabel.textColor = Colors.inputSecondaryForeground
        unitLabel.backgroundColor = Colors.inputBackground
        unitLabel.isAccessibilityElement = false
        stack.addArrangedSubview(unitLabel)

        var constraints: [NSLayoutConstraint] = [
            needle.topAnchor.constraint(equalTo: collectionView.topAnchor),
            needle.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            stack.centerYAnchor.constraint(equalTo: needle.centerYAnchor) ]

        if alignment == .left {
            constraints += [
                needle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: needleInset),
                stack.leadingAnchor.constraint(equalTo: needle.trailingAnchor) ]

            if UIDevice.current.userInterfaceIdiom == .pad {
                constraints += [
                    stack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
                    stack.widthAnchor.constraint(equalToConstant: 200).with(priority: .defaultLow+1) ]
            } else {
                constraints += [
                    stack.trailingAnchor.constraint(equalTo: trailingAnchor) ]
            }
        } else {
            constraints += [
                needle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -needleInset),
                stack.trailingAnchor.constraint(equalTo: needle.leadingAnchor) ]

            if UIDevice.current.userInterfaceIdiom == .pad {
                constraints += [
                    stack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
                    stack.widthAnchor.constraint(equalToConstant: 200).with(priority: .defaultLow+1) ]
            } else {
                constraints += [
                    stack.leadingAnchor.constraint(equalTo: leadingAnchor) ]
            }
        }

        NSLayoutConstraint.activate(constraints)
    }
}


// MARK: - Layout

extension RefractionInput {
    private func contentInsetsToFit() -> UIEdgeInsets {
        let delta = ceil(self.bounds.height/2 - verticalPickerCellHeight/2)
        return UIEdgeInsets(top: delta, left: 0, bottom: delta, right: 0)
    }

    override func layoutSubviews() {
        self.updateRefractionOnScrollEvents = false

        // trigger relayout of collection view content before call to super
        collectionView.collectionViewLayout.invalidateLayout()
        super.layoutSubviews()

        // scroll to correct value
        let newInsets = contentInsetsToFit()
        let oldOffset = contentOffset(for: indexPath(for: refraction))
        let newOffset = CGPoint(x: oldOffset.x, y: oldOffset.y - newInsets.top)
        collectionView.contentInset = newInsets
        collectionView.contentOffset = newOffset

        self.updateRefractionOnScrollEvents = true
    }

    func scrollTo(refraction newRefraction: Double) {
        updateRefractionOnScrollEvents = false
        collectionView.contentOffset = contentOffset(for: indexPath(for: newRefraction), contentInset: collectionView.contentInset)
        updateRefractionOnScrollEvents = true
    }
}


// MARK: - Helpers for Conversion between IndexPath and Refraction Values

extension RefractionInput {
    func indexPath(for refraction: Double) -> IndexPath {
        let index = maxRefraction*10 - Int(round(refraction * 10.0))
        return IndexPath(row: index % 10, section: index/10)
    }

    func refraction(for indexPath: IndexPath) -> Double {
        let refraction = Double(maxRefraction) - Double(indexPath.section * 10 + indexPath.row) / 10.0
        return min(max(Double(minRefraction), refraction), Double(maxRefraction))
    }
}


// MARK: - Helpers for Conversion between IndexPath and ContentOffset

extension RefractionInput {
    func isOverscroll(for contentOffset: CGPoint, contentInset inset: UIEdgeInsets = .zero) -> Bool {
        let offset = inset.top + contentOffset.y
        let maxOffset = 10 * CGFloat(maxRefraction - minRefraction) * (verticalPickerCellHeight + verticalPickerCellSpacing)
        return offset < 0.0 || offset > maxOffset
    }

    func indexPath(for contentOffset: CGPoint, contentInset inset: UIEdgeInsets = .zero) -> IndexPath {
        let cellno = Int(rint((inset.top + contentOffset.y) / (verticalPickerCellHeight + verticalPickerCellSpacing)))
        let index = min (maxRefraction*10, minRefraction*10 + cellno)
        return IndexPath(row: index%10, section: index/10)
    }

    func contentOffset(for indexPath: IndexPath, contentInset inset: UIEdgeInsets = .zero) -> CGPoint {
        let index = indexPath.section*10 + indexPath.row
        let position = CGFloat(index) * (verticalPickerCellHeight + verticalPickerCellSpacing) - inset.top
        return CGPoint(x: 0.0, y: position)
    }
}


// MARK: - UIScrollViewDelegate

extension RefractionInput {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard updateRefractionOnScrollEvents else { return }

        // update refraction value on scrolling
        let newRefraction = refraction(for: indexPath(for: scrollView.contentOffset, contentInset: scrollView.contentInset))

        if abs(newRefraction - refraction) > Double.ulpOfOne {
            refraction = newRefraction
        }

        // no ticks within overscroll areas
        if isOverscroll(for: scrollView.contentOffset, contentInset: scrollView.contentInset) {
            return
        }

        // generate a haptic tick when the needle hits a marker line or if the distance to the previous tick position is large enough
        let newOffset = scrollView.contentOffset.y + scrollView.contentInset.top
        let delta = newOffset / verticalPickerCellHeight

        if abs(rint(delta) - delta) <= 0.05 || abs(lastFeedbackOffset - newOffset) >= verticalPickerCellHeight {
            lastFeedbackOffset = newOffset
            AppDelegate.shared.generateHapticTick()
        }
    }
}


// MARK: - UICollectionViewDataSource

extension RefractionInput: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        maxRefraction - minRefraction + 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        section < numberOfSections(in: collectionView) - 1 ? 10 : 1
    }

    func width(for indexPath: IndexPath) -> RefractionPickerBarWidth {
        switch indexPath.row {
        case 0:  return .large
        case 5:  return .medium
        default: return .small
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let id = RefractionInputCell.identifier
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as? RefractionInputCell else { fatalError() }
        cell.configure(alignment: alignment, width: width(for: indexPath))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let id = RefractionInputLabel.identifier
        guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath)
            as? RefractionInputLabel else { fatalError() }

        cell.configure(text: String(format: "%02d", maxRefraction - indexPath.section))
        return cell
    }
}


// MARK: - Accessibility

extension RefractionInput {

    private func setupAccessibility() {
        isAccessibilityElement = true

        if alignment == .right {
            accessibilityLabel = "AccessibilityLabelOriginalRefraction".localized
            accessibilityHint = "AccessibilityHintOriginalRefraction".localized
        } else {
            accessibilityLabel = "AccessibilityLabelCurrentRefraction".localized
            accessibilityHint = "AccessibilityHintCurrentRefraction".localized
        }

        accessibilityTraits = .adjustable
    }

    override var accessibilityValue: String? {
        get {
            Formatter.accessibleBrix.formattedString(for: refraction)
        }
        set {
        }
    }

    override func accessibilityIncrement() {
        _ = accessibilityUpdateRefraction(by: +0.1)
    }

    override func accessibilityDecrement() {
        _ = accessibilityUpdateRefraction(by: -0.1)
    }

    override func accessibilityScroll(_ direction: UIAccessibilityScrollDirection) -> Bool {
        switch direction {
        case .down:
            return accessibilityUpdateRefraction(by: +1.0, announceValue: true)
        case .up:
            return accessibilityUpdateRefraction(by: -1.0, announceValue: true)
        default:
            return false
        }
    }

    private func accessibilityUpdateRefraction(by delta: Double, announceValue: Bool = false) -> Bool {
        let newRefraction = max(Double(minRefraction), min(Double(maxRefraction), refraction + delta))
        if abs(newRefraction - refraction) > Double.ulpOfOne {
            updateRefractionOnScrollEvents = false
            refraction = newRefraction
            collectionView.contentOffset = contentOffset(for: indexPath(for: refraction), contentInset: collectionView.contentInset)
            updateRefractionOnScrollEvents = true

            if announceValue {
                UIAccessibility.post(notification: .announcement, argument: accessibilityValue)
            }
            return true
        }
        return false
    }
}
