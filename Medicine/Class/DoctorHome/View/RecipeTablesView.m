//
//  RecipeTablesView.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/24.
//

#import "RecipeTablesView.h"
#import "LeftTableViewCell.h"
#import "RightTableViewCell.h"
#import "RightTableHeaderView.h"
#import "HomeModel.h"
#import "RecipeSampleView.h"

@interface RecipeTablesView()
<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (nonatomic, assign) NSInteger currentSection;
@property (nonatomic, assign) NSInteger tap;
@property (nonatomic, copy) NSString *isSystem;
@property (nonatomic, copy) NSString *isHospital;
@property (nonatomic, copy) NSString *isSelf;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong)  TYAlertController *alertVC ;



@end

@implementation RecipeTablesView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.rightTableView registerNib:[UINib nibWithNibName:@"RightTableHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"RightTableHeaderViewId"];
    
    if (@available(iOS 11.0, *)) {
        self.rightTableView.estimatedRowHeight = 0;
        self.rightTableView.estimatedSectionFooterHeight = 0;
        self.rightTableView.estimatedSectionHeaderHeight = 0;
        self.rightTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        
    }
    
}



- (void)setCurrentTag:(NSInteger)currentTag {
    _currentTag = currentTag;
    if(currentTag == 0) {
        self.isSelf = @"1";
        self.isSystem = @"0";
        self.isHospital = @"0";
    }else if(currentTag == 1) {
        self.isSelf = @"0";
        self.isSystem = @"1";
        self.isHospital = @"0";
    }else {
        self.isSelf = @"0";
        self.isSystem = @"0";
        self.isHospital = @"1";
    }
//    [self requestData];
}

- (void)setRecipesampleName:(NSString *)recipesampleName {
    _recipesampleName = recipesampleName;
    [self requestData];
}


- (void)requestData {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.isSystem forKey:@"isSystem"];
    [dic setValue:self.recipesampleName forKey:@"recipesampleName"];
    [dic setValue:self.isHospital forKey:@"isHospital"];
    [dic setValue:self.isSelf forKey:@"isSelf"];
    [[RequestManager shareInstance]requestWithMethod:GET url:CategorySampleListURL dict:dic hasHeader:YES finished:^(id request) {

        CategoryTemplateListModel *listModel = [CategoryTemplateListModel mj_objectWithKeyValues:request];
        self.dataArray = listModel.data.mutableCopy;
        
        [self.leftTableView reloadData];
        [self.rightTableView reloadData];
       
    } failed:^(NSError *error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableView.tag == 0) {
        return 1;
    }else {
        return self.dataArray.count;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView.tag == 0) {
        return self.dataArray.count;
    }else {
        CategoryTemplateItemModel *subModel = self.dataArray[section];
        return subModel.recipeList.count>0?subModel.recipeList.count: 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView.tag == 0) {
        return [LeftTableViewCell getCellHeight];
    }else {
        CategoryTemplateItemModel *subModel = self.dataArray[indexPath.section];
        return subModel.recipeList.count>0?[RightTableViewCell getCellHeight]: 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return tableView.tag == 0? 0.01: 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section  {
    if(tableView.tag == 1) {
        RightTableHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"RightTableHeaderViewId"];
        CategoryTemplateItemModel *subModel = self.dataArray[section];
        headerView.headLab.text = [NSString stringWithFormat:@"%@(%ld)",subModel.categoryName, subModel.recipeList.count];
        return headerView;
    }else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView.tag == 0) {
        LeftTableViewCell *cell = [LeftTableViewCell getTableView:tableView indexPathWith:indexPath];
        CategoryTemplateItemModel *subModel = self.dataArray[indexPath.row];
        if(self.currentSection == indexPath.row) {
            cell.backView.backgroundColor = COLOR_FFFFFF;
            cell.lineView.hidden = NO;
        }else {
            cell.backView.backgroundColor = COLOR_F8F5EF;
            cell.lineView.hidden = YES;
        }
        cell.nameLab.text = [NSString stringWithFormat:@"%@(%ld)",subModel.categoryName, subModel.recipeList.count];
        return cell;
    }else {
        CategoryTemplateItemModel *subModel = self.dataArray[indexPath.section];
        if(subModel.recipeList.count>0) {
            RightTableViewCell *cell = [RightTableViewCell getTableView:tableView indexPathWith:indexPath];
            RecipesampleSymptomsModel *symModel = subModel.recipeList[indexPath.row];
            cell.model = symModel;
            @weakify(self)
            [[[cell.openBtn rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                RecipeSampleView *sheetView = [[NSBundle mainBundle]loadNibNamed:@"RecipeSampleView" owner:self options:nil].lastObject;
                symModel.parentName = subModel.categoryName;
                sheetView.model = symModel;
                [sheetView.subject subscribeNext:^(id  _Nullable x) {
                    if([x isKindOfClass:[NSString class]]) {
                        self.alertVC = [TYAlertController alertControllerWithAlertView:sheetView preferredStyle:TYAlertControllerStyleActionSheet];
                        self.alertVC.backgoundTapDismissEnable = YES;
                        [[UIViewController currentViewController] presentViewController:self.alertVC animated:YES completion:nil];
                    }else {
                        [self.alertVC dismissViewControllerAnimated:YES];
                        if(self.subject) {
                            [self.subject sendNext:x];
                        }
                    }

                }];
                
            }];
            return cell;
        }else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellId"];
            if(!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellId"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return cell;
        }
        
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == 0) {
        self.tap = 0;
        self.currentSection = indexPath.row;
        [self.leftTableView reloadData];
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection: self.currentSection];
        [self.rightTableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//        CGRect headerRect = [self.rightTableView rectForHeaderInSection:self.currentSection];
//        [self.rightTableView scrollRectToVisible:headerRect animated:YES];
//        CGPoint offset = CGPointMake(0, headerRect.origin.y);
//        [self.rightTableView setContentOffset:offset animated:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.rightTableView) {
        self.tap = 1; // 重新允许更新
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (scrollView == self.rightTableView) {
        self.tap = 1; // 重新允许更新
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.rightTableView && self.tap == 1) {
        NSIndexPath *topHeaderViewIndexPath = [self.rightTableView indexPathsForVisibleRows].firstObject;
        self.currentSection = topHeaderViewIndexPath.section;
        [self.leftTableView reloadData];
        
    }
}

- (NSMutableArray *)dataArray {
    if(!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (RACSubject *)subject {
    if(!_subject) {
        _subject = [RACSubject subject];
    }
    return _subject;
}


@end
