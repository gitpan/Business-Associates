<?xml version="1.0" encoding="ISO-8859-1"?>
<!--
## $Id: Associates_variables.xslt,v 1.1 2002/04/01 22:13:10 allane Exp $
##
## Copyright (c) 2002 Allan Engelhardt <allane@cybaea.com>
##
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
-->
<xsl:stylesheet
	xml:lang="en-US"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml"
	version="1.0">

<xsl:variable name="how_many_r" select="$width * $height" />
<xsl:variable name="how_many_a" select="count(/catalog/product)" />

 <xsl:variable name="how_many">
  <xsl:choose>
   <xsl:when test="$how_many_r &gt; $how_many_a">
    <xsl:value-of select="$how_many_a" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="$how_many_r" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:variable>

<xsl:variable name="newline"  select="'&#xA;'" />

</xsl:stylesheet>