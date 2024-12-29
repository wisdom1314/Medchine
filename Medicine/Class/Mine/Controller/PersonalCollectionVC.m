//
//  PersonalCollectionVC.m
//  Medicine
//
//  Created by 张智慧 on 2024/12/26.
//

#import "PersonalCollectionVC.h"
#import "PersonalCollectionTableViewCell.h"

@interface PersonalCollectionVC ()
<UITableViewDelegate,
UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PersonalCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"个人信息收集清单";
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -- UITableViewDelegate && DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalCollectionTableViewCell *cell = [PersonalCollectionTableViewCell getTableView:tableView indexPathWith:indexPath];
    @weakify(self);
    [[cell.subject takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self pushVC:@"PersonalDetailVC" param:@{@"tag": x} animated:YES];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return [PersonalCollectionTableViewCell getCellHeightWith:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
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
