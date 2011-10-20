#import "GPGException.h"
#import "GPGTask.h"
#import "/usr/include/dlfcn.h"

@interface GPGException ()
@property (retain) GPGTask *gpgTask;
@property GPGErrorCode errorCode;
@end


@implementation GPGException
@synthesize gpgTask, errorCode;

NSString *GPGExceptionName = @"GPGException";

- (id)initWithName:(NSString *)aName reason:(NSString *)aReason userInfo:(NSDictionary *)aUserInfo errorCode:(GPGErrorCode)aErrorCode gpgTask:(GPGTask *)aGPGTask {
	if (!(self = [super initWithName:aName reason:aReason userInfo:aUserInfo])) {
		return nil;
	}
	
	if (aGPGTask) {
		self.gpgTask = aGPGTask;
		if (aGPGTask.exitcode == GPGErrorCancelled) {
			aErrorCode = GPGErrorCancelled;
		} else if (aErrorCode == 0 && gpgTask.errorCode) {
			aErrorCode = gpgTask.errorCode;
		}
	}
	
	self.errorCode = aErrorCode;
	
	return self;
}

- (id)initWithName:(NSString *)aName reason:(NSString *)aReason userInfo:(NSDictionary *)aUserInfo {
	return [self initWithName:aName reason:aReason userInfo:aUserInfo errorCode:0 gpgTask:nil];
}

+ (GPGException *)exceptionWithReason:(NSString *)aReason userInfo:(NSDictionary *)aUserInfo errorCode:(GPGErrorCode)aErrorCode gpgTask:(GPGTask *)aGPGTask {
	return [[[self alloc] initWithName:GPGExceptionName reason:aReason userInfo:aUserInfo errorCode:aErrorCode gpgTask:aGPGTask] autorelease];
}
+ (GPGException *)exceptionWithReason:(NSString *)aReason errorCode:(GPGErrorCode)aErrorCode gpgTask:(GPGTask *)aGPGTask {
	return [[[self alloc] initWithName:GPGExceptionName reason:aReason userInfo:nil errorCode:aErrorCode gpgTask:aGPGTask] autorelease];
}
+ (GPGException *)exceptionWithReason:(NSString *)aReason gpgTask:(GPGTask *)aGPGTask {
	return [[[self alloc] initWithName:GPGExceptionName reason:aReason userInfo:nil errorCode:0 gpgTask:aGPGTask] autorelease];
}
+ (GPGException *)exceptionWithReason:(NSString *)aReason errorCode:(GPGErrorCode)aErrorCode {
	return [[[self alloc] initWithName:GPGExceptionName reason:aReason userInfo:nil errorCode:aErrorCode gpgTask:nil] autorelease];
}


- (NSString *)description {
	void *libHandle = dlopen("/usr/local/MacGPG2/lib/libgpg-error.dylib", RTLD_LOCAL | RTLD_LAZY);
    if (!libHandle) {
		NSLog(@"[%@] %s", [self className], dlerror());
        goto noLibgpgError;
    }
	
	unsigned int (*gpg_err_init)() = dlsym(libHandle, "gpg_err_init");
	if (!gpg_err_init) {
		NSLog(@"[%@] %s", [self className], dlerror());
        goto noLibgpgError;
	}
	
	const char *(*gpg_strerror)(unsigned int) = dlsym(libHandle, "gpg_strerror");
	if (!gpg_strerror) {
		NSLog(@"[%@] %s", [self className], dlerror());
        goto noLibgpgError;
	}
	
	if (gpg_err_init()) {
		NSLog(@"[%@] gpg_err_init() failed!", [self className]);
        goto noLibgpgError;
	}
	
	GPGErrorCode code = self.errorCode;
	if (!code && self.gpgTask) {
		code = self.gpgTask.errorCode;
	}
	
	//TODO: Fehlercodes von Schlüsselserver Fehlern.
	if (!code) {
		goto noLibgpgError;
	}
	
	const char *decription = gpg_strerror(2 << 24 | code);
	if (!decription) {
		goto noLibgpgError;
	}
	
	
	dlclose(libHandle);
	return [NSString stringWithFormat:@"%@ (%@)\nCode = %i", self.reason, [NSString stringWithUTF8String:decription], code];
	
noLibgpgError:
	dlclose(libHandle);
	return self.reason;
}


@end

