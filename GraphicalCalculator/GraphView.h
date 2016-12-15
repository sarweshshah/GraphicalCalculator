//
//  GraphView.h
//  GraphicalCalculator
//
//  Created by Sarwesh Shah (Intern) on 22/08/13.
//  Copyright (c) 2013 Sarwesh Shah (Intern). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AxesDrawer.h"

@protocol GraphViewDataSource;

//PUBLIC APIs
@interface GraphView : UIView
@property (nonatomic) float scale;
@property (nonatomic) int style;
@property (nonatomic,weak) id <GraphViewDataSource> datasource;
- (void)pinch: (UIGestureRecognizer *)pinchGesture;
- (void)resetZoom : (UITapGestureRecognizer *)tapGesture;
@end

//Protocols
@protocol GraphViewDataSource <NSObject>
- (NSNumber *)getFunctionValueForX:(float)x;
@end