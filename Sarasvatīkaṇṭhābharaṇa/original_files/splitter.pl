#!/usr/bin/perl

undef $/;
$_ = <>;
$n = 0;

for $match (split(/(?=PATTERN)/)) {
	open(0, '>temp' . ++$n);
	print 0 $match;
	close(0);
}
