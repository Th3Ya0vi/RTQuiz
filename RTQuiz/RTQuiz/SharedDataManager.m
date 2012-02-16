//
//  SharedDataManager.m
//  RTQuiz
//
//  Created by C. A. Beninati on 12/15/11.
//  Copyright (c) 2012 C. A. Beninati. All rights reserved.
//
//	This file is part of RTQuiz.
//
//	RTQuiz is free software: you can redistribute it and/or modify
//	it under the terms of the GNU Lesser Public License as published by
//	the Free Software Foundation, either version 3 of the License, or
//	(at your option) any later version.
//
//	RTQuiz is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU Lesser Public License for more details.
//
//	You should have received a copy of the GNU Lesser Public License
//	along with RTQuiz.  If not, see <http://www.gnu.org/licenses/>.
//

#import "SharedDataManager.h"
#import "QuizElement.h"

#import "Score.h"
#import "Topic.h"
#import "Category.h"
#import "Quiz.h"
#import "Element.h"

@implementation SharedDataManager

@synthesize managedObjectContext = _managedObjectContext;

- (id)init {
	return self;
}

#pragma mark - Singleton Methods

static SharedDataManager *sharedDataManager = nil;

+ (SharedDataManager*)sharedDataManager {
    if (sharedDataManager == nil) {
        sharedDataManager = [[super allocWithZone:NULL] init];
    }
    return sharedDataManager;
}

#pragma mark - Topic and Quiz Methods

- (NSArray*)getArrayFromTopic:(NSString*)topicName {
    
    NSArray *topicArray = nil;
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *plistPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", topicName]];
    topicArray = [NSArray arrayWithContentsOfFile:plistPath];
    
    return topicArray;
}

- (NSMutableDictionary*)getDictionaryForQuiz:(NSString*)quizName {
    
    NSMutableDictionary *quizDictionary = nil;
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *plistPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", quizName]];
    quizDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];    
    
    return quizDictionary;
}

- (NSMutableArray*)getQuizForTopic:(NSString*)topicName forLevel:(int)level {
    
    NSMutableArray *quizArray = [[NSMutableArray alloc] init];
    
    NSArray * topicsArray = [self getArrayFromTopic:topicName];
    NSDictionary *topicsDictionary = [topicsArray objectAtIndex:level];
    NSArray *valuesArray = [topicsDictionary allValues];
    NSString *currentValue = [valuesArray lastObject];
    NSMutableDictionary *quizDictionary = [self getDictionaryForQuiz:currentValue];
    
    for(NSString *currentQuizElement in quizDictionary) {
		
		NSString *firstWord = [NSString stringWithFormat:@"%@", currentQuizElement];
		NSString *secondWord = [NSString stringWithFormat:@"%@", [quizDictionary valueForKey:currentQuizElement]];
		
		QuizElement *currentElement = [[QuizElement alloc] initWithFirstWord:firstWord
																  SecondWord:secondWord];
        
		[quizArray addObject:currentElement];		
    }
    
    quizArray = [self shuffleQuiz:quizArray];
    
    return quizArray;
}

- (NSMutableArray*)shuffleQuiz:(NSMutableArray*)theQuiz {
	    
    for(NSUInteger i = [theQuiz count]; i > 1; i--) {
        int newWord = arc4random() % [theQuiz count];
        [theQuiz exchangeObjectAtIndex:i-1 withObjectAtIndex:newWord];
    }
    
    return theQuiz;
}

#pragma mark - Score Methods

- (Category*)getCategoryWithName:(NSString*)name {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Category" inManagedObjectContext:_managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"name = %@", name]];
    
    NSError *error = nil;
    Category *category = [[_managedObjectContext executeFetchRequest:request error:&error] lastObject];
        
    return category;
}

- (NSArray*)getHighScoresForCategoryNamed:(NSString*)categoryName {
    
    NSArray * highScoresArray = nil;
    
    Category *category = [self getCategoryWithName:categoryName];
        
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Score" inManagedObjectContext:_managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"category = %@", category]];
    request.fetchLimit = 50;
    NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"points" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:highestToLowest]];
    
    NSError *error = nil;
    highScoresArray = [_managedObjectContext executeFetchRequest:request error:&error];
    
	if (!highScoresArray) {
		//error handling... IMPORTANT
        NSLog(@"no scores %@", error);
	}else {        
    }
    
    return highScoresArray;
}

- (BOOL)didSaveScore:(int)points ForCategoryNamed:(NSString*)categoryName ForUserNamed:(NSString*)userName {
    
    BOOL didSave = NO;
    
    NSDate *today = [NSDate date];
    Category *category = [self getCategoryWithName:categoryName];
    
    Score *score = [NSEntityDescription insertNewObjectForEntityForName:@"Score" inManagedObjectContext:_managedObjectContext];
    
    [score setDate:today];
    [score setPoints:[NSNumber numberWithInt:points]];
    [score setPlayer:userName];
    [score setCategory:category];
    
    NSError *errora;
    
    if (![_managedObjectContext save:&errora]) {
        NSLog(@"no saving score %@", errora);
        // record could not be saved... error handling IMPORTANT
    }else {
        didSave = YES;
    }
    
    return didSave;
}

@end
