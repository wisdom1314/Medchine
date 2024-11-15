//
//  RecipeHosTableViewCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/8.
//

#import "RecipeHosTableViewCell.h"
#import "ZZCollectionViewFlowLayout.h"

#import "RecipeHeaderReusableView.h"
#import "RecipeHosCollectionViewCell.h"

@interface RecipeHosTableViewCell ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>
@property (weak, nonatomic) IBOutlet UILabel *categoryLab;
@property (weak, nonatomic) IBOutlet UILabel *recipe_nameLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *sexLab;
@property (weak, nonatomic) IBOutlet UILabel *ageLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *symptomsLab;
@property (weak, nonatomic) IBOutlet UILabel *timesdayLab;
@property (weak, nonatomic) IBOutlet UILabel *granuleTotalNoLab;
@property (weak, nonatomic) IBOutlet UILabel *attentionLan;
@property (weak, nonatomic) IBOutlet UILabel *saleTotalHeadLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saleTotalHeight;

@property (weak, nonatomic) IBOutlet UILabel *chufangNumLab;
@property (weak, nonatomic) IBOutlet UILabel *saleTotalPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *actualSalePriceLab;
@property (weak, nonatomic) IBOutlet UILabel *chufactualLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saleTotalTop;
@end

@implementation RecipeHosTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.minimumLineSpacing= 10;
    layout.minimumInteritemSpacing = 10;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"RecipeHosCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"RecipeHosCollectionViewCellId"];
//
    // Initialization code
}


#pragma mark -- UICollectionViewDelegate && DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.detailModel.recipedetail.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(floor((WIDE - 80)/2.0), 40);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RecipeHosCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecipeHosCollectionViewCellId" forIndexPath:indexPath];
    DrugItemModel *model = self.detailModel.recipedetail[indexPath.item];
    if([self.detailModel.recipeModel.is_secret integerValue] == 0) {
        NSString *nameStr = [NSString stringWithFormat:@"%@%@袋", model.granule_name, model.herb_dose];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:nameStr];
        [attri addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(0, model.granule_name.length)];
        [attri addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} range:NSMakeRange(model.granule_name.length, model.herb_dose.length+1)];
        cell.categorylab.attributedText = attri;
    }else {
        cell.categorylab.text = model.granule_name;
    }
    cell.detailLab.text = [NSString stringWithFormat:@"每袋相当于饮片%@g",model.equivalent];
    return cell;
}

+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath {
    NSInteger selectTag = 0;
    NSString *identifier = @"RecipeHosTableViewCellFristId";
    if(indexPath.row == 0) {
        selectTag = 0;
        identifier = @"RecipeHosTableViewCellFristId";
    }else if(indexPath.row == 1) {
        selectTag = 1;
        identifier = @"RecipeHosTableViewCellSecondId";
    }else {
        selectTag = 2;
        identifier = @"RecipeHosTableViewCellThridId";
    }
    RecipeHosTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"RecipeHosTableViewCell" owner:self options:nil]objectAtIndex:selectTag];
    }
    return cell;
}

- (void)setModel:(RecipeOrderItemModel *)model {
    _model = model;
    self.recipe_nameLab.text = model.recipe_name;
    self.nameLab.text = model.name;
    self.sexLab.text = model.sex;
    self.ageLab.text = model.age;
    self.phoneLab.text = model.phone;
    self.addressLab.text = [NSString stringWithFormat:@"%@%@%@%@", model.province,model.city,model.area, model.address];
    self.symptomsLab.text = model.symptoms;
    self.timesdayLab.text = model.times_day;
    self.granuleTotalNoLab.text = model.recipe_no;
    self.attentionLan.text = model.attention;
}

- (void)setDetailModel:(RecipeOrderDetailModel *)detailModel {
    _detailModel = detailModel;
    RecipeOrderItemModel *itemModel = detailModel.recipeModel;
    self.categoryLab.text = @"Rp.小袋包装";
    self.chufangNumLab.text =  itemModel.granule_total_no;
    self.saleTotalPriceLab.text = @"0.0";
    self.actualSalePriceLab.text = itemModel.sell_price_total ;
    self.chufactualLab.text = [NSString stringWithFormat:@"%.2f", [itemModel.recipe_sale_price floatValue]]; /// 处方销售应收总价
    if(detailModel.isExpand) {
        self.saleTotalHeight.constant = 12;
        self.saleTotalTop.constant = 6;
        self.expandBtn.selected = YES;
    }else {
        self.saleTotalHeight.constant = 0;
        self.saleTotalTop.constant = 0;
        self.expandBtn.selected = NO;
    }
    
    self.collectionHeight.constant =  50*ceil(detailModel.recipedetail.count/2.0) +10;
    [self.collectionView reloadData];
}


+ (CGFloat)getCellHeightWith:(NSIndexPath *)indexPath modelWith:(nonnull RecipeOrderItemModel *)model detailModelWith:(nonnull RecipeOrderDetailModel *)detaiModel{
    if(indexPath.row == 0) {
        CGFloat addressHeight = [ClassMethod sizeText:[NSString stringWithFormat:@"%@%@%@%@", model.province,model.city,model.area, model.address] font:[UIFont systemFontOfSize:10] limitWidth:WIDE - 140].height;
        CGFloat symptomsHeight = [ClassMethod sizeText:model.symptoms font:[UIFont systemFontOfSize:10] limitWidth:WIDE - 140].height;
        
        CGFloat attentionHeight = [ClassMethod sizeText:model.attention font:[UIFont systemFontOfSize:10] limitWidth:WIDE - 140].height;
        return 180 + addressHeight + symptomsHeight + attentionHeight;
        
    }else if(indexPath.row == 1) {  /// 计算collectionView高度
        return 50*ceil(detaiModel.recipedetail.count/2.0) + 10 + 55;
    }else {
        CGFloat height = 105;
        if(!detaiModel.isExpand) {
            height = 105 - 18;
        }
        return height;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
