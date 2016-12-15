//
//  GraphicalViewController.h
//  GraphicalCalculator
//
//  Created by Sarwesh Shah (Intern) on 22/08/13.
//  Copyright (c) 2013 Sarwesh Shah (Intern). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"
#import "SplitViewBarButtonItemPresenter.h"

@interface GraphicalViewController : UIViewController <SplitViewBarButtonItemPresenter>
- (IBAction)chooseStyle:(UISwitch *)sender;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet GraphView *graph;
@end
