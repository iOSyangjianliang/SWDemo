//
//  JLTextView.m
//  JLTextView
//
//  Created by 杨建亮 on 2018/4/26.
//  Copyright © 2018年 yangjianliang. All rights reserved.
//

#import "JLTextView.h"

@interface JLTextView ()<UITextInput>
//使用等大JLTextView解决占位符问题.方便设置富文本、typingAttributes等时的字体重叠显示
@property (nonatomic, weak) UITextView *placeholderView;
@property (nonatomic, assign) BOOL scrollEnabledLock;//当使用sizeToFitHight=YES时scrollEnabled外部设置无效

@property (nonatomic, assign) BOOL isNextDidChangeHeight;
@property (nonatomic, assign) CGFloat lastTextHeight;

@end

@implementation JLTextView
@dynamic text ;

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initDefaultData];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initDefaultData];
    }
    return self;
}
- (void)initDefaultData
{
    _jlLineHeight = self.font.lineHeight;
    _jlLineSpacing = 0.f;
    _jlCurryLines = 0;
    _jlFontSpacing = 0.f;

    _minNumberOfLines = 1;
    _maxNumberOfLines = NSUIntegerMax;
    _maxLength = NSUIntegerMax;
    _sizeToFitHight = NO;
    _isNextDidChangeHeight = NO;
    
    _placeholderColor = [UIColor colorWithRed:194.f/255.0f green:194.f/255.0f blue:194.f/255.0f alpha:1.0];
    _scrollEnabledLock = NO;
    _isAutoAdjustTextInsetBehavior = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
}
#pragma mark - placeholderView
- (UITextView *)placeholderView
{
    if (!_placeholderView ) {
        UITextView *placeholderView = [[UITextView alloc] initWithFrame:self.bounds];
        _placeholderView = placeholderView;
        _placeholderView.scrollEnabled = NO;
        _placeholderView.showsHorizontalScrollIndicator = NO;
        _placeholderView.showsVerticalScrollIndicator = NO;
        _placeholderView.userInteractionEnabled = NO;
        _placeholderView.textColor = _placeholderColor;
        _placeholderView.backgroundColor = [UIColor clearColor];
        _placeholderView.font = self.font;
        _placeholderView.attributedText = self.attributedText;
        _placeholderView.textContainerInset = self.textContainerInset;
        _placeholderView.hidden = self.text.length > 0?YES:NO;
        [self addSubview:placeholderView];
    }
    return _placeholderView;
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    self.placeholderView.textColor = placeholderColor;
}
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    if (_placeholder) {
        self.placeholderView.text = placeholder;
    }else{
        [_placeholderView removeFromSuperview];
    }
}
-(void)setSizeToFitHight:(BOOL)sizeToFitHight
{
    _sizeToFitHight = sizeToFitHight;
    if (_sizeToFitHight) {
        self.scrollEnabledLock = NO;
        self.scrollEnabled = NO;
        self.scrollEnabledLock = YES;
    }else{
        self.scrollEnabledLock = NO;
        self.scrollEnabled = YES;
    }
    if (!self.text||[self.text isEqualToString:@""]) {
        [self sizeToFitMinLinesHightWhenNoText];
    }else{
        [self sizeToFitHightWhenNeed];
    }
}
-(CGFloat)minTextHeight
{
    if (self.minNumberOfLines == 0) {
        return 0.0;
    }
    CGFloat heightMIN = self.jlLineHeight * self.minNumberOfLines+self.jlLineSpacing* (self.minNumberOfLines-1) + self.textContainerInset.top + self.textContainerInset.bottom +self.contentInset.top+self.contentInset.bottom;
    return ceilf(heightMIN);
}
-(CGFloat)maxTextHeight
{
    CGFloat heightMAX = self.jlLineHeight* self.maxNumberOfLines+self.jlLineSpacing* (self.maxNumberOfLines-1) + self.textContainerInset.top + self.textContainerInset.bottom+self.contentInset.top+self.contentInset.bottom;
    return ceilf(heightMAX);
}
-(void)setMaxLength:(NSUInteger)maxLength
{
    _maxLength = maxLength;
    if (self.text.length > _maxLength) {
        self.text = [self.text substringToIndex:_maxLength]; // 截取最大限制字符数.
    }
}
#pragma mark - 自适应高度
-(void)sizeToFitMinLinesHightWhenNoText
{
    if (self.sizeToFitHight && self.text.length==0)
    {
        BOOL heightChange = self.bounds.size.height!=self.minTextHeight;
        CGRect bounds = self.bounds;//对于旋转一定角度，设置frame可能会出错。若需要可以在_textHeightHandler再做调整frame
        bounds.size.height = self.minTextHeight;
        self.bounds = bounds;
        if (heightChange) {
            _lastTextHeight = self.minTextHeight;
            !_textHeightHandler ?: _textHeightHandler(self,self.minTextHeight);
        }
    }
}
-(void)sizeToFitHightWhenNeed
{
    if (self.sizeToFitHight)
    {
        CGFloat heightText  = [self calculateTextHeight];
        CGFloat heightTop_bottom  = [self jl_getHeightOfContentMargin];
        CGFloat height_textView = heightText+ heightTop_bottom;
        if (self.isNextDidChangeHeight || self.lastTextHeight != height_textView)
        {
            //优化系统输入时跳动
            self.scrollEnabledLock = NO;
            self.scrollEnabled = NO;
            self.scrollEnabledLock = YES;

            if (height_textView<=self.minTextHeight)
            {
                if (_isAutoAdjustTextInsetBehavior) {
                    super.textContainerInset = UIEdgeInsetsMake(8, 0, 8, 0);
                    _placeholderView.textContainerInset = super.textContainerInset;
                    self.contentInset = UIEdgeInsetsZero;
                    heightTop_bottom  = [self jl_getHeightOfContentMargin];
                    height_textView = heightText+heightTop_bottom;
                }
               

                CGRect bounds = self.bounds;
                bounds.size.height = self.minTextHeight;
                self.bounds = bounds;
                !_textHeightHandler ?: _textHeightHandler(self,self.minTextHeight);
            }
            else if (height_textView>=self.maxTextHeight)
            {
                if (_isAutoAdjustTextInsetBehavior) {
                    super.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
                    _placeholderView.textContainerInset = super.textContainerInset;
                    self.contentInset = UIEdgeInsetsMake(0, 0, 4, 0);
                    heightTop_bottom  = [self jl_getHeightOfContentMargin];
                    height_textView = heightText+heightTop_bottom;
                }
                //当高度大于自身高度时允许滚动
                self.scrollEnabledLock = NO;
                self.scrollEnabled = YES;
                self.scrollEnabledLock = YES;

                CGFloat H = self.maxTextHeight;
                CGRect bounds = self.bounds;
                bounds.size.height = H;
                self.bounds = bounds;
              
                !_textHeightHandler ?: _textHeightHandler(self,H);
           
            }else{
                if (_isAutoAdjustTextInsetBehavior) {
                    super.textContainerInset = UIEdgeInsetsMake(2, 0, 0, 0);
                    _placeholderView.textContainerInset = super.textContainerInset;
                    self.contentInset = UIEdgeInsetsMake(0, 0, 4,0);
                    heightTop_bottom  = [self jl_getHeightOfContentMargin];
                    height_textView = heightText+heightTop_bottom;
                }
                CGFloat H = height_textView;
                CGRect bounds = self.bounds;
                bounds.size.height = H;
                self.bounds = bounds;
                !_textHeightHandler ?: _textHeightHandler(self,H);

            }
            // 字符串高度改变时调整frame高度
            self.lastTextHeight = height_textView;
        }
    }
}
//为了解决bug
//如果是一行并且带中文，并且设置了间距lineSpace，结果多发现显示出来多了一个间距的高度。
- (CGFloat )calculateTextHeight
{
    CGFloat textHeight = [self jl_getTextHeightInTextView:self.text];

    //文本的高度减去字体高度小于等于行间距，判断为当前只有1行
    if (_jlLineSpacing>0.f)
    {
        if ( ( (textHeight - _jlLineHeight) - _jlLineSpacing) <= 0.01)
        {// -> (textHeight - _jlLineHeight) == _jlLineSpacing)
            if ([self containChinese:self.text])
            { //如果包含中文
                textHeight -= _jlLineSpacing;
            }
        }
    }
    //计算当前行数 nk1+(n-1)*k2 = s
    if ((_jlLineHeight+_jlLineSpacing)!=0) {
        CGFloat Lines = (textHeight+_jlLineSpacing)/(_jlLineHeight+_jlLineSpacing);
        _jlCurryLines = roundf(Lines);
        NSLog(@"jl_jlCurryLines%f",Lines);
    }

    return textHeight;
    
//fun 2
//    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:self.typingAttributes];
//    NSMutableParagraphStyle *attName =  [dictM objectForKey:NSParagraphStyleAttributeName];
//    if (attName) {
//        attName.lineSpacing = 0.f;
//        [dictM setObject:attName forKey:NSParagraphStyleAttributeName];
//    }
//
//    CGFloat  width = [self jl_getWidthOfContentText];
//    CGFloat textHeight =  [self.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dictM context:nil].size.height;
//
//    CGFloat Lines = textHeight/self.jlLineHeight;
//    _jlCurryLines = Lines;
//    NSLog(@"jl_jlCurryLines%f",Lines);
//
//    textHeight = textHeight+self.jlLineSpacing*(Lines-1);
//    NSLog(@"jl_textHeight%f",textHeight);
//    return textHeight;
}
//判断如果包含中文
- (BOOL)containChinese:(NSString *)str
{
    for(int i=0; i< [str length];i++){ int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}

//限制字符输入
-(void)limitCharacterLengthWhenNeed
{
    [self jl_limitTextViewMaxLengthWhenDidChange:self.maxLength];
    // 回调文本改变的Block.
    !_textLengthHandler ?: _textLengthHandler(self,self.text.length);
}
-(void)setMinNumberOfLines:(NSUInteger)minNumberOfLines
{
    NSUInteger lastMinNumberOfLines = self.minNumberOfLines;
    _minNumberOfLines = minNumberOfLines<_maxNumberOfLines?minNumberOfLines:_maxNumberOfLines;
    if (self.minNumberOfLines!=lastMinNumberOfLines) {
        self.isNextDidChangeHeight = YES;
        [self sizeToFitHightWhenNeed];
    }
}
- (void)setMaxNumberOfLines:(NSUInteger)maxNumberOfLines
{
    NSUInteger lastMaxNumberOfLines = self.maxNumberOfLines;
    _maxNumberOfLines = maxNumberOfLines>_minNumberOfLines?maxNumberOfLines:_minNumberOfLines;
    if (self.maxNumberOfLines!=lastMaxNumberOfLines) {
        self.isNextDidChangeHeight = YES;
        [self sizeToFitHightWhenNeed];
    }
}
#pragma mark - NSNotification
- (void)textDidChange:(NSNotification *)notification
{    
    //隐藏placeholderView
    _placeholderView.hidden = self.text.length > 0?YES:NO;
    
    //限制字符输入
    [self limitCharacterLengthWhenNeed];
    
    //自适应高度
    [self sizeToFitHightWhenNeed];
}
#pragma mark - 重写父类方法
-(void)setScrollEnabled:(BOOL)scrollEnabled
{
    if (!self.scrollEnabledLock) {
        [super setScrollEnabled:scrollEnabled];
    }
}
- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    [_placeholderView setFont:font];
    
    [self updateCurry_jlLineHeight_jlLineSpacing];//若已设置富文本、再设置font，font自动加入typingAttributes中、并调整富文本
    self.isNextDidChangeHeight = YES;
    [self sizeToFitHightWhenNeed];
}
-(void)updateCurry_jlLineHeight_jlLineSpacing
{
    NSParagraphStyle *paragraphStyle =  [self.typingAttributes objectForKey:NSParagraphStyleAttributeName];
    if (paragraphStyle)
    {
        if (paragraphStyle.minimumLineHeight<self.font.lineHeight)
        {
            _jlLineHeight = self.font.lineHeight;
        }else{
            _jlLineHeight = paragraphStyle.minimumLineHeight;
        }
        _jlLineSpacing = paragraphStyle.lineSpacing;
    }else
    {
        _jlLineHeight = self.font.lineHeight;
        _jlLineSpacing = 0.f;
    }
}
- (void)setText:(NSString *)text
{
    [super setText:text];
    [self textDidChange:nil];
}
-(void)setTextContainerInset:(UIEdgeInsets)textContainerInset
{
    UIEdgeInsets old = self.textContainerInset;

    [super setTextContainerInset:textContainerInset];
    [_placeholderView setTextContainerInset:textContainerInset];

    if (!UIEdgeInsetsEqualToEdgeInsets(old, textContainerInset)) {
        self.isNextDidChangeHeight = YES;
        [self sizeToFitHightWhenNeed];
    }
}
-(void)setTypingAttributes:(NSDictionary<NSString *,id> *)typingAttributes
{
    NSMutableDictionary *dictM;
    if ([typingAttributes isKindOfClass:NSMutableDictionary.class]) {
        dictM = (NSMutableDictionary *)typingAttributes;
    }else{
        dictM = [NSMutableDictionary dictionaryWithDictionary:typingAttributes];
    }
    //自动将font、textColor设置为当前富文本(如果未设置。而不是使用富文本的默认值)
    if (![typingAttributes objectForKey:NSFontAttributeName] && self.font)
    {
        [dictM setObject:self.font forKey:NSFontAttributeName];
    }
    if (![typingAttributes objectForKey:NSForegroundColorAttributeName]&&self.textColor)
    {
        [dictM setObject:self.textColor forKey:NSForegroundColorAttributeName];
    }
    [super setTypingAttributes:dictM];
    [self setTypingAttributes_placeholderView:dictM];

    
    NSNumber *num = [typingAttributes objectForKey:NSKernAttributeName];
    if (num){
        _jlFontSpacing = num.floatValue;
    }else{
        _jlFontSpacing = 0.f;
    }
    
    [self updateCurry_jlLineHeight_jlLineSpacing];
    self.isNextDidChangeHeight = YES;
    [self sizeToFitHightWhenNeed];
}
-(void)setTypingAttributes_placeholderView:(NSDictionary<NSString *,id> *)typingAttributes
{
    //_placeholderView
    NSMutableDictionary *dictM_placeholder = [NSMutableDictionary dictionaryWithDictionary:typingAttributes];
    if ([dictM_placeholder objectForKey:NSBackgroundColorAttributeName]) {//字体背景色
        [dictM_placeholder removeObjectForKey:NSBackgroundColorAttributeName];
    }
    if ([dictM_placeholder objectForKey:NSShadowAttributeName]) {//阴影色
        [dictM_placeholder removeObjectForKey:NSShadowAttributeName];
    }
    if ([dictM_placeholder objectForKey:NSStrokeColorAttributeName]) {//字体背景色
        [dictM_placeholder removeObjectForKey:NSStrokeColorAttributeName];
    }
    if ([dictM_placeholder objectForKey:NSBackgroundColorAttributeName]) {//描边色
        [dictM_placeholder removeObjectForKey:NSBackgroundColorAttributeName];
        [dictM_placeholder removeObjectForKey:NSStrokeWidthAttributeName];
    }
    if ([dictM_placeholder objectForKey:NSStrikethroughColorAttributeName]) {//删除线颜色
        [dictM_placeholder removeObjectForKey:NSStrikethroughColorAttributeName];
        [dictM_placeholder removeObjectForKey:NSStrikethroughStyleAttributeName];
        [dictM_placeholder removeObjectForKey:NSStrikethroughStyleAttributeName];
    }
    if ([dictM_placeholder objectForKey:NSUnderlineColorAttributeName]) {//下划线颜色
        [dictM_placeholder removeObjectForKey:NSUnderlineColorAttributeName];
        [dictM_placeholder removeObjectForKey:NSBaselineOffsetAttributeName];
        [dictM_placeholder removeObjectForKey:NSUnderlineStyleAttributeName];
    }
    _placeholderView.typingAttributes = dictM_placeholder;
    _placeholderView.text = self.placeholder;
    _placeholderView.textColor = self.placeholderColor;
}
-(void)layoutSubviews
{
//    NSLog(@"JLTextView layoutSubviews");
    [super layoutSubviews];
    [self sizeToFitMinLinesHightWhenNoText];
    if (_placeholderView) {
        if (!CGRectEqualToRect(self.bounds, _placeholderView.frame)) {
            _placeholderView.frame = self.bounds;
        }
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - UITextInput 修正光标在富文本中位置
- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    CGRect originalRect = [super caretRectForPosition:position];
    NSMutableParagraphStyle *attName =  [self.typingAttributes objectForKey:NSParagraphStyleAttributeName];
    if (attName) {
        originalRect.origin.y = originalRect.origin.y+(_jlLineHeight-self.font.lineHeight);
    }
    NSNumber *baselineOffset = [self.typingAttributes objectForKey: NSBaselineOffsetAttributeName];
    if (baselineOffset) {
        originalRect.origin.y-= baselineOffset.floatValue;
    }
    originalRect.size.height = self.font.lineHeight;
    return originalRect;
}
//基于UITextView的typingAttributes富文本设置行高、字体
- (void)setTypingAttributesWithLineHeight:(CGFloat)lineHeight lineSpacing:(CGFloat)lineSpacing textFont:(nullable UIFont *)font textColor:(nullable UIColor *)color;
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;// 字体的行间距
    paragraphStyle.minimumLineHeight = lineHeight ;// 字体的行高
    UIFont *attFont = font?font:self.font;
    UIColor *attColor = color?color:self.textColor;
    
    CGFloat attLineHeight = lineHeight>attFont.lineHeight?lineHeight:attFont.lineHeight;
   
    NSNumber *attOffset = @((attLineHeight-attFont.lineHeight)/2.f);//居中
    NSDictionary *attr = @{
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 NSBaselineOffsetAttributeName:attOffset
                                 };
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:attr];
    if (attFont) {
        [attributes setObject:attFont forKey:NSFontAttributeName];
    }
    if (attColor) {
        [attributes setObject:attColor forKey:NSForegroundColorAttributeName];
    }
    self.typingAttributes = attributes;
}
@end

