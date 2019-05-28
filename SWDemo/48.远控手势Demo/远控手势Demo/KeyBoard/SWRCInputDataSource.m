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
                SWRCKeySignalModel *ksModel = [[SWRCKeySignalModel alloc] initWithState:0 value:0x5B];
                SWRCKeySignalModel *ksModel1 = [[SWRCKeySignalModel alloc] initWithState:0 value:0x44];
                SWRCKeySignalModel *ksModel2 = [[SWRCKeySignalModel alloc] initWithState:2 value:0x5B];
                SWRCKeySignalModel *ksModel3 = [[SWRCKeySignalModel alloc] initWithState:2 value:0x44];
                model.keyboardSignals = @[ksModel,ksModel1,ksModel2,ksModel3];
            }
            else if ([title isEqualToString:@"资源管理器 (E)"])
            {
                SWRCKeySignalModel *ksModel = [[SWRCKeySignalModel alloc] initWithState:0 value:0x5B];
                SWRCKeySignalModel *ksModel1 = [[SWRCKeySignalModel alloc] initWithState:0 value:0x45];
                SWRCKeySignalModel *ksModel2 = [[SWRCKeySignalModel alloc] initWithState:2 value:0x5B];
                SWRCKeySignalModel *ksModel3 = [[SWRCKeySignalModel alloc] initWithState:2 value:0x45];
                model.keyboardSignals = @[ksModel,ksModel1,ksModel2,ksModel3];
            }
            else if ([title isEqualToString:@"锁定 (L)"])
            {

                
            }
            else if ([title isEqualToString:@"运行 (R)"])
            {
                SWRCKeySignalModel *ksModel = [[SWRCKeySignalModel alloc] initWithState:0 value:0x5B];
                SWRCKeySignalModel *ksModel1 = [[SWRCKeySignalModel alloc] initWithState:0 value:0x52];
                SWRCKeySignalModel *ksModel2 = [[SWRCKeySignalModel alloc] initWithState:2 value:0x5B];
                SWRCKeySignalModel *ksModel3 = [[SWRCKeySignalModel alloc] initWithState:2 value:0x52];
                model.keyboardSignals = @[ksModel,ksModel1,ksModel2,ksModel3];
            }
            else if ([title isEqualToString:@"系统 (Pause)"])
            {
                SWRCKeySignalModel *ksModel = [[SWRCKeySignalModel alloc] initWithState:0 value:0x5B];
                SWRCKeySignalModel *ksModel1 = [[SWRCKeySignalModel alloc] initWithState:0 value:0x13];
                SWRCKeySignalModel *ksModel2 = [[SWRCKeySignalModel alloc] initWithState:2 value:0x5B];
                SWRCKeySignalModel *ksModel3 = [[SWRCKeySignalModel alloc] initWithState:2 value:0x13];
                model.keyboardSignals = @[ksModel,ksModel1,ksModel2,ksModel3];
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
                         @"Shift", @"Space",@"安全(Ctrl+Alt+Del)",@"任务管理器",
                         @"全选(A)",@"复制(C)",@"粘贴(V)",@"剪切(X)",@"撤销(Z)",@"保存(S)"
                         ];
