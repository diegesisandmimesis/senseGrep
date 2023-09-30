#charset "us-ascii"
//
// senseGrep.t
//
//	A TADS3 module providing utilities for working with sense tables.
//
//
// USAGE
//
//	senseGrep(sense?, actor?, fn?)
//		Returns a list of the objects detectable by the given
//		actor using the given sense.  Args are:
//
//			sense	The sense to use, one of: sight, sound, smell,
//				or touch.
//				Default:  sight
//
//			actor	The actor to use.
//				Default:  gActor
//
//			fn	A filter function taking two arguments:  an
//				object to test and the sense table.  Object
//				will be included in results if fn returns
//				boolean true, it will not be included
//				otherwise.
//				Default:  no filter
//		
//	senseGrepFilter(sense?, actor?, matchList?, excludeList?)
//		As above, but using a list of classes/objects to include
//		and a list of classes/objects to exclude.  Different args are:
//
//			matchList	Objects will only be included in the
//					results if they are equal to an element
//					of the matchList, or if they are an
//					instance of a class in the matchList.
//					Default:  no match list
//
//			excludeList	Objects that are match objects or
//					classes in the excludeList will not
//					be included in the results.
//					Default:  no exclude list
//
//	sightGrep(actor?, fn?)
//	soundGrep(actor?, fn?)
//	smellGrep(actor?, fn?)
//	touchGrep(actor?, fn?)
//		Wrappers around senseGrep() to use one sense by default.
//
//	wordFilter(txt)
//	nounFilter(txt)
//	adjectiveFilter(txt)
//		Generator functions that return a filter sutable for
//		passing (as the fn argument) to a senseGrep() function.
//
//		wordFilter() will return a filter that matches the argument
//		as a noun or adjective, nounFilter() and adjectiveFilter()
//		match the argument just as a noun or adjective (respectively).
//
//
// EXAMPLES
//
//	// Returns all the objects visible by gActor.
//	local l = senseGrep(sight);
//
//	// Identical to the above.
//	local l = sightGrep();		// wrapper for senseGrep()
//	local l = senseGrep();		// default sense is sight
//
//	// Returns all the objects visible by Alice.
//	local l = senseGrep(sight, alice);
//
//	// Returns all the objects visible by Bob, not counting himself
//	// and any Fixture objects.
//	local l = senseGrepFilter(sight, bob, nil, [ bob, Fixture ]);
//
//	// Returns all the Actors visible to the player, not counting themself.
//	local l = senseGrepFilter(sight, me, Actor, me);
//
//	// Returns all the books visible to the player.
//	local l = senseGrepFilter(sight, me, nounFilter('book'));
//
//	// Returns all the red objects visible to the player.
//	local l = senseGrepFilter(sight, me, adjectiveFilter('red'));
//	
//
#include <adv3.h>
#include <en_us.h>

#include "senseGrep.h"

// Module ID for the library
senseGrepModuleID: ModuleID {
        name = 'Sense Grep Library'
        byline = 'Diegesis & Mimesis'
        version = '1.0'
        listingOrder = 99
}

// Generic sense grep function.
// Args are:
//	sense	the sense to use (sight, sound, smell, or touch)
//	fn	function taking two args (object and sense info table)
//		returning true-ish if the object should be listed and
//		nil-ish if it shouldn't
//	actor	actor whose POV will be used, or gActor if not specified
senseGrep(sense?, actor?, fn?) {
	if(sense == nil) sense = sight;
	if(actor == nil) actor = gActor;
	if(!actor.ofKind(Actor)) return([]);
	return(senseInfoTableSubset(getPOVDefault(actor ? actor : gActor)
		.senseInfoTable(sense),
		(fn ? fn : function(o, s) { return(true); })));
}

// Instead of a generic filter function, we accept match and exclude
// lists.
senseGrepFilter(sense?, actor?, matchList?, excludeList?) {
	if(sense == nil) sense = sight;
	if(matchList && !matchList.ofKind(List))
		matchList = [ matchList ];
	if(excludeList && !excludeList.ofKind(List))
		excludeList = [ excludeList ];

	return(senseGrep(sense, actor, function(o, s) {
		local i, r;

		if(matchList) {
			r = nil;
			for(i = 1; i <= matchList.length; i++) {
				if(o.ofKind(matchList[i])
					|| (o == matchList[i]))
					r = true;
			}
			if(r == nil)
				return(nil);
		}

		if(excludeList) {
			for(i = 1; i <= excludeList.length; i++) {
				if(excludeList[i] == o)
					return(nil);
				if(o.ofKind(excludeList[i]))
					return(nil);
			}
		}

		return(true);
	}));
}

// Convenience wrappers for the adv3-defined senses
sightGrep(actor?, fn?) { return(senseGrep(sight, actor, fn)); }
soundGrep(actor?, fn?) { return(senseGrep(sound, actor, fn)); }
smellGrep(actor?, fn?) { return(senseGrep(smell, actor, fn)); }
touchGrep(actor?, fn?) { return(senseGrep(touch, actor, fn)); }

// Filter functions
//
// These take a search term as an argument and return an anonymous function
// that can be passed as an argument to senseInfoTableSubset().  Example:
//
// 	local fn = nounFilter('foozle');
//
// This creates a function and assigns it to fn.  The function fn() takes
// two arguments:  an object and a sense info table.  fn(obj, info) will
// return true if the object obj's noun list contains "foozle".  That is,
// if >X FOOZLE (for example) would work for the object.
//
// adjectiveFilter() works similarly, only it searches adjectives on the
// object instead of nouns.
//
// wordFilter() combines nounFilter() and adjectiveFilter(), returning
// the objects that match either.
//
// In the example above we assign the function returned by these filters to
// a variable, but they're really designed to be used as anonymous arguments
// to the senseGrep() functions.  Something like:
//
// 	local l = sightGrep(alice, nounFilter('foozle'));
//
// ...will result in l containing a list of all the visible objects that
// match "foozle" as a noun, and...
//
//	sightGrep(alice, adjectiveFilter('red')).forEach(function(o) {
//		// stuff goes here
//	});
//
// ...would loop through all of the visible objects that the adjective "red"
// applies to.
//
wordFilter(txt)
	{ return({ x, info: !txt || ((x.noun && x.noun.indexOf(txt) != nil)
		|| (x.adjective && x.adjective.indexOf(txt) != nil)) }); }
nounFilter(txt)
	{ return({ x, info: !txt || (x.noun && x.noun.indexOf(txt) != nil) }); }
adjectiveFilter(txt)
	{ return({ x, info: !txt
		|| (x.adjective && x.adjective.indexOf(txt) != nil) }); }

