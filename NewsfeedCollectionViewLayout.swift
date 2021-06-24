import UIKit

enum MosaicPhotoStyle {
    case fullWidth
    case halfWidth
    case oneHalf
    case oneThirds
    case moreThanExpected
    //case fourPhotos
}

protocol CustomCollectionViewLayoutDelegate : AnyObject {
    func collectionView(_ collectionView : UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath)-> CGFloat
}

class NewsfeedCollectionViewLayout: UICollectionViewLayout {
    weak var delegate: CustomCollectionViewLayoutDelegate?
    private var cachedAttributes = [UICollectionViewLayoutAttributes] ()
    
    private var contentWidth: CGFloat{
        guard let collectionView = collectionView else{ return 0 }
        return collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)
    }
    
    private var contentBounds = CGRect.zero
    
    override var collectionViewContentSize: CGSize{
        return contentBounds.size
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        cachedAttributes.removeAll()
        contentBounds = CGRect(origin: .zero, size: collectionView.bounds.size)
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
        let yOrigin : CGFloat = 0
        let xOrigin : CGFloat = 0
        let cvWidth = collectionView.bounds.size.width
        
        
        print (count,style)
        while currentIndex < count {
            //let indexPath = IndexPath(item: item, section: 0)
            let segmentFrame = CGRect(x: 0, y: 0, width: cvWidth, height: 400.0)
            var segmentRects = [CGRect]()
            // MARK:- TO DO
            //let photoHeight:CGFloat = delegate?.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath) ?? 400
            
            
            switch style {
            case .fullWidth:
                segmentRects = [segmentFrame]
            case .halfWidth:
                let firstSlice = CGRect (x: 0, y: 0, width: cvWidth / 2, height: 400)
                let secondSlice = CGRect (x: firstSlice.width, y: 0, width: cvWidth / 2, height: 400)
                segmentRects = [firstSlice, secondSlice]
            case .oneHalf:
                let firstSlice = CGRect (x: 0, y: 0, width: cvWidth / 2, height: 400)
                let secondSlice = CGRect (x: firstSlice.width, y: 0, width: cvWidth / 2, height: 400 / 2)
                let thirdSlice = CGRect (x: firstSlice.width, y: secondSlice.height, width: cvWidth / 2, height: 400 / 2)
                segmentRects = [firstSlice, secondSlice, thirdSlice]
            case .oneThirds:
                let firstSlice = CGRect (x: 0, y: 0, width: cvWidth / 2, height: 400)
                let secondSlice = CGRect (x: firstSlice.width, y: 0, width: cvWidth / 2, height: 400 / 3)
                let thirdSlice = CGRect (x: firstSlice.width, y: secondSlice.height, width: cvWidth / 2, height: 400 / 3)
                let fourthSlice = CGRect (x: firstSlice.width, y: 300, width: cvWidth / 2, height: 100)
                segmentRects = [firstSlice, secondSlice, thirdSlice, fourthSlice]
            case .moreThanExpected:
                ///MARK: TO DO
                let firstSlice = CGRect (x: 0, y: 0, width: cvWidth / 2, height: 400)
                let secondSlice = CGRect (x: firstSlice.width, y: 0, width: cvWidth / 2, height: 400 / 3)
                let thirdSlice = CGRect (x: firstSlice.width, y: secondSlice.height, width: cvWidth / 2, height: 400 / 3)
                let fourthSlice = CGRect (x: firstSlice.width, y: 300, width: cvWidth / 2, height: 100)
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
