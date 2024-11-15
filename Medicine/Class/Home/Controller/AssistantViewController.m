//
//  AssistantViewController.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/11.
//

#import "AssistantViewController.h"
#import <TYTabPagerBar.h>
#import <TYPagerView.h>
#import "CustomRecipeTablesView.h"
#import "PromoteAlertView.h"
@interface AssistantViewController ()
<
TYPagerViewDataSource,
TYPagerViewDelegate,
TYTabPagerBarDataSource,
TYTabPagerBarDelegate,
UITextFieldDelegate
>
@property (nonatomic, copy) NSArray *datas;
@property (nonatomic, copy) NSString *keyWord;
@property (nonatomic, strong) TYTabPagerBar *tabBar;
@property (nonatomic, strong) TYPagerView *pageView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) PromoteAlertView *alertView;
@property (nonatomic, copy) NSString *date1;
@property (nonatomic, copy) NSString *date2;
@end

@implementation AssistantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datas = @[@"全部",@"待审核",@"已通过", @"已拒绝"];
    [self initialize];
    
    @weakify(self);
    [self.alertView.commitSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.date1 = [x valueForKey:@"date1"];
        self.date2 = [x valueForKey:@"date2"];
        self.currentIndex = self.pageView.curIndex;
        [self.pageView reloadData];
        [self.pageView scrollToViewAtIndex:self.currentIndex animate:NO];
    }];
//    [self.view addSubview:self.alertView];

    self.alertView.frame = CGRectMake(0, NAV_H, WIDE, HIGHT - NAV_H);
    [[UIApplication sharedApplication].keyWindow addSubview:self.alertView];
    // Do any additional setup after loading the view.
}

- (void)initialize {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(15, 10, WIDE - 15, 45)];
    [self.view addSubview:headerView];
    UIButton *filterBtn = [[UIButton alloc]init];
    [filterBtn setImage:[UIImage imageNamed:@"icon_screen"] forState:UIControlStateNormal];
    [headerView addSubview:filterBtn];
    [filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView.mas_right).offset(-10);
        make.width.height.mas_equalTo(45);
        make.centerY.equalTo(headerView.mas_centerY);
    }];
    @weakify(self)
    [[filterBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.alertView show];
    }];
    
    UIView *searchView = [[UIView alloc]init];
    searchView.backgroundColor = COLOR_FFFFFF;
    searchView.layer.masksToBounds = YES;
    searchView.layer.cornerRadius = 4;
    [headerView addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(0); // 左边距离父视图为 0
        make.top.equalTo(headerView.mas_top).offset(5); // 顶部距离父视图为 0
        make.bottom.equalTo(headerView.mas_bottom).offset(-5); // 底部距离父视图为 0
        make.right.equalTo(filterBtn.mas_left).offset(-5);
    }];
    
    UIImageView *searchImg = [ClassMethod createImgViewFrameWith:CGRectMake(10, 10, 15, 15) imageNamed:@"icon_search"];
    [searchView addSubview:searchImg];
    
    UITextField *searchTextF = [[UITextField alloc]initWithFrame:CGRectMake(40, 0, WIDE - 120,  35)];
    searchTextF.returnKeyType = UIReturnKeySearch;
    searchTextF.placeholder = @"请输入电话号码/姓名";
    searchTextF.borderStyle = UITextBorderStyleNone;
    searchTextF.font = [UIFont systemFontOfSize:14];
    searchTextF.textAlignment = NSTextAlignmentLeft;
    searchTextF.delegate = self;
    [[self rac_signalForSelector:@selector(textFieldDidEndEditing:) fromProtocol:@protocol(UITextFieldDelegate)]subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        UITextField *tf = tuple.first;
        self.keyWord = tf.text;
        self.currentIndex = self.pageView.curIndex;
        [self.pageView reloadData];
        [self.pageView scrollToViewAtIndex:self.currentIndex animate:NO];
    }];
    
    [[self rac_signalForSelector:@selector(textFieldShouldReturn:) fromProtocol:@protocol(UITextFieldDelegate)]
     subscribeNext:^(RACTuple *tuple) {
        UITextField *tf = tuple.first;
        // 如果需要关闭键盘
        [tf resignFirstResponder];
    }];
    
    [searchView addSubview:searchTextF];
    
    [self addPageTabBar];
    [self addPagerView];
    [self loadData];
    
    
}

