#charset "us-ascii"
//
// senseGrepSense.t
//
#include <adv3.h>
#include <en_us.h>

#include "senseGrep.h"

// Add some properties to the builtin Sense class
modify Sense
	id = nil		// "name" is reserved
	adj = nil		// "adjective" is reserved
	verb = nil
;

modify sight
	id = 'sight'
	adj = 'visible'
	verb = 'see'
;

modify sound
	id = 'sound'
	adj = 'audible'
	verb = 'hear'
;

modify smell
	id = 'smell'
	adj = 'smellable'
	verb = 'smell'
;

modify touch
	id = 'touch'
	adj = 'touchable'
	verb = 'feel'
;
