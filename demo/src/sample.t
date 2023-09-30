#charset "us-ascii"
//
// sample.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the senseGrep library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f makefile.t3m
//
// ...or the equivalent, depending on what TADS development environment
// you're using.
//
// This "game" is distributed under the MIT License, see LICENSE.txt
// for details.
//
#include <adv3.h>
#include <en_us.h>

#include "senseGrep.h"

versionInfo: GameID
        name = 'senseGrep Library Demo Game'
        byline = 'Diegesis & Mimesis'
        desc = 'Demo game for the senseGrep library. '
        version = '1.0'
        IFID = '12345'
	showAbout() {
		"This is a simple test game that demonstrates the features
		of the senseGrep library.
		<.p>
		Some verbs to try:
		<.p>
		\n\t<b>&gt;GREP</b>
		\n\t\tDisplays a list of all objects detectable via the current
		\n\t\tgrep sense.  Defaults to using sight.
		<.p>
		\n\t<b>&gt;GREPSENSE [sense]</b>
		\n\t\tMakes the given sense the current grep sense.
		\n\t\tAllowed senses are:  sight, sound, smell, touch.
		<.p>
		\n\t<b>&gt;NGREP [noun]</b>
		\n\t\tUsing the current grep sense, list all objects whose
		\n\t\tnoun(s) match the given search term.
		<.p>
		\n\t<b>&gt;AGREP [adjective]</b>
		\n\t\tUsing the current grep sense, list all objects whose
		\n\t\tadjective(s) match the given search term.
		<.p>
		Consult the README.txt document distributed with the library
		source for a quick summary of how to use the library in your
		own games.
		<.p>
		The library source is also extensively commented in a way
		intended to make it as readable as possible. ";
	}
;

gameMain: GameMainDef initialPlayerChar = me;
