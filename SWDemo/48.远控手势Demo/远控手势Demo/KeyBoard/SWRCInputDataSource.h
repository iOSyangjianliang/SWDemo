//
//  SWRCInputDataSource.h
//  shunxinwei
//
//  Created by 杨建亮 on 2019/2/13.
//  Copyright © 2019年 shunwang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SWRCInputModel.h"

NS_ASSUME_NONNULL_BEGIN

//键盘类型
typedef NS_ENUM(NSInteger , SWRCInputViewType){
    

    SWRCInputViewType_Win      = 0,
    
    SWRCInputViewType_Ctrl     = 1,
    
    SWRCInputViewType_Alt      = 2,
    
    SWRCInputViewType_Del      = 3,
    
    SWRCInputViewType_More     = 4,
    
    SWRCInputViewType_Default  = 5,

};
/*
static uint64_t const KS_Backspace = 0x08;//Backspace键
static uint64_t const KS_Tab = 0x09;      //Tab键
static uint64_t const KS_Clear = 0x0C; //Clear键（Num Lock关闭时的数字键盘5）
static uint64_t const KS_XXXX = 0xXXX;//Enter键
static uint64_t const KS_Shift = 0x10;//Shift键
static uint64_t const KS_Ctrl = 0x11;//Ctrl键
static uint64_t const KS_Alt = 0x12;//Alt键
static uint64_t const KS_.666 = 0x13;//Pause键
static uint64_t const KS_.666 = 0x14;//Caps Lock键
static uint64_t const KS_.666 = 0x1B;// Ese键
static uint64_t const KS_.666 = 0x20;//Spacebar键
static uint64_t const KS_.666 = 0x21;//Page Up键
static uint64_t const KS_.666 = 0x22;//Page Down键
static uint64_t const KS_.666 = 0x23;//End键
static uint64_t const KS_.666 = 0x24;Home键
static uint64_t const KS_.666 = 0x25;LEFT ARROW 键(←)
static uint64_t const KS_.666 = 0x26;UP ARROW键(↑)
static uint64_t const KS_.666 = 0x27; RIGHT ARROW键(→)
static uint64_t const KS_.666 = 0x28; DOWN ARROW键(↓)
static uint64_t const KS_.666 = 0x29; Select键
static uint64_t const KS_.666 = 0x2B;//EXECUTE键
static uint64_t const KS_.666 = 0x2C;Print Screen键（抓屏）
static uint64_t const KS_.666 = 0x2D;Ins键(Num Lock关闭时的数字键盘0)
static uint64_t const KS_.666 = 0x2E;Del键(Num Lock关闭时的数字键盘.)
static uint64_t const KS_.666 = 0x2F;Help键
static uint64_t const KS_.666 = 0x30;//0键 0-9 A-Z
static uint64_t const KS_.666 = 0x.66;
static uint64_t const KS_.666 = 0x.66;
static uint64_t const KS_.666 = 0x.66;
static uint64_t const KS_.666 = 0x.66;
static uint64_t const KS_.666 = 0x.66;
static uint64_t const KS_.666 = 0x.66;
static uint64_t const KS_.666 = 0x.66;
static uint64_t const KS_.666 = 0x.66;
static uint64_t const KS_.666 = 0x.66;
static uint64_t const KS_.666 = 0x.66;


KS_0    30    48    0键
KS_1    31    49    1键
KS_2    32    50    2键
KS_3    33    51    3键
KS_4    34    52    4键
KS_5    35    53    5键
KS_6    36    54    6键
KS_7    37    55    7键
KS_8    38    56    8键
KS_9    39    57    9键
KS_A    41    65    A键
KS_B    42    66    B键
KS_C    43    67    C键
KS_D    44    68    D键
KS_E    45    69    E键
KS_F    46    70    F键
KS_G    47    71    G键
KS_H    48    72    H键
KS_I    49    73    I键
KS_J    4A    74    J键
KS_K    4B    75    K键
KS_L    4C    76    L键
KS_M    4D    77    M键
KS_N    4E    78    N键
KS_O    4F    79    O键
KS_P    50    80    P键
KS_Q    51    81    Q键
KS_R    52    82    R键
KS_S    53    83    S键
KS_T    54    84    T键
KS_U    55    85    U键
KS_V    56    86    V键
KS_W    57    87    W键
KS_X    58    88    X键
KS_Y    59    89    Y键
KS_Z    5A    90    Z键
KS_NUMPAD0    60    96    数字键0键
KS_NUMPAD1    61    97    数字键1键
KS_NUMPAD2    62    98    数字键2键
KS_NUMPAD3    62    99    数字键3键
KS_NUMPAD4    64    100    数字键4键
KS_NUMPAD5    65    101    数字键5键
KS_NUMPAD6    66    102    数字键6键
KS_NUMPAD7    67    103    数字键7键
KS_NUMPAD8    68    104    数字键8键
KS_NUMPAD9    69    105    数字键9键
KS_MULTIPLY    6A    106    数字键盘上的*键
KS_ADD    6B    107    数字键盘上的+键
KS_SEPARATOR    6C    108    Separator键
KS_SUBTRACT    6D    109    数字键盘上的-键
KS_DECIMAL    6E    110    数字键盘上的.键
KS_DIVIDE    6F    111    数字键盘上的/键
KS_F1    70    112    F1键
KS_F2    71    113    F2键
KS_F3    72    114    F3键
KS_F4    73    115    F4键
KS_F5    74    116    F5键
KS_F6    75    117    F6键
KS_F7    76    118    F7键
KS_F8    77    119    F8键
KS_F9    78    120    F9键
KS_F10    79    121    F10键
KS_F11    7A    122    F11键
KS_F12    7B    123    F12键
KS_NUMLOCK    90    144    Num Lock 键
KS_SCROLL    91    145    Scroll Lock键
上面没有提到的：（都在大键盘）
KS_LWIN        91    左win键
KS_RWIN        92    右win键
KS_APPS        93    右Ctrl左边键，点击相当于点击鼠标右键，会弹出快捷菜单
186    ;(分号)
187    =键
188    ,键(逗号)
189    -键(减号)
190    .键(句号)
191    /键
192    `键(Esc下面)
219    [键
        220    键
        221    ]键
222    ‘键(引号)
*/

