//
//  RecipeDetailTableViewCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/8.
//

#import "RecipeDetailTableViewCell.h"
#import "ZZCollectionViewFlowLayout.h"
#import "ZZGoodsBuyCollectionCell.h"
#import "RecipeHeaderReusableView.h"
#import "RecipePicCollectionViewCell.h"
#import "ZZBigView.h"

@interface RecipeDetailTableViewCell ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
ZZCollectionViewFlowLayoutDelegate
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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saleTotalTop;
@property (weak, nonatomic) IBOutlet UILabel *saleTotalHeadLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saleTotalHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gongbenHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gongbenTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fuliaoTop;
@property (weak, nonatomic) IBOutlet UILabel *totalLab;
@property (weak, nonatomic) IBOutlet UILabel *chufangNumLab;
@property (weak, nonatomic) IBOutlet UILabel *saleTotalPriceLab;
@property (weak, nonatomic) IBOutlet UILabel *actualSalePriceLab;
@property (weak, nonatomic) IBOutlet UILabel *expressLab;
@property (weak, nonatomic) IBOutlet UILabel *gongbenLab;
@property (weak, nonatomic) IBOutlet UILabel *fuliaoLab;
@property (weak, nonatomic) IBOutlet UILabel *chufactualLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fuliaoHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstLab;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeight2;
@property (weak, nonatomic) IBOutlet UICollectionView *picCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picCollectionHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picLabHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payView;
@property (weak, nonatomic) IBOutlet UILabel *payTotalPriceLab;

@end

