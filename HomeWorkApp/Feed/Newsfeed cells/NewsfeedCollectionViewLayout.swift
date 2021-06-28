import UIKit

enum MosaicPhotoStyle {
    case fullWidth
    case halfWidth
    case oneHalf
    case oneThirds
    case moreThanExpected
}

class NewsfeedCollectionViewLayout: UICollectionViewLayout {
    private var cachedAttributes = [UICollectionViewLayoutAttributes] ()
    
    private var contentWidth: CGFloat{
        guard let collectionView = collectionView else{ return 0 }
        return collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)
    }
    
    private var contentBounds = CGRect.zero

    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        cachedAttributes.removeAll()
        var style:MosaicPhotoStyle
        var currentIndex = 0
        let count = collectionView.numberOfItems(inSection: 0)
        
        switch count {
        case 1:
            style = .fullWidth
        case 2:
            style = .halfWidth
        case 3:
            style = .oneHalf
        case 4:
            style = .oneThirds
        default:
            style = .moreThanExpected
        }
        let y : CGFloat = .zero
        let x : CGFloat = .zero
        let height: CGFloat = 400.0
        let width = collectionView.bounds.size.width
        let size = CGSize (width: width, height: height)
        contentBounds = CGRect(origin: .zero, size: size)
        
        while currentIndex < count {
            var segmentRects = [CGRect]()
            // MARK:- TO DO
            //let indexPath = IndexPath(item: item, section: 0)
            switch style {
            
            case .fullWidth:
                let fullFrame = CGRect(x: x, y: y, width: width, height: height)
                segmentRects = [fullFrame]
                
            case .halfWidth:
                let firstSlice = CGRect (x: x, y: y, width: width / 2 - 1, height: height)
                let secondSlice = CGRect (x: firstSlice.maxX + 2, y: y, width: width / 2 - 1, height: height)
                segmentRects = [firstSlice, secondSlice]
                
            case .oneHalf:
                let firstSlice = CGRect (x: x, y: y, width: width / 1.5 - 1, height: height)
                let secondSlice = CGRect (x: firstSlice.maxX + 2, y: y, width: width / 3 - 1, height: height / 2 - 1)
                let thirdSlice = CGRect (x: firstSlice.maxX + 2, y: secondSlice.maxY + 2, width: width / 3, height: height / 2 - 1)
                segmentRects = [firstSlice, secondSlice, thirdSlice]
                
            case .moreThanExpected:
                fallthrough
                
            case .oneThirds:
                let firstSlice = CGRect (x: x, y: y, width: width / 1.5 - 1, height: height)
                let secondSlice = CGRect (x: firstSlice.maxX + 2, y: y, width: width / 3 - 1, height: height / 3 - 1)
                let thirdSlice = CGRect (x: firstSlice.maxX + 2, y: secondSlice.maxY + 2, width: width / 3 - 1, height: height / 3 - 1)
                let fourthSlice = CGRect (x: firstSlice.maxX + 2, y: thirdSlice.maxY + 2, width: width / 3 - 1, height: height / 3 - 1)
                segmentRects = [firstSlice, secondSlice, thirdSlice, fourthSlice]
            }
            
            
            for rect in segmentRects {
                let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: currentIndex, section: 0))
                attributes.frame = rect
                cachedAttributes.append(attributes)
                currentIndex += 1
                if style == .moreThanExpected, currentIndex == 4 {
                    currentIndex = count
                }
            }
            
            
        }
    }
    
    override var collectionViewContentSize: CGSize{
        return contentBounds.size
    }
    
    override func layoutAttributesForElements(in rect: CGRect)
    -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        for attributes in cachedAttributes {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.item]
    }
    
}
