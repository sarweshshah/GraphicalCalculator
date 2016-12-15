//
//  GraphicalViewController.m
//  GraphicalCalculator
//
//  Created by Sarwesh Shah (Intern) on 22/08/13.
//  Copyright (c) 2013 Sarwesh Shah (Intern). All rights reserved.
//

#import "GraphicalViewController.h"

@interface GraphicalViewController () 
- (IBAction)zoomSlide:(UISlider *)sender;
@end

@implementation GraphicalViewController
@synthesize graph = _graph;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize toolbar = _toolbar;

- (void) setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem{
    if (_splitViewBarButtonItem != splitViewBarButtonItem) {
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
        if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
        self.toolbar.items = toolbarItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}

- (void) setGraph:(GraphView *)graph
{
    if (!_graph) {
        _graph=graph;
    }
    [self.graph addGestureRecognizer:[[UIPinchGestureRecognizer alloc]initWithTarget:self.graph action:@selector(pinch:)]];
    [self.graph addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self.graph action:@selector(resetZoom:)]];
    [self.graph addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self.graph action:@selector(panGraph:)]];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    [self.view setNeedsDisplay];
    return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)zoomSlide:(UISlider *)sender {
    self.graph.scale = sender.value;
}

- (IBAction)chooseStyle:(UISwitch *)sender {
    if (sender.on) {
        self.graph.style = 1;
    }else{
        self.graph.style = 0;
    }
}
@end