@implementation RecipeDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    //    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    //    layout.minimumLineSpacing= 10;
    //    layout.minimumInteritemSpacing = 10;
    ZZCollectionViewFlowLayout *layout = [[ZZCollectionViewFlowLayout alloc]init];
    layout.delegate = self;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZZGoodsBuyCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"buyID"];
    
    
    ZZCollectionViewFlowLayout *layout2 = [[ZZCollectionViewFlowLayout alloc]init];
    layout2.delegate = self;
    self.collectionView2.collectionViewLayout = layout2;
    self.collectionView2.delegate = self;
    self.collectionView2.dataSource = self;
    [self.collectionView2 registerNib:[UINib nibWithNibName:@"ZZGoodsBuyCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"buyID"];
    
    
    UICollectionViewFlowLayout * picLayout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.minimumLineSpacing= 10;
    layout.minimumInteritemSpacing = 10;
    self.picCollectionView.collectionViewLayout = picLayout;
    self.picCollectionView.delegate = self;
    self.picCollectionView.dataSource = self;
    self.picCollectionView.backgroundColor = COLOR_FFFFFF;
    [self.picCollectionView registerNib:[UINib nibWithNibName:@"RecipePicCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"RecipePicCollectionViewCellId"];
    
    
    // Initialization code
}


+ (CGSize)boundingRectWithSize:(NSString*)txt {
    CGSize size;
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0]};
    size =  [txt sizeWithAttributes:attribute];
    return size;
}

#pragma mark -- UICollectionViewDelegate && DataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return collectionView.tag == 100? self.detailModel.recipeModel.fileList.count: collectionView.tag == 0? self.detailModel.recipedetail.count : self.detailModel.recipeExcipientList.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(collectionView.tag == 100) {
        return CGSizeMake(floor((WIDE - 140 - 30)/4.0), floor((WIDE - 140 - 30)/4.0));
    }else if(collectionView.tag == 0) {
        DrugItemModel *model = self.detailModel.recipedetail[indexPath.item];
        double cellWidth = [RecipeDetailTableViewCell boundingRectWithSize:model.granule_name].width + 20.0;
        if([self.detailModel.recipeModel.is_secret integerValue] == 0) {
            NSString *actualStr = [NSString stringWithFormat:@"%@g",model.herb_dose];
            cellWidth += [ClassMethod sizeText:actualStr font:[UIFont systemFontOfSize:10] limitHeight:15].width;
            return CGSizeMake(ceil(cellWidth)>WIDE - 50?WIDE-50:ceil(cellWidth), 30);
        }else {
            return CGSizeMake(ceil(cellWidth)>WIDE - 50?WIDE-50:ceil(cellWidth), 30);
        }
    }else {
        RecipeExcipientModel *model = self.detailModel.recipeExcipientList[indexPath.item];
        double cellWidth = [RecipeDetailTableViewCell boundingRectWithSize:model.name].width + 20.0;
        if([self.detailModel.recipeModel.is_secret integerValue] == 0) {
            NSString *actualStr = [NSString stringWithFormat:@"%@g",model.weight];
            cellWidth += [ClassMethod sizeText:actualStr font:[UIFont systemFontOfSize:10] limitHeight:15].width;
            return CGSizeMake(ceil(cellWidth)>WIDE - 50?WIDE-50:ceil(cellWidth), 30);
        }else {
            return CGSizeMake(ceil(cellWidth)>WIDE - 50?WIDE-50:ceil(cellWidth), 30);
        }
    }
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(collectionView.tag == 100) {
        RecipePicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecipePicCollectionViewCellId" forIndexPath:indexPath];
        cell.model = self.detailModel.recipeModel.fileList[indexPath.item];
        return cell;
    }else {
        ZZGoodsBuyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"buyID" forIndexPath:indexPath];
        if(collectionView.tag == 0) {
            DrugItemModel *model = self.detailModel.recipedetail[indexPath.item];
            
            if([self.detailModel.recipeModel.is_secret integerValue] == 0) {
                NSString *nameStr = [NSString stringWithFormat:@"%@%@g", model.granule_name, model.herb_dose];
                NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:nameStr];
                [attri addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(0, model.granule_name.length)];
                [attri addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} range:NSMakeRange(model.granule_name.length, model.herb_dose.length+1)];
                cell.catoryLab.attributedText = attri;
            }else {
                cell.catoryLab.text = model.granule_name;
            }
        }else {
            RecipeExcipientModel *model = self.detailModel.recipeExcipientList[indexPath.item];
            if([self.detailModel.recipeModel.is_secret integerValue] == 0) {
                NSString *nameStr = [NSString stringWithFormat:@"%@%@g", model.name, model.weight];
                NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:nameStr];
                [attri addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(0, model.name.length)];
                [attri addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} range:NSMakeRange(model.name.length, model.weight.length+1)];
                cell.catoryLab.attributedText = attri;
            }else {
                cell.catoryLab.text = model.name;
            }
        }
        
        
        return cell;
    }
   
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(collectionView.tag == 100) {
        UploadImgModel *model =  self.detailModel.recipeModel.fileList[indexPath.item];
        ZZBigView *bigView=[[ZZBigView alloc]initWithFrame:CGRectMake(0, 0, WIDE, HIGHT) withURLs:@[model.url] with:0];
        [bigView show];
    }
}

