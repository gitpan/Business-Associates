## $Id: XML.pm,v 1.3 2002/04/02 11:39:08 allane Exp $
## Associates package: Routines to handle Amazon.com XML interface
##                     for Amazon Associates.
## XML:    Encapsulate XML, XSL, and XSLT operations
##
## Copyright © 2002 Allan Engelhardt <allane@cybaea.com>
##
## Amazon, Amazon.com, and other names used may be trademarks of Amazon
## in the United States of America and other jurisdictions.
##
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
##

package Business::Associates::XML;

use strict;

use Business::Associates::Data();
use Business::Associates::Imgsize();

use File::Spec 0.82 ();
use IO::File ();

## One of the reasons for this modules is that we may later want to
## change the XML and XSLT libraries.  For now, you need the libxml
## and libxslt libraries, avaiable as RPM and other formats from the
## Gnome ftp site (ftp://ftp.gnome.org/).

## The XML::LibXML packages are available from CPAN.  As root, do:

## % perl -MCPAN -e 'install XML::LibXSLT'

## to update to the latest versions.  Make sure you have the latest.

use XML::LibXML  1.40 ();	# Requires Gnome libxml  installed
use XML::LibXSLT 1.31 ();	# Requires Gnome libxslt installed

BEGIN {
    use Exporter();
    our ($VERSION, @ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS);
    $VERSION = do { my @r = (q$Revision: 1.3 $ =~ /\d+/g); sprintf "%d."."%02d" x $#r, @r }; # must be all one line, for MakeMaker
    @ISA = qw(Exporter);
    @EXPORT = qw();
    @EXPORT_OK = qw($Base_Directory $Always_Load 
		    transform);
    %EXPORT_TAGS = (
		    methods => [qw(transform)],
		    variables => [qw($Base_Directory)],
		    debug => [qw($Always_Load)]
		    );
}

## Public variables

our @Stylesheet_Path = (File::Spec->catdir(File::Spec->rootdir, 
					   "var", "www", "stylesheets"),
			@INC);
our $Base_Directory = \$Stylesheet_Path[0];
our $Always_Load = 0;		# Set to 1 to always load stylesheets from file

## Private variables

our %stylesheets;

=pod

=begin notused

sub match_uri {
    print STDERR "match_uri: @_\n";
    my $uri = shift;
    return undef unless defined $uri;
    print STDERR "match_uri: $uri\n";
    return $uri =~ m:^/Associates_Imagesize/:;
}
sub open_uri {
    print STDERR "open_uri: @_\n";
    my $uri = shift;
    return undef unless defined $uri;
    print STDERR "open_uri: $uri\n";
    ( my $fn = $uri ) =~ s:^/Associates_Imagesize/::;
    my $xml = Business::Associates::Imgsize::img_size_xml_string($uri);
    my $handler = {
	pos => $[,
	xml => $xml
	};
    return $handler;
}
sub read_uri {
    print STDERR "read_uri: @_\n";
    my ($handler, $length) = @_;
    return undef unless defined $handler;
    return undef unless defined $length;
    print STDERR "read_uri: $length\n";
    my $buffer = substr ($handler->{xml}, $handler->{pos}, $length);
    $handler->{pos} += $length;
    return $buffer;
}
sub close_uri {
    print STDERR "close_uri: @_\n";
    my $handler = shift;
    print STDERR "close_uri\n";
    return undef unless defined $handler;
    undef $handler;
}

=end notused

=cut

sub new {
    my $proto      = shift;
    my $class      = ref($proto) || $proto;
    my $data       = shift;
    my $xml_string = $data->{'xml'} || return undef;

    my $parser = XML::LibXML->new();
    $parser->load_ext_dtd(0);	# Global setting, unfortunately :-(

#    $parser->match_callback(\match_uri);
#    $parser->open_callback(\open_uri);
#    $parser->read_callback(\read_uri);
#    $parser->close_callback(\close_uri);

    my $xml    = $parser->parse_string($xml_string);    

    my $self  = { xml => $xml,
		  @_ };
    bless ($self, $class);
    return $self;
}


sub append {
    my ($self, $other) = @_;
    my $dom1 = $self->{'xml'};
    my $dom2 = $other->{'xml'}         || return undef;
    my $r1 = $dom1->getDocumentElement || return undef;
    my $r2 = $dom2->getDocumentElement || return undef;
    my $r  = $r1->getLastChild()       || return undef;
    my $c  = $r2->getFirstChild();
    while ($c) {
	my $l = $c->cloneNode(1)       || return undef;
	$dom1->importNode($l)          || return undef;
	$r1->insertAfter($l, undef);
	$c = $c->getNextSibling();
    }
    return 1;
}

sub transform {
    my ($self, $ss_name, %args) = @_;
    my $xml = $self->{'xml'};
    return undef unless defined $xml;

    if ( not defined $args{'associates_id'} ) {
	my %a = XML::LibXSLT::xpath_to_string(a => $Business::Associates::Data::Associates_Id );
	$args{'associates_id'} = $a{'a'};
    }

    my $doc;
    my $result;
    my $ss  = $self->get_stylesheet($ss_name);
    $doc = $ss->transform($xml, %args) if defined $ss;
    $result = $ss->output_string($doc) if defined $doc;
    return $result;
}

sub get_stylesheet {
    my $self = shift;
    my $ss_name = shift;
    return $stylesheets{$ss_name} if defined $stylesheets{$ss_name};

    my $ss;
    ## XXX This is a bit primitive....
    my $fn;
    my $ss_dir;
    foreach $ss_dir (shift, @Stylesheet_Path) {
	next if not defined $ss_dir;
	$fn = File::Spec->catfile($ss_dir, "${ss_name}.xslt");
	last if -r $fn;
	$fn = File::Spec->catfile($ss_dir, "Business", "Associates", "${ss_name}.xslt");
	last if -r $fn;
	$fn = undef;
    }
    return undef if not defined $fn;

    my $xslt = XML::LibXSLT->new();
    $ss      = $xslt->parse_stylesheet_file($fn);
    $stylesheets{$ss_name} = $ss unless $Always_Load;
    return $ss;
}

1;

__END__

=head1 NAME

Business::Associates::XML - encapsulating XML, XSL, and XSLT operations for the Associates package

=head1 SYNOPSIS

    use Business::Associates::Data();
    use Business::Associates::XML();

    $data = Business::Associates::Data->$type ($what, $mode);
    $xml  = new Business::Associates::XML ($data) if defined $data;
    $s    = $xml->transform($ss_name, %args)      if defined $xml;
    print "\n\n$s\n";

=head1 METHODS

=over 6

=item I<new($data [, %options ])>

This constructor takes an Business::Associates::Data object as the required
argument.  The optional I<options> hash can be used to set additional
values.

=over 4

=item I<xml>

This is the parsed xml string.  If you want to pass
special arguments to the XML::LibXML library then you can do it
with this argument:

  $data = Business::Associates::Data->$type ($what, $mode);
  my $xml_string = $data->xml();
  my $parser = XML::LibXML->new();
  $parser->load_ext_dtd(0); # Global setting, unfortunately :-(
  my $xml = new Business::Associates::XML(
     xml => $parser->parse_string($xml_string));
  ...

It is possibly more efficient to access this element directly after
the construction to set the options on the newly constructed
XML::LibXML object.

=back

=item I<transform($stylesheet_name [, %args ] )>

This method transforms the XML using the I<named> stylesheet, parsing
any additional arguments to the stylesheet I<transform> method.
Typically, these additional arguments are used to set global XSLT
parameters.

  $data = Business::Associates::Data->$type ($what, $mode);
  $xml  = new Business::Associates::XML ($data);
  $s    = $xml->transform($ss_name, width => "'3'");

B<Note> that these are I<named> stylesheets.  By default, they are
found in the I<Base_Directory> (see L</Base_Directory>) with the same
name and the extension C<.xslt>.  To change this, either change the
I<Base_Directory> variable, or derive another class from this,
overriding the I<get_stylesheet> method.

B<NOTE:> in the current version, if the parameter associates_id is not
set in the I<%args> hash, then the default value from Business::Associates::Data
(see L<Business::Associates::Data/"VARIABLES"> is inserted.  I recommend that
you do B<not> rely on this behavior!

=item I<append($xml)>

This method appends I<$xml> (which is of type Business::Associates::XML) to the
current XML object, inserting all elements below the root of I<$xml>
after the last child of the current XML.

This is used to implement searched across multiple product
categories.  For example

    my $mode="music dvd";
    my $xml;
    my $s = "";
    foreach my $m (split /\s+/, $mode) {
        my $data = Business::Associates::Data->$type ($what, $m);
        if (not defined $xml) {
    	$xml  = new Business::Associates::XML ($data) if defined $data->xml();
        }
        else {
    	my $x = new Business::Associates::XML ($data) if defined $data->xml();
    	$xml->append($x)  || die "No append!";
        }
    }
    $s    = $xml->transform($ss_name, %args)  if defined $xml;
    print "\n\n$s\n";

Note that after you append then new XML document may not be in a
format that is compatible with the original DTD.

=back

=head1 VARIABLES

=over 6

=item I<@Stylesheet_Path>

This variable provides an array of directories to search for the named
style sheets.  The default value is

    ("/var/www/stylesheets", @INC)

Note that the directories specified and any sub-directories called
F<Business/Associates> are searched.

=item I<$Base_Directory> [Default: C<"/var/www/stylesheets/">]

DEPRECIATED: Use I<@Stylesheet_Path> instead.  This is now an alias
for I<$Stylesheet_Path[0]>.

This is the base directory for all stylesheets.  You will probably
want to override this:

    use Business::Associates::XML();
    $Associates::XML::Base_Directory = "/my/path";

=item I<$Always_Load> [Default: 0]

This is a little hack for developers.  If this value is set to 1 then
no styelsheets are chached in memory by the default I<get_stylesheet>
funtion.  Instead they are read from the file every time.

=back

=head1 DESCRIPTION

This module provides a simple interface to the XML libraries.  The
main reason for havinf this module at all, is to allow us to switch to
another XML implenetation in the future, should we want to do this.

=head1 BUGS

Please report bugs to the author.

=head1 SEE ALSO

See also L<XML::LibXSLT>, L<XML::LibXML>, L<libxml(4)>,
and L<File::Spec>.

=head1 AUTHOR

This package was written by Allan Engelhardt E<lt>allane@cybaea.comE<gt>

=head1 COPYING

Copyright (c) 2002 Allan Engelhardt E<lt>allane@cybaea.comE<gt>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or (at
your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
USA

