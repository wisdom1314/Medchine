//
//  ClassMethod.m
//  BlueBricks
//
//  Created by GOOT on 2018/10/18.
//  Copyright © 2018年 Wisdom. All rights reserved.
//

#import "ClassMethod.h"

#import <CommonCrypto/CommonCrypto.h>
#import "GTMBase64.h"

@implementation ClassMethod


+ (UILabel *)initWithFrame:(CGRect)frame
                 titleWith:(NSString *)title
           fontCGFloatWith:(CGFloat)font
             alignmentWith:(NSTextAlignment)alignment; {
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:font];
    label.text = title;
    label.textAlignment = alignment;
    return label;
}

+ (UICollectionView*)creatCollectionViewWithFrame:(CGRect)frame
                                     withitemSize:(CGSize)size
                         withReuseIdentifierClass:(NSString *)className
                                           idName:(NSString*)identifier
                              scrollViewDirection:(UICollectionViewScrollDirection)scrollDirection
                                    withImageEdes:(UIEdgeInsets)inset
                                        isONeView:(BOOL)one {
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = size;
    layout.scrollDirection = scrollDirection;
    layout.sectionInset = inset;
    if (one) {
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
    }
    layout.minimumInteritemSpacing = 0;
    UICollectionView * collection = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    if (className) {
        [collection registerNib:[UINib nibWithNibName:className bundle:nil] forCellWithReuseIdentifier:identifier];
    }
    
    collection.backgroundColor = [UIColor whiteColor];
    return collection;
}

+ (CAGradientLayer *)setGradualChangingColorframeWith:(CGRect)frame {
    //    CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = frame;
    //  创建渐变色数组，需要转换为CGColor颜色
    UIColor *color1 = [UIColor colorWithHexString:@"#FF405B"];
    UIColor *color2 = [UIColor colorWithHexString:@"#FF0304"];
    gradientLayer.colors = @[(__bridge id)color1.CGColor, (__bridge id)color2.CGColor];
    gradientLayer.startPoint = CGPointMake(1, 1);
    gradientLayer.endPoint = CGPointMake(0, 0);
    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0.0,@1.0];
    return gradientLayer;
}

+ (UIView *)createViewFrameWith:(CGRect)frame
                  backColorWith:(UIColor *)color {
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = color;
    return view;
}

+ (UIImageView *)createImgViewFrameWith:(CGRect)frame
                             imageNamed:(NSString *)imageName {
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.image = [UIImage imageNamed:imageName];
    return imageView;
}

+ (void)setString:(NSString *)str key:(NSString *)keyWord{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user setObject:str forKey:keyWord];
    [user synchronize];
}

+ (NSString *)getStringBy:(NSString *)keyWord{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    id obj=[user objectForKey:keyWord];
    return obj;
}


+ (void)setModel:(id)mod key:(NSString*)keyWord{
    [self setObject:mod key:keyWord];
}

+ (id)getModelBy:(NSString*)keyWord{
    return [self getObjectBy:keyWord];
}

+ (void)setObject:(id)obj
              key:(NSString*)keyWord{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:obj];
    [user setObject:data forKey:keyWord];
    [user synchronize];
}

+ (id)getObjectBy:(NSString*)keyWord{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    id obj=[user objectForKey:keyWord];
    if (obj && [obj isKindOfClass:[NSData class]]) {
        id file=[NSKeyedUnarchiver unarchiveObjectWithData:obj];
        return file;
    }
    return nil;
}

+ (void)setDict:(NSDictionary *)dict
            key:(NSString *)keyWord{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    [user setObject:dict forKey:keyWord];
    [user synchronize];
}

+ (NSDictionary *)getDictBy:(NSString *)keyWord{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    id obj=[user objectForKey:keyWord];
    if (obj && [obj isKindOfClass:[NSData class]]) {
        NSDictionary *dict=[NSKeyedUnarchiver unarchiveObjectWithData:obj];
        return dict;
    }
    return nil;
}

