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
		// Gotta be somewhere first.
		if(location == nil)
			return([]);

		
		if(excludeList == nil) {
			excludeList = [ self ];
		} else {
			if(!excludeList.ofKind(List))
				excludeList = [ excludeList ];
			if(excludeList.indexOf(self) == nil)
				excludeList += self;
		}

/*
		// Make sure we have a class.
		if(cls == nil)
			cls = Thing;

		// If we have a non-nil, non-List excludeList, make it a List.
		if((excludeList != nil) && !excludeList.ofKind(List))
			excludeList = [ excludeList ];

		// Make sure we have a sense.
		if(sense == nil)
			sense = sight;

		r = senseGrep(sense, function(o, s) {
			local i;

			// Make sure we match the class.
			if(!o.ofKind(cls) && (o != cls))
				return(nil);

			// Don't include ourselves.
			if(o == self)
				return(nil);

			// If we have an exclude list, check it.
			if(excludeList) {
				for(i = 1; i <= excludeList.length; i++) {
					if(excludeList[i] == o)
						return(nil);
					if(o.ofKind(excludeList[i]))
						return(nil);
				}
			}

			// Match.
			return(true);
		});

		// Return the table subset.
		return(r);
*/
		return(senseGrepFancy(sense, cls, excludeList, self));
	}
;