@interface SWRCInputDataSource : NSObject

- (NSArray<SWRCInputModel *> *)getDataWithInputType:(SWRCInputViewType)inputType;

/**
常数名称    十六进制值    十进制值    对应按键
KS_LBUTTON    01    1    鼠标的左键
KS_RBUTTON    02    2    鼠标的右键
VK-CANCEL    03    3    Ctrl+Break(通常不需要处理)
KS_MBUTTON    04    4    鼠标的中键（三按键鼠标)
KS_BACK    08    8    Backspace键
KS_TAB    09    9    Tab键
KS_CLEAR    0C    12    Clear键（Num Lock关闭时的数字键盘5）
KS_RETURN    0D    13    Enter键
KS_SHIFT    10    16    Shift键
KS_CONTROL    11    17    Ctrl键
KS_MENU    12    18    Alt键
KS_PAUSE    13    19    Pause键
KS_CAPITAL    14    20    Caps Lock键
KS_ESCAPE    1B    27    Ese键
KS_SPACE    20    32    Spacebar键
KS_PRIOR    21    33    Page Up键
KS_NEXT    22    34    Page Domw键
KS_END    23    35    End键
KS_HOME    24    36    Home键
KS_LEFT    25    37    LEFT ARROW 键(←)
KS_UP    26    38    UP ARROW键(↑)
KS_RIGHT    27    39    RIGHT ARROW键(→)
KS_DOWN    28    40    DOWN ARROW键(↓)
KS_Select    29    41    Select键
KS_PRINT    2A    42
KS_EXECUTE    2B    43    EXECUTE键
KS_SNAPSHOT    2C    44    Print Screen键（抓屏）
KS_Insert    2D    45    Ins键(Num Lock关闭时的数字键盘0)
KS_Delete    2E    46    Del键(Num Lock关闭时的数字键盘.)
KS_HELP    2F    47    Help键
KS_0    30    48    0键
KS_1    31    49    1键
KS_2    32    50    2键
KS_3    33    51    3键
KS_4    34    52    4键
KS_5    35    53    5键
KS_6    36    54    6键
KS_7    37    55    7键
KS_8    38    56    8键
KS_9    39    57    9键
KS_A    41    65    A键
KS_B    42    66    B键
KS_C    43    67    C键
KS_D    44    68    D键
KS_E    45    69    E键
KS_F    46    70    F键
KS_G    47    71    G键
KS_H    48    72    H键
KS_I    49    73    I键
KS_J    4A    74    J键
KS_K    4B    75    K键
KS_L    4C    76    L键
KS_M    4D    77    M键
KS_N    4E    78    N键
KS_O    4F    79    O键
KS_P    50    80    P键
KS_Q    51    81    Q键
KS_R    52    82    R键
KS_S    53    83    S键
KS_T    54    84    T键
KS_U    55    85    U键
KS_V    56    86    V键
KS_W    57    87    W键
KS_X    58    88    X键
KS_Y    59    89    Y键
KS_Z    5A    90    Z键
KS_NUMPAD0    60    96    数字键0键
KS_NUMPAD1    61    97    数字键1键
KS_NUMPAD2    62    98    数字键2键
KS_NUMPAD3    62    99    数字键3键
KS_NUMPAD4    64    100    数字键4键
KS_NUMPAD5    65    101    数字键5键
KS_NUMPAD6    66    102    数字键6键
KS_NUMPAD7    67    103    数字键7键
KS_NUMPAD8    68    104    数字键8键
KS_NUMPAD9    69    105    数字键9键
KS_MULTIPLY    6A    106    数字键盘上的*键
KS_ADD    6B    107    数字键盘上的+键
KS_SEPARATOR    6C    108    Separator键
KS_SUBTRACT    6D    109    数字键盘上的-键
KS_DECIMAL    6E    110    数字键盘上的.键
KS_DIVIDE    6F    111    数字键盘上的/键
KS_F1    70    112    F1键
KS_F2    71    113    F2键
KS_F3    72    114    F3键
KS_F4    73    115    F4键
KS_F5    74    116    F5键
KS_F6    75    117    F6键
KS_F7    76    118    F7键
KS_F8    77    119    F8键
KS_F9    78    120    F9键
KS_F10    79    121    F10键
KS_F11    7A    122    F11键
KS_F12    7B    123    F12键
KS_NUMLOCK    90    144    Num Lock 键
KS_SCROLL    91    145    Scroll Lock键
上面没有提到的：（都在大键盘）
KS_LWIN        91    左win键
KS_RWIN        92    右win键
KS_APPS        93    右Ctrl左边键，点击相当于点击鼠标右键，会弹出快捷菜单
186    ;(分号)
187    =键
188    ,键(逗号)
189    -键(减号)
190    .键(句号)
191    /键
192    `键(Esc下面)
219    [键
        220    键
        221    ]键
222    ‘键(引号)
 */
@end

NS_ASSUME_NONNULL_END
