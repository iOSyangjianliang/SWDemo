//
//  SWRCTextViewDelegate.m
//  shunxinwei
//
//  Created by 杨建亮 on 2019/4/3.
//  Copyright © 2019年 shunwang. All rights reserved.
//

//该类主要对UITextView Delegate进行二次封装:主要对系统九宫格中英文输入代理拿到的数据进行处理，并向外输出插入text、删除text两种操作

#import "SWRCTextViewDelegate.h"

@interface SWRCTextViewDelegate ()
@property(nonatomic, strong) NSString *textWhenNoMarkedTextRange;//处理中文输入联想词

@property(nonatomic, assign) NSInteger lastInsertLocation;
@property(nonatomic, assign) BOOL needWaitingSpecialString;
@property(nonatomic, strong, nullable) NSString *waitingSpecialString;

@property(nonatomic, assign) NSInteger lastABCnumber;
@property(nonatomic, strong, nullable) NSString *waitingABCString;

@property(nonatomic, assign) BOOL isPinyin10Chinese;


@end

static NSString *RCTextSpace = @" ";
@implementation SWRCTextViewDelegate
-(instancetype)init
{
    if (self = [super init]) {
        
        _lastInsertLocation = RCTextSpace.length;
    }
    return self;
}

#pragma mark - ---------UITextView Delegate-----------
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"---------RC_textView=should<%@>------",text);
    NSLog(@"RC_textView=should range=%@",NSStringFromRange(range));
    
    if ([text isEqualToString:@""])
    {//删除
        if(textView.markedTextRange == nil)
        {
            NSLog(@"删除");
            [self sendInsertText:@""];
            if (textView.text.length==RCTextSpace.length)
            {
                return NO;//保证按住删除键可持续触发删除
            }
        }
    }
    else if ([text isEqualToString:@"\n"])
    {//换行
        NSLog(@"换行");
        [self sendInsertText:@"\n"];
    }
    else
    {
        NSInteger isShould = [self isSendInsertedTextDirect];
        if (isShould == 0)
        {//第三方键盘
            NSLog(@"===S====插入<%@>",text);
            [self sendInsertText:text];
        }
        else if (isShould==-1)
        {//放textViewDidChange处理
            
        }
        else  if (isShould==-2)
        {//九宫格中文键盘
            if ([self isABCScan:text])
            {
                NSLog(@">>>>字母");
                if (_waitingSpecialString)
                {
                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(waitingString:) object:_waitingSpecialString];
                    [self sendInsertText:_waitingSpecialString];//取消延迟、立即发送
                    _waitingSpecialString = nil;
                }
                
                if (text.length==1)
                {
                    if (_lastABCnumber>0)
                    {
                        NSInteger curryABCnumber = [self getABC_Number:text];
                        NSLog(@"curryABCnumber=%ld",(long)curryABCnumber);
                        
                        if (curryABCnumber == _lastABCnumber)
                        {
                            if (_waitingABCString) {
                                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(waitingABCString:) object:_waitingABCString];
                            }
                            _waitingABCString = text;
                            [self performSelector:@selector(waitingABCString:) withObject:_waitingABCString afterDelay:1.0];
                        }else{
                            if (_waitingABCString){
                                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(waitingABCString:) object:_waitingABCString];
                                [self sendInsertText:_waitingABCString];//取消延迟立即发送上一个
                            }
                            _waitingABCString = text;
                            [self performSelector:@selector(waitingABCString:) withObject:_waitingABCString afterDelay:1.0];
                        }
                    }
                    else
                    {
                        if (_waitingABCString) {
                            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(waitingABCString:) object:_waitingABCString];
                        }
                        _waitingABCString = text;
                        [self performSelector:@selector(waitingABCString:) withObject:_waitingABCString afterDelay:1.0];
                    }
                    _lastABCnumber = [self getABC_Number:text];
                    NSLog(@"_lastABCnumber=%ld",(long)_lastABCnumber);
                }else
                {
                    NSLog(@"直接插入多个字母<%@>",text);
                    [self sendInsertText:text];
                }
            }
            else if ([self is123SpaceScan:text])
            {
                NSLog(@">>>>数字+空格");
                //eg：从标点、九宫格字母-->切换到数字
                if (_waitingSpecialString)
                {
                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(waitingString:) object:_waitingSpecialString];
                    [self sendInsertText:_waitingSpecialString];//取消延迟、立即发送
                    _waitingSpecialString = nil;
                }
                if (_waitingABCString){
                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(waitingABCString:) object:_waitingABCString];
                    [self sendInsertText:_waitingABCString];//取消延迟、立即发送
                    _waitingABCString = nil;
                }
                [self sendInsertText:text];
            }
            else if ([self isSudoku:text])
            {
                NSLog(@">>>>中文");
                _isPinyin10Chinese = YES;
            }
            else if ([text isEqualToString:@"☻"])
            {
                _isPinyin10Chinese = YES;
                NSLog(@">>>>^_^");
            }
            else
            {//标点符号
                NSLog(@"输入【%@】 length=%lu",text,(unsigned long)text.length);
           
                if (_waitingABCString){
                    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(waitingABCString:) object:_waitingABCString];
                    [self sendInsertText:_waitingABCString];//取消延迟、立即发送
                    _waitingABCString = nil;
                }
                
                if (range.length==0)
                {
                    if ([text isEqualToString:@"，"] || [text isEqualToString:@"."]) {
                        _needWaitingSpecialString = YES;
                        NSLog(@"needWaitingSpecialString111");
                    }
                    
                    NSLog(@"need %d",_needWaitingSpecialString);

                    NSLog(@"_lastInsertLocation=%ld",(long)_lastInsertLocation);
                    if (_lastInsertLocation == range.location && _needWaitingSpecialString)
                    {
                        if (_waitingSpecialString) {
                            NSLog(@"取消等待%@",_waitingSpecialString);
                            
                            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(waitingString:) object:_waitingSpecialString];
                            _waitingSpecialString = nil;
                        }
                        
                        _waitingSpecialString = text;
                        NSLog(@"开始等待%@",_waitingSpecialString);
                        [self performSelector:@selector(waitingString:) withObject:_waitingSpecialString afterDelay:1.0];
                    }
                    else
                    {//eg:123-更多
                        
                        if (_waitingSpecialString){
                            NSLog(@"取消等待  %@",_waitingSpecialString);
                            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(waitingString:) object:_waitingSpecialString];
                            if (!_needWaitingSpecialString) {
                                [self sendInsertText:_waitingSpecialString];//取消延迟、立即发送
                            }
                            _waitingSpecialString = nil;
                        }
                        _needWaitingSpecialString = NO;

                        NSLog(@"needWaitingSpecialString000");

                        NSLog(@">>>>插入不用等待特殊字符 <%@>",text);
                        [self sendInsertText:text];
                    }
                }
                else
                {
                    if (_isPinyin10Chinese)
                    {
                        _isPinyin10Chinese = NO;
                        NSLog(@">>>>选定联想词 <%@>",text);
                        [self sendInsertText:text];
                    }
                    else
                    {//联想标点
//                        if (_waitingSpecialString) {
//                            NSLog(@"取消等待%@",_waitingSpecialString);
//                            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(waitingString:) object:_waitingSpecialString];
//                            _waitingSpecialString = nil;
//                        }
                    }
                }
            }
        }
    }
    return YES;
}
-(void)waitingABCString:(NSString *)waitingABCString
{
    NSLog(@"waitingStringg====插入<%@>",waitingABCString);
    _waitingABCString = nil;
    [self sendInsertText:waitingABCString];
}
-(void)waitingString:(NSString *)waitingString
{
    NSLog(@"waitingStringg====插入<%@>",waitingString);
    _waitingSpecialString = nil;
    _needWaitingSpecialString = NO;
    NSLog(@"needWaitingSpecialString0000");
    [self sendInsertText:waitingString];
}
- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"textViewDidChange length=%lu ",(unsigned long)textView.text.length);

