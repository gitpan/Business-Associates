<?xml version="1.0" encoding="ISO-8859-1"?>
<!--
## $Id: Associates_utilities.xslt,v 1.1 2002/04/01 22:13:10 allane Exp $
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

<!--
  **********************************************************************
			  Utility functions
  **********************************************************************
-->

<xsl:template name="trunc">
 <xsl:param name="string" />
 <xsl:param name="length" />
 <xsl:choose>
  <xsl:when test="string-length($string) &gt; $length">
   <xsl:value-of
	select="substring($string, 1, $length - string-length($truncation))" />
   <xsl:value-of select="$truncation" />
  </xsl:when>
  <xsl:otherwise>
   <xsl:value-of select="$string" />
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>


<xsl:template name="top-image">
 <xsl:choose>
  <xsl:when test="contains($images, 'top')">
   <xsl:call-template name="insert-image">
    <xsl:with-param name="image" select="$img_src_top" />
    <xsl:with-param name="alt"   select="$img_alt_top" />
   </xsl:call-template>
  </xsl:when>
  <xsl:when test="contains($images, 'auto')">
   <xsl:if test="$width &lt;= $height">
    <xsl:call-template name="insert-image">
     <xsl:with-param name="image" select="$img_src_top" />
     <xsl:with-param name="alt"   select="$img_alt_top" />
    </xsl:call-template>
   </xsl:if>
  </xsl:when>
 </xsl:choose>
</xsl:template>

<xsl:template name="left-image">
 <xsl:choose>
  <xsl:when test="contains($images, 'left')">
   <xsl:call-template name="insert-image">
    <xsl:with-param name="image" select="$img_src_left" />
    <xsl:with-param name="alt"   select="$img_alt_left" />
   </xsl:call-template>
  </xsl:when>
  <xsl:when test="contains($images, 'auto')">
   <xsl:if test="$width &gt; $height">
    <xsl:call-template name="insert-image">
     <xsl:with-param name="image" select="$img_src_left" />
     <xsl:with-param name="alt"   select="$img_alt_left" />
    </xsl:call-template>
   </xsl:if>
  </xsl:when>
 </xsl:choose>
</xsl:template>

<xsl:template name="right-image">
 <xsl:choose>
  <xsl:when test="contains($images, 'right')">
   <xsl:call-template name="insert-image">
    <xsl:with-param name="image" select="$img_src_right" />
    <xsl:with-param name="alt"   select="$img_alt_right" />
   </xsl:call-template>
  </xsl:when>
 </xsl:choose>
</xsl:template>

<xsl:template name="bottom-image">
 <xsl:choose>
  <xsl:when test="contains($images, 'bottom')">
   <xsl:call-template name="insert-image">
    <xsl:with-param name="image" select="$img_src_bottom" />
    <xsl:with-param name="alt"   select="$img_alt_bottom" />
   </xsl:call-template>
  </xsl:when>
 </xsl:choose>
</xsl:template>

<xsl:template name="get_img_size_for_url">
 <xsl:param name="url" />
 <xsl:if test="not($disable_img_size)">
  <xsl:variable name="local_url">
   <xsl:text>http://localhost/Associates_Imagesize/</xsl:text>
<!--
   <xsl:text>/Associates_Imagesize/</xsl:text>
-->
   <xsl:value-of select="$url" />
  </xsl:variable>
  <xsl:for-each select="document($local_url)//width">
   <xsl:attribute name="width">
    <xsl:value-of select="normalize-space(.)" />
   </xsl:attribute>
  </xsl:for-each>
  <xsl:for-each select="document($local_url)//height">
   <xsl:attribute name="height">
    <xsl:value-of select="normalize-space(.)" />
   </xsl:attribute>
  </xsl:for-each>
 </xsl:if>
</xsl:template>

<xsl:template name="insert-image">
 <xsl:param name="image" />
 <xsl:param name="alt" select="'[]'" />
 <xsl:value-of select="$newline" />
 <xsl:element name="a">
  <xsl:attribute name="class"><xsl:text>Associate_link</xsl:text></xsl:attribute>
  <xsl:attribute name="href">
  <xsl:text>http://www.amazon.com/exec/obidos/redirect-home/</xsl:text>
  <xsl:value-of select="$associates_id" />
  </xsl:attribute>
  <xsl:attribute name="target"><xsl:text>_blank</xsl:text></xsl:attribute>
  <xsl:element name="img">
   <xsl:attribute name="src"><xsl:value-of select="$image" /></xsl:attribute>
   <xsl:attribute name="alt"><xsl:value-of select="$alt" /></xsl:attribute>
   <xsl:attribute name="title"><xsl:value-of select="$alt" /></xsl:attribute>
   <xsl:call-template name="get_img_size_for_url">
    <xsl:with-param name="url" select="$image" />
   </xsl:call-template>
 </xsl:element>
  </xsl:element>
 <xsl:value-of select="$newline" />
</xsl:template>



</xsl:stylesheet>