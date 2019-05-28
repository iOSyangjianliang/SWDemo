//
//  SWRCInputDataSource.m
//  shunxinwei
//
//  Created by 杨建亮 on 2019/2/13.
//  Copyright © 2019年 shunwang. All rights reserved.
//

#import "SWRCInputDataSource.h"

@interface SWRCInputDataSource ()
@property(nonatomic, strong)NSArray<SWRCInputModel *> *inputDataArray_Win;
@property(nonatomic, strong)NSArray<SWRCInputModel *> *inputDataArray_Ctrl;
@property(nonatomic, strong)NSArray<SWRCInputModel *> *inputDataArray_Alt;
@property(nonatomic, strong)NSArray<SWRCInputModel *> *inputDataArray_Del;
@property(nonatomic, strong)NSArray<SWRCInputModel *> *inputDataArray_More;
@end

@implementation SWRCInputDataSource
- (NSArray<SWRCInputModel *> *)getDataWithInputType:(SWRCInputViewType)inputType;
{
    if (inputType == SWRCInputViewType_Ctrl)
    {
        return self.inputDataArray_Ctrl;
    }
    else if (inputType == SWRCInputViewType_Alt)
    {
        return self.inputDataArray_Alt;
    }
    else if (inputType == SWRCInputViewType_Del)
    {
        return self.inputDataArray_Del;
    }
    else if (inputType == SWRCInputViewType_More)
    {
        return self.inputDataArray_More;
    }
    else if (inputType == SWRCInputViewType_Win)
    {
        return self.inputDataArray_Win;
    }
    else
    {
        return [NSArray array];
    }
}
#pragma mark - Win
-(NSArray<SWRCInputModel *> *)inputDataArray_Win
{
    if (!_inputDataArray_Win) {
        NSArray *arr = @[
                         @"(开始菜单)", @"桌面 (D)",@"资源管理器 (E)",
                         @"锁定 (L)",@"运行 (R)",@"系统 (Pause)"
                         ];
        
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i=0; i<arr.count; ++i) {
            SWRCInputModel *model = [[SWRCInputModel alloc] init];
            NSString *title = arr[i];
            model.mainTitle = title;
            if ([title isEqualToString:@"(开始菜单)"])
            {
            }
            else if ([title isEqualToString:@"桌面 (D)"])
            {

                
            }
            else if ([title isEqualToString:@"资源管理器 (E)"])
            {
                
            }
            else if ([title isEqualToString:@"锁定 (L)"])
            {

                
            }
            else if ([title isEqualToString:@"运行 (R)"])
            {

                
            }
            else if ([title isEqualToString:@"系统 (Pause)"])
            {
                
            }
            model.percentWidth = SWMakePercentWidth(1, 3);
            NSString *str = model.mainTitle.length>model.subTitle.length? model.mainTitle:model.subTitle;
            model.itemWidth = [self sw_boundingRectWithStr:str];
            if (i==0) {
                model.itemUIStyle = SWRCItemUIStyle_Img_H_Title;
                model.itemWidth+=45;
            }
            [arrayM addObject:model];
        }
        _inputDataArray_Win = arrayM;
    }
    return _inputDataArray_Win;
}
#pragma mark - Ctrl
-(NSArray<SWRCInputModel *> *)inputDataArray_Ctrl
{
    if (!_inputDataArray_Ctrl) {
        NSArray *arr = @[
                         @"Shift", @"Space",@"安全",@"任务管理器",
                         @"全选",@"复制",@"粘贴",@"剪切",@"撤销",@"保存"
                         ];
        NSArray *subArr = @[
                         @"", @"",@"(Ctrl+Alt+Del)",@"",
                         @"(A)",@"(C)",@"(V)",@"(X)",@"(Z)",@"(S)"
                         ];
        
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i=0; i<arr.count; ++i) {
            SWRCInputModel *model = [[SWRCInputModel alloc] init];
            NSString *title = arr[i];
            NSString *subTitle = subArr[i];
            if (![subTitle isEqualToString:@""]) {
                model.itemUIStyle = SWRCItemUIStyle_Title_V_Title;
                model.mainTitle = title;
                model.subTitle = subTitle;
            }else{
                model.mainTitle = title;
            }
            if ([title isEqualToString:@"Shift"])
            {
                model.percentWidth = SWMakePercentWidth(1, 6);
            }
            else if ([title isEqualToString:@"Space"])
            {
                model.percentWidth = SWMakePercentWidth(1, 6);

            }
            else if ([title isEqualToString:@"安全"])
            {
                model.percentWidth = SWMakePercentWidth(2, 6);

            }
            else if ([title isEqualToString:@"任务管理器"])
            {
                model.percentWidth = SWMakePercentWidth(2, 6);

            }
            else if ([title isEqualToString:@"全选"])
            {
                model.percentWidth = SWMakePercentWidth(1, 6);

            }
            else if ([title isEqualToString:@"复制"])
            {
                model.percentWidth = SWMakePercentWidth(1, 6);

            }
            else if ([title isEqualToString:@"粘贴"])
            {
                model.percentWidth = SWMakePercentWidth(1, 6);

            }
            else if ([title isEqualToString:@"剪切"])
            {
                model.percentWidth = SWMakePercentWidth(1, 6);

            }
            else if ([title isEqualToString:@"撤销"])
            {
                model.percentWidth = SWMakePercentWidth(1, 6);

            }
            else if ([title isEqualToString:@"保存"])
            {
                model.percentWidth = SWMakePercentWidth(1, 6);

            }
            model.itemWidth = [self sw_boundingRectWithStr:title];
            NSString *str = model.mainTitle.length>model.subTitle.length? model.mainTitle:model.subTitle;
            model.itemWidth = [self sw_boundingRectWithStr:str];
            [arrayM addObject:model];
        }
        _inputDataArray_Ctrl = arrayM;
    }
    return _inputDataArray_Ctrl;
}
#pragma mark - Alt
-(NSArray<SWRCInputModel *> *)inputDataArray_Alt
{
    if (!_inputDataArray_Alt) {
        NSArray *arr = @[
                         @"切换", @"关闭",@"属性",@"截屏"
                         ];
        NSArray *subArr = @[
                            @"", @"",@"(Enter)",@"(PrtSC)",
                            ];
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i=0; i<arr.count; ++i) {
            SWRCInputModel *model = [[SWRCInputModel alloc] init];
            NSString *title = arr[i];
            NSString *subTitle = subArr[i];
            if (![subTitle isEqualToString:@""]) {
                model.itemUIStyle = SWRCItemUIStyle_Title_V_Title;
                model.mainTitle = title;
                model.subTitle = subTitle;
            }else{
                model.mainTitle = title;
            }
            if ([title isEqualToString:@"切换"])
            {
                model.percentWidth = SWMakePercentWidth(1, 4);
            }
            else if ([title isEqualToString:@"关闭"])
            {
                model.percentWidth = SWMakePercentWidth(1, 4);
                
            }
            else if ([title isEqualToString:@"属性"])
            {
                model.percentWidth = SWMakePercentWidth(1, 4);
            }
            else if ([title isEqualToString:@"截屏"])
            {
                model.percentWidth = SWMakePercentWidth(1, 4);
            }
            model.mainTitle = title;
            NSString *str = model.mainTitle.length>model.subTitle.length? model.mainTitle:model.subTitle;
            model.itemWidth = [self sw_boundingRectWithStr:str];
            [arrayM addObject:model];
        }
        _inputDataArray_Alt = arrayM;
    }
    return _inputDataArray_Alt;
}
#pragma mark - Delete
-(NSArray<SWRCInputModel *> *)inputDataArray_Del
{
    if (!_inputDataArray_Del) {
        NSArray *arr = @[
                         @"Esc", @"切换 (Tab)",@"回车 (Enter)"
                         ];
        
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i=0; i<arr.count; ++i) {
            SWRCInputModel *model = [[SWRCInputModel alloc] init];
            NSString *title = arr[i];
            model.mainTitle = title;
            if ([title isEqualToString:@"Esc"])
            {
                model.percentWidth = SWMakePercentWidth(0.8, 3);
            }
            else if ([title isEqualToString:@"切换 (Tab)"])
            {
                model.percentWidth = SWMakePercentWidth(1.1, 3);
                
            }
            else if ([title isEqualToString:@"回车 (Enter)"])
            {
                model.percentWidth = SWMakePercentWidth(1.1, 3);
            }
            NSString *str = model.mainTitle.length>model.subTitle.length? model.mainTitle:model.subTitle;
            model.itemWidth = [self sw_boundingRectWithStr:str];
            [arrayM addObject:model];
        }
        
        _inputDataArray_Del = arrayM;
    }
    return _inputDataArray_Del;
}
#pragma mark - 更多
-(NSArray<SWRCInputModel *> *)inputDataArray_More
{
    if (!_inputDataArray_More) {
        NSArray *arr = @[
                         @"Esc", @"F1",@"F2",@"F3",@"F4",@"F5",@"F6",@"F10",@"F11",
                         @"Table",@"Shift",@"Home",@"End",@"BackSpace",
                         @"系统配置",@"管理",@"注册表",@"PgUp",@"↑",@"PgDn",
                         @"控制面板",@"命令",@"组策略",@"←",@"↓", @"→"
                         ];
        
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i=0; i<arr.count; ++i) {
            SWRCInputModel *model = [[SWRCInputModel alloc] init];
            NSString *title = arr[i];
            model.mainTitle = title;
            
            
            SWRCKeyboardSignalModel *kSignal = [[SWRCKeyboardSignalModel alloc] init];
            
            if ([title isEqualToString:@"Esc"])
            {
                model.percentWidth = SWMakePercentWidth(1.f, 9);
            }
            else if ([title isEqualToString:@"F1"])
            {
                model.percentWidth = SWMakePercentWidth(1.f, 9);
                
            }
            else if ([title isEqualToString:@"F2"])
            {
                model.percentWidth = SWMakePercentWidth(1.f, 9);
                
            }
            else if ([title isEqualToString:@"F3"])
            {
                model.percentWidth = SWMakePercentWidth(1.f, 9);
                
            }
            else if ([title isEqualToString:@"F4"])
            {
                model.percentWidth = SWMakePercentWidth(1.f, 9);
                
            }
            else if ([title isEqualToString:@"F5"])
            {
                model.percentWidth = SWMakePercentWidth(1.f, 9);
                
            }
            else if ([title isEqualToString:@"F6"])
            {
                model.percentWidth = SWMakePercentWidth(1.f, 9);
                
            }
            else if ([title isEqualToString:@"F10"])
            {
                model.percentWidth = SWMakePercentWidth(1.f, 9);
                
            }
            else if ([title isEqualToString:@"F11"])
            {
                model.percentWidth = SWMakePercentWidth(1.f, 9);
                
            }
            //row 2----5555
            else if ([title isEqualToString:@"Table"])
            {
                model.percentWidth = SWMakePercentWidth(1.9, 6);
            }
            else if ([title isEqualToString:@"Shift"])
            {
                model.percentWidth = SWMakePercentWidth(1.9, 6);
                
            }
            else if ([title isEqualToString:@"Home"])
            {
                model.percentWidth = SWMakePercentWidth(1.9, 6);
                
            }
            else if ([title isEqualToString:@"End"])
            {
                model.percentWidth = SWMakePercentWidth(1.1, 6);
                
            }
            else if ([title isEqualToString:@"BackSpace"])
            {
                model.percentWidth = SWMakePercentWidth(2.2, 6);
                
                
            }
            //row 3
            else if ([title isEqualToString:@"系统配置"])
            {
                model.percentWidth = SWMakePercentWidth(1.9, 6);
                
            }
            else if ([title isEqualToString:@"管理"])
            {
                model.percentWidth = SWMakePercentWidth(1.9, 6);
                
            }
            else if ([title isEqualToString:@"注册表"])
            {
                model.percentWidth = SWMakePercentWidth(1.9, 6);
                
            }
            else if ([title isEqualToString:@"PgUp"])
            {
                model.percentWidth = SWMakePercentWidth(1.1, 6);
                
            }
            else if ([title isEqualToString:@"↑"])
            {
                model.percentWidth = SWMakePercentWidth(1.1, 6);
                
            }
            else if ([title isEqualToString:@"PgDn"])
            {
                model.percentWidth = SWMakePercentWidth(1.1, 6);
                
            }
            //row 4
            else if ([title isEqualToString:@"控制面板"])
            {
                model.percentWidth = SWMakePercentWidth(1.9, 6);
                
            }
            else if ([title isEqualToString:@"命令"])
            {
                model.percentWidth = SWMakePercentWidth(1.9, 6);
                
            }
            else if ([title isEqualToString:@"组策略"])
            {
                model.percentWidth = SWMakePercentWidth(1.9, 6);
                
            }
            else if ([title isEqualToString:@"←"])
            {
                model.percentWidth = SWMakePercentWidth(1.1, 6);
                
            }
            else if ([title isEqualToString:@"↓"])
            {
                model.percentWidth = SWMakePercentWidth(1.1, 6);
                
            }
            else if ([title isEqualToString:@"→"])
            {
                model.percentWidth = SWMakePercentWidth(1.1, 6);
                
            }
            
            //        CGFloat per100 = model.percentWidth.percent*100.f;
            //        CGFloat per = (CGFloat)floorf(per100)/100.f;//无法整除时舍去小数点后两位精度
            //        model.percentWidth = SWMakePercentWidth(per, model.percentWidth.items);
            
//            model.keyboardSignals = kSignal;
            
            NSString *str = model.mainTitle.length>model.subTitle.length? model.mainTitle:model.subTitle;
            model.itemWidth = [self sw_boundingRectWithStr:str];
            [arrayM addObject:model];
        }
        _inputDataArray_More = arrayM;
        

    }
    
   
    return _inputDataArray_More;
}

-(CGFloat)sw_boundingRectWithStr:(NSString*)str
{
    CGRect rect = [str boundingRectWithSize:CGSizeMake(MAXFLOAT,0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    CGFloat Width = rect.size.width + 40;
    
    return Width;
}
@end