//        NSArray *subArr = @[
//                         @"", @"",@"(Ctrl+Alt+Del)",@"",
//                         @"(A)",@"(C)",@"(V)",@"(X)",@"(Z)",@"(S)"
//                         ];
        
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i=0; i<arr.count; ++i) {
            SWRCInputModel *model = [[SWRCInputModel alloc] init];
            NSString *title = arr[i];
//            NSString *subTitle = subArr[i];
//            if (![subTitle isEqualToString:@""]) {
//                model.itemUIStyle = SWRCItemUIStyle_Title_V_Title;
//                model.mainTitle = title;
//                model.subTitle = subTitle;
//            }else{
                model.mainTitle = title;
//            }
            if ([title hasPrefix:@"Shift"])
            {
                model.percentWidth = SWMakePercentWidth(1, 6);
            }
            else if ([title hasPrefix:@"Space"])
            {
                model.percentWidth = SWMakePercentWidth(1, 6);

            }
            else if ([title hasPrefix:@"安全"])
            {
                model.percentWidth = SWMakePercentWidth(2, 6);

                SWRCKeySignalModel *ksModel = [[SWRCKeySignalModel alloc] initWithState:0 value:0x11];
                SWRCKeySignalModel *ksModel1 = [[SWRCKeySignalModel alloc] initWithState:0 value:0x12];
                SWRCKeySignalModel *ksModel2 = [[SWRCKeySignalModel alloc] initWithState:0 value:0x23];
                SWRCKeySignalModel *ksModel3 = [[SWRCKeySignalModel alloc] initWithState:2 value:0x11];
                SWRCKeySignalModel *ksModel4 = [[SWRCKeySignalModel alloc] initWithState:2 value:0x12];
                SWRCKeySignalModel *ksModel5 = [[SWRCKeySignalModel alloc] initWithState:2 value:0x23];
                
  
                model.keyboardSignals = @[ksModel,ksModel1,ksModel2,ksModel3,ksModel4,ksModel5];
            }
            else if ([title hasPrefix:@"任务管理器"])
            {
                model.percentWidth = SWMakePercentWidth(2, 6);

            }
            else if ([title hasPrefix:@"全选"])
            {
                model.percentWidth = SWMakePercentWidth(1, 6);

                SWRCKeySignalModel *ksModel = [[SWRCKeySignalModel alloc] initWithState:0 value:0x11];
                SWRCKeySignalModel *ksModel1 = [[SWRCKeySignalModel alloc] initWithState:0 value:0x41];
                SWRCKeySignalModel *ksModel2 = [[SWRCKeySignalModel alloc] initWithState:2 value:0x11];
                SWRCKeySignalModel *ksModel3 = [[SWRCKeySignalModel alloc] initWithState:2 value:0x41];
                model.keyboardSignals = @[ksModel,ksModel1,ksModel2,ksModel3];
            }
            else if ([title hasPrefix:@"复制"])
            {
                model.percentWidth = SWMakePercentWidth(1, 6);
                SWRCKeySignalModel *ksModel = [[SWRCKeySignalModel alloc] initWithState:0 value:0x11];
                SWRCKeySignalModel *ksModel1 = [[SWRCKeySignalModel alloc] initWithState:0 value:0x43];
                SWRCKeySignalModel *ksModel2 = [[SWRCKeySignalModel alloc] initWithState:2 value:0x11];
                SWRCKeySignalModel *ksModel3 = [[SWRCKeySignalModel alloc] initWithState:2 value:0x43];
                model.keyboardSignals = @[ksModel,ksModel1,ksModel2,ksModel3];
             
            }
            else if ([title hasPrefix:@"粘贴"])
            {
                model.percentWidth = SWMakePercentWidth(1, 6);

            }
            else if ([title hasPrefix:@"剪切"])
            {
                model.percentWidth = SWMakePercentWidth(1, 6);

            }
            else if ([title hasPrefix:@"撤销"])
            {
                model.percentWidth = SWMakePercentWidth(1, 6);

            }
            else if ([title hasPrefix:@"保存"])
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
                         @"切换", @"关闭",@"属性(Enter)",@"截屏(PrtSC)"
                         ];