+ (void)clearUserDefaults {
    NSDictionary *defaults = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    for (id key in defaults) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (CGSize)sizeTextNext:(NSString*)text
                  font:(UIFont*)font
            limitWidth:(float)width
{
    //    NSMutableParagraphStyle *npgStyle = [[NSMutableParagraphStyle alloc] init];
    //    npgStyle.alignment = NSTextAlignmentJustified;
    //    text = [text stringByReplacingOccurrencesOfString:@" " withString:@"字"];
    NSDictionary *attributes = @{NSFontAttributeName:font,
                                 //                                 NSParagraphStyleAttributeName :npgStyle,
                                 //                                 NSUnderlineStyleAttributeName :[NSNumber numberWithInteger:NSUnderlineStyleNone],
    };
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    rect.size.width=width;
    rect.size.height=ceil(rect.size.height);
    return rect.size;
}

+ (CGSize)sizeText:(NSString*)text
              font:(UIFont*)font
       limitHeight:(float)height
{
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin//|NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    rect.size.height=height;
    rect.size.width=ceil(rect.size.width);
    return rect.size;
}

+ (CGSize)sizeText:(NSString*)text
              font:(UIFont*)font
        limitWidth:(float)width
{
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin//|NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    rect.size.width=width;
    rect.size.height=ceil(rect.size.height);
    return rect.size;
}

+ (NSString *)dateStrWithTimestampDetail:(long long)timestamp {
    //时间戳转化
    NSTimeInterval interval  = timestamp / 1000.0; /// 毫秒级的
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"MM-dd HH:mm";
    return [dateFormatter stringFromDate:confromTimesp];
}

//时间字符串转时间戳
+ (NSString *)timeSpWithTimeStr:(NSString *)timeStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate* date = [dateFormatter dateFromString:timeStr];
    NSString *timeSp = [NSString stringWithFormat:@"%li", (long)[date timeIntervalSince1970]];
    return timeSp;
}

// !!!: 将试图绘制成图片
+ (UIImage *)paintingPictureWithView:(UIView *)view
{
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    [view.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        //        // 保存图片
        //        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        return image;
    }
    return nil;
}

//+ (BOOL)isBlankString:(NSString *)aStr {
//    if (!aStr) {
//        return YES;
//    }
//    if ([aStr isKindOfClass:[NSNull class]]) {
//        return YES;
//    }
//    if (!aStr.length) {
//        return YES;
//    }
//    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
//    NSString *trimmedStr = [aStr stringByTrimmingCharactersInSet:set];
//    if (!trimmedStr.length) {
//        return YES;
//    }
//    return NO;
//}

+ (BOOL)isEmpty:(NSString *)text{
    if ([text isEqual:[NSNull null]]) {
        return YES;
    }
    else if ([text isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    else if (text == nil){
        return YES;
    }
    return NO;
}

+ (SecKeyRef)loadPublicKey {
    SecKeyRef retKey = nil;
    NSString *fileType = @"dat";
    NSString *keyPath = [[NSBundle mainBundle] pathForResource:@"cpr" ofType:fileType];
    if (keyPath == nil) {
        return nil;
    }
    NSData *keyFileContent = [NSData dataWithContentsOfFile:keyPath];
    if (keyFileContent == nil) {
        return nil;
    }
    SecPolicyRef policy = nil;
    SecTrustRef  trust  = nil;
    SecCertificateRef certificate = SecCertificateCreateWithData(kCFAllocatorDefault, ( __bridge CFDataRef)keyFileContent);
    if (certificate == nil) {
        goto clear_tag;
    }
    
    policy = SecPolicyCreateBasicX509();
    
    OSStatus returnCode = SecTrustCreateWithCertificates(certificate, policy, &trust);
    if (returnCode != 0) {
        goto clear_tag;
    }
    
    SecTrustResultType trustResultType;
    returnCode = SecTrustEvaluate(trust, &trustResultType);
    if (returnCode != 0) {
        goto clear_tag;
    }
    
    retKey = SecTrustCopyPublicKey(trust);
    
clear_tag:
    if (policy) {
        CFRelease(policy);
    }
    
    if (certificate) {
        CFRelease(certificate);
    }
    if (trust) {
        CFRelease(trust);
    }
    
    return retKey;
}

+ (CGFloat)theTextLong:(NSString *)text Font:(float)font
{
    CGSize titleSize = [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:font],NSFontAttributeName, nil]];
    return titleSize.width;
}

