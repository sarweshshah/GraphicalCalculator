//
//  GraphView.m
//  GraphicalCalculator
//
//  Created by Sarwesh Shah (Intern) on 22/08/13.
//  Copyright (c) 2013 Sarwesh Shah (Intern). All rights reserved.
//

#import "GraphView.h"
#define NO_OF_INTEGARS_SHOWN_IN_THE_GRAPH 5
#define DEFAULT_SCALE self.bounds.size.width/NO_OF_INTEGARS_SHOWN_IN_THE_GRAPH

@interface GraphView()
@end

@implementation GraphView

@synthesize datasource = _datasource;
@synthesize scale = _scale;
@synthesize style = _style;

-(float)scale{
    if (!_scale) {
        return DEFAULT_SCALE;
    } else {
        return _scale;
    }
}
-(void)setScale:(float)scale{
    if (_scale!=scale) {
        _scale=scale;
        [self setNeedsDisplay];
    }
}

-(int)style{
    if (!_style) {
        return 0;
    }else
        return _style;
}
-(void)setStyle:(int)style{
    if (_style!=style) {
        _style=style;
        [self setNeedsDisplay];
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)pinchGesture{
    if ((pinchGesture.state == UIGestureRecognizerStateChanged) ||
        (pinchGesture.state == UIGestureRecognizerStateEnded)) {
        self.scale *= pinchGesture.scale;
        pinchGesture.scale = 1;
    }
}

- (void)resetZoom:(UITapGestureRecognizer *)tapGesture{
    tapGesture.numberOfTapsRequired = 2;
    self.scale = DEFAULT_SCALE;
}

- (void)panGraph:(UIPanGestureRecognizer *)panGesture{
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setMinimumNumberOfTouches:2];
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void) drawPointatPosition : (CGPoint)position inContext:(CGContextRef)context{
    [[UIColor colorWithRed:52/255.0 green:83/255.0 blue:51/255.0 alpha:1.0] set];
    CGContextFillRect(context, CGRectMake(position.x, position.y, 1, 1));
}

//Add parameter of origin and change code accordingly
- (void) drawGraphInContext:(CGContextRef)context{
    if (self.style) {
        for (float a = -self.bounds.size.width/2; a<=self.bounds.size.width/2; a++) {
            CGPoint p;
            float b = [[self.datasource getFunctionValueForX:(a/self.scale)]doubleValue];
            b *= self.scale;
            p.x = a + self.bounds.size.width/2;
            p.y = self.bounds.size.height/2 - b;
            [self drawPointatPosition:p inContext:context];
        }
    }else{
        CGContextBeginPath(context);
        [[UIColor colorWithRed:52/255.0 green:83/255.0 blue:51/255.0 alpha:1.0] set];
        float b = [[self.datasource getFunctionValueForX:((-self.bounds.size.width/2)/self.scale)]doubleValue];
        b *= self.scale;
        CGContextMoveToPoint( context, 0, self.bounds.size.height/2 - b);
        CGPoint p[3];
        for (float a = -self.bounds.size.width/2; a<=self.bounds.size.width/2; a++) {
            float b = [[self.datasource getFunctionValueForX:(a/self.scale)]doubleValue];
            b *= self.scale;
            p[0].x = a + self.bounds.size.width/2;
            p[0].y = self.bounds.size.height/2 - b;
            a++;
            b = [[self.datasource getFunctionValueForX:(a/self.scale)]doubleValue];
            b *= self.scale;
            p[1].x = a + self.bounds.size.width/2;
            p[1].y = self.bounds.size.height/2 - b;
            a++;
            b = [[self.datasource getFunctionValueForX:(a/self.scale)]doubleValue];
            b *= self.scale;
            p[2].x = a + self.bounds.size.width/2;
            p[2].y = self.bounds.size.height/2 - b;
            CGContextAddCurveToPoint(context, p[0].x, p[0].y, p[1].x, p[1].y, p[2].x, p[2].y);
            CGContextStrokePath(context);
            CGContextMoveToPoint(context,p[2].x,p[2].y);
        }
    }
}

- (void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    
    CGPoint midpoint;
    midpoint.x = self.bounds.size.width/2;
    midpoint.y = self.bounds.size.height/2;
    
    CGFloat size = self.bounds.size.width/NO_OF_INTEGARS_SHOWN_IN_THE_GRAPH;
    if (self.bounds.size.height < self.bounds.size.width) {
        size = self.bounds.size.height/NO_OF_INTEGARS_SHOWN_IN_THE_GRAPH;
    }
    size *= self.scale;
    
    [[UIColor colorWithRed:161/255.0 green:102/255.0 blue:97/255.0 alpha:1.0] setStroke];
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:midpoint scale:self.scale];
    UIGraphicsPushContext(context);
    
    //Calculate the origin and pass it into drawGraphInContext:atOrigin:
    
    [self drawGraphInContext:context];
    UIGraphicsPopContext();
}

@end