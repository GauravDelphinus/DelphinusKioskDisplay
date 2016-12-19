#!/usr/bin/perl

 use strict;
 
use LWP::Simple;
 use XML::RSS::Parser;
 use FileHandle;

use HTML::Tree;
use HTML::TreeBuilder;
use HTML::TreeBuilder::XPath;
use Image::PNG::QRCode 'qrpng';
use String::Random;

my $url = "http://feeds.feedburner.com/brainyquote/QUOTEBR"; #URL for RSS feed for quotations

#common utils
my $tempdir = "C:\\Windows\\temp";
my $randStr = new String::Random;

#download the feed xml to a temp file
my $localfile = $tempdir . "\\" . $randStr->randpattern("cccccccc") . ".tmp";
getstore($url, $localfile);

#parse the file and get rid of the temp file
my $p = XML::RSS::Parser->new;
my $fh = FileHandle->new($localfile);
my $feed = $p->parse_file($fh);
$fh->close;
unlink $localfile;

#parse the feed for the puzzle title, description and link to the answer
my @feeds = $feed->query('//item');
my $url =$feeds[0]->query('link')->text_content;

#find the number of quotes, and then extract each one and print
my $numQuotes = scalar @feeds;

my @quotes;
my @authors;
my @links;

#format of output: <quote text>###<author name>SEPARATOR<quote text 2>###<author name 2>... etc.
for (my $i = 0; $i < $numQuotes; $i++) {
	my $url =$feeds[$i]->query('link')->text_content;
	my $author = $feeds[$i]->query('title')->text_content;
	my $quote = $feeds[$i]->query('description')->text_content;
	$author =~ s/^\s+|\s+$//g; #trim whitespaces from both ends
	$quote =~ s/^\s+|\s+$//g; #trim whitespaces from both ends
	$url =~ s/^\s+|\s+$//g; #trim whitespaces from both ends
	
	push (@quotes, $quote);
	push (@authors, $author);
	push (@links, $url);
}

#randomly select any one word
my $low = 0;
my $high = scalar @quotes - 1;
my $randomIndex = int(rand($high + 1)) + $low;

#generate QRCode for the link and save to a temp file
my $outfilename = $randStr->randpattern("cccccccc") . ".png";
my $outfile = $tempdir . "\\" . $outfilename;
qrpng(text => $links[$randomIndex], out => $outfile);

print $quotes[$randomIndex] . "####" . $authors[$randomIndex] . "####" . $outfilename;