+ (UIImage *)createImage:(NSString *)str
                   Color:(UIColor *)color
                    Font:(CGFloat)font
               DeafulImg:(UIImage *)deafulImg
{
    UIImage *image = deafulImg;
    
    CGSize size=CGSizeMake(image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [image drawAtPoint:CGPointMake(0, 0)];
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextDrawPath(context, kCGPathStroke);
    
    [str drawAtPoint:CGPointMake((size.width-[ClassMethod theTextLong:str Font:font])/2.0, (size.height-font)/2.0-1) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"ArialMT" size:font],NSForegroundColorAttributeName:color}];
    
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)getOneKeyImage:(NSString *)name {
    NSString * str = @"";
    str = name.length > 0?name:@"无";
    NSString * piny = [ClassMethod firstCharactor:str];
    str = [str substringToIndex:1];
    piny = piny.length > 2?[piny substringFromIndex:piny.length-2]:piny;
    UIImage * image = [ClassMethod imageWithColor:COLOR_05C160 Rect:CGRectMake(0, 0, 64, 64)];
    
    return [ClassMethod createImage:str Color:[UIColor whiteColor] Font:28 DeafulImg:image];;
}

+ (NSString *)firstCharactor:(NSString *)aString
{
    NSMutableString *str = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    NSString *pinYin = [str capitalizedString];
    NSArray * array = [pinYin componentsSeparatedByString:@" "];
    NSString * str1 = @"";
    for (NSString * str in array) {
        str1 = [NSString stringWithFormat:@"%@%@",str1,[str substringToIndex:1]];
    }
    return str1;
}

