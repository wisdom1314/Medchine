//
//  AuthorityViewController.m
//  Medicine
//
//  Created by 张智慧 on 2024/12/24.
//

#import "AuthorityViewController.h"

@interface AuthorityViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AuthorityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"系统权限管理";
    // Do any additional setup after loading the view from its nib.
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
