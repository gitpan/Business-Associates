## $Id: Makefile.PL,v 1.3 2002/04/01 22:36:43 allane Exp $
## Copyright © 2002 Allan Engelhardt <allane@cybaea.com>
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

use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Business::Associates',
    'AUTHOR'            => 'Allan Engelhardt <allane@cybaea.com>',
    'VERSION_FROM'	=> 'lib/Business/Associates.pm', # finds $VERSION
    'ABSTRACT_FROM'     => 'lib/Business/Associates.pm',
    'PREREQ_PM'		=> {
        Cache::Cache => 0.99,
        Cache::SizeAwareFileCache => 0,
        File::Spec => 0.82,
	HTTP::Request => 1.30,
	Image::Info => 1.09,
	LWP::UserAgent => 2.001,
	XML::LibXML => 1.40,
	XML::LibXSLT => 1.31,
    }, # e.g., Module::Name => 1.1
    'dist' => {
	CI        => 'cvs update -d',
	RCS_LABEL => 'cvs tag v$(VERSION_SYM)',
    },
);
