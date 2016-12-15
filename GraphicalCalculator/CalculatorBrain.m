//
//  CalculatorBrain.m
//  RPNCalculator
//
//  Created by Sarwesh Shah (Intern) on 05/08/13.
//  Copyright (c) 2013 Sarwesh Shah (Intern). All rights reserved.
//

#import "CalculatorBrain.h"


@implementation CalculatorBrain

@synthesize stack=_stack;
@synthesize variableValues=_variableValues;

-(NSMutableArray *)stack{
    if (_stack==nil) {
        _stack= [[NSMutableArray alloc]init];
    }
    return _stack;
}

-(NSMutableDictionary *)variableValues{
    if (!_variableValues) {
        _variableValues=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                         [NSNumber numberWithDouble:0],@"x",
                         nil];
    }
    return _variableValues;
}

-(id)program{
    return [self.stack mutableCopy];
}

-(void)pushOperand: (double)anOperand{
    [self.stack addObject:[NSNumber numberWithDouble:anOperand]];
}

-(void)pushVariables: (NSString *)aVariable{
    if([aVariable isKindOfClass:[NSString class]])
    [self.stack addObject:aVariable];
}

-(double)performOperation: (NSString *)operation{
    [self.stack addObject:operation];
    return [CalculatorBrain runProgram:self.program usingVariableValues:self.variableValues];
}

+ (double)popEntryofgivenStack:(NSMutableArray *)givenstack{
    double result = 0;
    id topOfgivenStack = [givenstack lastObject];
    if (topOfgivenStack)[givenstack removeLastObject];
    if ([topOfgivenStack isKindOfClass:[NSNumber class]]) {
        result = [topOfgivenStack doubleValue];
    }else if([topOfgivenStack isKindOfClass:[NSString class]]){
        NSString *operation = topOfgivenStack;
        if ([operation isEqual:@"+"]){
            result = [self popEntryofgivenStack:givenstack] + [self popEntryofgivenStack:givenstack];
        }else if ([operation isEqual:@"*"]){
            result = [self popEntryofgivenStack:givenstack] * [self popEntryofgivenStack:givenstack];
        }else if([operation isEqual:@"-"]){
            double subtrand=[self popEntryofgivenStack:givenstack];
            result = [self popEntryofgivenStack:givenstack] - subtrand;
        }else if([operation isEqual:@"/"]){
            double divisor=[self popEntryofgivenStack:givenstack];
            result = [self popEntryofgivenStack:givenstack] / divisor;
        }else if([operation isEqual:@"√x"]){
            double r=[self popEntryofgivenStack:givenstack];
            if(r>=0) result=sqrt(r);
        }else if ([operation isEqual:@"sin"]){
            result=sin(([self popEntryofgivenStack:givenstack]/180)*M_PI);
        }else if ([operation isEqual:@"cos"]){
            result=cos(([self popEntryofgivenStack:givenstack]/180)*M_PI);
        }else if ([operation isEqual:@"tan"]){
            result=tan(([self popEntryofgivenStack:givenstack]/180)*M_PI);
        }else if ([operation isEqual:@"π"]){
            result=M_PI;
        }
    }
    return result;
}

+ (double)runProgram:(id)aProgram{
    NSMutableArray *givenstack;
    if ([aProgram isKindOfClass:[NSArray class]]) {
        givenstack=[aProgram mutableCopy];
    }
    return [self popEntryofgivenStack:givenstack];
}

+ (double)runProgram:(id)program
 usingVariableValues:(NSDictionary *)variableVal
{
    NSMutableArray *givenstack=[[NSMutableArray alloc]init];
    NSMutableArray *toDelete;
    if ([program isKindOfClass:[NSArray class]]) {
        toDelete = [program mutableCopy];
    }
    for (id entry in toDelete) {
        if ([entry isKindOfClass:[NSString class]]) {
            if ([entry isEqual:@"x"]) {
                [givenstack addObject:[variableVal objectForKey:@"x"]];
            }else {
                [givenstack addObject:entry];
            }
        }else if ([entry isKindOfClass:[NSNumber class]]){
            [givenstack addObject:entry];
        }
    }
    return [self popEntryofgivenStack:givenstack];
}

+ (NSString *)descriptionOfProgram:(id)theProgram{
    id top = [theProgram lastObject];
    if (theProgram) [theProgram removeLastObject];
    if ([top isKindOfClass:[NSString class]]){
        if ([self isOperation:top]){
            if ([top isEqual:@"√x"]){
                return [NSString stringWithFormat:@"sqrt(%@)",[self descriptionOfProgram:theProgram]];
            }
            else if ([top isEqual:@"cos"]){
                return [NSString stringWithFormat:@"cos(%@)",[self descriptionOfProgram:theProgram]];
            }
            else if ([top isEqual:@"sin"]){
                return [NSString stringWithFormat:@"sin(%@)",[self descriptionOfProgram:theProgram]];
            }
            else if ([top isEqual:@"tan"]){
                return [NSString stringWithFormat:@"tan(%@)",[self descriptionOfProgram:theProgram]];
            }
            else if ([top isEqual:@"+"]){
                NSString *add=[self descriptionOfProgram:theProgram];
                return [NSString stringWithFormat:@"(%@+%@)",[self descriptionOfProgram:theProgram],add];
            }
            else if ([top isEqual:@"*"]){
                NSString *mul=[self descriptionOfProgram:theProgram];
                return [NSString stringWithFormat:@"(%@*%@)",[self descriptionOfProgram:theProgram],mul];
            }
            else if ([top isEqual:@"/"]){
                NSString *div=[self descriptionOfProgram:theProgram];
                return [NSString stringWithFormat:@"(%@/%@)",[self descriptionOfProgram:theProgram],div];
            }
            else if ([top isEqual:@"-"]){
                NSString *sub2=[self descriptionOfProgram:theProgram];
                return [NSString stringWithFormat:@"(%@-%@)",[self descriptionOfProgram:theProgram],sub2];
            }
            else{
                return @"π";
            }
        }else{
            return top;
        }
    }else return [NSString stringWithFormat:@"%g",[top doubleValue]];
}

+ (NSSet *)variablesUsedInProgram:(id)program{
    NSMutableSet *variableSet=[[NSMutableSet alloc]init];
    for (id entry1 in program) {
        if ([entry1 isEqual:@"x"]) {
            [variableSet addObject:entry1];
            break;
        }
    }
    return variableSet;
}

+ (BOOL)isOperation:(NSString *)operation{
    if ([operation isEqual:@"x"]) {
        return NO;
    }else return YES;
}

@end
