## $Id: Cache.pm,v 1.1 2002/04/01 22:13:10 allane Exp $
## Associates package: Routines to handle Amazon.com XML interface
##                     for Amazon Associates.
## Associates::Cache - Routines to cache the result from Amazon
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


package Business::Associates::Cache;

use strict;

use Cache::Cache 0.99 ();	# Just for version check...
use Cache::SizeAwareFileCache();

BEGIN {
    use Exporter();
    our ($VERSION, @ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS);
    $VERSION = do { my @r = (q$Revision: 1.1 $ =~ /\d+/g); sprintf "%d."."%02d" x $#r, @r }; # must be all one line, for MakeMaker
    @ISA = qw(Exporter);
    @EXPORT = qw();
    %EXPORT_TAGS = ();
    @EXPORT_OK = qw($Cache_Size $Cache_Depth); # our - variables
}

our $Cache_Size  = 25*1024*1024;
our $Cache_Depth = 3;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self  = { };
    $self->{'cache'} = 
      new Cache::SizeAwareFileCache( {
        namespace => 'Business_Associates_Cache',
	default_expires_in => 24*60*60,	# XXX Expensive?
	max_size => $Cache_Size,
        cache_depth => $Cache_Depth,
	@_ }
      );
    bless ($self, $class);
    return $self;
}

sub set : locked method {
    my ($self, $key, $data) = @_;
    return $self->{'cache'}->set($key, $data);
}

sub get : locked method {
    my ($self, $key) = @_;
    return $self->{'cache'}->get($key);
}

1;


__END__

=head1 NAME

Business::Associates::Cache - Cache routines for the Associates packages.

=head1 SYNOPSIS

    use Business::Associates::Cache();
    my $cache = new Business::Associates::Cache;
    my $data = $cache->get($key);
    if (!defined($data)) {
        $data = ...some expensive operation...
	$cache->set($key, $data) if $data;
    }

=head1 METHODS

=over 6

=item I<new( [%options] )>

This constructs a new object.  Any options are passed directly to the
constructor for Cache::SizeAwareFileCache (see also
L<Cache::SizeAwareFileCache>), providing a convenient way of
overriding the default arguments.  Currently, these are

  namespace => 'Business_Associates_Cache',
  default_expires_in => 24*60*60,	# XXX Expensive?
  max_size => 25*1024*1024,
  cache_depth => 3

=item I<set($key, $data)>

This method sets the data for the given key, using the default
expiration time.  See also L<Cache::Cache/set>.

=item I<get($key)>

This method retrieves the data for the given key, checking for data
expiration.  See also L<Cache::Cache/get>.

=back

=head1 VARIABLES

=over 6

=item Cache_Size   [Default: 25M]

This is the default maximum cache size.  If you are doing many
different searches you may want to increase this B<before> you create
any Business::Associates::Cache objects.  A "typical" Amazon XML response is
about 8k, so the default size provides for over 1,000 requests to be
cached.

If you increse this you should probably also increase I<Cache_Depth>

=item Cache_Depth  [Default: 3]

See L<Cache::FileCache>.

=back

=head1 PREREQUISITES

This module requires the relatively new C<Cache::Cache>
module.  If you do not have it installed, then you can easily install
it.

As B<root> do

    % perl -MCPAN -e shell
    
    cpan shell -- CPAN exploration and modules installation (v1.59)
    ReadLine support enabled
    
    cpan> install Cache::Cache
    [...]
    Appending installation info to /usr/lib/perl5/5.6.0/i386-linux/perllocal.pod
      /usr/bin/make install  -- OK

    cpan>


=head1 DESCRIPTION

This package provides a simple cache interface for the Associates
modules.  The caching is required as a condition of using the
Amazon.com XML interface:

I<"And third, you should retrieve the new XML data once every 24
hours.">

The current implementation uses the Cache::Cache interface.  In the
near future, I plan to include a DBI interface so I can use
my beloved PostgreSQL database and you can use whatever you are
using.

=head1 CONFIGURATION

None required.  Please note that Cache::FileCache by default uses a
directory called C<FileCache> in your temporary directory.  It must be
possible to write there and, of course, you must have such a device.
See also L<Cache::FileCache/"OPTIONS"> and L</new>.

Default cache size is 25M, to chage it see L</"VARIABLES">

=head1 BUGS

Please report bugs to the author.

=head1 SEE ALSO

See also L<Cache::Cache>, L<Cache::FileCache>,
L<Cache::SizeAwareFileCache>,
L<DBI>, and http://www.postgresql.org/.

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

