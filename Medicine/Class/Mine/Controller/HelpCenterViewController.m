//
//  HelpCenterViewController.m
//  Medicine
//
//  Created by 张智慧 on 2024/9/29.
//

#import "HelpCenterViewController.h"
#import "HelpTableViewCell.h"

@interface HelpCenterViewController ()
<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *content;

@end

@implementation HelpCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"帮助中心";
    
    [self requestHelpCenter];
    // Do any additional setup after loading the view from its nib.
}

- (void)requestHelpCenter {
    [[RequestManager shareInstance]requestWithMethod:POST url:HelpCenterURL dict:nil finished:^(id request) {
        if([[request allKeys]containsObject:@"content"]) {
            self.content = request[@"content"];
            [self.tableView reloadData];
        }
       
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark -- UITableViewDelegate && DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HelpTableViewCell *cell = [HelpTableViewCell getTableView:tableView indexPathWith:indexPath];
    cell.contentLab.text = self.content;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    return [HelpTableViewCell getCellHeightWith:self.content];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
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