@implementation UITextView (JLSizeCalculate)
- (void)jl_limitTextViewMaxLengthWhenDidChange:(NSUInteger)maxLength
{
    NSString *lang = [[self.nextResponder textInputMode] primaryLanguage]; // 键盘输入模式
    // 简体中文输入，包括简体拼音，健体五笔，简体手写
    if ([lang isEqualToString:@"zh-Hans"])
    {
        UITextRange *selectedRange = [self markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position)
        {
            if (self.text.length > maxLength) {
                self.text = [self.text substringToIndex:maxLength]; // 截取最大限制字符数.
                [self.undoManager removeAllActions]; // 达到最大字符数后清空所有undoaction, 以免undo操作(复制过来一个长度很长的字符串，粘贴过后，摇晃手机，点击撤销)造成crash. 注:在粘贴超出长度撤销操作触发字符串越界所致，若自定义实现超出字符串截断再粘贴，会自动丢失摇晃手机撤销功能。还是超出长度粘贴取消撤销功能这样较为简便
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else
        {
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else
    {
        if (self.text.length > maxLength)
        {
            self.text = [ self.text substringToIndex:maxLength];
            [self.undoManager removeAllActions];
        }
    }
    
}
//左右
- (CGFloat)jl_getWidthOfContentText
{
    CGFloat contentWidth = CGRectGetWidth(self.frame);
  
//    CGSize size = CGSizeApplyAffineTransform(self.bounds.size, self.transform);//处理textView旋转等情况
//    CGFloat contentWidth = size.width;

    //内容需要除去显示的边框值= 文本排版真正宽度
    CGFloat broadWith    = (  self.contentInset.left
                            + self.contentInset.right
                            + self.textContainerInset.left
                            + self.textContainerInset.right
                            + self.textContainer.lineFragmentPadding/*左边距*/
                            + self.textContainer.lineFragmentPadding/*右边距*/
                            );
    contentWidth -= broadWith;
    return contentWidth;
}
//上下
- (CGFloat)jl_getHeightOfContentMargin
{
    CGFloat broadHeight  = (  self.contentInset.top
                            + self.contentInset.bottom
                            + self.textContainerInset.top
                            + self.textContainerInset.bottom);//+self.textContainer.lineFragmentPadding/*top*//*+self*//*there is no bottom padding*/);
    return broadHeight;
}


- (CGFloat)jl_getTextHeightInTextView:(NSString *)text
{
    CGFloat  width = [self jl_getWidthOfContentText];
    CGSize InSize = CGSizeMake(width, MAXFLOAT);
    CGFloat textHeight =  [text boundingRectWithSize:InSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:self.typingAttributes context:nil].size.height;
    NSLog(@"text Height=%f",textHeight);
    return textHeight;
}

- (CGFloat)jl_getTextViewHeightInTextView:(NSString *)text
{
    CGFloat  textHeight = [self jl_getTextHeightInTextView:text];
    CGFloat broadHeight  = [self jl_getHeightOfContentMargin];
    CGFloat height = ceilf(textHeight+broadHeight);
    NSLog(@"TextView Heigh=%f",height);
    return height;
}
@end
