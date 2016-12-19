#!/usr/bin/perl

use strict;
 
use LWP::Simple;
use XML::RSS::Parser;
use FileHandle;
use HTML::Entities;
use XML::Parser;
use String::Random;
use Image::PNG::QRCode 'qrpng';

my $feed;

my $url = "http://www.merriam-webster.com/wotd/feed/rss2";

#common utils
my $tempdir = "C:\\Windows\\temp";
my $randStr = new String::Random;

#download the feed xml to a temp file
my $localfile = $tempdir . "\\" . $randStr->randpattern("cccccccc") . ".tmp";
getstore($url, $localfile);

my $current_word = "";
my $current_meaning = "";
my $current_link = "";
my $print_sep = 0; #print the separator

my @words;
my @meanings;
my @links;

my $parser = new XML::Parser ( Handlers => {
                               Start   => \&hdl_start,
                               End     => \&hdl_end,
                               Char    => \&hdl_char,
                             } );
                                                                      
+                                                                    
$parser->parsefile($localfile);

sub hdl_start {

    my ($p, $ele, %attribs) = @_;
    $attribs{'string'} = '';
    $feed = \%attribs;
}

sub hdl_end {                                                         
+       

    my ($p, $ele) = @_;
	if ($ele eq 'title') { #found a word
			display_word($feed);
	}
	if ($ele eq 'merriam:shortdef') { #found a meaning
			display_meaning($feed);
	}
	if ($ele eq 'link') { #found a link
			display_link($feed);
	}
    #display_feed($feed) if $ele eq 'link';
	#display_feed($feed) if $ele eq 'merriam:shortdef';
	#print_word($feed, $ele);
}

sub hdl_char {

   my ($p, $str) = @_;
   no strict 'refs';

   $feed->{'string'} .= $str;
}

sub display_feed {

   my $attribs = shift;
   $attribs =~ s/\n//g;

   print "$attribs->{'string'}";
}

sub display_word {
   my $attribs = shift;
   $attribs =~ s/\n//g;

   $current_word = $attribs->{'string'};
}
sub display_link {
   my $attribs = shift;
   $attribs =~ s/\n//g;

   $current_link = $attribs->{'string'};
}
sub display_meaning{
   my $attribs = shift;
   $attribs =~ s/\n//g;

	$current_meaning = $attribs->{'string'};
   
   #if ($print_sep == 1) {
		#print "SEPARATOR";
	#}
	push(@words, $current_word);
	push(@meanings, $current_meaning);
	push(@links, $current_link);
	
   #print $current_word . "####" . $current_meaning . "####" . $current_link;
   $current_word = "";
   $current_meaning = "";
   $current_link = "";
   $print_sep = 1;
}

unlink($localfile);

#randomly select any one word
my $low = 0;
my $high = scalar @words - 1;
my $randomIndex = int(rand($high + 1)) + $low;

#generate QRCode for the link and save to a temp file
my $outfilename = $randStr->randpattern("cccccccc") . ".png";
my $outfile = $tempdir . "\\" . $outfilename;
qrpng(text => $links[$randomIndex], out => $outfile);

print $words[$randomIndex] . "####" . $meanings[$randomIndex] . "####" . $outfilename;

