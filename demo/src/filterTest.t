#charset "us-ascii"
//
// filterTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the senseGrep library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f filterTest.t3m
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

// Big ol' kludge to just display some output and quit.
modify startRoom
	roomName = ''
	desc = senseGrepKludge

	// Grep list output formatter.
	_grepOutput(l?) {
		if((l != nil) && (l.length > 0)) {
			l.forEach(function(o) { "\n\t<<o.name>>\n "; });
		} else {
			"No matches\n ";
		}
	}

	// The room "description".
	senseGrepKludge() {
		// Run a few tests.
		runTests();

		// Exit the game.
		QuitAction.terminateGame();
	}

	runTests() {
		"\nAll lists include only objects visible to the
			initial player character. ";
		"<.p> ";

		// Unfiltered senseGrep results.
		"\nAll objects:\n ";
		_grepOutput(senseGrepFilter(sight, nil, nil,
			initialPlayerChar));

		// Exclude all the Fixtures and me.
		"<.p> ";
		"\nAll non-Fixture objects, excluding the player:\n ";
		_grepOutput(senseGrepFilter(sight, nil, [ me, Fixture ],
			initialPlayerChar));

		// List only the books.
		"<.p> ";
		"\nAll books:\n ";
		_grepOutput(senseGrep(sight, nounFilter('book'), me));

		// List only the red objects.
		"<.p> ";
		"\nAll red objects:\n ";
		_grepOutput(senseGrep(sight, adjectiveFilter('red'), me));
	}
;

versionInfo: GameID;
gameMain: GameMainDef
	initialPlayerChar = me
	newGame() { runGame(true); }
;
