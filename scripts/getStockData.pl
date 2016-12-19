#!/usr/bin/perl

use strict;
use warnings;

use LWP::Simple;
use JSON;
use JSON::PP;

#FETCH LIVE STOCK QUOTE FROM NASDAQ FOR A GIVEN COMPANY ID
#This scripts expects exactly one argument - the Nasdaq Company Code (usually 4 letters)

#check for the argument
my $numArgs = $#ARGV + 1;
if ($numArgs != 1) {
	#bail, since we expect some output.
	exit;
}

my $companyCode = $ARGV[0];

sub main
{
	my $data = get("http://www.google.com/finance/info?q=" . $companyCode);
	my $html = get("http://www.google.com/finance?q=" . $companyCode);
	my $market_open = 0;
	if (index($html, "Real-time:") >= 0)
	{
		$market_open = 1;
	}
	
	$data = substr($data, index($data, "//") + 2);
	$data = substr($data, index($data, "[") + 1);
	$data = substr($data, 0, length($data) - 2);
	
	my $jdata = decode_json $data;

	print "l@" . $jdata->{l} . "#";
	print "c@" . $jdata->{c} . "#";
	print "cp@" . $jdata->{cp} . "#";
	print "el@" . $jdata->{el} . "#";
	print "ec@" . $jdata->{ec} . "#";
	print "ecp@" . $jdata->{ecp} . "#";
	print "elt@" . $jdata->{elt} . "#";
	print "lt@" . $jdata->{lt} . "#";
	print "open@" . $market_open;
}
 
main();
