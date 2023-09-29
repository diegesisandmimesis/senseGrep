#charset "us-ascii"
//
// senseGrepDebug.t
//
//	Debugging actions for senseGrep.
//
//
// USAGE:
//
//	>GREP
//		Displays a list of all objects sensable via the current
//		grep sense.  Defaults to using sight.
//
//	>GREPSENSE [sense]
//		Makes the given sense the current grep sense.
//
//	>NGREP [noun]
//		Using the current grep sense, list all objects whose
//		noun(s) match the given search term.
//
//	>AGREP [adjective]
//		Using the current grep sense, list all objects whose
//		adjective(s) match the given search term.
//
#include <adv3.h>
#include <en_us.h>

#include "senseGrep.h"

#ifdef __DEBUG_SENSE_GREP

grepCfg: object sense = sight;

#define gSense grepCfg.sense

class _GrepAction: Action
	_grepOutput(l?) {
		//"\^<<grepCfg.sense.adj>> objects:  ";
		if((l != nil) && (l.length > 0)) {
			l.forEach(function(o) { "\n\t<<o.name>>\n "; });
		} else {
			"No matches\n ";
		}
	}
;

class _GrepSystemAction: _GrepAction, SystemAction;
class _GrepLiteralAction: _GrepAction, LiteralAction;

DefineAction(GrepSense, _GrepLiteralAction)
	execAction() {
		local r, v;

		v = getLiteral();
		r = nil;
		forEachInstance(Sense, function(o) {
			if(o.id != v)
				return;
			r = o;
		});

		if(r == nil) {
			reportFailure('No sense matching <<toString(v)>>
				found. ');
		} else {
			if(r == grepCfg.sense) {
				reportFailure('Grep sense is already
					<<toString(v)>>. ');
				exit;
			}
			grepCfg.sense = r;
			defaultReport('Grep sense is now <<toString(v)>>. ');
		}
	}
;
VerbRule(GrepSense) 'grepsense' singleLiteral : GrepSenseAction
	verbPhrase = 'grepsense/grepsensing (what)';


DefineAction(Grep, _GrepSystemAction)
	execSystemAction() {
		"\^<<grepCfg.sense.adj>> objects:  ";
		_grepOutput(gActor.getVisibleObjects(nil, nil, grepCfg.sense));
	}
;
VerbRule(Grep) 'grep' : GrepAction verbPhrase = 'grep/grepping';
DefineAction(Ngrep, _GrepLiteralAction)
	execAction() {
		"\^<<grepCfg.sense.adj>> <q><<toString(getLiteral())>></q>
			objects:  ";
		_grepOutput(senseGrep(gSense, nounFilter(getLiteral()),
			gActor));
	}
;
VerbRule(Ngrep) 'ngrep' singleLiteral : NgrepAction
	verbPhrase = 'ngrep/ngrepping (what)'
;

DefineAction(Agrep, _GrepLiteralAction)
	execAction() {
		"\^<<grepCfg.sense.adj>> <q><<toString(getLiteral())>></q>
			objects:  ";
		_grepOutput(senseGrep(gSense, adjectiveFilter(getLiteral()),
			gActor));
	}
;
VerbRule(Agrep) 'agrep' singleLiteral : AgrepAction
	verbPhrase = 'agrep/agrepping (what)'
;

#endif // __DEBUG_SENSE_GREP
