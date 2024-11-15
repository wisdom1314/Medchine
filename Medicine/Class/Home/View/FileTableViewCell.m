//
//  FileTableViewCell.m
//  Medicine
//
//  Created by 张智慧 on 2024/11/15.
//

#import "FileTableViewCell.h"
@interface FileTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *fileNameLab;
@property (weak, nonatomic) IBOutlet UILabel *sizeLab;
@end

@implementation FileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)getTableView:(UITableView *)tableView indexPathWith:(NSIndexPath *)indexPath {
    FileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FileTableViewCellId"];
    if(!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FileTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
    return cell;
}

+ (CGFloat)getCellHeight {
    return 60;
}


- (void)setModel:(idCardImgModel *)model {
    _model = model;
    self.fileNameLab.text = model.fileName;
    self.sizeLab.text = [ClassMethod fileSizeStringFromBytesString:model.fileSize];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
