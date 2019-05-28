//
//  UIViewController+test.h
//  runtime交换注意点
//
//  Created by 杨建亮 on 2019/1/11.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

//交换二个实例方法的IMP（方法实现）
static inline void jl_Swizzling_exchangeMethod(Class theClass, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(theClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(theClass, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

//class_addMethod的实现会覆盖父类的方法实现，但不会取代本类中已存在的实现，如果本类中包含一个同名的实现，则函数会返回NO
static inline BOOL jl_addMethod(Class theClass, SEL selector, Method method) {
    return class_addMethod(theClass, selector,  method_getImplementation(method),  method_getTypeEncoding(method));
}


@interface UIViewController (test)

@end

NS_ASSUME_NONNULL_END
