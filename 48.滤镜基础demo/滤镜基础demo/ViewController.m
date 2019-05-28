//
//  ViewController.m
//  滤镜基础demo
//
//  Created by 杨建亮 on 2019/3/15.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self allCIFilters];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 230, 600)];
    [self.view addSubview:imageV];
   
    
    UIImage *img = [self testCIFilter];

//    UIImage *img = [self grayImage:[UIImage imageNamed:@"1"] ];

    
    
    imageV.image = img;
    
    
}
-(UIImage *)testCIFilter
{
    // 创建输入CIImage对象
    CIImage * inputImg = [[CIImage alloc] initWithImage:[UIImage imageNamed:@"1.png"]];
    // 创建滤镜
    CIFilter * filter = [CIFilter filterWithName:@"CIHueAdjust"];//

    [filter setValue:[NSNumber numberWithFloat:(0.5 * M_PI)] forKey:@"inputAngle"];//色调  -3.14 -- 3.14 默认为0


    // 设置滤镜属性值为默认值
    [filter setDefaults];
    // 设置输入图像
    [filter setValue:inputImg forKey:@"inputImage"];
    // 获取输出图像
    CIImage * outputImg = [filter valueForKey:@"outputImage"];
    
    // 创建CIContex上下文对象
    CIContext * context = [CIContext contextWithOptions:nil];
    CGImageRef cgImg = [context createCGImage:outputImg fromRect:outputImg.extent];
    UIImage *resultImg = [UIImage imageWithCGImage:cgImg];

    
    CGImageRelease(cgImg);
    
    return resultImg;
}

-(void)allCIFilters
{
    NSArray *cifilter = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
    
    NSLog(@"FilterName:\n%@,,,===%ld", cifilter,cifilter.count);//显示所有过滤器名字
    
    for (NSString *filterName in cifilter) {
        
        CIFilter *fltr = [CIFilter filterWithName:filterName];
        //用一个过滤器名字生成一个过滤器CIFilter对象
        NSLog(@":\n%@", [fltr attributes]);
    }
}
-(UIImage *)testsss1
{
    
    CIImage *beginImage = [[CIImage alloc]initWithImage:[UIImage imageNamed:@"1"]];
    //创建滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochrome"];
    //设置滤镜参数
    [filter setValue:beginImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:1] forKey:kCIInputIntensityKey];
    [filter setValue:[CIColor colorWithRed:1 green:0 blue:0] forKey:kCIInputColorKey];
    CIImage *outputImage = [filter outputImage];
    //GPU优化
    EAGLContext *eaglContext = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES3];
    eaglContext.multiThreaded = YES;
    
    CIContext *context = [CIContext contextWithEAGLContext:eaglContext];
    [EAGLContext setCurrentContext:eaglContext];
    
    
    CGImageRef ref = [context createCGImage:outputImage fromRect:outputImage.extent];
    UIImage *endImage = [UIImage imageWithCGImage:ref];
    CGImageRelease(ref);

    return endImage;
}


//方法1：
//UIImage:去色功能的实现（图片灰色显示）
- (UIImage*)grayImage:(UIImage*)sourceImage {
      int width = sourceImage.size.width;
      int height = sourceImage.size.height;
      CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
      CGContextRef context = CGBitmapContextCreate (nil, width, height,8,0, colorSpace,kCGImageAlphaNone);
      CGColorSpaceRelease(colorSpace);
      if (context ==NULL)
      {
          return sourceImage;
      }
      CGContextDrawImage(context,CGRectMake(0,0, width, height), sourceImage.CGImage);
      UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
      CGContextRelease(context);
      return grayImage;
}
/**
//方法2：
- (UIImage*)grayscaleImageForImage:(UIImage*)image {
      // Adapted from this thread: http://stackoverflow.com/questions/1298867/convert-image-to-grayscale
      const int RED =1;
      const int GREEN =2;
      const int BLUE =3;
 
      // Create image rectangle with current image width/height
      CGRect imageRect = CGRectMake(0,0, image.size.width* image.scale, image.size.height* image.scale);
 
      int width = imageRect.size.width;
      int height = imageRect.size.height;
 
      // the pixels will be painted to this array
      uint32_t *pixels = (uint32_t*) malloc(width * height *sizeof(uint32_t));
 
      // clear the pixels so any transparency is preserved
      memset(pixels,0, width * height *sizeof(uint32_t));
 
      CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
 
      // create a context with RGBA pixels
      CGContextRef context = CGBitmapContextCreate(pixels, width, height,8, width *sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
 
      // paint the bitmap to our context which will fill in the pixels array
      CGContextDrawImage(context,CGRectMake(0,0, width, height), [imageCGImage]);
 
      for(inty = 0; y < height; y++) {
            for(intx = 0; x < width; x++) {
                  uint8_t *rgbaPixel = (uint8_t*) &pixels[y * width + x];
   
                  // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
                  uint32_t gray = 0.3 * rgbaPixel[RED] +0.59 * rgbaPixel[GREEN] +0.11 * rgbaPixel[BLUE];
   
                  // set the pixels to gray
                  rgbaPixel[RED] = gray;
                  rgbaPixel[GREEN] = gray;
                  rgbaPixel[BLUE] = gray;
                }
          }
 
      // create a new CGImageRef from our context with the modified pixels
      CGImageRef imageRef = CGBitmapContextCreateImage(context);
 
      // we're done with the context, color space, and pixels
      CGContextRelease(context);
      CGColorSpaceRelease(colorSpace);
      free(pixels);
 
      // make a new UIImage to return
      UIImage *resultUIImage = [UIImageimageWithCGImage:imageRefscale:image.scaleorientation:UIImageOrientationUp];
 
      // we're done with image now too
      CGImageRelease(imageRef);
 
      return resultUIImage;
}
*/

