//
//  CreateRecipeTemplateListVC.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/23.
//

#import "CreateRecipeTemplateListVC.h"
#import <TYTabPagerBar.h>
#import <TYPagerView.h>
#import "RecipeTablesView.h"
@interface CreateRecipeTemplateListVC ()
<
TYPagerViewDataSource,
TYPagerViewDelegate,
TYTabPagerBarDataSource,
TYTabPagerBarDelegate
>
@property (weak, nonatomic) IBOutlet UITextField *textF;

@property (nonatomic, strong) TYTabPagerBar *tabBar;
@property (nonatomic, strong) TYPagerView *pageView;
@property (nonatomic ,strong) NSArray *datas;
@property (nonatomic, copy) NSString *keyWord;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation CreateRecipeTemplateListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"处方";
    self.datas = @[@"常用处方",@"系统处方",@"机构处方"];
    [self addPageTabBar];
    [self addPagerView];
    [self loadData];
    
    @weakify(self);
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
        [tf resignFirstResponder];
    }];
  
    // Do any additional setup after loading the view from its nib.
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
//    [self.pageView.layout registerClass:[UIView class] forItemWithReuseIdentifier:@"cellId"];
    [self.pageView.layout registerNib:[UINib nibWithNibName:@"RecipeTablesView" bundle:nil] forItemWithReuseIdentifier:@"cellId"];
    [self.view addSubview:self.pageView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.pageView.frame = CGRectMake(0, 115, WIDE, HIGHT - NAV_H - 115 - Indicator_H);
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
    return floor((WIDE - 30)/3.0);
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [self.pageView scrollToViewAtIndex:index animate:YES];
}

#pragma mark -- TYPagerViewDataSource
- (NSInteger)numberOfViewsInPagerView {
    return self.datas.count;
}

- (UIView *)pagerView:(TYPagerView *)pagerView viewForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    RecipeTablesView *subView =  [[NSBundle mainBundle]loadNibNamed:@"RecipeTablesView" owner:self options:nil].lastObject;
    subView.frame = [pagerView.layout frameForItemAtIndex:index];
    subView.currentTag = index;
    subView.recipesampleName = self.keyWord;
    [subView.subject subscribeNext:^(id  _Nullable x) {
        if(self.backBlockWithParam) {
            self.backBlockWithParam(@{@"drugArr":x});
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    return subView;
}

#pragma mark -- TYPagerViewDelegate
- (void)pagerView:(TYPagerView *)pagerView transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [self.tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

- (void)pagerView:(TYPagerView *)pagerView transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
   
    [self.tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
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
