//
//  AppDelegate.h
//  Lemp2
//
//  Created by Hyemin Kim on 13. 1. 8..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import <CoreData/CoreData.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>//, CHSlideControllerDelegate, SQLiteDelegate>
{
//    NSThread *bonThread;
    //    BOOL alreadyBon;
    BOOL didPush;
    BOOL firstLaunch;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) RootViewController *root;
@property (nonatomic, assign) BOOL didPush;
@property (nonatomic, strong) CTCallCenter* callCenter;
//@property (nonatomic, readonly) UIViewController *viewControllerForPresentation;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (id)readPlist:(NSString *)key;
- (void)writeToPlist:(NSString *)key value:(id)value;
//- (void)setIconBadge:(NSInteger)num;
- (BOOL)openURL:(NSURL*)url;
- (void)setNoteBadge:(NSInteger)num;
- (void)setChatIconBadge:(NSInteger)num;
- (BOOL)checkRemoteNotificationActivate;
- (void)resetNavigationBar;
- (void)killApplication;

@end