+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath {
    NSInteger selectTag = 0;
    NSString *identifier = @"RecipeDetailTableViewCellFristId";
    if(indexPath.row == 0) {
        selectTag = 0;
        identifier = @"RecipeDetailTableViewCellFristId";
    }else if(indexPath.row == 1) {
        selectTag = 1;
        identifier = @"RecipeDetailTableViewCellSecondId";
    }else {
        selectTag = 2;
        identifier = @"RecipeDetailTableViewCellThridId";
    }
    RecipeDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"RecipeDetailTableViewCell" owner:self options:nil]objectAtIndex:selectTag];
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
    
    if(detailModel.otherPay) {
        self.payView.constant = 100;
    }else {
        self.payView.constant = 0;
    }
    
    CGFloat row = detailModel.recipeModel.fileList.count>0?10: 0;
    self.picCollectionHeight.constant = floor((WIDE - 140 - 30)/4.0)*ceil(detailModel.recipeModel.fileList.count/4.0)+row;
    
    self.picLabHeight.constant =detailModel.recipeModel.fileList.count>0? 15: 0;
    
    RecipeOrderItemModel *itemModel = detailModel.recipeModel;
    self.totalLab.text = [NSString stringWithFormat:@"%.4fx%@=%.4f",[itemModel.total_granule_dose floatValue],itemModel.recipe_no,  [itemModel.total_granule_dose floatValue]* [itemModel.recipe_no floatValue]];
    self.chufangNumLab.text =  itemModel.granule_total_no;
    if([itemModel.recipe_type integerValue] == 1) { /// 膏方
        self.categoryLab.text = @"Rp.膏方";
        self.gongbenLab.text = itemModel.excipient_cost; /// 工本费
        self.saleTotalPriceLab.text = [NSString stringWithFormat:@"%.2f",[itemModel.priceTotal floatValue]+ [itemModel.excipient_cost floatValue] + [itemModel.excipient_price floatValue]]; /// 处方供货总价
        self.fuliaoHeight.constant = 12;
        self.gongbenHeight.constant = 12;
        self.fuliaoTop.constant = 6;
        self.gongbenTop.constant = 6;
        self.actualSalePriceLab.text = [NSString stringWithFormat:@"%.2f", [itemModel.sell_price_total floatValue] + [itemModel.excipient_cost floatValue] + [itemModel.excipient_price floatValue]] ; /// 处方颗粒销售总价
        
    }else {
        self.categoryLab.text = @"Rp.颗粒剂";
        self.saleTotalPriceLab.text = itemModel.priceTotal;
        self.fuliaoHeight.constant = 0;
        self.gongbenHeight.constant = 0;
        self.fuliaoTop.constant = 0;
        self.gongbenTop.constant = 0;
        self.actualSalePriceLab.text = itemModel.sell_price_total ; /// 处方颗粒销售总价
    }
    
    self.expressLab.text = itemModel.fee; /// 运费
    self.chufactualLab.text = [NSString stringWithFormat:@"%.2f", [itemModel.recipe_sale_price floatValue]]; /// 处方销售应收总价
    self.fuliaoLab.text = itemModel.excipient_price;
    
    self.payTotalPriceLab.text = [NSString stringWithFormat:@"¥%.2f", [itemModel.recipe_sale_price floatValue]]; /// 处方销售应收总价
    
    if(detailModel.isExpand) {
        self.saleTotalHeight.constant = 12;
        self.saleTotalTop.constant = 6;
        self.expandBtn.selected = YES;
    }else {
        self.saleTotalHeight.constant = 0;
        self.saleTotalTop.constant = 0;
        self.expandBtn.selected = NO;
    }
    
    /// 计算collectionView高度
    NSInteger heightNum = 1;
    CGFloat allWidth = 0;
    if([self.detailModel.recipeModel.is_secret integerValue] == 0) {
        for (DrugItemModel *subModel in detailModel.recipedetail) {
            NSString *actualStr = [NSString stringWithFormat:@"%@g",subModel.herb_dose];
            allWidth += ceil([RecipeDetailTableViewCell boundingRectWithSize:subModel.granule_name].width + 30.0 + [ClassMethod sizeText:actualStr font:[UIFont systemFontOfSize:10] limitHeight:15].width);
            if(allWidth > WIDE - 50) {
                allWidth = ceil([RecipeDetailTableViewCell boundingRectWithSize:subModel.granule_name].width + 30.0 + [ClassMethod sizeText:actualStr font:[UIFont systemFontOfSize:10] limitHeight:15].width);
                heightNum = heightNum + 1;
            }
        }
    }else {
        for (DrugItemModel *subModel in detailModel.recipedetail) {
            allWidth += ceil([RecipeDetailTableViewCell boundingRectWithSize:subModel.granule_name].width + 30.0);
            if(allWidth > WIDE - 50) {
                allWidth = ceil([RecipeDetailTableViewCell boundingRectWithSize:subModel.granule_name].width + 30.0);
                heightNum = heightNum + 1;
            }
        }
    }
    
    
    /// 膏方
    NSInteger heightNum1 = 1;
    CGFloat allWidth1 = 0;
    if([detailModel.recipeModel.recipe_type integerValue] == 1) {
        if([detailModel.recipeModel.is_secret integerValue] == 0) {
            for (RecipeExcipientModel  *subModel in detailModel.recipeExcipientList) {
                NSString *actualStr = [NSString stringWithFormat:@"%@g",subModel.weight];
                allWidth1 += ceil([RecipeDetailTableViewCell boundingRectWithSize:subModel.name].width + 30.0 + [ClassMethod sizeText:actualStr font:[UIFont systemFontOfSize:10] limitHeight:15].width);
                if(allWidth1 > WIDE - 50) {
                    allWidth1 = ceil([RecipeDetailTableViewCell boundingRectWithSize:subModel.name].width + 30.0 + [ClassMethod sizeText:actualStr font:[UIFont systemFontOfSize:10] limitHeight:15].width);
                    heightNum1 = heightNum1 + 1;
                }
            }
        }else {
            for (RecipeExcipientModel *subModel in detailModel.recipeExcipientList) {
                allWidth1 += ceil([RecipeDetailTableViewCell boundingRectWithSize:subModel.name].width + 30.0);
                if(allWidth1 > WIDE - 50) {
                    allWidth1 = ceil([RecipeDetailTableViewCell boundingRectWithSize:subModel.name].width + 30.0);
                    heightNum1 = heightNum1 + 1;
                }
            }
        }
    }
    if([detailModel.recipeModel.recipe_type integerValue] == 1) {
        self.firstLab.constant = 25;
        self.secondLab.constant = 25;
        self.collectionHeight2.constant = 40*heightNum1 + 10;
        self.collectionHeight.constant =  40*heightNum + 10;
    }else {
        self.firstLab.constant = 0;
        self.secondLab.constant = 0;
        self.collectionHeight2.constant = 0;
        self.collectionHeight.constant =  40*heightNum+10;
    }
    
    [self.collectionView reloadData];
    [self.collectionView2 reloadData];
}


