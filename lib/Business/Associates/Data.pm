## $Id: Data.pm,v 1.2 2002/04/02 06:57:53 allane Exp $
##
## Associates package: Routines to handle Amazon.com XML interface
##                     for Amazon Associates.
## Data:               Methods for getting XML data from Amazon.com
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

package Business::Associates::Data;

use strict;

use Business::Associates::Communication();
use Business::Associates::Cache();

BEGIN {
    use Exporter();
    our ($VERSION, @ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS);
    $VERSION = do { my @r = (q$Revision: 1.2 $ =~ /\d+/g); sprintf "%d."."%02d" x $#r, @r }; # must be all one line, for MakeMaker
    @ISA = qw(Exporter);
    @EXPORT = qw();
    @EXPORT_OK = qw($Associates_Id keywords browse);
    %EXPORT_TAGS = (
		    methods   => [qw(keywords browse)],
		    variables => [qw($Associates_Id)]
		    );
}

our $Associates_Id = "allanengelhardt"; # Default.  Change in program

our $cache;

sub get_it($) {
    ## internal use
    my $url = shift;
    {
	lock $cache;
	$cache ||= new Business::Associates::Cache;
    }
    my $data = $cache->get($url);
    if (!defined($data)) {
	my $comms = new Business::Associates::Communication;
	$data = $comms->get_url($url);
	## XXX temporary hack for Amazon.com bug
	$data =~ s/\&(\s)/&amp;$1/gs if defined $data;
	## XXX End of hack
	$cache->set($url, $data) if $data;
    }
    return $data;
}

sub xml {
    my $self = shift;
    $self->{xml} = shift if @_;
    return $self->{xml};
}

sub keywords {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $keywords = shift;
    my $mode = shift;
    my $id = shift || $Associates_Id;
    my $url = qq{http://rcm.amazon.com/e/cm?t=$id&l=st1&search=$keywords&mode=$mode&p=102&o=1&f=xml};
    my $data = get_it($url);
    my $self  = { xml => $data };
    bless ($self, $class);
    return $self;
}

sub browse {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $browse_id = shift;
    my $mode = shift;
    my $id = shift || $Associates_Id;
    my $url = qq{http://rcm.amazon.com/e/cm?t=$id&l=bn1&browse=$browse_id&mode=$mode&p=102&o=1&f=xml};
    print STDERR $url, "\n";
    my $data = get_it($url);
    my $self  = { xml => $data };
    bless ($self, $class);
    return $self;
}



1;

__END__

=head1 NAME

Business::Associates::Data - Methods for getting XML data from Amazon.com

=head1 SYNOPSIS

  use Business::Associates::Data(); # preferred
  use Business::Associates::Data(:methods :variables);
  use Business::Associates::XML();

  $data = Business::Associates::Data->keywords ($what, $mode); # or:
  $data = Business::Associates::Data->browse ($what, $mode);

  $xml  = new Business::Associates::XML ($data)       if defined $data;
  $s    = $xml->transform($ss_name, %args)  if defined $xml;

=head1 METHODS

=over 6

=item I<keywords($keywords, $mode [, $id ] )>

This does a keyword search on Amazon.com, using I<$keywords> as
keywords and I<$mode> as the mode (e.g. "books" or "dvd").  Both
variables are used directly in a URL and should be suitably escaped
(see for example L<Apache::Util> or L<URI::Escape>).

The optional I<$id> variable specifies an Amazon.com Associates id to
use for this request.  The default is set by the package variable
I<$Associates_Id> (see L</"VARIABLES">).  You will want to modify this
variable for your implementation!

=item I<browse($browse_id, $mode [, $id ] )>

This does a browse on Amazon.com, using I<$browse_id> as the browse
category (e.g. 1000 for Books, 513080 for Camera & Photo) and I<$mode>
as the mode (e.g. "books" or "electronics").  Both variables are used
directly in a URL and should be suitably escaped (see for example
L<Apache::Util> or L<URI::Escape>).

No, I don't know why the I<$mode> variable is required on this
interface when the I<$browse_id> obviously specifies the type of
product, but Amazon says it is mandatory, so we provide it.  It
doesn't seem to make any difference.

The optional I<$id> variable specifies an Amazon.com Associates id to
use for this request.  The default is set by the package variable
I<$Associates_Id> (see L</"VARIABLES">).  You will want to modify this
variable for your implementation!

=back

=head1 VARIABLES

=over 6

=item I<Associates_Id>

This is the default Amazon.com Associates id that this interface will
use.

B<YOU SHOULD CHANGE THIS VALUE>, unless you specifically want to
support this starving programmer, of course :-)  Do it like this:

  use Business::Associates::Data();
  $Business::Associates::Data::Associates_Id = "MyAssociatesId";

(Note to users from previous versions: extra quotes are now 
I<not> required.)

=back

=head1 DESCRIPTION

This module provides a simple interface to both keyword search and
category browse using the Amazon.com XML interface.  It uses
Business::Associates::Cache to cache the results for (by default) 24
hours.

=head1 BUGS

Please report bugs to the author.

=head1 SEE ALSO

See also L<Business::Associates::Communication>, 
L<Business::Associates::Cache>
http://www.amazon.com/.

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

