//
//  UIImage+LBSTColorImage.m
//  SudokuStart
//
//  Created by Laptop 16 on 9/16/14.
//  Copyright (c) 2014 Louis Brann, Rachel Macfarlane. All rights reserved.
//

#import "UIImage+LevelButtonColorImage.h"

@implementation UIImage (LevelButtonColorImage)

+ (UIImage*)imageWithColor: (UIColor*)color
{
  CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGContextSetFillColorWithColor(context, [color CGColor]);
  CGContextFillRect(context, rect);
  
  UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return img;
}

@end
