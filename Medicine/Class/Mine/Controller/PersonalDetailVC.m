//
//  PersonalDetailVC.m
//  Medicine
//
//  Created by 张智慧 on 2024/12/29.
//

#import "PersonalDetailVC.h"
#import "PersonalDetailCell.h"

@interface PersonalDetailVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger tagNum;

@end

@implementation PersonalDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"个人信息收集清单";
    self.tagNum = [[self.param valueForKey:@"tag"]integerValue];
    NSLog(@"sdsdsd %@", @(self.tagNum));
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -- UITableViewDelegate && DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalDetailCell *cell = [PersonalDetailCell getTableView:tableView indexPathWith:indexPath];
    cell.secondDetailInfoLab.hidden = YES;
    if(self.tagNum == 200) {
        cell.topTitleLab.text = @"【患者名字】收集情况";
        cell.deviceNameLab.text = @"创建处方、处方搜索";
        cell.detailInfoLab.text = @"1.用于创建处方时输入患者姓名";
        cell.secondDetailInfoLab.hidden = NO;
        cell.secondDetailInfoLab.text = @"2.用于在处方列表搜索患者姓名搜索处方";
    }else if(self.tagNum == 201) {
        cell.topTitleLab.text = @"【手机号】收集情况";
        cell.deviceNameLab.text = @"创建处方";
        cell.detailInfoLab.text = @"用于创建处方时输入手机号";
    }else if(self.tagNum == 202) {
        cell.topTitleLab.text = @"【详细地址】收集情况";
        cell.deviceNameLab.text = @"创建处方";
        cell.detailInfoLab.text = @"用于创建处方时输入详细地址";
    }else if(self.tagNum == 203) {
        cell.topTitleLab.text = @"【性别】收集情况";
        cell.deviceNameLab.text = @"创建处方";
        cell.detailInfoLab.text = @"用于创建处方时输入性别";
    }else if(self.tagNum == 204) {
        cell.topTitleLab.text = @"【年龄】收集情况";
        cell.deviceNameLab.text = @"创建处方";
        cell.detailInfoLab.text = @"用于创建处方时输入年龄";
    }else if(self.tagNum == 300) {
        cell.topTitleLab.text = @"【设备型号和名称】收集情况";
        cell.deviceNameLab.text = @"用于兼容性判断和安全保障等";
        cell.detailInfoLab.text = @"使用APP过程中";
    }else if(self.tagNum == 301) {
        cell.topTitleLab.text = @"【操作系统版本】收集情况";
        cell.deviceNameLab.text = @"用于兼容性判断和安全保障等";
        cell.detailInfoLab.text = @"使用APP过程中";
    }else if(self.tagNum == 400) {
        cell.topTitleLab.text = @"【图片】收集情况";
        cell.deviceNameLab.text = @"创建处方";
        cell.detailInfoLab.text = @"用于创建处方时上传症状图片";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return [PersonalDetailCell getCellHeightWith:indexPath];
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
