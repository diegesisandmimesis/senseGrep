#charset "us-ascii"
//
// grepWorld.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// Simple game world for use with the senseGrep demos.
//
// This "game" is distributed under the MIT License, see LICENSE.txt
// for details.
//
#include <adv3.h>
#include <en_us.h>

startRoom: Room 'Void' "This is a featureless void with a built-in bookshelf.";
+Fixture, Surface 'shelf bookshelf/shelves bookshelves' 'bookshelf'
	"It's a generic bookshelf. "
;
++Thing '(red) book' 'red book' "It's a red book. ";
++Thing '(green) book' 'green book' "It's a green book. ";
++Thing '(blue) book' 'blue book' "It's a blue book. ";
+Thing '(black) book' 'black book' "It's a black book. ";
+me: Person;
+pebble: Thing 'small round pebble' 'pebble' "A small, round pebble. ";
+Thing '(red) brick' 'brick' "It's a red brick. ";