- (void)addPageTabBar {
    self.tabBar = [[TYTabPagerBar alloc]initWithFrame:CGRectMake(15, 65, WIDE-30, 40)];
    self.tabBar.layout.barStyle = TYPagerBarStyleCoverView;
    self.tabBar.layout.normalTextColor = COLOR_562306;
    self.tabBar.layout.selectedTextColor = COLOR_FFFFFF;
    self.tabBar.layout.progressColor = MainColor;
    self.tabBar.layout.normalTextFont = [UIFont systemFontOfSize:14];
    self.tabBar.layout.selectedTextFont = [UIFont systemFontOfSize:14];
    self.tabBar.layout.cellSpacing = 0;
    self.tabBar.layout.cellEdging = 0;
    self.tabBar.dataSource = self;
    self.tabBar.delegate = self;
    [self.tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    [self.view addSubview:self.tabBar];
}


- (void)addPagerView {
    self.pageView = [[TYPagerView alloc]init];
    self.pageView.scrollView.bounces = NO;
    self.pageView.layout.autoMemoryCache = NO;
    self.pageView.dataSource = self;
    self.pageView.delegate = self;
    [self.pageView.layout registerNib:[UINib nibWithNibName:@"CustomRecipeTablesView" bundle:nil] forItemWithReuseIdentifier:@"cellId"];
    [self.view addSubview:self.pageView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
 
    self.pageView.frame = CGRectMake(0, 115, WIDE, self.view.height - 115 - Indicator_H);
}


- (void)reloadData {
    [self.tabBar reloadData];
    [self.pageView reloadData];
}

- (void)loadData {
    [self reloadData];
}


#pragma mark -- TYTabPagerBarDataSource

- (NSInteger)numberOfItemsInPagerTabBar {
    return self.datas.count;
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = self.datas[index];
    return cell;
}


#pragma mark -- TYTabPagerBarDelegate
- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    return floor((WIDE - 30)/4.0);
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [self.pageView scrollToViewAtIndex:index animate:YES];
}

#pragma mark -- TYPagerViewDataSource
- (NSInteger)numberOfViewsInPagerView {
    return self.datas.count;
}

- (UIView *)pagerView:(TYPagerView *)pagerView viewForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    CustomRecipeTablesView *subView =  [[NSBundle mainBundle]loadNibNamed:@"CustomRecipeTablesView" owner:self options:nil].lastObject;
    subView.frame = [pagerView.layout frameForItemAtIndex:index];
   
    if([[self.param allKeys]containsObject:@"promoteUserId"]) {
        subView.userId = self.param[@"promoteUserId"];
    }else {
        subView.userId = [MedicineManager sharedInfo].customModel.userId;
    }
    subView.keyWord = self.keyWord;
    subView.date1 = self.date1;
    subView.date2 = self.date2;
    subView.type = index;
    
    return subView;
}

#pragma mark -- TYPagerViewDelegate
- (void)pagerView:(TYPagerView *)pagerView transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [self.tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

- (void)pagerView:(TYPagerView *)pagerView transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
   
    [self.tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

- (PromoteAlertView *)alertView {
    if(!_alertView) {
        _alertView = [[NSBundle mainBundle]loadNibNamed:@"PromoteAlertView" owner:self options:nil].lastObject;
//        _alertView.frame = CGRectMake(0, NAV_H, WIDE, HIGHT - NAV_H);
    }
    return _alertView;
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
