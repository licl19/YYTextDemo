//
//  ViewControllerParse.m
//  YYTextDemo
//
//  Created by lichanglai on 2018/3/27.
//  Copyright © 2018年 sankai. All rights reserved.
//

#import "ViewControllerParse.h"
#import <YYImage.h>
#import <YYLabel.h>

@interface ViewControllerParse ()

@end

@implementation ViewControllerParse

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSMutableDictionary *mapper = [NSMutableDictionary new];
    mapper[@":smile:"] = [self imageWithName:@"002"];
    mapper[@":cool:"] = [self imageWithName:@"013"];
    mapper[@":biggrin:"] = [self imageWithName:@"047"];
    mapper[@":arrow:"] = [self imageWithName:@"007"];
    mapper[@":confused:"] = [self imageWithName:@"041"];
    mapper[@":cry:"] = [self imageWithName:@"010"];
    mapper[@":wink:"] = [self imageWithName:@"085"];
    
    YYTextSimpleEmoticonParser *parser = [YYTextSimpleEmoticonParser new];
    parser.emoticonMapper = mapper;
    
    YYTextLinePositionSimpleModifier *mod = [YYTextLinePositionSimpleModifier new];
    mod.fixedLineHeight = 22;
    
    YYLabel *contentLabel = [[YYLabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    contentLabel.center = self.view.center;
    contentLabel.userInteractionEnabled = YES;
    contentLabel.numberOfLines = 0;
    contentLabel.text = @"Hahahah:smile:, it\'s emoticons::cool::arrow::cry::wink:\n\nYou can input \":\" + \"smile\" + \":\" to display smile emoticon, or you can copy and paste these emoticons.\n";
    UIFont *font = [UIFont systemFontOfSize:16];
    contentLabel.font = font;
    contentLabel.displaysAsynchronously = YES; /// enable async display
    contentLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
    [contentLabel setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.2]];
    contentLabel.linePositionModifier = mod;
    contentLabel.textParser = parser;
    [self.view addSubview:contentLabel];
    
    NSLog(@"%@",contentLabel.text);
    
    // Do any additional setup after loading the view.
}
- (UIImage *)imageWithName:(NSString *)name {
    NSString *path = [self pathForScaledResource:name ofType:@"gif" inDirectory:@"EmoticonQQ.bundle"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    YYImage *image = [YYImage imageWithData:data scale:2];
    image.preloadAllAnimatedImageFrames = YES;
    return image;
}
- (NSString *)pathForScaledResource:(NSString *)name ofType:(NSString *)ext inDirectory:(NSString *)bundlePath {
    if (name.length == 0) return nil;
    if ([name hasSuffix:@"/"]) return [[NSBundle mainBundle] pathForResource:name ofType:ext inDirectory:bundlePath];
    
    NSString *path = nil;
    NSString *scaledName = [NSString stringWithFormat:@"%@@%@x",name,@(2)];
    path = [[NSBundle mainBundle] pathForResource:scaledName ofType:ext inDirectory:bundlePath];
    
    return path;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
