//
//  DoctorTableViewCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/11/14.
//

#import "DoctorTableViewCell.h"
#import "FileTableViewCell.h"
@interface DoctorTableViewCell()
 <UITableViewDelegate,
UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *sexLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *idcardLab;
@property (weak, nonatomic) IBOutlet UIImageView *statusImgView;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;


@property (weak, nonatomic) IBOutlet UIImageView *arrowImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowRightWidth1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowRightWidth2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowRightWidth3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowRightWidth4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowRightWidth5;
@property (weak, nonatomic) IBOutlet UILabel *ksLLab;
@property (weak, nonatomic) IBOutlet UILabel *levelLab;
@property (weak, nonatomic) IBOutlet UILabel *yearLab;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;

@property (weak, nonatomic) IBOutlet UIImageView *managerSignImgView;
@property (weak, nonatomic) IBOutlet UIImageView *businessImgView;
@property (weak, nonatomic) IBOutlet UIImageView *hospitalImgView;
@property (weak, nonatomic) IBOutlet UILabel *bottomLab;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fileHeight;
@property (nonatomic, copy) NSMutableArray *fileArray;

@end

@implementation DoctorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath modelWith:(PromoteUserModel *)model{
    
    NSInteger selectTag = 0;
    NSString *identifier = @"DoctorTableViewCellFristId";
//    if([model.status integerValue] != 10) {
//        if(indexPath.row == 0) {
//            selectTag = 0;
//            identifier = @"DoctorTableViewCellFristId";
//        }else if(indexPath.row == 1) {
//            selectTag = 1;
//            identifier = @"DoctorTableViewCellSecondId";
//        }else if(indexPath.row == 2) {
//            selectTag = 2;
//            identifier = @"DoctorTableViewCellThridId";
//        }else {
//            selectTag = 3;
//            identifier = @"DoctorTableViewCellForthId";
//        }
//    }else {
//        if(indexPath.row == 0) {
//            selectTag = 1;
//            identifier = @"DoctorTableViewCellSecondId";
//        }else if(indexPath.row == 1) {
//            selectTag = 2;
//            identifier = @"DoctorTableViewCellThridId";
//        }else {
//            selectTag = 3;
//            identifier = @"DoctorTableViewCellForthId";
//        }
//    }
//    
    if(indexPath.row == 0) {
        selectTag = 0;
        identifier = @"DoctorTableViewCellFristId";
    }else if(indexPath.row == 1) {
        selectTag = 1;
        identifier = @"DoctorTableViewCellSecondId";
    }else if(indexPath.row == 2) {
        selectTag = 2;
        identifier = @"DoctorTableViewCellThridId";
    }else {
        selectTag = 3;
        identifier = @"DoctorTableViewCellForthId";
    }
    
    DoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"DoctorTableViewCell" owner:self options:nil]objectAtIndex:selectTag];
    }
    return cell;
}


+ (CGFloat)getCellHeightWith:(NSIndexPath *)indexPath modelWith:(PromoteUserModel *)model {
//    if([model.status integerValue] != 10) {
//        if(indexPath.row == 0) {
//            if([model.status integerValue] == 30) {
//                return [ClassMethod sizeText:model.reviewRemark font:[UIFont systemFontOfSize:13] limitWidth:WIDE - 113].height>16? 74 + [ClassMethod sizeText:model.reviewRemark font:[UIFont systemFontOfSize:13] limitWidth:WIDE - 113].height : 90;
//            }
//            return 90;
//        }else if (indexPath.row == 1) {
//            return 270;
//        }else if (indexPath.row == 2) {
//            return 385;
//        }else {
//            return 950 + 60*model.attachFiles.count;
//        }
//    }else {
//        if(indexPath.row == 0) {
//            return 270;
//        }else if (indexPath.row == 1) {
//            return 385;
//        }else {
//            return 950 + 60*model.attachFiles.count;
//        }
//    }
    if(indexPath.row == 0) {
        if([model.status integerValue] == 30) {
            return [ClassMethod sizeText:model.reviewRemark font:[UIFont systemFontOfSize:13] limitWidth:WIDE - 113].height>16? 74 + [ClassMethod sizeText:model.reviewRemark font:[UIFont systemFontOfSize:13] limitWidth:WIDE - 113].height : 90;
        }
        return 90;
    }else if (indexPath.row == 1) {
        return 270;
    }else if (indexPath.row == 2) {
        return 385;
    }else {
        return 950 + 60*model.attachFiles.count;
    }
}