//        NSArray *subArr = @[
//                            @"", @"",@"(Enter)",@"(PrtSC)",
//                            ];
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i=0; i<arr.count; ++i) {
            SWRCInputModel *model = [[SWRCInputModel alloc] init];
            NSString *title = arr[i];
//            NSString *subTitle = subArr[i];
//            if (![subTitle isEqualToString:@""]) {
//                model.itemUIStyle = SWRCItemUIStyle_Title_V_Title;
//                model.mainTitle = title;
//                model.subTitle = subTitle;
//            }else{
                model.mainTitle = title;
//            }
            if ([title hasPrefix:@"切换"])
            {
                model.percentWidth = SWMakePercentWidth(1, 4);
            }
            else if ([title hasPrefix:@"关闭"])
            {
                model.percentWidth = SWMakePercentWidth(1, 4);
                
            }
            else if ([title hasPrefix:@"属性"])
            {
                model.percentWidth = SWMakePercentWidth(1, 4);
            }
            else if ([title hasPrefix:@"截屏"])
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
            
            
            SWRCKeySignalModel *kSignal = [[SWRCKeySignalModel alloc] init];
            
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
        
        /*
         if ([cmd isEqualToString:@"esc"]) {
         [self esc];
         } else if ([cmd isEqualToString:@"f1"]) {
         [self sendKeyboardSignalWithState:0 andValue:0x70];
         [self sendKeyboardSignalWithState:2 andValue:0x70];
         } else if ([cmd isEqualToString:@"f2"]) {
         [self sendKeyboardSignalWithState:0 andValue:0x71];
         [self sendKeyboardSignalWithState:2 andValue:0x71];
         } else if ([cmd isEqualToString:@"f3"]) {
         [self sendKeyboardSignalWithState:0 andValue:0x72];
         [self sendKeyboardSignalWithState:2 andValue:0x72];
         } else if ([cmd isEqualToString:@"f4"]) {
         [self sendKeyboardSignalWithState:0 andValue:0x73];
         [self sendKeyboardSignalWithState:2 andValue:0x73];
         } else if ([cmd isEqualToString:@"f5"]) {
         [self sendKeyboardSignalWithState:0 andValue:0x74];
         [self sendKeyboardSignalWithState:2 andValue:0x74];
         } else if ([cmd isEqualToString:@"f6"]) {
         [self sendKeyboardSignalWithState:0 andValue:0x75];
         [self sendKeyboardSignalWithState:2 andValue:0x75];
         } else if ([cmd isEqualToString:@"f10"]) {
         [self sendKeyboardSignalWithState:0 andValue:0x79];
         [self sendKeyboardSignalWithState:2 andValue:0x79];
         } else if ([cmd isEqualToString:@"f11"]) {
         [self sendKeyboardSignalWithState:0 andValue:0x7A];
         [self sendKeyboardSignalWithState:2 andValue:0x7A];
         } else if ([cmd isEqualToString:@"tab"]) {
         [self tab];
         } else if ([cmd isEqualToString:@"shift"]) {
         [self sendKeyboardSignalWithState:0 andValue:0xA0];
         [self sendKeyboardSignalWithState:2 andValue:0xA0];
         } else if ([cmd isEqualToString:@"home"]) {
         [self sendKeyboardSignalWithState:0 andValue:0x24];
         [self sendKeyboardSignalWithState:2 andValue:0x24];
         } else if ([cmd isEqualToString:@"end"]) {
         [self sendKeyboardSignalWithState:0 andValue:0x23];
         [self sendKeyboardSignalWithState:2 andValue:0x23];
         } else if ([cmd isEqualToString:@"sysConfig"]) {
         //        [self sendControlCmd:0x01];
         [self.view makeToast:@"被控端暂时不支持" duration:2.0 position:CSToastPositionCenter];
         } else if ([cmd isEqualToString:@"manage"]) {
         [self sendControlCmd:0x02];
         } else if ([cmd isEqualToString:@"controlPanel"]) {
         [self sendControlCmd:0x04];
         } else if ([cmd isEqualToString:@"command"]) {
         [self sendControlCmd:0x03];
         } else if ([cmd isEqualToString:@"group"]) {
         [self sendControlCmd:0x06];
         } else if ([cmd isEqualToString:@"regTable"]) {
         [self sendControlCmd:0x05];
         } else if ([cmd isEqualToString:@"pgup"]) {
         [self pageUp];
         } else if ([cmd isEqualToString:@"up"]) {
         [self sendKeyboardSignalWithState:0 andValue:0x26];
         [self sendKeyboardSignalWithState:2 andValue:0x26];
         } else if ([cmd isEqualToString:@"pgdn"]) {
         [self pageDown];
         } else if ([cmd isEqualToString:@"left"]) {
         [self sendKeyboardSignalWithState:0 andValue:0x25];
         [self sendKeyboardSignalWithState:2 andValue:0x25];
         } else if ([cmd isEqualToString:@"down"]) {
         [self sendKeyboardSignalWithState:0 andValue:0x28];
         [self sendKeyboardSignalWithState:2 andValue:0x28];
         } else if ([cmd isEqualToString:@"right"]) {
         [self sendKeyboardSignalWithState:0 andValue:0x27];
         [self sendKeyboardSignalWithState:2 andValue:0x27];
         } else if ([cmd isEqualToString:@"backspace"]) {
         [self sendKeyboardSignalWithState:0 andValue:0x08];
         [self sendKeyboardSignalWithState:2 andValue:0x08];
         }
         */
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
