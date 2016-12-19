#!/usr/bin/perl

 use strict;
 
use LWP::Simple;
use XML::RSS::Parser;
use FileHandle;
use HTML::Entities;
use String::Random;

#GENERAL SCRIPT FOR RSS NEWS RELATED ITEMS
#This script expects one argument which is the URL to the RSS feed

#check for the argument
my $numArgs = $#ARGV + 1;
if ($numArgs != 1) {
	#bail, since we expect some output.
	return;
}

#extract URL from argument
my $url = $ARGV[0];

#common utils
my $tempdir = "C:\\Windows\\temp";
my $randStr = new String::Random;

#download html to a temp file
my $localfile = $tempdir . "\\" . $randStr->randpattern("cccccccc") . ".tmp";

getstore($url, $localfile);

#parse the rss feed
my $p = XML::RSS::Parser->new;
my $fh = FileHandle->new($localfile);
my $feed = $p->parse_file($fh);
 	
my $feed_title = $feed->query('/channel/title');
my $max_count = 5;
my $index = 0;
foreach my $i ( $feed->query('//item') ) { 
	my $node = $i->query('title');
    print decode_entities($node->text_content);
	$index ++;
	if ($index >= $max_count)
	{
		last;
	}
	else
	{
     	print "\n"; 
	}
 }

$fh->close;
unlink($localfile);
