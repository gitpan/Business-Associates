#!/usr/local/bin/perl -Tw
## $Id: a.pl,v 1.2 2002/04/02 06:58:57 allane Exp $
## test.pl : Simple test of the Associates module
## Copyright © 2002 Allan Engelhardt <allane@cybaea.com>
## ************************************************************************
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; if not, write to the Free Software
## Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
## ************************************************************************

use strict;

use Business::Associates::Data();
use Business::Associates::XML();

## XXX CHANGE NEXT LINE TO YOUR ASSOCIATES ID XXX
$Business::Associates::Data::Associates_Id = "allanengelhardt";
$Business::Associates::XML::Always_Load = 1; # For debugging!

my @all_modes = qw(books magazines music classical-music vhs dvd toys baby videogames electronics software universal garden kitchen photo pc-hardware);

my $what = join('+', @ARGV);
my $mode = "books+music+dvd";	# try: join('+', @all_modes)
my $ss_name = "Associates";
my $type = "keywords";		# Or: browse

# The two arguments shown here should always be set explicitly
my %args = (associates_id => $Business::Associates::Data::Associates_Id,
	    disable_img_size => "true()"
	    );

if (defined $ENV{QUERY_STRING}) {
    ## You'll want to use CGI.pm instead...
    my @args = split /&/, $ENV{QUERY_STRING};
    foreach my $a (@args) {
	my ($n, $v) = split /=/, $a; # XXX
	if    ($n eq "keywords") { $what = $v }
	elsif ($n eq "browse")   { $what = $v }
	elsif ($n eq "mode")     { $mode = $v }
	elsif ($n eq "ss")       { $ss_name = $v }
	elsif ($n eq "type")     { $type = $v }
	else                     { $args{$n} = $v }
    }
}

my $xml;
my $s = "";
foreach my $m (split /\++/, $mode) {
    my $data = Business::Associates::Data->$type ($what, $m);
    if (not defined $xml) {
	$xml  = new Business::Associates::XML ($data) if defined $data->xml();
    }
    else {
	my $x = new Business::Associates::XML ($data) if defined $data->xml();
	$xml->append($x)  || print STDERR "No append!";
    }
}
$s    = $xml->transform($ss_name, %args)  if defined $xml;
print "\n\n$s\n";

