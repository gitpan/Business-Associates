## $Id: Imgsize.pm,v 1.1 2002/04/01 22:13:10 allane Exp $
## Associates package: Routines to handle Amazon.com XML interface
##                     for Amazon Associates.
## Imgsize: mod_perl functions to get and cache image size
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


package Business::Associates::Imgsize;

use strict;

use Business::Associates::Communication();

use Apache::Registry ();
use Apache::Constants qw(:common);
use Apache::Log();
use Apache::Util();

use Image::Info 1.09 ();

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

our $cache;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self  = { };
    $cache ||= new Cache::SizeAwareFileCache( {
        namespace => 'Business_Associates_Imgsize',
	default_expires_in => '1 month',
	max_size => $Cache_Size,
        cache_depth => $Cache_Depth,
	@_ });
    bless ($self, $class);
    return $self;
}

sub jpegsize {
  my($JPEG) = @_;
  my $pos = 0;
  my($done)=0;
  my($c1,$c2,$ch,$s,$length,$dummy)=(0,0,0,0,0,0);
  my($a,$b,$c,$d);

  if(defined($JPEG)             &&
     ($c1 = substr($JPEG, $pos++, 1))        &&
     ($c2 = substr($JPEG, $pos++, 1))        &&
     ord($c1) == 0xFF           &&
     ord($c2) == 0xD8           ){
    while (ord($ch) != 0xDA && !$done) {
      # Find next marker (JPEG markers begin with 0xFF)
      # This can hang the program!!
      while (ord($ch) != 0xFF) { return(0,0) unless ($ch = substr($JPEG, $pos++, 1)); }
      # JPEG markers can be padded with unlimited 0xFF's
      while (ord($ch) == 0xFF) { return(0,0) unless ($ch = substr($JPEG, $pos++, 1)); }
      # Now, $ch contains the value of the marker.
      if ((ord($ch) >= 0xC0) && (ord($ch) <= 0xC3)) {
        return(0,0) unless ($dummy = substr($JPEG, $pos, 3), $pos+=3, $dummy);
        return(0,0) unless ($s = substr($JPEG, $pos, 4), $pos += 4, $s);
        ($a,$b,$c,$d)=unpack("C"x4,$s);
        return ($c<<8|$d, $a<<8|$b );
      } else {
        # We **MUST** skip variables, since FF's within variable names are
        # NOT valid JPEG markers
        return(0,0) unless ($s = substr($JPEG, $pos, 2), $pos+=2, $s);
        ($c1, $c2) = unpack("C"x2,$s);
        $length = $c1<<8|$c2;
        last if (!defined($length) || $length < 2);
        $pos += $length-2; # read($JPEG, $dummy, $length-2);
      }
    }
  }
  return (0,0);
}

sub img_size_xml {
    my $r = shift;
    my $uri = shift;
    $r->content_type("text/xml; charset=ISO-8859-1");
    $r->send_http_header;
    return OK if ($r->header_only);
    my $xml = img_size_xml_string($uri);
    $r->print($xml);
    return OK;
}

sub img_size_xml_string {
    my $uri = shift;
    my $xml = $cache->get($uri);
    if (not defined $xml) {
	$xml .= qq{<?xml version="1.0" encoding="ISO-8859-1"?>\n};
        $xml .= qq{<!DOCTYPE imgsize>\n};
        $xml .= qq{<imgsize>\n};
	my ($w,$h) = (0,0);
	my $c = new Business::Associates::Communication;
	$uri = "http://localhost$uri" if $uri =~ m:^/:;
	my $img = $c->get_url_with_timeout($uri, 5);
	if ($img) {
	    my $info = Image::Info::image_info(\$img);
	    if (not $info->{error}) {
		($w,$h) = Image::Info::dim($info);
		if ($w > 1 and $h > 1) {
		    while(my($key,$value) = each %$info ) {
			$key   = Apache::Util::escape_html($key);
			$value = Apache::Util::escape_html($value);
			$xml .= qq{ <$key>$value</$key>\n} unless ref($value);
		    }
		}
	    }
	}
	$xml .= qq{</imgsize>\n};
	if ($w > 1 and $h > 1) {
	    $cache->set($uri, $xml);
	}
    }
    return $xml;
}

sub handler {
    my $r = shift;
    if    (0) {
    }
    elsif ($r->uri() =~ m:^/Associates_Imagesize/(.+)$:) {
	my $url = $1;
	new();
	return img_size_xml($r, $url);
    }

    $r->log->warn("\n" . __PACKAGE__ . " DECLINING " . $r->uri());
    return DECLINED;
}

1;


__END__

=head1 NAME

Business::Associates::Imgsize - mod_perl routines to provide cached image sizes

=head1 SYNOPSIS

In your Apache configuration file add a section

    <Location /Associates_Imagesize/>
        SetHandler  perl-script
        PerlHandler Business::Associates::Imgsize
    </Location>

For other web servers (e.g. IIS with ActiveState perl) please consult
the local documentation.

=head1 METHODS

=over 6

=item I<handler($r)>

The handler method for Apache's mod_perl implementation.  It expects
to be called with a URL of C</Associates_Imagesize/I<image-url>> and
will decline the request if it is not.  Otherwise, it calls
I<img_size_xml> with I<image-url> as argument.

=item I<img_size_xml($r, $url)>

This method writes an XML document to the request I<$r> with
information about the size of the image I<$url>.  A typical response
looks like:

    <?xml version="1.0" encoding="ISO-8859-1"?>
    <!DOCTYPE imgsize>
    <imgsize>
     <width>62</width>
     <height>90</height>
     ... additional elements ...
    </imgsize>

In the future we may change the C<DOCTYPE>.

The additional elements are every scalar element that Image::Info
knows about.  For this information, and for a list of supported image
formats, see L<Image::Info>.

If we could not load the image url or parse the resulting image file,
then we return an empty C<imgsize> element.

All XML results are cached using Cache::SizeAwareFileCache for a
period of one month.

If the I<$url> begins with a '/', then "C<http://localhost>" is added
to the start of the URL.

=back

=head1 VARIABLES

=over 6

=item Cache_Size   [Default: 25M]

This is the default maximum cache size.  If you are doing many
different searches you may want to increase this.

If you increse this you should probably also increase I<Cache_Depth>

=item Cache_Depth  [Default: 3]

See L<Cache::FileCache>.

=back

=head1 DESCRIPTION

Unfortunately, the Amazon.com Associates XML interface does not
directly provide information on the sizes of the product images.

For some web pages, especially those with a large number of Amazon
images, the user experience is somewhat unpleasant as the browser
redraws the page multiple times while it loads the Amazon images.

When installed, this package adds C<width> and C<height> attributes to
all C<img> entities of the generated images, unless disabled by the
style sheet C<disable_img_size> parameter, see
L<Business::Associates::Stylesheet/"User Parameters">.

=head1 BUGS

Please report bugs to the author.

=head1 SEE ALSO

See also L<Business::Associates::Stylesheet/"User Parameters">,
L<Image::Info>, L<Cache::Cache>, L<Cache::FileCache>,
L<Cache::SizeAwareFileCache>,
and http://www.apache.org/

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

