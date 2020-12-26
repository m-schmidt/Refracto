//  FormulaInput.swift

import UIKit

fileprivate let minimumHeight: CGFloat = 44.0

class FormulaInput: ReadableWidthView {
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    private var formula: RefractometerFormula

    init(formula: RefractometerFormula) {
        self.formula = formula
        super.init(frame: .zero)
        isAccessibilityElement = true
        setContentHuggingPriority(.defaultHigh+1, for: .vertical)

        setup()
        setupLayerMask()
        setupAccessibility()

        selectItem(at: self.formula.caseIndex, animated: false)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        let lineHeight = rint(FormulaInputCell.lineHeight())
        return CGSize(width: FormulaInput.noIntrinsicMetric, height: max (minimumHeight, lineHeight))
    }

    private func setup() {
        collectionView.backgroundColor = Colors.formulaBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.scrollsToTop = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.isUserInteractionEnabled = false
        collectionView.register(FormulaInputCell.self, forCellWithReuseIdentifier: FormulaInputCell.identifier)
        embedd(readableSubview: collectionView)

        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        leftSwipe.direction = .left
        addGestureRecognizer(leftSwipe)

        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        rightSwipe.direction = .right
        addGestureRecognizer(rightSwipe)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapRecognizer)

        let dot = FormulaInputDot()
        dot.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dot)

        let constraints = [
            dot.centerXAnchor.constraint(equalTo: centerXAnchor),
            dot.topAnchor.constraint(equalTo: topAnchor) ]
        NSLayoutConstraint.activate(constraints)
    }
}


// MARK: - User Interaction

extension FormulaInput {
    private func selectedItemIndex() -> Int {
        if let paths = collectionView.indexPathsForSelectedItems {
            if paths.count == 1 {
                return paths[0].item
            }
        }
        return 0;
    }

    private func selectItem(at index: Int, animated: Bool = true) {
        guard index >= 0 && index < self.collectionView(collectionView, numberOfItemsInSection: 0)
            else { return }

        if animated {
            UISelectionFeedbackGenerator().selectionChanged()
        }

        let indexPath = IndexPath(item: index, section: 0)
        collectionView.selectItem(at: indexPath, animated: animated, scrollPosition: .centeredHorizontally)
        formula = RefractometerFormula.allCases[index]

        Settings.shared.formula = formula
    }

    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer? = nil) {
        let selected = selectedItemIndex()

        if sender?.direction == .right {
            selectItem(at: selected - 1)
        } else {
            selectItem(at: selected + 1)
        }
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let sender = sender else { return }
        let location = CGPoint(x: sender.location(in: collectionView).x, y: self.bounds.height/2)
        if let tappedIndexPath = collectionView.indexPathForItem(at: location) {
            selectItem(at: tappedIndexPath.item)
        }
    }
}


// MARK: - Visual Effects

extension FormulaInput {
    private func setupLayerMask() {
        let maskLayer = CAGradientLayer()
        maskLayer.frame = collectionView.bounds;
        maskLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]
        maskLayer.locations = [0.0, 0.12, 0.88, 1.0]
        maskLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        maskLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        collectionView.layer.mask = maskLayer;
    }

    private func updateLayerMask() {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)

        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        collectionView.layer.mask?.frame = visibleRect;
        CATransaction.commit()
    }

    override func layoutSubviews() {
        // trigger relayout of collection view content before call to super
        collectionView.collectionViewLayout.invalidateLayout()

        super.layoutSubviews()

        // reselect current formula
        selectItem(at: selectedItemIndex(), animated: false)
        updateLayerMask()
    }
}


// MARK: - UIScrollViewDelegate

extension FormulaInput: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateLayerMask()
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

fileprivate let cellMargin: CGFloat = 14.0

extension FormulaInput: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let formula = RefractometerFormula.allCases[indexPath.row].rawValue.localized
        let standardAttributes = FormulaInputCell.textAttributes(selected: false)
        let standardSize = formula.size(withAttributes: standardAttributes)
        let selectedAttributes = FormulaInputCell.textAttributes(selected: true)
        let selectedSize = formula.size(withAttributes: selectedAttributes)
        return CGSize(width: ceil (2 * cellMargin + max(standardSize.width, selectedSize.width)), height: ceil(max(standardSize.height, selectedSize.height)))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let count = self.collectionView(collectionView, numberOfItemsInSection: section)
        let firstSize = self.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: IndexPath(item: 0, section: section))
        let lastSize = self.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: IndexPath(item: count - 1, section: section))
        let lineHeight = FormulaInputCell.lineHeight()
        let size = collectionView.bounds.size
        let insetL = floor((size.width - firstSize.width)/2)
        let insetR = floor((size.width - lastSize.width)/2)
        let insetV = floor((size.height - lineHeight)/2)
        return UIEdgeInsets(top: insetV, left:insetL, bottom: insetV, right: insetR)
    }
}


// MARK: - UICollectionViewDataSource

extension FormulaInput: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard section == 0 else { fatalError() }
        return RefractometerFormula.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormulaInputCell.identifier, for: indexPath) as? FormulaInputCell
            else { fatalError() }

        let formula = RefractometerFormula.allCases[indexPath.row]
        cell.configure(text: formula.localizedItemDescription)
        return cell
    }
}


// MARK: - Accessibility

extension FormulaInput {

    private func setupAccessibility() {
        accessibilityLabel = "AccessibilityLabelComputationMode".localized
        accessibilityTraits = .adjustable
    }

    override var accessibilityValue: String? {
        get {
            let formula = RefractometerFormula.allCases[selectedItemIndex()]
            return formula.localizedItemDescription
        }
        set {
        }
    }

    override func accessibilityIncrement() {
        let selected = selectedItemIndex()
        selectItem(at: selected + 1)
    }

    override func accessibilityDecrement() {
        let selected = selectedItemIndex()
        selectItem(at: selected - 1)
    }
}