- (void)setModel:(PromoteUserModel *)model {
    _model = model;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:model.managerAvatar] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    self.sexLab.text = [model.managerSex integerValue] == 0?@"男":@"女";
    self.phoneLab.text = model.phonenumber;
    self.idcardLab.text = model.managerIdcard;
    self.nameLab.text = model.managerName;
    self.ksLLab.text = model.managerDeptName;
    self.levelLab.text = model.managerTitleName.length>0? model.managerTitleName: @"暂无";
    if(([model.status integerValue] == 10 && [model.reviewable boolValue] == YES)) {
        self.arrowRightWidth1.constant = 20;
        self.arrowRightWidth2.constant = 20;
        self.arrowRightWidth3.constant = 20;
        self.arrowRightWidth4.constant = 20;
        self.arrowRightWidth5.constant = 20;
        self.cardTextF.enabled = YES;
        self.hosNameTextF.enabled = YES;
        self.chooseAreaBtn.enabled = YES;
        self.chooseCardBtn.enabled = YES;
        self.chooseMedBtn.enabled = YES;
        
        
    }else {
        self.arrowRightWidth1.constant = 0;
        self.arrowRightWidth2.constant = 0;
        self.arrowRightWidth3.constant = 0;
        self.arrowRightWidth4.constant = 0;
        self.arrowRightWidth5.constant = 0;
        self.cardTextF.enabled = NO;
        self.hosNameTextF.enabled = NO;
        self.chooseAreaBtn.enabled = NO;
        self.chooseCardBtn.enabled = NO;
        self.chooseMedBtn.enabled = NO;
        if([model.status integerValue] == 11) {
            self.statusLab.text = @"待复核";
            self.statusImgView.image = [UIImage imageNamed:@"time-circle-filled"];
            self.detailLab.hidden = NO;
            self.top.constant = 14;
        }else if([model.status integerValue] == 30) {
            self.statusImgView.image = [UIImage imageNamed:@"close-circle-filled"];
            self.statusLab.text = @"已拒绝";
            self.detailLab.hidden = NO;
            self.detailLab.text = model.reviewRemark;
            self.top.constant = 14;
        }else if([model.status integerValue] == 20) {
            self.statusImgView.image = [UIImage imageNamed:@"check-circle-filled"];
            self.statusLab.text = @"已审核";
            self.detailLab.hidden = YES;
            self.top.constant = 34;
        }
    }
    if((([model.status integerValue] == 10 && [model.reviewable boolValue] == YES)) && model.certNo.length == 0) {
        self.cardTextF.placeholder = @"请输入证件号";
        
    }else {
        self.cardTextF.placeholder = @"";
    }
    self.cardTextF.text = model.certNo;
   
    self.hosNameTextF.text = model.hospitalname;
    if(model.area.length >0) {
        [self.chooseAreaBtn setTitleColor:COLOR_562306 forState:UIControlStateNormal];
        [self.chooseAreaBtn setTitle:[NSString stringWithFormat:@"%@,%@,%@", model.province, model.city, model.area] forState:UIControlStateNormal];
    }else {
        [self.chooseAreaBtn setTitleColor:COLOR_DFDFDF forState:UIControlStateNormal];
        if(([model.status integerValue] == 10 && [model.reviewable boolValue] == YES)) {
            [self.chooseAreaBtn setTitle:@"请选择所属地区" forState:UIControlStateNormal];
        }else {
            [self.chooseAreaBtn setTitle:@"" forState:UIControlStateNormal];
        }
    }
    
    if(model.certTypeName.length >0) {
        [self.chooseCardBtn setTitleColor:COLOR_562306 forState:UIControlStateNormal];
        [self.chooseCardBtn setTitle:model.certTypeName forState:UIControlStateNormal];
    }else {
        [self.chooseCardBtn setTitleColor:COLOR_DFDFDF forState:UIControlStateNormal];
        if(([model.status integerValue] == 10 && [model.reviewable boolValue] == YES)) {
            [self.chooseCardBtn setTitle:@"请选择证件类型" forState:UIControlStateNormal];
        }else {
            [self.chooseCardBtn setTitle:@"" forState:UIControlStateNormal];
        }
    }
    
    
    if(model.pharmacyModel.simpleName.length>0) {
        [self.chooseMedBtn setTitleColor:COLOR_562306 forState:UIControlStateNormal];
        [self.chooseMedBtn setTitle:model.pharmacyModel.simpleName forState:UIControlStateNormal];
    }else {
        [self.chooseMedBtn setTitleColor:COLOR_DFDFDF forState:UIControlStateNormal];
        if(([model.status integerValue] == 10 && [model.reviewable boolValue] == YES)) {
            [self.chooseMedBtn setTitle:@"请选择所属药房" forState:UIControlStateNormal];
        }else {
            [self.chooseMedBtn setTitle:@"" forState:UIControlStateNormal];
        }
    }
    
    self.yearLab.text = [NSString stringWithFormat:@"%@年",model.managerDoctorYears];
    [self.managerSignImgView sd_setImageWithURL:[NSURL URLWithString:model.managerSignUrl]];
    [self.hospitalImgView sd_setImageWithURL:[NSURL URLWithString:model.hospitalLicenseFileModel.url]];
    [self.businessImgView sd_setImageWithURL:[NSURL URLWithString:model.businessLicenseFileModel.url]];
    
    
    self.fileArray = model.attachFiles.mutableCopy;
    if(self.fileArray.count>0) {
        [self.tableView reloadData];
    }
    self.fileHeight.constant = 60*self.fileArray.count;
    
    NSString *text = @"《质量保证协议》、《法人授权委托书》两份资质需要打印加盖鲜章，并以纸质资料快递审核联系地址：湖北黄石经济技术开发区金山街道圣明路9号 陈女士 0714-3188923";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    // 设置普通文本颜色
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:COLOR_562306
                             range:NSMakeRange(0, text.length)];
    NSRange range1 = [text rangeOfString:@"《质量保证协议》"];
   
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"http://zhyf-h5.sfrog.cn/static/files/%E6%B3%95%E4%BA%BA%E6%8E%88%E6%9D%83%E5%A7%94%E6%89%98%E4%B9%A6.pdf"
                             range:range1];
