//
//  SKYArticle.h
//  Good News
//
//  Created by Alan Scarpa on 10/8/15.
//  Copyright © 2015 Skytop Designs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKYArticle : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) NSString *urlStringEscaped;
@property (strong, nonatomic) NSString *imageUrlString;
@property (nonatomic) BOOL isUrlEscaped;

@end