+ (CGFloat)getCellHeightWith:(NSIndexPath *)indexPath modelWith:(nonnull RecipeOrderItemModel *)model detailModelWith:(nonnull RecipeOrderDetailModel *)detaiModel{
    if(indexPath.row == 0) {
        CGFloat addressHeight = [ClassMethod sizeText:[NSString stringWithFormat:@"%@%@%@%@", model.province,model.city,model.area, model.address] font:[UIFont systemFontOfSize:10] limitWidth:WIDE - 140].height;
        CGFloat symptomsHeight = [ClassMethod sizeText:model.symptoms font:[UIFont systemFontOfSize:10] limitWidth:WIDE - 140].height;
        CGFloat attentionHeight = [ClassMethod sizeText:model.attention font:[UIFont systemFontOfSize:10] limitWidth:WIDE - 140].height;
        CGFloat row = 0;
        if(detaiModel.recipeModel.fileList.count>0) {
            row = 10;
        }
        return 180 + addressHeight + symptomsHeight + attentionHeight + floor((WIDE - 140 - 30)/4.0)*ceil(detaiModel.recipeModel.fileList.count/4.0)+row ;
        
    }else if(indexPath.row == 1) {  /// 计算collectionView高度
        NSInteger heightNum = 1;
        CGFloat allWidth = 0;
        if([detaiModel.recipeModel.is_secret integerValue] == 0) {
            for (DrugItemModel *subModel in detaiModel.recipedetail) {
                NSString *actualStr = [NSString stringWithFormat:@"%@g",subModel.herb_dose];
                allWidth += ceil([RecipeDetailTableViewCell boundingRectWithSize:subModel.granule_name].width + 30.0 + [ClassMethod sizeText:actualStr font:[UIFont systemFontOfSize:10] limitHeight:15].width);
                if(allWidth > WIDE - 50) {
                    allWidth = ceil([RecipeDetailTableViewCell boundingRectWithSize:subModel.granule_name].width + 30.0 + [ClassMethod sizeText:actualStr font:[UIFont systemFontOfSize:10] limitHeight:15].width);
                    heightNum = heightNum + 1;
                }
            }
        }else {
            for (DrugItemModel *subModel in detaiModel.recipedetail) {
                allWidth += ceil([RecipeDetailTableViewCell boundingRectWithSize:subModel.granule_name].width + 30.0);
                if(allWidth > WIDE - 50) {
                    allWidth = ceil([RecipeDetailTableViewCell boundingRectWithSize:subModel.granule_name].width + 30.0);
                    heightNum = heightNum + 1;
                }
            }
        }
        
        /// 膏方
        NSInteger heightNum1 = 0;
        CGFloat allWidth1 = 0;
        if([model.recipe_type integerValue] == 1) {
            heightNum1 = 1;
            if([detaiModel.recipeModel.is_secret integerValue] == 0) {
                for (RecipeExcipientModel  *subModel in detaiModel.recipeExcipientList) {
                    NSString *actualStr = [NSString stringWithFormat:@"%@g",subModel.weight];
                    allWidth1 += ceil([RecipeDetailTableViewCell boundingRectWithSize:subModel.name].width + 30.0 + [ClassMethod sizeText:actualStr font:[UIFont systemFontOfSize:10] limitHeight:15].width);
                    if(allWidth1 > WIDE - 50) {
                        allWidth1 = ceil([RecipeDetailTableViewCell boundingRectWithSize:subModel.name].width + 30.0 + [ClassMethod sizeText:actualStr font:[UIFont systemFontOfSize:10] limitHeight:15].width);
                        heightNum1 = heightNum1 + 1;
                    }
                }
            }else {
                for (RecipeExcipientModel *subModel in detaiModel.recipeExcipientList) {
                    allWidth1 += ceil([RecipeDetailTableViewCell boundingRectWithSize:subModel.name].width + 30.0);
                    if(allWidth1 > WIDE - 50) {
                        allWidth1 = ceil([RecipeDetailTableViewCell boundingRectWithSize:subModel.name].width + 30.0);
                        heightNum1 = heightNum1 + 1;
                    }
                }
            }
        }
        if([detaiModel.recipeModel.recipe_type integerValue] == 1) {
            return 40*heightNum+10 + 55 + 40*heightNum1 + 10+ 50;
        }else {
            return 40*heightNum+10 + 55;
        }
    }else {
        CGFloat height = 126;
        if([model.recipe_type integerValue] == 1) { /// 膏方
            height +=18*2;
        }
        if(detaiModel.isExpand) {
            height += 18;
        }
        return height;
    }
}




