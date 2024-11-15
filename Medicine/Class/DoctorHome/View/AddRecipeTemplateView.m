//
//  AddRecipeTemplateView.m
//  Medicine
//
//  Created by 张智慧 on 2024/10/10.
//

#import "AddRecipeTemplateView.h"
#import "StatementPickView.h"
#import "HomeModel.h"

@interface AddRecipeTemplateView ()
@property (nonatomic, strong) StatementPickView *pickView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextF;
@property (weak, nonatomic) IBOutlet UITextField *bzTextF;
@property (nonatomic, strong) NSMutableArray *categoryArr;
@property (nonatomic, copy) NSString *category_id;
@end

@implementation AddRecipeTemplateView

- (void)awakeFromNib  {
    [super awakeFromNib];
    [self requestRecipeCategory];
    [[self.chooseCategoryBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        TYAlertController *alertVC = [TYAlertController alertControllerWithAlertView:self.pickView preferredStyle:TYAlertControllerStyleActionSheet];
        alertVC.backgoundTapDismissEnable = YES;
        @weakify(self);
        [self.pickView.commitSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            if(x) {
                NSString *value = [x valueForKey:@"value"];
                NSString *category_id = [x valueForKey:@"id"];
                [self.chooseCategoryBtn setTitle:value forState:UIControlStateNormal];
                [self.chooseCategoryBtn setTitleColor:COLOR_562306 forState:UIControlStateNormal];
                self.category_id = category_id;
            }
            [alertVC dismissViewControllerAnimated:YES];
        }];
        [[UIViewController currentViewController] presentViewController:alertVC animated:YES completion:nil];
    }];
    
    [[self.commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        if(self.nameTextF.text.length == 0) {
            [ZZProgress showErrorWithStatus:@"请输入模板名称"];
            return;
        }
        if(self.subject) {
            [self.subject sendNext:@{
                            @"recipesample_name":self.nameTextF.text,
                            @"recipesample_symptoms":self.bzTextF.text,
                            @"categoryId":self.category_id
                        }];
        }
        
    }];
        
    
}

- (void)requestRecipeCategory {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"" forKey:@"name"];
    [[RequestManager shareInstance]requestWithMethod:GET url:RecipeCategoryListURL dict:dic hasHeader:YES finished:^(id request) {
        PageBaseModel *model = [PageBaseModel mj_objectWithKeyValues:request];
        [PageListModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                @"data": [CategoryModel class]
            };
        }];
        model.listModel = [PageListModel mj_objectWithKeyValues:model.list];
        for (CategoryModel *subModel in model.listModel.data) {
            [self.categoryArr addObject:@{
                @"id": subModel.category_id,
                @"value": subModel.name
            }];
            
            self.pickView.dataArray = self.categoryArr;
        }
    } failed:^(NSError *error) {
        
    }];
    
}


- (StatementPickView *)pickView {
    if(!_pickView) {
        _pickView = [[StatementPickView alloc]initWithFrame:CGRectMake(0, 0, WIDE, 260)];
    }
    return _pickView;
}

- (RACSubject *)subject {
    if(!_subject) {
        _subject = [RACSubject subject];
    }
    return _subject;
}


- (NSMutableArray *)categoryArr {
    if(!_categoryArr) {
        _categoryArr = [NSMutableArray array];
    }
    return _categoryArr;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
