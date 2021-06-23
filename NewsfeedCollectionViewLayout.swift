import UIKit

enum MosaicPhotoStyle {
    case onePhoto
    case twoPhotos
    case threePhotos
    //case fourPhotos
}

class NewsfeedCollectionViewLayout: UICollectionViewLayout {
    
    var contentBounds = CGRect.zero
    var cachedAttributes = [UICollectionViewLayoutAttributes] ()
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        cachedAttributes.removeAll()
        contentBounds = CGRect (origin: .zero, size: collectionView.bounds.size)
        
        let count = collectionView.numberOfItems(inSection: 0)
        
        var currentIndex = 0
        var segment:MosaicPhotoStyle = .onePhoto
        var lastFrame:CGRect = .zero
        
        let cvWidth = collectionView.bounds.size.width
        
        while currentIndex < count {
            let segmentFrame = CGRect(x: 0, y: lastFrame.maxY + 1.0, width: cvWidth, height: 200.0)
            var segmentRects = [CGRect]()
            
            switch segment {
            case .onePhoto:
                segmentRects = [segmentFrame]
            case .twoPhotos:
                let horizontalSlices = segmentFrame.dividedIntegral(fraction: 0.5, from: .minXEdge)
                segmentRects = [horizontalSlices.first, horizontalSlices.second]
            case .threePhotos:
                let horizontalSlices = segmentFrame.dividedIntegral(fraction: 1.0 / 3.0, from: .minXEdge)
                let verticalSlices = horizontalSlices.first.dividedIntegral(fraction: 0.5, from: .minYEdge)
                segmentRects = [verticalSlices.first, verticalSlices.second, horizontalSlices.second]
            }
            
            for rect in segmentRects {
                let attributes = UICollectionViewLayoutAttributes (forCellWith: IndexPath (item: currentIndex, section: 0))
                attributes.frame = rect
                
                cachedAttributes.append(attributes)
                contentBounds = contentBounds.union(lastFrame)
                currentIndex += 1
                lastFrame = rect
            }
        }
    }
}