+ (RecipeDetailTableViewCell *)getPayTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath {
    NSInteger selectTag = 0;
    NSString *identifier = @"RecipeDetailTableViewCellFristId";
    if(indexPath.row == 1) {
        selectTag = 0;
        identifier = @"RecipeDetailTableViewCellFristId";
    }else if(indexPath.row == 2) {
        selectTag = 1;
        identifier = @"RecipeDetailTableViewCellSecondId";
    } else if(indexPath.row == 3) {
        selectTag = 2;
        identifier = @"RecipeDetailTableViewCellThridId";
    }else  {
        selectTag = 3;
        identifier = @"RecipeDetailTableViewCellForthId";
    }
    RecipeDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"RecipeDetailTableViewCell" owner:self options:nil]objectAtIndex:selectTag];
    }
    return cell;
}

+ (CGFloat)getPayCellHeightWith:(NSIndexPath *)indexPath modelWith: (RecipeOrderItemModel *)model detailModelWith:(RecipeOrderDetailModel *)detaiModel {
    if(indexPath.row == 1) {
        CGFloat addressHeight = [ClassMethod sizeText:[NSString stringWithFormat:@"%@%@%@%@", model.province,model.city,model.area, model.address] font:[UIFont systemFontOfSize:10] limitWidth:WIDE - 140].height;
        CGFloat symptomsHeight = [ClassMethod sizeText:model.symptoms font:[UIFont systemFontOfSize:10] limitWidth:WIDE - 140].height;
        CGFloat attentionHeight = [ClassMethod sizeText:model.attention font:[UIFont systemFontOfSize:10] limitWidth:WIDE - 140].height;
        CGFloat row = 0;
        if(detaiModel.recipeModel.fileList.count>0) {
            row = 10;
        }
        return 180 + addressHeight + symptomsHeight + attentionHeight + floor((WIDE - 140 - 30)/4.0)*ceil(detaiModel.recipeModel.fileList.count/4.0)+row ;
        
    }else if(indexPath.row == 2) {  /// 计算collectionView高度
        NSInteger heightNum = 1;
        CGFloat allWidth = 0;
        if([detaiModel.recipeModel.is_secret integerValue] == 0) {
            for (DrugItemModel *subModel in detaiModel.recipedetail) {
                NSString *actualStr = [NSString stringWithFormat:@"%@g",subModel.herb_dose];
                allWidth += ceil([RecipeDetailTableViewCell boundingRectWithSize:subModel.granule_name].width + 30.0 + [ClassMethod sizeText:actualStr font:[UIFont systemFontOfSize:10] limitHeight:15].width);
                if(allWidth > WIDE - 50) {
                    allWidth = ceil([RecipeDetailTableViewCell boundingRectWithSize:subModel.granule_name].width + 30.0 + [ClassMethod sizeText:actualStr font:[UIFont systemFontOfSize:10] limitHeight:15].width);
                    heightNum = heightNum + 1;
                }
            }
        }else {
            for (DrugItemModel *subModel in detaiModel.recipedetail) {
                allWidth += ceil([RecipeDetailTableViewCell boundingRectWithSize:subModel.granule_name].width + 30.0);
                if(allWidth > WIDE - 50) {
                    allWidth = ceil([RecipeDetailTableViewCell boundingRectWithSize:subModel.granule_name].width + 30.0);
                    heightNum = heightNum + 1;
                }
            }
        }
        
        /// 膏方
        NSInteger heightNum1 = 0;
        CGFloat allWidth1 = 0;
        if([model.recipe_type integerValue] == 1) {
            heightNum1 = 1;
            if([detaiModel.recipeModel.is_secret integerValue] == 0) {
                for (RecipeExcipientModel  *subModel in detaiModel.recipeExcipientList) {
                    NSString *actualStr = [NSString stringWithFormat:@"%@g",subModel.weight];
                    allWidth1 += ceil([RecipeDetailTableViewCell boundingRectWithSize:subModel.name].width + 30.0 + [ClassMethod sizeText:actualStr font:[UIFont systemFontOfSize:10] limitHeight:15].width);
                    if(allWidth1 > WIDE - 50) {
                        allWidth1 = ceil([RecipeDetailTableViewCell boundingRectWithSize:subModel.name].width + 30.0 + [ClassMethod sizeText:actualStr font:[UIFont systemFontOfSize:10] limitHeight:15].width);
                        heightNum1 = heightNum1 + 1;
                    }
                }
            }else {
                for (RecipeExcipientModel *subModel in detaiModel.recipeExcipientList) {
                    allWidth1 += ceil([RecipeDetailTableViewCell boundingRectWithSize:subModel.name].width + 30.0);
                    if(allWidth1 > WIDE - 50) {
                        allWidth1 = ceil([RecipeDetailTableViewCell boundingRectWithSize:subModel.name].width + 30.0);
                        heightNum1 = heightNum1 + 1;
                    }
                }
            }
        }
        if([detaiModel.recipeModel.recipe_type integerValue] == 1) {
            return 40*heightNum+10 + 55 + 40*heightNum1 + 10+ 50;
        }else {
            return 40*heightNum+10 + 55;
        }
    }else  if(indexPath.row == 3){
        CGFloat height = 126;
        if([model.recipe_type integerValue] == 1) { /// 膏方
            height +=18*2;
        }
        if(detaiModel.isExpand) {
            height += 18;
        }
        return height;
    } else {
        CGFloat height = 215;
        if(detaiModel.otherPay) {
            height += 100;
        }
        return height;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
