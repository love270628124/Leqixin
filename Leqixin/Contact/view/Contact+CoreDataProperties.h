//
//  Contact+CoreDataProperties.h
//  乐企信
//
//  Created by 震霄 张 on 16/5/22.
//  Copyright © 2016年 SDW. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Contact.h"

NS_ASSUME_NONNULL_BEGIN

@interface Contact (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *brithday;
@property (nullable, nonatomic, retain) NSString *userid;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *department;
@property (nullable, nonatomic, retain) NSString *entry;
@property (nullable, nonatomic, retain) NSString *img;
@property (nullable, nonatomic, retain) NSString *initials;
@property (nullable, nonatomic, retain) NSString *itemid;
@property (nullable, nonatomic, retain) NSString *mobile;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *position;
@property (nullable, nonatomic, retain) NSString *telphone;
@property (nullable, nonatomic, retain) NSString *rows;
@property (nullable, nonatomic, retain) NSString *type;



@end

NS_ASSUME_NONNULL_END