//    [attributedString addAttribute:NSForegroundColorAttributeName
//                             value:MainColor
//                             range:range1];
   
    
    NSRange range2 = [text rangeOfString:@"《法人授权委托书》"];
//    [attributedString addAttribute:NSForegroundColorAttributeName
//                             value:MainColor
//                             range:range2];
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"http://zhyf-h5.sfrog.cn/static/files/%E6%B3%95%E4%BA%BA%E6%8E%88%E6%9D%83%E5%A7%94%E6%89%98%E4%B9%A6.pdf"
                             range:range2];
    self.remarkTextView.tintColor = MainColor;
    self.remarkTextView.attributedText = attributedString;
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fileArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FileTableViewCell *cell = [FileTableViewCell getTableView:tableView indexPathWith:indexPath];
    idCardImgModel *subModel = self.fileArray[indexPath.row];
    cell.model = subModel;
    @weakify(self);
    [[[cell.downBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"提示" message:@"是否下载该文件？"];
        alertView.buttonHeight = 40;
        alertView.buttonFont = [UIFont systemFontOfSize:14];
        alertView.layer.masksToBounds = YES;
        alertView.layer.cornerRadius = 4.0f;
        alertView.buttonDestructiveBgColor = MainColor;
        [alertView addAction:[TYAlertAction actionWithTitle:@"取消" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
        }]];
        [alertView addAction:[TYAlertAction actionWithTitle:@"确定" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {
            [self downloadAndSaveImageToAlbumWith:subModel.url];
        }]];
        [alertView showInWindow];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [FileTableViewCell getCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (NSMutableArray *)fileArray {
    if(!_fileArray) {
        _fileArray = [NSMutableArray array];
    }
    return _fileArray;
}

- (void)downloadAndSaveImageToAlbumWith:(NSString *)urlStr {
  
    NSURL *url = [NSURL URLWithString: urlStr];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        if (error) {
          
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [ZZProgress showErrorWithStatus:@"下载失败"];
            });
            return;
        }
        
        // 加载下载到的图片
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
        
        if (image) {
            // 保存图片到相册
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            dispatch_async(dispatch_get_main_queue(), ^{
                [ZZProgress showSuccessWithStatus:@"图片已保存到相册"];
            });

            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ZZProgress showErrorWithStatus:@"该文件不能保存"];
            });
           
        }
    }];
    
    [downloadTask resume];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
