//
//  RRThemeManager.m
//  ThemeManager
//
//  Created by 杨建亮 on 2019/6/26.
//  Copyright © 2019 yangjianliang. All rights reserved.
//

#import "RRThemeManager.h"

NSString * const RRThemeChangedNotification = @"RRThemeChangedNotification";

@interface RRThemeManager()
//@property (nonatomic, strong) NSBundle *bundle;           ///< 主题bundle
//@property (nonatomic, copy) NSDictionary *theme;      ///< 颜色对照表


@property (nonatomic, strong) NSMutableDictionary *themeDictM;      ///< 颜色对照表

@end

@implementation RRThemeManager
-(instancetype)init
{
    if (self = [super init]) {
        self.themeDictM = [NSMutableDictionary dictionary];
        [self.themeDictM setObject:@"test1" forKey:@"home_icon"];//读取默认数据
    }
    return self;
}
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static RRThemeManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[RRThemeManager alloc] init];
    });
    return instance;
}

- (BOOL)changeTheme:(NSString *)themeName
{
    if ([themeName isEqualToString:@"0"]) {
        [self.themeDictM setObject:@"test1" forKey:@"home_icon"];
    }
    if ([themeName isEqualToString:@"1"]) {
        [self.themeDictM setObject:@"test2" forKey:@"home_icon"];
    }
    
    
//    NSURL *url = [[NSBundle mainBundle] URLForResource:themeName withExtension:@"bundle"];
//    NSBundle *bundle = nil;
//    if (url == nil) {
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        NSString *fromPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.bundle", themeName]];
//        if ([[NSFileManager defaultManager] fileExistsAtPath:fromPath]) {
//            bundle = [NSBundle bundleWithPath:fromPath];
//            NSURL *urlpath = [bundle URLForResource:@"theme" withExtension:@"plist"];
//            NSDictionary *theme = [NSDictionary dictionaryWithContentsOfURL:urlpath];
//            if (theme == nil) {
//                return NO;
//            }
//            _themeName = themeName;
//            self.bundle = bundle;
//            self.theme = theme;
//        }else {
//            NSLog(@"未找到对应文件");
//        }
//    }else {
//        bundle = [NSBundle bundleWithURL:url];
//        if (!bundle) {
//            return NO;
//        }
//        NSString *mapPath = [bundle pathForResource:@"theme" ofType:@"plist"];
//        NSDictionary *theme = [NSDictionary dictionaryWithContentsOfFile:mapPath];
//        _themeName = themeName;
//        self.bundle = bundle;
//        self.theme = theme;
//    }
    [self sendChangeThemeNotification];
    return YES;
}

+ (UIColor *)colorWithID:(NSString *)colorID {
    return [UIColor redColor];
//    if (!colorID) {
//        return [UIColor clearColor];
//    }
//    return [UIColor sd_colorWithHexString:[[self class] colorStringWithID:colorID]];
}


+ (NSString *)colorStringWithID:(NSString *)colorID {
    return @"FFFFFF";
//    NSArray *array = [colorID componentsSeparatedByString:@"_"];
//    NSAssert(array.count > 1, @"未找到对应颜色-%@", colorID);
//
//    NSDictionary *colorDict = [[SDThemeManager sharedInstance].theme valueForKeyPath:array[0]];
//    NSString *value = colorDict[colorID][@"Color"];
//    NSAssert(value, @"未找到对应颜色-%@", colorID);
//    return value;
}

+ (UIImage *)imageWithName:(NSString *)imageName {
    if (!imageName) {
        return nil;
    }
    
 
    //eg:

    NSString *filePath = [[RRThemeManager sharedInstance].themeDictM objectForKey:imageName];
    UIImage *image = [UIImage imageNamed:filePath];
    
//    UIImage *image = [UIImage imageNamed:imageName inBundle:[SDThemeManager sharedInstance].bundle compatibleWithTraitCollection:nil];
//    NSAssert(image, @"未找到对应图片-%@", imageName);
    return image;
}

// MARK: - ================ Private M ===========================

- (void)sendChangeThemeNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:RRThemeChangedNotification object:nil];
}

@end
