//
//  UIAreaPickView.m
//  SSRead
//
//  Created by 张智慧 on 2021/2/6.
//

#import "UIAreaPickView.h"
#import "HomeModel.h"

@interface UIAreaPickView ()
<UIPickerViewDelegate,
UIPickerViewDataSource>
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIButton *commitBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, copy) NSArray *provinces;
@property (nonatomic, copy) NSArray *cities;
@property (nonatomic, copy) NSArray *areas;
@property (nonatomic, copy) NSArray *addressList;

@property (nonatomic, strong) NSString *selectedProvince;
@property (nonatomic, strong) NSString *selectedCity;
@property (nonatomic, strong) NSString *selectedArea;


@end

@implementation UIAreaPickView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_FFFFFF;
        [self addSubview:self.commitBtn];
        [self addSubview:self.cancelBtn];
        [self addSubview:self.pickerView];
        @weakify(self);
        [[self.commitBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            RegionItemModel *selectedAddressModel = [self getSelectedAddressModel];
            if(selectedAddressModel) {
                [self.commitSubject sendNext:selectedAddressModel];
            }
        }];
    
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.size.mas_equalTo(CGSizeMake(60, 40));
            make.top.equalTo(self);
        }];
        [[self.cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self.commitSubject sendNext:nil];
        }];
        [self requestRegionData];
    }
    return self;
}

- (void)requestRegionData {
    [[RequestManager shareInstance]requestWithMethod:POST url:GetRegionsURL dict:nil finished:^(id request) {
        RegionsListModel *model = [RegionsListModel mj_objectWithKeyValues:request];
        self.addressList = model.regions_list;
        NSSet *provinceSet = [NSSet setWithArray:[model.regions_list valueForKey:@"province"]];
        self.provinces = [provinceSet allObjects];
        [self updateCitiesAndAreasForProvince:self.provinces.firstObject];
        [self.pickerView reloadAllComponents];
        
        // 设置默认选中的省市区
        self.selectedProvince = self.provinces.firstObject;
        self.selectedCity = self.cities.firstObject;
        self.selectedArea = self.areas.firstObject;
        
    } failed:^(NSError *error) {
        
    }];
    
}

- (void)updateCitiesAndAreasForProvince:(NSString *)province {
    // 根据省份过滤城市
    NSPredicate *cityPredicate = [NSPredicate predicateWithFormat:@"province == %@", province];
    NSArray *filteredCities = [self.addressList filteredArrayUsingPredicate:cityPredicate];
    
    NSSet *citySet = [NSSet setWithArray:[filteredCities valueForKey:@"city"]];
    self.cities = [citySet allObjects];
    // 获取第一个城市的区
    [self updateAreasForCity:self.cities.firstObject];
}

- (void)updateAreasForCity:(NSString *)city {
    // 根据城市过滤区
    NSPredicate *areaPredicate = [NSPredicate predicateWithFormat:@"city == %@", city];
    NSArray *filteredAreas = [self.addressList filteredArrayUsingPredicate:areaPredicate];
    self.areas = [filteredAreas valueForKey:@"area"];
    // 刷新UIPickerView的区列
    [self.pickerView reloadComponent:2];
}



#pragma mark -PickerViewDelegate && DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

// 每列的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinces.count;
    } else if (component == 1) {
        return self.cities.count;
    } else {
        return self.areas.count;
    }
}

// 每列的内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinces[row];
    } else if (component == 1) {
        return self.cities[row];
    } else {
        return self.areas[row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return WIDE/3;
}

// 当用户选中某一行时的联动操作
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        // 更新城市和区
        self.selectedProvince = self.provinces[row];
        [self updateCitiesAndAreasForProvince:self.selectedProvince];
        [self.pickerView reloadComponent:1];
        [self.pickerView reloadComponent:2];
        
        // 默认选择第一个城市和区
        self.selectedCity = self.cities.firstObject;
        self.selectedArea = self.areas.firstObject;
    } else if (component == 1) {
        // 更新区
        self.selectedCity = self.cities[row];
        [self updateAreasForCity:self.selectedCity];
        [self.pickerView reloadComponent:2];
        
        // 默认选择第一个区
        self.selectedArea = self.areas.firstObject;
    } else if (component == 2) {
        // 更新选中的区
        self.selectedArea = self.areas[row];
    }
}

- (RegionItemModel *)getSelectedAddressModel {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"province == %@ AND city == %@ AND area == %@", self.selectedProvince, self.selectedCity, self.selectedArea];
    NSArray *filteredArray = [self.addressList filteredArrayUsingPredicate:predicate];
    
    if (filteredArray.count > 0) {
        // 返回选中的地址模型
        RegionItemModel *selectedAddress = filteredArray.firstObject;
        return selectedAddress;
    }
    
    return nil; // 未找到匹配项
}

#pragma mark -- LazyMethod
- (UIPickerView *)pickerView {
    if(!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, WIDE, self.height - 40)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (UIButton *)commitBtn {
    if(!_commitBtn) {
        _commitBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDE - 70, 0, 60, 40)];;
        [_commitBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_commitBtn setTitleColor:MainColor forState:UIControlStateNormal];
        _commitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _commitBtn;
}

- (UIButton *)cancelBtn {
    if(!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:COLOR_999999 forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _cancelBtn;
}



- (RACSubject *)commitSubject {
    if(!_commitSubject) {
        _commitSubject = [RACSubject subject];
    }
    return _commitSubject;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