- (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image{
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    
    CVPixelBufferRef pxbuffer = NULL;
    
    CGFloat frameWidth = CGImageGetWidth(image);
    CGFloat frameHeight = CGImageGetHeight(image);
    
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,
                                          frameWidth,
                                          frameHeight,
                                          kCVPixelFormatType_32ARGB,
                                          (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pxdata,
                                                 frameWidth,
                                                 frameHeight,
                                                 8,
                                                 CVPixelBufferGetBytesPerRow(pxbuffer),
                                                 rgbColorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaNoneSkipFirst);
    NSParameterAssert(context);
    CGContextConcatCTM(context, CGAffineTransformIdentity);
    CGContextDrawImage(context, CGRectMake(0,
                                           0,
                                           frameWidth,
                                           frameHeight),
                       image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}
//pixelBuffer-CIImage-CGImage-UIImage
- (UIImage *)convert:(CVPixelBufferRef)pixelBuffer {
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
    
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext
                             createCGImage:ciImage
                             fromRect:CGRectMake(0, 0, CVPixelBufferGetWidth(pixelBuffer), CVPixelBufferGetHeight(pixelBuffer))];
    
    UIImage *uiImage = [UIImage imageWithCGImage:videoImage];
    CGImageRelease(videoImage);
    
    return uiImage;
}
//UIImage-CGContext-CGImage-UIImage
- (CVPixelBufferRef )my_grayImage:(CVPixelBufferRef)pxbuffer
{
//    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pxbuffer];
    UIImage *sourceImage = [self convert:pxbuffer];
    
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil, width, height,8,0, colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    if (context ==NULL)
    {
        return pxbuffer;
    }
    CGContextDrawImage(context,CGRectMake(0,0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
  
  
    CVPixelBufferRef ff = [self pixelBufferFaster:CGBitmapContextCreateImage(context)];
    
    CGContextRelease(context);
    return ff;
}


//CGImageRef->CVPixelBufferRef
- (CVPixelBufferRef)pixelBufferFaster:(CGImageRef )image
{
    
    CVPixelBufferRef pxbuffer = NULL;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    
    size_t width =  CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    size_t bytesPerRow = CGImageGetBytesPerRow(image);
    
    CFDataRef  dataFromImageDataProvider = CGDataProviderCopyData(CGImageGetDataProvider(image));
    GLubyte  *imageData = (GLubyte *)CFDataGetBytePtr(dataFromImageDataProvider);
    
    CVPixelBufferCreateWithBytes(kCFAllocatorDefault,width,height,kCVPixelFormatType_32ARGB,imageData,bytesPerRow,NULL,NULL,(__bridge CFDictionaryRef)options,&pxbuffer);
    
    CFRelease(dataFromImageDataProvider);
    
    return pxbuffer;
    
}
//CGImageRef->CVPixelBufferRef
- (CVPixelBufferRef)pixelBufferFromCGImageWithPool:(CVPixelBufferPoolRef)pixelBufferPool cgimage:(CGImageRef )image
{
    
    CVPixelBufferRef pxbuffer = NULL;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    
    size_t width =  CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    size_t bytesPerRow = CGImageGetBytesPerRow(image);
    size_t bitsPerComponent = CGImageGetBitsPerComponent(image);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(image);
    void *pxdata = NULL;
    
    
    if (pixelBufferPool == NULL)
        NSLog(@"pixelBufferPool is null!");
    
    CVReturn status = CVPixelBufferPoolCreatePixelBuffer (NULL, pixelBufferPool, &pxbuffer);
    if (pxbuffer == NULL) {
        status = CVPixelBufferCreate(kCFAllocatorDefault, width,
                                     height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options,
                                     &pxbuffer);
    }
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    
    NSParameterAssert(pxdata != NULL);
    
    if(1){
        
        CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(pxdata, width,
                                                     height,bitsPerComponent,bytesPerRow, rgbColorSpace,
                                                     bitmapInfo);
        NSParameterAssert(context);
        CGContextConcatCTM(context, CGAffineTransformMakeRotation(0));
        CGContextDrawImage(context, CGRectMake(0, 0, width,height), image);
        CGColorSpaceRelease(rgbColorSpace);
        CGContextRelease(context);
    }else{
        
        
        CFDataRef  dataFromImageDataProvider = CGDataProviderCopyData(CGImageGetDataProvider(image));
        CFIndex length = CFDataGetLength(dataFromImageDataProvider);
        GLubyte  *imageData = (GLubyte *)CFDataGetBytePtr(dataFromImageDataProvider);
        memcpy(pxdata,imageData,length);
        
        CFRelease(dataFromImageDataProvider);
    }
    
    
    return pxbuffer;
    
}


@end
