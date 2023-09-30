#charset "us-ascii"
//
// senseGrepActor.t
//
#include <adv3.h>
#include <en_us.h>

#include "senseGrep.h"

modify Actor
	canSense(obj) {
		return(canSee(obj) || canHear(obj) || canSmell(obj));
	}

	// Returns a list of the objects visible to this actor.
	// Args are:
	//	cls		only include objects of this class
	//			(default:  Thing)
	//	excludeList	exclude these objects
	//	sense		sense to use (default:  sight)
	getVisibleObjects(cls?, excludeList?, sense?) {
		// We must be in a location to find other things in our
		// location.
		if(location == nil)
			return([]);

		// We always exclude ourselves from the results.
		if(excludeList == nil) {
			excludeList = [ self ];
		} else {
			if(!excludeList.ofKind(List))
				excludeList = [ excludeList ];
			if(excludeList.indexOf(self) == nil)
				excludeList += self;
		}

		// Return the grep results.
		return(senseGrepFilter(sense, self, cls, excludeList));
	}
;