//    NSLog(@"textViewDidChange=%@ length=%d selectedRange=%@",textView.text,textView.text.length, NSStringFromRange(textView.selectedRange));

    if(textView.markedTextRange == nil)
    {
        NSInteger isShould = [self isSendInsertedTextDirect];
        if (isShould==-1)
        {//处理简体拼音-全键盘
            if (textView.text.length>_textWhenNoMarkedTextRange.length)
            {
                NSString *markedText = [textView.text substringFromIndex:_textWhenNoMarkedTextRange.length];
                [self sendInsertText:markedText];
            }
        }
        _textWhenNoMarkedTextRange = textView.text;
    }
    _lastInsertLocation = textView.text.length;

    
    //设置光标始终在文本最后(eg:选择())
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        textView.selectedRange = NSMakeRange(textView.text.length, 0);
    });
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = RCTextSpace;//键盘弹出直接按住删除键持续删除
    _textWhenNoMarkedTextRange = RCTextSpace;//处理中文输入时联想词问题
    _lastInsertLocation = RCTextSpace.length;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    textView.text = RCTextSpace;
    _textWhenNoMarkedTextRange = RCTextSpace;
}
-(NSInteger)isSendInsertedTextDirect
{
    NSArray *arr = [UITextInputMode activeInputModes];
    NSArray *filteredArray = [arr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isDisplayed = YES"]];
    UITextInputMode *textInputMode = filteredArray.lastObject;
    NSString *currentKeyboardName = [textInputMode valueForKey:@"extendedDisplayName"];
    if([currentKeyboardName isEqualToString:@"简体拼音"])
    {//系统自带键盘-中文键盘
        NSString *identifier = [textInputMode valueForKey:@"identifier"];
        NSRange range = [identifier rangeOfString:@"Pinyin10"];
        if (range.location != NSNotFound)
        {//九宫格
            return -2;
        }else
        {//全键盘
            return -1;
        }
    }
    else if([currentKeyboardName isEqualToString:@"English (US)"])
    { //系统自带键盘-全英文
        return 0;
    }
    else if([currentKeyboardName isEqualToString:@"Emoji"] )
    {//系统自带键盘-Emoji
        return 0;
    }
    else
    {//第三方键盘
        NSLog(@"currentKeyboardName=%@",currentKeyboardName);
        return 0;
    }
    
    //identifier=zh_Hans-Pinyin@sw=Pinyin10-Simplified;hw=Automatic 全键盘中文
    //identifier=zh_Hans-Pinyin@sw=Pinyin-Simplified;hw=Automatic 九宫格中英文
    //identifier=en_US@sw=QWERTY;hw=Automatic 全键盘英文
    //identifier=emoji@sw=Emoji
    //identifier=com.sogou.sogouinput.basekeyboard
}
-(BOOL)isABCScan:(NSString *)str
{
    NSString *number = @"^[A-Za-z]+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", number];
    return [emailTest evaluateWithObject:str];
}
-(NSInteger)getABC_Number:(NSString *)str
{
    NSString *abc = @"^[A-Ca-c]+$";
    NSPredicate *emailTest_abc = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", abc];
    BOOL two = [emailTest_abc evaluateWithObject:str];
    if (two) {
        return 2;
    }
    
    NSString *def = @"^[D-Fd-f]+$";
    NSPredicate *emailTest_def = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", def];
    BOOL three = [emailTest_def evaluateWithObject:str];
    if (three) {
        return 3;
    }
    
    
    NSString *ghi = @"^[G-Ig-i]+$";
    NSPredicate *emailTest_ghi = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ghi];
    BOOL four = [emailTest_ghi evaluateWithObject:str];
    if (four) {
        return 4;
    }
    
    NSString *jkl = @"^[J-Lj-l]+$";
    NSPredicate *emailTest_jkl = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", jkl];
    BOOL five = [emailTest_jkl evaluateWithObject:str];
    if (five) {
        return 5;
    }
    
    NSString *mno = @"^[M-Om-o]+$";
    NSPredicate *emailTest_mno = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mno];
    BOOL six = [emailTest_mno evaluateWithObject:str];
    if (six) {
        return 6;
    }
    
    NSString *pqrs = @"^[P-Sp-s]+$";
    NSPredicate *emailTest_pqrs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pqrs];
    BOOL seven = [emailTest_pqrs evaluateWithObject:str];
    if (seven) {
        return 7;
    }
    
    NSString *tuv = @"^[T-Vt-v]+$";
    NSPredicate *emailTest_tuv = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", tuv];
    BOOL eight = [emailTest_tuv evaluateWithObject:str];
    if (eight) {
        return 8;
    }
    
    NSString *wxyz = @"^[W-Zw-z]+$";
    NSPredicate *emailTest_wxyz = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", wxyz];
    BOOL nine = [emailTest_wxyz evaluateWithObject:str];
    if (nine) {
        return 9;
    }
    
    return -1;
}
-(BOOL)is123SpaceScan:(NSString *)str
{
    NSString *number = @"^[0123456789 *]+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", number];
    return [emailTest evaluateWithObject:str];
}
//-(BOOL)isWatingStrings:(NSString *)str
//{
//    NSString *number = @"^[，。？！._@/#:]+$";
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", number];
//    return [emailTest evaluateWithObject:str];
//}
-(BOOL)isSudoku:(NSString *)str
{
    NSString *other = @"➋➌➍➎➏➐➑➒";
    NSString *lastStr = [str substringFromIndex:str.length-1];
    if (![other containsString:lastStr]) {
        return NO;
    }
    
    unsigned long len=lastStr.length;
    for(int i=0; i<len; i++)
    {
        unichar a= [lastStr characterAtIndex:i];
        if(!((isalpha(a))
             ||(isalnum(a))
             ||((a=='_') || (a == '-'))
             ||((a >= 0x4e00 && a <= 0x9fa6))
             ||([other rangeOfString:lastStr].location != NSNotFound)
             ))
            return NO;
    }
    return YES;
}

-(void)sendInsertText:(NSString *)text
{
    NSLog(@"发送--------------------------------------------<%@>",text);
    [self.outPut sw_textViewDelegatOutputWithInsertString:text];
}
@end
