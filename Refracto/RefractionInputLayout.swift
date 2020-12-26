//  RefractionInputLayout.swift

import UIKit

let verticalPickerCellWidth: CGFloat = 100.0
let verticalPickerCellHeight: CGFloat = 11.0
let verticalPickerCellSpacing: CGFloat = 0.0
let verticalPickerCellInset: CGFloat = 2.0

let verticalPickerSupplementaryViewWidth: CGFloat = 22.0
let verticalPickerSupplementaryViewHeight: CGFloat = 16.0
let verticalPickerSupplementaryViewInset: CGFloat = 55.0

class RefractionInputLayout: UICollectionViewFlowLayout {
    let alignment: RefractionPickerAlignment

    var headerYPositions: [CGFloat] = []

    init(alignment: RefractionPickerAlignment) {
        self.alignment = alignment
        super.init()
        self.itemSize = CGSize(width: verticalPickerCellWidth, height: verticalPickerCellHeight)
        self.minimumLineSpacing = verticalPickerCellSpacing
        self.headerReferenceSize = .zero
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepare() {
        guard let collectionView = self.collectionView,
              let dataSource = collectionView.dataSource
            else { fatalError() }

        self.minimumInteritemSpacing = ceil(collectionView.bounds.width - verticalPickerCellWidth);

        let numOfSections = dataSource.numberOfSections?(in: collectionView) ?? 1
        headerYPositions.removeAll(keepingCapacity: true)
        headerYPositions.reserveCapacity(numOfSections)

        var y: CGFloat = 0
        for section in 0..<numOfSections {
            headerYPositions.append(rint(y + verticalPickerCellHeight/2))
            y += verticalPickerCellHeight * CGFloat(dataSource.collectionView(collectionView, numberOfItemsInSection: section))
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = self.collectionView,
              let superAttributes = super.layoutAttributesForElements(in: rect)
            else { return nil }

        var result: [UICollectionViewLayoutAttributes] = []

        for attributes in superAttributes {
            let alignedX = (self.alignment == .left) ? verticalPickerCellInset : collectionView.bounds.width - attributes.frame.width - verticalPickerCellInset

            let alignedAttributes = attributes.copy() as! UICollectionViewLayoutAttributes
            alignedAttributes.frame.origin.x = alignedX
            alignedAttributes.zIndex = 0

            result.append(alignedAttributes)
        }

        for (section, y) in headerYPositions.enumerated() {
            let headerRect = CGRect(x: 0, y: y, width: collectionView.bounds.width, height: verticalPickerSupplementaryViewHeight)
            if headerRect.intersects(rect) {
                if let a = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: section)) {
                    result.append(a)
                }
            }
        }

        return result
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = self.collectionView
            else { return nil }

        let alignedAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        let alignedX = (self.alignment == .left) ? verticalPickerSupplementaryViewInset : collectionView.bounds.width - verticalPickerSupplementaryViewWidth - verticalPickerSupplementaryViewInset
        alignedAttributes.frame = CGRect(x: alignedX, y: headerYPositions[indexPath.section], width: verticalPickerSupplementaryViewWidth, height: verticalPickerSupplementaryViewHeight)
        alignedAttributes.zIndex = 1

        return alignedAttributes;
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let vc = self.collectionView?.delegate as? RefractionInput,
              let inset = self.collectionView?.contentInset
            else { return proposedContentOffset }

        return vc.contentOffset(for: vc.indexPath(for: proposedContentOffset, contentInset: inset), contentInset: inset)
    }
}
