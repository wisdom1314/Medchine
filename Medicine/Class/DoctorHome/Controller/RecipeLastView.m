//
//  RecipeLastView.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/26.
//

#import "RecipeLastView.h"
#import "DateTimeTool.h"
@interface RecipeLastView()
@property (weak, nonatomic) IBOutlet UILabel *infolab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *zzLab;
@property (weak, nonatomic) IBOutlet UILabel *recipeTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *drugLab;
@property (weak, nonatomic) IBOutlet UILabel *flheadLab;
@property (weak, nonatomic) IBOutlet UILabel *flLab;
@property (weak, nonatomic) IBOutlet UILabel *yfLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *bottomLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flTop;
@end

@implementation RecipeLastView


- (void)setModel:(RecipeModel *)model {
    _model = model;
    CGFloat height = 145;
    NSString *info = [NSString stringWithFormat:@"患者姓名:%@  性别:%@   年龄:%@  手机号:%@", model.name, model.sex, model.age ,model.phone];
    self.infolab.text = info;
    
    if(!model.isMy) {
        NSString *address = [NSString stringWithFormat:@"地址:%@ %@ %@ %@",model.province, model.city, model.area, model.address];
        
        self.addressLab.text = address;
        self.addressTop.constant = 10;
        
        height = height + [ClassMethod sizeText:address font:[UIFont systemFontOfSize:13] limitWidth:self.width - 30].height + 10;
    }else {
        self.addressTop.constant = 0;
    }
   
    
    NSString *zz = [NSString stringWithFormat:@"症状:%@",model.symptoms.length>0?model.symptoms:@""];
    self.zzLab.text = zz;
    
    if([model.recipe_type integerValue] == 1) {
        self.recipeTypeLab.text = @"Rp.膏方";
    }else {
        self.recipeTypeLab.text = @"Rp.颗粒剂";
    }
    NSMutableArray *drugList = [NSMutableArray array];
    for (DrugItemModel *subModel in model.drugArr) {
        subModel.herb_dose = [model.need_factor integerValue] ==1?  [ClassMethod formatNumberWithCustomRounding:subModel.num*[subModel.herb_factor floatValue]]: [NSString stringWithFormat:@"%ld",subModel.num];
        if([subModel.herb_factor floatValue]<1) {
            [drugList addObject:[NSString stringWithFormat:@"%@[新标准]%@g",subModel.drugname, subModel.herb_dose]];
        }else {
            [drugList addObject:[NSString stringWithFormat:@"%@%@g",subModel.drugname, subModel.herb_dose]];
        }
       
    } 
    NSString *drug = [drugList componentsJoinedByString: @"      "];
    self.drugLab.text = drug;
    
    if([model.recipe_type integerValue] == 1) {
        NSMutableArray *excipentList = [NSMutableArray array];
        for (ExcipientItemModel *subModel in model.excipentArr) {
            [excipentList addObject:[NSString stringWithFormat:@"%@%ldg",subModel.name, subModel.num]];
        }
        NSString *excipent = [excipentList componentsJoinedByString: @"  "];
        self.flLab.text = excipent;
        self.flTop.constant = 15;
        self.flheadLab.text = @"辅料信息";
    }else {
        self.flTop.constant = 0;
        self.flheadLab.text = @"";
        self.flLab.text =@"";
    }
    
    NSString *useStr = [NSString stringWithFormat:@"用法用量:每日%@次  共%@副  %@",model.times_day,model.recipe_no, model.attention.length>0?model.attention: @""];
    self.yfLab.text = useStr;
    
    
    NSString *numStr = [NSString stringWithFormat:@"共计：%ld味药",model.drugArr.count];
    if(model.excipentArr.count>0) {
        numStr = [NSString stringWithFormat:@"%@  %ld味辅料",numStr,model.excipentArr.count];
    }
    self.numLab.text = numStr;
    
  
    
    NSString *priceStr = model.isMy?  [NSString stringWithFormat:@"总价(元):%.3f     实收金额(元):%@", [model.recipe_sale_price floatValue] - [model.fee floatValue], model.recipe_sale_price ]: [NSString stringWithFormat:@"总价(元):%.3f   运费(元):%@      实收金额(元):%@", [model.recipe_sale_price floatValue] - [model.fee floatValue], model.fee, model.recipe_sale_price ];
    self.priceLab.text = priceStr;
    
    NSString *lastStr = [NSString stringWithFormat:@"医生机构:%@  医生:%@  时间:%@",[MedicineManager sharedInfo].hospitalModel.hospitalname, [MedicineManager sharedInfo].doctorModel.doctorname, [DateTimeTool stringFromDate:[NSDate date] DateFormat:@"yyyy-MM-dd"]];
    
    self.bottomLab.text = lastStr;
    
    
   
    height = height + [ClassMethod sizeText:info font:[UIFont systemFontOfSize:13] limitWidth:self.width - 30].height + 10;
   
    height = height + [ClassMethod sizeText:zz font:[UIFont systemFontOfSize:13] limitWidth:self.width - 30].height + 10;
    height = height + [ClassMethod sizeText:drug font:[UIFont systemFontOfSize:13] limitWidth:self.width - 30].height + 10;
    height = height + [ClassMethod sizeText:useStr font:[UIFont systemFontOfSize:13] limitWidth:self.width - 30].height + 10;
    height = height + 30;
    height = height + [ClassMethod sizeText:priceStr font:[UIFont systemFontOfSize:13] limitWidth:self.width - 30].height + 10;
    height = height + [ClassMethod sizeText:lastStr font:[UIFont systemFontOfSize:13] limitWidth:self.width - 30].height + 10;
    self.height = height + 30 + 40;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
