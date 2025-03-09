//
//  RecipeDetailStatusVC.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/8.
//

#import "RecipeDetailStatusVC.h"
#import "RecipeDetailTableViewCell.h"
#import "RecipeLogTableViewCell.h"
#import "HomeModel.h"
#import "NoDataTableViewCell.h"
#import "RecipeHosTableViewCell.h"
#import "CreateRecipeViewController.h"
#import "MyCreateRecipeViewController.h"
#import "ZZBigView.h"
#import "SendMessageView.h"

@interface RecipeDetailStatusVC ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (weak, nonatomic) IBOutlet UIView *detailBackView;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic, copy) NSString *recipe_name;
@property (nonatomic, strong) RecipeOrderDetailModel *detailModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;

@end

@implementation RecipeDetailStatusVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recipe_name = [self.param valueForKey:@"recipe_name"];
    self.detailModel = [[RecipeOrderDetailModel alloc]init];
    self.detailModel.otherPay = YES;
    self.bottomViewHeight.constant = 0;
    
    [self rightViewShowWithImg:@"reload_white" titleWith:nil actionWith:@selector(reload)];
    
    self.navTitle = @"待支付";
    self.detailBackView.backgroundColor =  COLOR_F8F5EF;
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDE, HIGHT-NAV_H-Indicator_H-(self.detailModel.otherPay?0:60)) style:UITableViewStyleGrouped];
    tableView.backgroundColor = COLOR_F8F5EF;
    tableView.separatorColor = COLOR_F8F5EF;
    tableView.delegate = self;
    tableView.dataSource = self;
   
    if (@available(iOS 11.0, *)) {
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        
    }
    
    self.tableView = tableView;
    [self.detailBackView addSubview:self.tableView];
  

    [self requestDetail];
    // Do any additional setup after loading the view from its nib.
}

- (void)reload {
    
}

- (IBAction)openClick:(UIButton *)sender {
    if(sender.tag == 10) {
        
    }else {
        
    }
}

- (void)requestDetail {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.recipe_name forKey:@"recipe_name"];
    [[RequestManager shareInstance]requestWithMethod:POST url:SeeRecipeURL dict:dic hasHeader:YES finished:^(id request) {
        RecipeOrderDetailModel *model = [RecipeOrderDetailModel mj_objectWithKeyValues:request];
        model.recipeModel = [RecipeOrderItemModel mj_objectWithKeyValues:model.recipe];
        for (DrugItemModel *subModel in model.recipedetail) {
            NSDecimalNumber *numDecimal = [NSDecimalNumber decimalNumberWithString: subModel.herb_dose];
            NSString *numString = [NSString stringWithFormat:@"%@", numDecimal];
            subModel.herb_dose = numString;
            
            NSDecimalNumber *numDecimalr = [NSDecimalNumber decimalNumberWithString: subModel.equivalent];
            NSString *numStringr = [NSString stringWithFormat:@"%@", numDecimalr];
            subModel.equivalent = numStringr;
            
            if(subModel.herb_factor.length> 0 &&[subModel.herb_factor floatValue]<1) {
                subModel.granule_name = [NSString stringWithFormat:@"%@[新标准]", subModel.granule_name];
            }
            
        }
        self.detailModel =  model;
        self.detailModel.otherPay = YES;
        [self.tableView reloadData];
        
    } failed:^(NSError *error) {
        
    }];
}




#pragma mark -- UITableViewDelegate && DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [RecipeDetailTableViewCell getPayCellHeightWith:indexPath modelWith:self.detailModel.recipeModel detailModelWith:self.detailModel];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    RecipeDetailTableViewCell *cell = [RecipeDetailTableViewCell getPayTableView:tableView indexPathWith:indexPath];
    cell.model = self.detailModel.recipeModel;
    cell.detailModel = self.detailModel;
    @weakify(self);
    [[[cell.expandBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.detailModel.isExpand = !self.detailModel.isExpand;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section],nil] withRowAnimation:UITableViewRowAnimationFade];
    }];
    [[[cell.sendMsgBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        SendMessageView *promptView = [SendMessageView createViewFromNib];
        TYAlertController *alertVC =  [TYAlertController alertControllerWithAlertView:promptView preferredStyle:TYAlertControllerStyleAlert];
        alertVC.backgoundTapDismissEnable = NO;
        [[promptView.closeBtn   rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            [alertVC dismissViewControllerAnimated:YES];
        }];
        [[promptView.cacelBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            [alertVC dismissViewControllerAnimated:YES];
        }];
        [[promptView.sendBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
           
            [alertVC dismissViewControllerAnimated:YES];
        }];
        [self presentViewController:alertVC animated:YES completion:nil];
       
    }];
    [[[cell.sendWXBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
       
    }];
    return cell;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
