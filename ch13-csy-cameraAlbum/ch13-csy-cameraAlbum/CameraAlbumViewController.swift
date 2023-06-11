//
//  ViewController.swift
//  ch13-csy-cameraAlbum
//
//  Created by hansung on 2023/06/08.
//

import UIKit
import AVKit
import Photos
import PhotosUI

class CameraAlbumViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var fetchResult: PHFetchResult<PHAsset>!    // 사진에 대한 메타 데이터 저장
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "앨범관리"

        // 모든 사진을 다 가져온다. 일부사진만 가져오는 것은
        // https://developer.apple.com/documentation/photokit/browsing_and_modifying_photo_albums 참조
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchResult = PHAsset.fetchAssets(with: allPhotosOptions) // 모든 사진의 목록을 갖는다
        
        collectionView.delegate = self        // 테이블뷰와 완전 동일하다
        collectionView.dataSource = self      // 테이블뷰와 완전 동일하다
    }
}

extension CameraAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 사진의 갯수를 리턴한다.
        return fetchResult == nil ? 0: fetchResult.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for:  indexPath) as! ImageCollectionViewCell
        
        let asset = fetchResult.object(at: indexPath.row)  // 이미지에 대한 메타 데이터를 가져온다
        PHCachingImageManager.default().requestImage(for: asset, targetSize: CGSize(), contentMode: .aspectFill, options: nil){
            (image, _) in    // 요청한 이미지를 디스크로부터 읽으면 이 함수가 호출 된다.
            cell.imageView.image = image  // 여기서 이미지를 보이게 한다
            cell.memoLabel.text = "메모없음"   // 현재는 메모가 없으므로
        }
        return cell
    }
}
