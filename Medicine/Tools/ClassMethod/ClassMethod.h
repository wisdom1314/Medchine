//
//  ClassMethod.h
//  BlueBricks
//
//  Created by GOOT on 2018/10/18.
//  Copyright © 2018年 Wisdom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ClassMethod : NSObject
+ (UILabel *)initWithFrame:(CGRect)frame
                 titleWith:(NSString *)title
           fontCGFloatWith:(CGFloat)font
             alignmentWith:(NSTextAlignment)alignment;

+ (UICollectionView*)creatCollectionViewWithFrame:(CGRect)frame
                                     withitemSize:(CGSize)size
                         withReuseIdentifierClass:(NSString*)className
                                           idName:(NSString*)identifier
                              scrollViewDirection:(UICollectionViewScrollDirection)scrollDirection
                                    withImageEdes:(UIEdgeInsets)inset
                                        isONeView:(BOOL)one;

+ (CAGradientLayer *)setGradualChangingColorframeWith:(CGRect)frame;

+ (UIView *)createViewFrameWith:(CGRect)frame
                  backColorWith:(UIColor *)color;

+ (UIImageView *)createImgViewFrameWith:(CGRect)frame
                             imageNamed:(NSString *)imageName;

+ (void)setString:(NSString *)str
              key:(NSString*)keyWord;

+ (NSString *)getStringBy:(NSString *)keyWord;

+ (void)setModel:(id)mod
             key:(NSString *)keyWord;

+ (id)getModelBy:(NSString *)keyWord;

+ (void)setDict:(NSDictionary *)dict
            key:(NSString *)keyWord;

+ (NSDictionary *)getDictBy:(NSString *)keyWord;

+ (void)clearUserDefaults;

+ (CGSize)sizeTextNext:(NSString*)text
                  font:(UIFont*)font
            limitWidth:(float)width;

+ (CGSize)sizeText:(NSString*)text
              font:(UIFont*)font
       limitHeight:(float)height;

+ (CGSize)sizeText:(NSString*)text
              font:(UIFont*)font
        limitWidth:(float)width;

+ (NSString *)dateStrWithTimestampDetail:(long long)timestamp;

+ (NSString *)timeSpWithTimeStr:(NSString *)timeStr;

// !!!: 将试图绘制成图片
+ (UIImage *)paintingPictureWithView:(UIView *)view;

+ (BOOL)isEmpty:(NSString *)text; /// 判断是否为空

+ (UIImage *)getOneKeyImage:(NSString *)name; /// 取字为图标

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

+ (CGFloat)hideLabelLayoutHeight:(NSString *)content;

+ (NSMutableAttributedString *)praseHtmlStr:(NSString *)htmlStr;

+ (UILabel *)createLabelWithFrame:(CGRect)frame Font:(float)font Text:(NSString *)text;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

+ (NSString *)imageFormatFromImageData:(NSData *)imageData;

/// 数组转json
+ (NSString *)arrayToJSONString:(NSArray *)array;

/// 字典转json
+ (NSString *)dictionaryToJSONString:(NSDictionary *)dictionary;


+ (void)setStatusBarBackgroundColor:(UIColor *)color;

+ (NSString *)getUUID;

+ (NSString *)stringWithDecimalNumber:(double)num;

+ (NSMutableAttributedString *)setAttributedString:(NSString *)str font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing;

+ (CGFloat)getHTMLHeightByStr:(NSString *)str font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing width:(CGFloat)width;


+ (NSMutableAttributedString *)ruleSetAttributedString:(NSString *)str font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing;

+ (CGFloat)getRuleHTMLHeightByStr:(NSString *)str font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing width:(CGFloat)width;



+ (NSString *)base64StringFromText:(NSString *)text;
/**
  *  将base64字符串转换成普通字符串
  *
  *  @param base64 base64字符串
  *
  *  @return 普通字符串
  */
+ (NSString *)textFromBase64String:(NSString *)base64;


+ (NSData *)reSizeImageData:(UIImage *)sourceImage maxImageSize:(CGFloat)maxImageSize maxFileSizeWithKB:(CGFloat)maxFileSize;

/// 判断版本号大小
+ (BOOL)isNeedUpdateVersionWithCurrentVer:(NSString *)currentVer serviceVerWith:(NSString *)serviceVer;

+ (NSMutableAttributedString *)customSetAttributedString:(NSString *)str font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing;

+ (NSString *)desEncryptToString:(NSString *)plainText key:(NSString *)key;

+ (NSString *)desDecryptFromString:(NSString *)cipherText key:(NSString *)key;

+ (NSString *)decryptUseDES:(NSString *)cipherText key:(NSString*)key;

+ (NSString *)formatNumberWithCustomRounding:(double)number;

+ (NSString *)fileSizeStringFromBytesString:(NSString *)bytesString;

@end
