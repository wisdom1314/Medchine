//
//  CycleTakePhotoView.m
//  BlueBricks
//
//  Created by GOOT on 2018/10/24.
//  Copyright © 2018年 Wisdom. All rights reserved.
//

#import "CycleTakePhotoView.h"
#import "LxGridViewFlowLayout.h"
#import "TZTestCell.h"
#import <TZImageManager.h>
#import "HomeModel.h"
#import "ZZBigView.h"

#define MaxNum 8
#define ColumnNum 4

@interface CycleTakePhotoView ()
<TZImagePickerControllerDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate,
UINavigationControllerDelegate>

@property (strong, nonatomic) UICollectionViewFlowLayout *layout;
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic, strong) NSMutableArray *imgArray;
@property (nonatomic, assign) NSInteger maxNum;


@end

@implementation CycleTakePhotoView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self configCollectionView];
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];

    [self configCollectionView];
}

- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.itemSize = CGSizeMake(floor((WIDE - 50)/4.0), floor((WIDE - 50)/4.0));
    _layout.minimumInteritemSpacing = 10;
    _layout.minimumLineSpacing = 10;
    _layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDE, floor((WIDE - 50)/4.0) + 20) collectionViewLayout:_layout];
    _collectionView.backgroundColor = COLOR_F9F5F1;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self addSubview:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
    self.maxNum = MaxNum;
}

#pragma mark -- UICollectionViewDelegate && DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (self.imgArray.count >= MaxNum) {
        return self.imgArray.count;
    }
    return self.imgArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.videoImageView.hidden = YES;
    if (indexPath.item == self.imgArray.count) {
        cell.imageView.image = [UIImage imageNamed:@"photo_add"];
        cell.deleteBtn.hidden = YES;
        cell.gifLable.hidden = YES;
    } else {
        UploadImgModel *subModel = self.imgArray[indexPath.item];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:subModel.url]];
        cell.deleteBtn.hidden = NO;
        cell.gifLable.hidden = YES;
    }
    cell.deleteBtn.tag = indexPath.item;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == self.imgArray.count) {
        [self pushTZImagePickerController];
    }else {
        NSMutableArray *dataArr = [NSMutableArray array];
        for (UploadImgModel *subModel in self.imgArray) {
            [dataArr addObject:subModel.url];
        }
        ZZBigView *bigView=[[ZZBigView alloc]initWithFrame:CGRectMake(0, 0, WIDE, HIGHT) withURLs:dataArr with:indexPath.item];
        [bigView show];
        
//        TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc]initWithMaxImagesCount:self.maxNum delegate:self];
//        imagePickerVC.showSelectedIndex = YES;
//        [imagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//        }];
//        imagePickerVC.modalPresentationStyle = UIModalPresentationFullScreen;
//        [[UIViewController currentViewController] presentViewController:imagePickerVC animated:YES completion:nil];
    }
}

#pragma mark -- 删除图片
- (void)deleteBtnClik:(UIButton *)sender {
    if ([self collectionView:self.collectionView numberOfItemsInSection:0] <= self.imgArray.count) {
        [self.imgArray removeObjectAtIndex:sender.tag];
        if(self.getImgBlock) {
            self.getImgBlock(self.imgArray);
        }
        self.maxNum = MaxNum - self.imgArray.count;
        [self.collectionView reloadData];
        return;
    }
    
    [self.imgArray removeObjectAtIndex:sender.tag];
    if(self.getImgBlock) {
        self.getImgBlock(self.imgArray);
    }
    self.maxNum = MaxNum - self.imgArray.count;
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [self->_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self->_collectionView reloadData];
    }];

}

#pragma mark - TZImagePickerController
- (void)pushTZImagePickerController {
    if (self.maxNum <= 0) {
        return;
    }
    TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxNum columnNumber:ColumnNum delegate:self pushPhotoPickerVc:YES];
    imagePickerVC.allowTakePicture = YES; // 在内部显示拍照按钮
    imagePickerVC.showSelectedIndex = YES;
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {

    }];
    
    imagePickerVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [[UIViewController currentViewController] presentViewController:imagePickerVC animated:YES completion:nil];
}

#pragma mark -- TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {

    [self uploadPicSourceAssets:assets photosWith:photos];
}

#pragma mark --  上传图片
- (void)uploadPicSourceAssets:(NSArray *)assets photosWith:(NSArray<UIImage *> *)photos {
    for (int i = 0; i<photos.count; i++) {
        UIImage *image = photos[i];
        NSData *imgData=UIImageJPEGRepresentation(image, 0.8);
        @WeakSelf(self);
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"1" forKey:@"private"];
        [[RequestManager shareInstance]requestPostMultipartWithURL:UploadImageURL params:dic updata:imgData key:@"file" fileName:@"image.jpeg" mimeType:@"jpeg" finished:^(id request) {
            UploadImgModel *model = [UploadImgModel mj_objectWithKeyValues:request];
            [weakSelf.imgArray addObject:model];
            if(weakSelf.getImgBlock) {
                weakSelf.getImgBlock(weakSelf.imgArray);
            }
            weakSelf.maxNum = MaxNum - weakSelf.imgArray.count;
            [self->_collectionView reloadData];
        } failed:^(NSError *error) {
            
        }];

    }
}

- (void)setOrginalArr:(NSMutableArray *)orginalArr {
    _orginalArr = orginalArr;
    self.imgArray = orginalArr;
    self.maxNum = MaxNum-self.imgArray.count;
    [self.collectionView reloadData];
}

- (NSMutableArray *)imgArray {
    if(!_imgArray) {
        _imgArray = [NSMutableArray array];
    }
    return _imgArray;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