+ (UIImage *)imageWithColor:(UIColor *)color Rect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();

    // 使用 UIBezierPath 生成圆角矩形
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    CGContextAddPath(context, path.CGPath);
    CGContextClip(context);

    // 填充颜色
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+ (CGFloat)hideLabelLayoutHeight:(NSString *)content
{
    NSMutableAttributedString *attributes = [[NSMutableAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
    [attributes addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, attributes.length)];
    [attributes addAttribute:NSForegroundColorAttributeName value:COLOR_999999 range:NSMakeRange(0, attributes.length)];
    CGSize attSize = [attributes boundingRectWithSize:CGSizeMake(WIDE - 30, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading context:nil].size;
    
    return ceil(attSize.height);
}

+ (NSMutableAttributedString *)praseHtmlStr:(NSString *)htmlStr {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:COLOR_999999     range:NSMakeRange(0, attributedString.length)];
    return attributedString;
}

+ (UILabel *)createLabelWithFrame:(CGRect)frame Font:(float)font Text:(NSString *)text {
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:font];
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    return label ;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

//图片格式检查
+ (NSString *)imageFormatFromImageData:(NSData *)imageData {
    
    uint8_t first_byte;
    [imageData getBytes:&first_byte length:1];
    switch (first_byte) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            if ([imageData length] < 12) {
                return nil;
            }
            
            NSString *dataString = [[NSString alloc] initWithData:[imageData subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([dataString hasPrefix:@"RIFF"] && [dataString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            
            return nil;
    }
    return nil;
}

/// 数组转json
+ (NSString *)arrayToJSONString:(NSArray *)array {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

/// 字典转json
+ (NSString *)dictionaryToJSONString:(NSDictionary *)dictionary {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}


+ (void)setStatusBarBackgroundColor:(UIColor *)color {
    if(@available(iOS 13.0, *)) {
        static UIView *statusBar =nil;
        if(!statusBar) {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                statusBar = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame];
                [[UIApplication sharedApplication].keyWindow addSubview:statusBar];
                statusBar.backgroundColor= color;
                
            });
            
        }else {
            statusBar.backgroundColor= color;
        }
    }else {
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        if([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            statusBar.backgroundColor= color;
            
        }
    }
}

+ (NSString *)getUUID{
    return [UIDevice currentDevice].identifierForVendor.UUIDString;;
}


+ (float)floatWithdecimalNumber:(double)num {
    return [[self decimalNumber:num] floatValue];
}

+ (double)doubleWithdecimalNumber:(double)num {
    return [[self decimalNumber:num] doubleValue];
}

+ (NSString *)stringWithDecimalNumber:(double)num {
    return [[self decimalNumber:num] stringValue];
}

+ (NSDecimalNumber *)decimalNumber:(double)num {
    NSString *numString = [NSString stringWithFormat:@"%lf", num];
    return [NSDecimalNumber decimalNumberWithString:numString];
}

/**
 html 富文本设置
 
 @param str html 未处理的字符串
 @param font 设置字体
 @param lineSpacing 设置行高
 @return 默认不将 \n替换<br/> 返回处理好的富文本
 */
+ (NSMutableAttributedString *)setAttributedString:(NSString *)str font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing
{
    //如果有换行，把\n替换成<br/>
    //如果有需要把换行加上
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
   //设置HTML图片的宽度
    str = [NSString stringWithFormat:@"<head><style>img{max-width:%f !important; height:auto;}</style></head>%@",[UIScreen mainScreen].bounds.size.width - 32,str];
    NSMutableAttributedString *htmlString =[[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:NULL error:nil];
    //设置富文本字的大小
    [htmlString addAttributes:@{NSFontAttributeName:font} range:NSMakeRange(0, htmlString.length)];
    //设置行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [htmlString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [htmlString length])];

    return htmlString;
    
}


+(NSString *)pointSizeOfImageInHtml_Str:(NSString*)str Width:(CGFloat)width{
    if (str == nil || str.length == 0) { return @"";  }
    NSString *content = [str stringByReplacingOccurrencesOfString:@"&amp;quot" withString:@"'"];
    content = [content stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    content = [content stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    content = [content stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    NSString *html = content;
    NSString * regExpStr = @"<(img|IMG)[^\\<\\>]*>";
    NSRegularExpression *regex=[NSRegularExpression regularExpressionWithPattern:regExpStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches=[regex matchesInString:html
                                    options:0
                                      range:NSMakeRange(0, [html length])];
    //H5中<img ...... />标签数组
    NSMutableArray *imgArray = [NSMutableArray array];
    NSMutableArray *urlArray = [NSMutableArray array];
    for (NSTextCheckingResult *result in matches) {
        NSRange range   = result.range;
        NSString *group = [html substringWithRange:range];
        NSRange srange1 = [group rangeOfString:@"http"];
        NSString *tempString1 = [group substringWithRange:NSMakeRange(srange1.location, group.length - srange1.location)];
        NSRange srange2 = [tempString1 rangeOfString:@"\""];
        NSString *tempString2 = [tempString1 substringWithRange:NSMakeRange(0,srange2.location)];
        [urlArray addObject:tempString2];
        [imgArray addObject:group];
    }
    for (int i = 0; i < imgArray.count; i++) {
        NSString *string = imgArray[i];
        html = [html stringByReplacingOccurrencesOfString:string withString:[NSString stringWithFormat:@"<img src=\"%@\" title=\"\" alt=\"%ld\" width=\"%f\" height=\"auto\">",urlArray[i],[self getNowTimeTimestamp]+i,width]];
    }
    return html;
}

+ (long)getNowTimeTimestamp{
    NSDate *datenow = [NSDate date];
    return (long)[datenow timeIntervalSince1970];
}

/**
 计算html字符串高度
 
 @param str html 未处理的字符串
 @param font 字体设置
 @param lineSpacing 行高设置
 @param width 容器宽度设置
 @return 富文本高度
 */
+ (CGFloat)getHTMLHeightByStr:(NSString *)str font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing width:(CGFloat)width
{
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
    
    str = [NSString stringWithFormat:@"<head><style>img{max-width:%f !important; height:auto;}</style></head>%@",[UIScreen mainScreen].bounds.size.width - 32,str];
    NSMutableAttributedString *htmlString =[[NSMutableAttributedString alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:NULL error:nil];
    [htmlString addAttributes:@{NSFontAttributeName:font} range:NSMakeRange(0, htmlString.length)];
    //设置行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [htmlString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [htmlString length])];
    
    CGSize contextSize = [htmlString boundingRectWithSize:(CGSize){width, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return contextSize.height ;
    
    
}



+ (NSMutableAttributedString *)ruleSetAttributedString:(NSString *)str font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing
{
    NSData *data = [str dataUsingEncoding:NSUnicodeStringEncoding];
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    NSMutableAttributedString *contentText = [[NSMutableAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
    [contentText addAttributes:@{NSFontAttributeName:font} range:NSMakeRange(0, contentText.length)];
    [contentText addAttribute:NSStrikethroughColorAttributeName value:COLOR_3B3B3B range:NSMakeRange(0, contentText.length)];
    //    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //    [paragraphStyle setLineSpacing:lineSpacing];
    //    [contentText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentText length])];
    return contentText;
    
}

+ (CGFloat)getRuleHTMLHeightByStr:(NSString *)str font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing width:(CGFloat)width {
    
    NSData *data = [str dataUsingEncoding:NSUnicodeStringEncoding];
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    NSMutableAttributedString *contentText = [[NSMutableAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
    [contentText addAttributes:@{NSFontAttributeName:font} range:NSMakeRange(0, contentText.length)];
    //设置行间距
    //    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    //    [paragraphStyle1 setLineSpacing:lineSpacing];
    //    [contentText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [contentText length])];
    CGSize contextSize = [contentText boundingRectWithSize:(CGSize){width, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return contextSize.height ;
}


+ (NSString *)base64StringFromText:(NSString *)text {
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [data base64EncodedStringWithOptions:0];
    return base64String;
}
/**
  *  将base64字符串转换成普通字符串
  *
  *  @param base64 base64字符串
  *
  *  @return 普通字符串
  */
+ (NSString *)textFromBase64String:(NSString *)base64 {
    //    base64 = base64.replaceAll("[\\s*\t\n\r]", "");
    
    base64 = [base64 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
    NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return text;
}



+ (NSData *)reSizeImageData:(UIImage *)sourceImage maxImageSize:(CGFloat)maxImageSize maxFileSizeWithKB:(CGFloat)maxFileSize
{
    
    if (maxFileSize <= 0.0)  maxFileSize = 1024.0;
    if (maxImageSize <= 0.0) maxImageSize = 1024.0;
    
    //先调整分辨率
    CGSize newSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
    
    CGFloat tempHeight = newSize.height / maxImageSize;
    CGFloat tempWidth = newSize.width / maxImageSize;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempWidth, sourceImage.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(sourceImage.size.width / tempHeight, sourceImage.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [sourceImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
    CGFloat sizeOriginKB = imageData.length / 1024.0;
    
    CGFloat resizeRate = 0.9;
    while (sizeOriginKB > maxFileSize && resizeRate > 0.1) {
        imageData = UIImageJPEGRepresentation(newImage,resizeRate);
        sizeOriginKB = imageData.length / 1024.0;
        resizeRate -= 0.1;
    }
    
    return imageData;
}


+ (BOOL)isNeedUpdateVersionWithCurrentVer:(NSString *)currentVer serviceVerWith:(NSString *)serviceVer {
    NSArray *currentVesionArray = [currentVer componentsSeparatedByString:@"."];//当前版本
    NSArray *serviecVersionArray = [serviceVer componentsSeparatedByString:@"."];//服务器返回版本
    NSInteger arrCount = (currentVesionArray.count < serviecVersionArray.count)? serviecVersionArray.count : currentVesionArray.count;
    for (int i = 0; i<arrCount; i++) {
        NSInteger a = i<currentVesionArray.count? [[currentVesionArray objectAtIndex:i] integerValue]: 0; /// 
        NSInteger b = i<serviecVersionArray.count ? [[serviecVersionArray objectAtIndex:i] integerValue]: 0;
        if(a < b) {
            return YES;
        }else if(a > b) {
            return NO;
        }
    }
    return NO;
}


+ (NSMutableAttributedString *)customSetAttributedString:(NSString *)str font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing
{
    NSData *data = [str dataUsingEncoding:NSUnicodeStringEncoding];
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    NSMutableAttributedString *contentText = [[NSMutableAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
    [contentText addAttributes:@{NSFontAttributeName:font} range:NSMakeRange(0, contentText.length)];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [contentText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentText length])];
    return contentText;
    
}

+ (NSString *)hexStringFromData:(NSData *)data {
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    if (!dataBuffer) return [NSString string];
    
    NSUInteger dataLength = [data length];
    NSMutableString *hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];
    for (int i = 0; i < dataLength; i++) {
        [hexString appendFormat:@"%02lx", (unsigned long)dataBuffer[i]];
    }
    return [NSString stringWithString:hexString];
}

+ (NSString *)desEncryptToString:(NSString *)plainText key:(NSString *)key {
    // 将明文字符串转换为 NSData
    NSData *data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    size_t plainTextBufferSize = [data length];
    const void *vplainText = [data bytes];
    
    // 准备输出缓冲区
    uint8_t buffer[1024];
    memset(buffer, 0, sizeof(buffer));
    size_t numBytesEncrypted = 0;
    
    // 确保密钥长度为 24 字节
    NSString *key24 = [key length] >= 24 ? [key substringToIndex:24] : [key stringByPaddingToLength:24 withString:@"0" startingAtIndex:0];
    
    // 3DES 加密
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithm3DES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key24 UTF8String],
                                          kCCKeySize3DES,
                                          nil,  // ECB 模式下 IV 为 nil
                                          vplainText,
                                          plainTextBufferSize,
                                          buffer,
                                          sizeof(buffer),
                                          &numBytesEncrypted);
    
    NSString *cipherText = nil;
    if (cryptStatus == kCCSuccess) {
        // 将加密后的数据转换为 NSData 并转换为 Hex 字符串
        NSData *encryptedData = [NSData dataWithBytes:buffer length:numBytesEncrypted];
        cipherText = [ClassMethod hexStringFromData:encryptedData];
    } else {
        NSLog(@"加密失败，状态码: %d", cryptStatus);
    }
    
    return cipherText;
}

+ (NSString *)desDecryptFromString:(NSString *)cipherText key:(NSString *)key {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:cipherText options:0];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    size_t outLength;
    NSMutableData *plainData = [NSMutableData dataWithLength:data.length + kCCBlockSizeDES];
    
    CCCryptorStatus result = CCCrypt(kCCDecrypt,
                                     kCCAlgorithmDES,
                                     kCCOptionPKCS7Padding | kCCOptionECBMode,
                                     keyData.bytes,
                                     kCCKeySizeDES,
                                     NULL, // IV
                                     data.bytes,
                                     data.length,
                                     plainData.mutableBytes,
                                     plainData.length,
                                     &outLength);
    
    if (result == kCCSuccess) {
        plainData.length = outLength;
        return [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];
    }
    return nil;
}


+ (NSData *)dataFromHexString:(NSString *)hexString {
    NSMutableData *data = [NSMutableData dataWithCapacity:hexString.length / 2];
    unsigned char wholeByte;
    char byteChars[3] = {'\0','\0','\0'};
    for (int i = 0; i < hexString.length / 2; i++) {
        byteChars[0] = [hexString characterAtIndex:i * 2];
        byteChars[1] = [hexString characterAtIndex:i * 2 + 1];
        wholeByte = strtol(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    return data;
}

+ (NSString *)decryptUseDES:(NSString*)cipherText key:(NSString*)key {
    //ECB格式
    NSData *cipherData = [ClassMethod dataFromHexString:cipherText];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    
    NSString *key24 = [key length] >= 24 ? [key substringToIndex:24] : [key stringByPaddingToLength:24 withString:@"0" startingAtIndex:0];
    
    // 使用 3DES 进行解密
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithm3DES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key24 UTF8String],
                                          kCCKeySize3DES,
                                          nil,  // ECB 模式下 IV 为 nil
                                          [cipherData bytes],
                                          [cipherData length],
                                          buffer,
                                          sizeof(buffer),
                                          &numBytesDecrypted);
    
    NSString *plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return plainText;
}


+ (NSString *)formatNumberWithCustomRounding:(double)number {
    if (number == 0) {
        return @"0";
    }
    
    double fractionalPart = fmod(number, 1.0);
    double roundedNumber;
    
    if (fractionalPart < 0.5) {
        roundedNumber = floor(number);
    } else {
        roundedNumber = floor(number) + 0.5;
    }
    
    // 使用 NSNumberFormatter 格式化输出
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.minimumFractionDigits = 0;
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    return [formatter stringFromNumber:@(roundedNumber)];
}


+ (NSString *)fileSizeStringFromBytesString:(NSString *)bytesString {
    long long bytes = [bytesString longLongValue]; // 将字符串转换为 long long 类型
    
    if (bytes < 1024) {
        return [NSString stringWithFormat:@"%lldB", bytes];
    } else if (bytes < 1024 * 1024) {
        return [NSString stringWithFormat:@"%.2f KB", bytes / 1024.0];
    } else if (bytes < 1024 * 1024 * 1024) {
        return [NSString stringWithFormat:@"%.2f MB", bytes / (1024.0 * 1024.0)];
    } else {
        return [NSString stringWithFormat:@"%.2f GB", bytes / (1024.0 * 1024.0 * 1024.0)];
    }
}


@end
