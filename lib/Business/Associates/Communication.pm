## $Id: Communication.pm,v 1.2 2002/04/01 22:37:34 allane Exp $
## Associates package: Routines to handle Amazon.com XML interface
##                     for Amazon Associates.
## Communication - Object to retrieve the XML data
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

package Business::Associates::Communication;

use strict;

use Business::Associates();

use HTTP::Request  1.30  ();
use LWP::UserAgent 2.001 ();

BEGIN {
    use Exporter();
    our ($VERSION, @ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS);
    $VERSION = do { my @r = (q$Revision: 1.2 $ =~ /\d+/g); sprintf "%d."."%02d" x $#r, @r }; # must be all one line, for MakeMaker
    @ISA = qw(Exporter);
    @EXPORT = qw();
    %EXPORT_TAGS = ();
    @EXPORT_OK = qw(); # our - variables
}

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self  = { ua =>
		    LWP::UserAgent->new(
                      agent => __PACKAGE__ . 
		      "/${Business::Associates::VERSION} [http://cybaea.con/Associates.html]",
		      keep_alive => 0,
		      timeout => 10),
		  @_ };
    bless ($self, $class);
    return $self;
}

sub get_url_with_timeout {
    my ($self, $url,$timeout) = @_;
    my $result;
    my $ua = $self->{'ua'};
    my $old_timeout = $ua->timeout();
    $ua->timeout($timeout)     unless $timeout == $old_timeout;
    my $req = HTTP::Request->new('GET', "$url");
    my $res = $ua->request($req);
    if ($res->is_success) {
	$result = $res->content;
    }
    $ua->timeout($old_timeout) unless $timeout == $old_timeout;
    return $result;
}

sub get_url {
    my $self = shift;
    my $url = shift;
    my $ua = $self->{'ua'};
    return $self->get_url_with_timeout($url, $ua->timeout());
}

1;

__END__

=head1 NAME

Business::Associates::Communication - Communication routines for the Associates module

=head1 SYNOPSIS

    use Business::Associates::Communication();
    my $c = new Business::Associates::Communication;
    my $html = $c->get_url("http://www.amazon.com/");
    my $xml  = $c->get_url_with_timeout($url, 10);

=head1 METHODS

=over 6

=item I<new( [ %options ] )>

This constructs a new object.  You should always call this method as
it sets up the basic communication objects (specifically, it creates
and caches a C<LWP::UserAgent> object).

No arguments are required for this function, but optional parameters
include:

=over 4

=item I<ua>

The C<LWP::UserAgent> user agent that all requests will use.

 use LWP::UserAgent();
 my $ua = LWP::UserAgent->new(keep_alive => 0, timeout => 15);
 my $c  = new Business::Associates::Communication ( ua => $ua );		       

=back

=item I<get_url_with_timeout($url, $timeout)>

Retrieves a URL specified by the I<$url> argument, and returns the
result as a string.  If it is unable to retrieve the page in
I<$timeout> seconds, it gives up and returns undefined.

=item I<get_url($url)>

Convenience funtion that calls I<get_url_with_timeout> with the
default timeout for the C<LWP::UserAgent>.  This timeout is
deliberately set to a relative short value in the constructor so as to
not hang your web server.

=back


=head1 DESCRIPTION

This is a very simple wrapper around LWP::UserAgent and HTTP::Request,
providing just a convenience function.

=head1 BUGS

Please report bugs to the author.

=head1 SEE ALSO

See also L<HTTP::Request>, L<LWP::UserAgent>

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

