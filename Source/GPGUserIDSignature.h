/*
 Copyright © Roman Zechmeister, 2013
 
 Diese Datei ist Teil von Libmacgpg.
 
 Libmacgpg ist freie Software. Sie können es unter den Bedingungen 
 der GNU General Public License, wie von der Free Software Foundation 
 veröffentlicht, weitergeben und/oder modifizieren, entweder gemäß 
 Version 3 der Lizenz oder (nach Ihrer Option) jeder späteren Version.
 
 Die Veröffentlichung von Libmacgpg erfolgt in der Hoffnung, daß es Ihnen 
 von Nutzen sein wird, aber ohne irgendeine Garantie, sogar ohne die implizite 
 Garantie der Marktreife oder der Verwendbarkeit für einen bestimmten Zweck. 
 Details finden Sie in der GNU General Public License.
 
 Sie sollten ein Exemplar der GNU General Public License zusammen mit diesem 
 Programm erhalten haben. Falls nicht, siehe <http://www.gnu.org/licenses/>.
 
 Additions by: Lukas Pitschl (@lukele) (c) 2013
*/

#import "GPGGlobals.h"
#import "GPGKey.h"

@interface GPGUserIDSignature : NSObject <GPGUserIDProtocol> {
	NSString *_keyID;
	GPGPublicKeyAlgorithm _algorithm;
	NSDate *_creationDate;
	NSDate *_expirationDate;
	NSString *_reason;
	int _signatureClass;
	BOOL _revocation;
	BOOL _local;

	GPGKey *_primaryKey;
}

- (instancetype)init;
- (instancetype)initWithKeyID:(NSString *)keyID;

@property (nonatomic, readonly) NSString *keyID;
@property (nonatomic, readonly) GPGPublicKeyAlgorithm algorithm;
@property (nonatomic, readonly) NSDate *creationDate;
@property (nonatomic, readonly) NSDate *expirationDate;
@property (nonatomic, readonly) NSString *reason;
@property (nonatomic, readonly) int signatureClass;
@property (nonatomic, readonly) BOOL revocation;
@property (nonatomic, readonly) BOOL local;

@property (nonatomic, readonly) GPGKey *primaryKey;

@property (nonatomic, readonly) NSString *userIDDescription;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *email;
@property (nonatomic, readonly) NSString *comment;
@property (nonatomic, readonly) NSImage *photo;

@end
