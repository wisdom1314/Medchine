//
//  RecipeSampleView.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/24.
//

#import "RecipeSampleView.h"
#import "DrugCollectionViewCell.h"
@interface RecipeSampleView ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *recipesampleNameLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (nonatomic, strong) NSMutableArray *drugArr;
@end

@implementation RecipeSampleView
- (void)awakeFromNib {
    [super awakeFromNib];

    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.minimumLineSpacing= 10;
    layout.minimumInteritemSpacing = 10;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = COLOR_F9F5F1;
    [self.collectionView registerNib:[UINib nibWithNibName:@"DrugCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"DrugCollectionViewCellId"];
    
    [self addCornerToView:self];
    @weakify(self);
    [[self.openBtn rac_signalForControlEvents:UIControlEventTouchUpInside ]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if(self.subject) {
            [self.subject sendNext:self.drugArr];
        }
    }];
    
   
}
- (void)addCornerToView:(UIView *)theView {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, WIDE , HIGHT) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, WIDE, HIGHT);
    maskLayer.path = maskPath.CGPath;
    theView.layer.mask = maskLayer;
}




#pragma mark -- UICollectionViewDelegate && DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.drugArr.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(floor((WIDE - 80)/3.0), 30);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DrugCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DrugCollectionViewCellId" forIndexPath:indexPath];
    DrugItemModel *model = self.drugArr[indexPath.item];
    cell.nameLab.text = model.granule_name;
    cell.hosLab.text = [NSString stringWithFormat:@"%@g",model.herb_dose];
    return cell;
}

- (void)setModel:(RecipesampleSymptomsModel *)model {
    _model = model;
    self.recipesampleNameLab.text = model.recipesampleSymptoms;
    self.dateLab.text = model.addtime;
    self.nameLab.text = model.recipesampleName;
    [self requestDetail];
}

- (void)requestDetail {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.model.recipesampleId forKey:@"recipesample_id"];
    [dic setValue:[MedicineManager sharedInfo].doctorModel.doctor_id forKey:@"doctor_id"];
    [[RequestManager shareInstance]requestWithMethod:POST  url:GetRecipeSampleURL dict:dic hasHeader:YES finished:^(id request) {
        DrugListModel *model = [DrugListModel mj_objectWithKeyValues:request];
        self.drugArr = [model.list mutableCopy];
        self.height = 220 + 40* ceil(self.drugArr.count/3.0);
        self.collectionViewHeight.constant = self.drugArr.count==0?0: 40* ceil(self.drugArr.count/3.0) + 20;
        self.numLab.text = [NSString stringWithFormat:@"共%ld味药材",self.drugArr.count];
        [self.subject sendNext:@"ok"];
        [self.collectionView reloadData];
    } failed:^(NSError *error) {
        
    }];
}

- (NSMutableArray *)drugArr {
    if(!_drugArr) {
        _drugArr = [NSMutableArray array];
    }
    return _drugArr;
}

- (RACSubject *)subject {
    if(!_subject) {
        _subject = [RACSubject subject];
    }
    return _subject;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
