//
//  AuthorityViewController.m
//  Medicine
//
//  Created by 张智慧 on 2024/12/24.
//

#import "AuthorityViewController.h"
#import "AuthorityViewCell.h"

@interface AuthorityViewController ()
<UITableViewDelegate,
UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AuthorityViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"系统权限管理";
    // Do any additional setup after loading the view from its nib.
}

- (NSString *)checkCameraPermission {
    NSString *statusName = @"";
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    switch (status) {
        case AVAuthorizationStatusNotDetermined:
            statusName = @"权限未确定，需要请求权限";
            break;
        case AVAuthorizationStatusRestricted:
            statusName = @"不允许访问";
            break;
        case AVAuthorizationStatusDenied:
            statusName = @"不允许访问";
            break;
        case AVAuthorizationStatusAuthorized:
            statusName = @"允许访问";
            break;
        default:
            break;
    }
    return statusName;
}

- (NSString *)checkPhotoLibraryPermission {
    NSString *statusName = @"";
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusNotDetermined:
            //            statusName = @"权限未确定，需要请求权限";
            statusName = @"不允许访问";
            break;
        case PHAuthorizationStatusRestricted:
            statusName = @"不允许访问";
            break;
        case PHAuthorizationStatusDenied:
            statusName = @"不允许访问";
            break;
        case PHAuthorizationStatusAuthorized:
            statusName = @"允许访问";
            break;
        case PHAuthorizationStatusLimited:
            statusName = @"有限的访问权限";
            break;
        default:
            break;
    }
    return statusName;
}


#pragma mark -- UITableViewDelegate && DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AuthorityViewCell *cell = [AuthorityViewCell getTableView:tableView indexPathWith:indexPath];
    //    if(indexPath.row == 0) {
    //        cell.headLab.text = @"存储权限";
    //        cell.detaiInfoLab.text = @"用于应用内更新";
    //    }else
    if(indexPath.row == 0) {
        cell.headLab.text = @"访问相机权限";
        cell.detaiInfoLab.text = @"为方便使用拍摄功能";
        cell.permissionLab.text = [self checkCameraPermission];
        
    }else if(indexPath.row == 1) {
        cell.headLab.text = @"访问相册权限";
        cell.detaiInfoLab.text = @"为方便使用图片保存、上传功能";
        cell.permissionLab.text = [self checkPhotoLibraryPermission];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return [AuthorityViewCell getCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) { // 假设第一行是访问相册
        [self requestCameraAccess];
        
    }
    // 判断是否是相机
    else if (indexPath.row == 1) { // 假设第二行是访问相机
        [self requestPhotoLibraryAccess];
    }
}

- (void)requestCameraAccess {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (status == AVAuthorizationStatusNotDetermined) {
        // 请求相机权限
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                // 相机权限已授权
                // 你可以在这里打开相机
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            } else {
                // 相机权限被拒绝
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        }];
    } else if (status == AVAuthorizationStatusAuthorized) {
        // 相机权限已授权
        // 你可以在这里打开相机
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    } else {
        // 相机权限被拒绝
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

// 请求相册权限
- (void)requestPhotoLibraryAccess {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        // 请求相册权限
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                // 相册权限已授权
                // 你可以在这里打开相册
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            } else {
                // 相册权限被拒绝
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
        }];
    } else if (status == PHAuthorizationStatusAuthorized) {
        // 相册权限已授权
        // 你可以在这里打开相册
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    } else {
        // 相册权限被拒绝
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
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
