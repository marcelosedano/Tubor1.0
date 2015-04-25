//
//  TuborBlueButton.m
//  Tubor
//
//  Created by Marcelo Sedano on 3/27/15.
//  Copyright (c) 2015 Marcelo Sedano. All rights reserved.
//

#import "TuborBlueButton.h"

@implementation TuborBlueButton

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* buttonColorDark = [UIColor colorWithRed: 0.083 green: 0.192 blue: 0.318 alpha: 1];
    UIColor* buttonColorLight = [UIColor colorWithRed: 0.231 green: 0.514 blue: 0.844 alpha: 1];
    UIColor* innerGlowColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.51];
    UIColor* fillColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    
    //// Gradient Declarations
    NSArray* buttonGradientColors = [NSArray arrayWithObjects:
                                     (id)buttonColorLight.CGColor,
                                     (id)buttonColorDark.CGColor, nil];
    CGFloat buttonGradientLocations[] = {0, 1};
    CGGradientRef buttonGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)buttonGradientColors, buttonGradientLocations);
    
    //// Shadow Declarations
    UIColor* highlight = innerGlowColor;
    CGSize highlightOffset = CGSizeMake(0.1, 2.1);
    CGFloat highlightBlurRadius = 2;
    
    //// Frames
    CGRect frame = rect;
    
    
    //// Abstracted Attributes
    //NSString* textContent = @"Log in";
    
    
    //// Button
    {
        //// Rounded Rectangle Drawing
        CGRect roundedRectangleRect = CGRectMake(CGRectGetMinX(frame) + 4, CGRectGetMinY(frame) + 4, CGRectGetWidth(frame) - 7, floor((CGRectGetHeight(frame) - 4) * 0.91111 + 0.5));
        UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: roundedRectangleRect cornerRadius: 4];
        CGContextSaveGState(context);
        CGContextBeginTransparencyLayer(context, NULL);
        [roundedRectanglePath addClip];
        CGContextDrawLinearGradient(context, buttonGradient,
                                    CGPointMake(CGRectGetMidX(roundedRectangleRect), CGRectGetMinY(roundedRectangleRect)),
                                    CGPointMake(CGRectGetMidX(roundedRectangleRect), CGRectGetMaxY(roundedRectangleRect)),
                                    0);
        CGContextEndTransparencyLayer(context);
        
        ////// Rounded Rectangle Inner Shadow
        CGRect roundedRectangleBorderRect = CGRectInset([roundedRectanglePath bounds], -highlightBlurRadius, -highlightBlurRadius);
        roundedRectangleBorderRect = CGRectOffset(roundedRectangleBorderRect, -highlightOffset.width, -highlightOffset.height);
        roundedRectangleBorderRect = CGRectInset(CGRectUnion(roundedRectangleBorderRect, [roundedRectanglePath bounds]), -1, -1);
        
        UIBezierPath* roundedRectangleNegativePath = [UIBezierPath bezierPathWithRect: roundedRectangleBorderRect];
        [roundedRectangleNegativePath appendPath: roundedRectanglePath];
        roundedRectangleNegativePath.usesEvenOddFillRule = YES;
        
        CGContextSaveGState(context);
        {
            CGFloat xOffset = highlightOffset.width + round(roundedRectangleBorderRect.size.width);
            CGFloat yOffset = highlightOffset.height;
            CGContextSetShadowWithColor(context,
                                        CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                        highlightBlurRadius,
                                        highlight.CGColor);
            
            [roundedRectanglePath addClip];
            CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(roundedRectangleBorderRect.size.width), 0);
            [roundedRectangleNegativePath applyTransform: transform];
            [[UIColor grayColor] setFill];
            [roundedRectangleNegativePath fill];
        }
        CGContextRestoreGState(context);
        
        CGContextRestoreGState(context);
        
        [[UIColor blackColor] setStroke];
        roundedRectanglePath.lineWidth = 1;
        [roundedRectanglePath stroke];
        
        
        //// Text Drawing
        CGRect textRect = CGRectMake(CGRectGetMinX(frame) + floor(CGRectGetWidth(frame) * 0.00625 + 0.5), CGRectGetMinY(frame) + floor(CGRectGetHeight(frame) * 0.30612 + 0.5), floor(CGRectGetWidth(frame) * 0.98958 + 0.5) - floor(CGRectGetWidth(frame) * 0.00625 + 0.5), floor(CGRectGetHeight(frame) * 0.75510 + 0.5) - floor(CGRectGetHeight(frame) * 0.30612 + 0.5));
        [fillColor setFill];
        [self.buttonText drawInRect: textRect withFont: [UIFont boldSystemFontOfSize: [UIFont systemFontSize]] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
    }
    
    
    //// Cleanup
    CGGradientRelease(buttonGradient);
    CGColorSpaceRelease(colorSpace);
    

}


@end
