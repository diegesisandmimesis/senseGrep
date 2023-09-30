#charset "us-ascii"
//
// senseGrep.t
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
senseGrep(sense, fn, actor?) {
	if(actor == nil) actor = gActor;
	if(!sense || !actor || !actor.ofKind(Actor)) return([]);
	return(senseInfoTableSubset(getPOVDefault(actor ? actor : gActor)
		.senseInfoTable(sense), fn));
}

senseGrepFilter(sense?, matchList?, excludeList?, actor?) {
	if(sense == nil) sense = sight;
	if(matchList && !matchList.ofKind(List))
		matchList = [ matchList ];
	if(excludeList && !excludeList.ofKind(List))
		excludeList = [ excludeList ];

	return(senseGrep(sense, function(o, s) {
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
sightGrep(fn, actor?) { return(senseGrep(sight, fn, actor)); }
soundGrep(fn, actor?) { return(senseGrep(sound, fn, actor)); }
smellGrep(fn, actor?) { return(senseGrep(smell, fn, actor)); }
touchGrep(fn, actor?) { return(senseGrep(touch, fn, actor)); }

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
// 	local l = sightGrep(nounFilter('foozle'));
//
// ...will result in l containing a list of all the visible objects that
// match "foozle" as a noun, and...
//
//	sightGrep(adjectiveFilter('red')).forEach(function(o) {
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

