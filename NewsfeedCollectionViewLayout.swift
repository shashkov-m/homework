import UIKit

enum MosaicPhotoStyle {
    case onePhoto
    case twoPhotos
    case threePhotos
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
        
        var yOrigin : CGFloat = 0
        var xOrigin : CGFloat = 0
        
        let cvWidth = collectionView.bounds.size.width / 2
        for item in 0..<collectionView.numberOfItems(inSection: 0){
            let indexPath = IndexPath(item: item, section: 0)
            let photoHeight:CGFloat = 400 //delegate?.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath) ?? 400
            
            let frame = CGRect (x: xOrigin, y: yOrigin, width: cvWidth, height: photoHeight)
            
            let attributes = UICollectionViewLayoutAttributes (forCellWith: indexPath)
            attributes.frame = frame
            
            cachedAttributes.append(attributes)
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
