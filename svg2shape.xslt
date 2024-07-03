<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:str="http://exslt.org/strings"
                xmlns:exsl="http://exslt.org/common"
		xmlns:math="http://exslt.org/math"
                extension-element-prefixes="exsl str"
                xmlns:dia="http://www.daa.com.au/~james/dia-shape-ns"
		xmlns:svg="http://www.w3.org/2000/svg"
                xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
                xmlns="http://www.daa.com.au/~james/dia-shape-ns"
                >
  <xsl:output method="xml" omit-xml-declaration="no" indent="yes" />
  <xsl:strip-space elements="*" />
  <xsl:param name="icon-file"/>

  <xsl:template match="/">
    <shape xmlns="http://www.daa.com.au/~james/dia-shape-ns" xmlns:svg="http://www.w3.org/2000/svg">
      <xsl:variable name="textbox" select="//*[name()='text' and @id='textbox']"/>
      <xsl:variable name="_name" select="$textbox/*[name()='tspan']"/>
      
      <name><xsl:value-of select="$_name"/></name>
      <xsl:if test="string-length($icon-file)">
        <icon><xsl:value-of select="$icon-file"/></icon>
      </xsl:if>
      
      <connections>
        <xsl:for-each select="//*[name()='g' and @id='connections']/*[starts-with(name(),'connection_')]|//*[starts-with(@id,'connection_')]">
          <xsl:call-template name="connection-point"/>
        </xsl:for-each>
      </connections>
      <xsl:if test="$textbox">
        <textbox align="center" resize="no">
          <xsl:attribute name="x1"><xsl:value-of select="$textbox/@x - 1"/></xsl:attribute>
          <xsl:attribute name="y1"><xsl:value-of select="$textbox/@y - 1"/></xsl:attribute>
          <xsl:attribute name="x2"><xsl:value-of select="$textbox/@x + 1"/></xsl:attribute>
          <xsl:attribute name="y2"><xsl:value-of select="$textbox/@y + 1"/></xsl:attribute>
        </textbox>
      </xsl:if>
      <aspectratio type="fixed"/>
      <xsl:apply-templates select="svg|svg:svg"/>
    </shape>
  </xsl:template>

  <xsl:template name="minx">
    <xsl:param name="draw" select="."/>
    <xsl:variable name="x">
      <xsl:call-template name="d">
        <xsl:with-param name="draw" select="$draw"/>
        <xsl:with-param name="index" select="1"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="math:min(str:tokenize(normalize-space($x)))"/>
  </xsl:template>

  <xsl:template name="maxx">
    <xsl:param name="draw" select="."/>
    <xsl:variable name="x">
      <xsl:call-template name="d">
        <xsl:with-param name="draw" select="$draw"/>
        <xsl:with-param name="index" select="1"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="math:max(str:tokenize(normalize-space($x)))"/>
  </xsl:template>

  <xsl:template name="miny">
    <xsl:param name="draw" select="."/>
    <xsl:variable name="y">
      <xsl:call-template name="d">
        <xsl:with-param name="draw" select="$draw"/>
        <xsl:with-param name="index" select="2"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="math:min(str:tokenize(normalize-space($y)))"/>
  </xsl:template>

  <xsl:template name="maxy">
    <xsl:param name="draw" select="."/>
    <xsl:variable name="y">
      <xsl:call-template name="d">
        <xsl:with-param name="draw" select="$draw"/>
        <xsl:with-param name="index" select="2"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="math:max(str:tokenize(normalize-space($y)))"/>
  </xsl:template>

  <xsl:template name="d">
    <xsl:param name="index" select="1"/>
    <xsl:param name="draw" select="."/>
  
    <xsl:for-each select="str:tokenize($draw)">
      <!-- interest in those that have a , in -->
      <xsl:if test="contains(.,',')">
        <xsl:value-of select="normalize-space(str:tokenize(.,',')[$index])"/><xsl:text>&#32;</xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- output a point tag which is the avg(minx+maxx),avg(miny,maxy) -->
  <xsl:template name="connection-point">
    <xsl:variable name="x1">
      <xsl:choose>
        <xsl:when test="@x"><xsl:value-of select="@x"/></xsl:when>
        <xsl:when test="@x1"><xsl:value-of select="@x1"/></xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="minx">
            <xsl:with-param name="draw" select="@d"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="y1">
      <xsl:choose>
        <xsl:when test="@y"><xsl:value-of select="@y"/></xsl:when>
        <xsl:when test="@y1"><xsl:value-of select="@y1"/></xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="miny">
            <xsl:with-param name="draw" select="@d"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="x2">
      <xsl:choose>
        <xsl:when test="@x2"><xsl:value-of select="@x2"/></xsl:when>
        <xsl:when test="@width"><xsl:value-of select="$x1 + @width"/></xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="maxx">
            <xsl:with-param name="draw" select="@d"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="y2">
      <xsl:choose>
        <xsl:when test="@y2"><xsl:value-of select="@y2"/></xsl:when>
        <xsl:when test="@height"><xsl:value-of select="$y1 + @height"/></xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="maxy">
            <xsl:with-param name="draw" select="@d"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="string-length($x1) and string-length($x2) and string-length($y1) and string-length($y2)">
      <point>
        <xsl:attribute name="x"><xsl:value-of select="( $x1 + $x2 ) div 2"/></xsl:attribute>
        <xsl:attribute name="y"><xsl:value-of select="( $y1 + $y2 ) div 2"/></xsl:attribute>
        <xsl:if test="@main">
          <xsl:attribute name="main"><xsl:value-of select="@main"/></xsl:attribute>
        </xsl:if>
      </point>
    </xsl:if>
  </xsl:template>

  <!-- ignore defs -->
  <xsl:template match="svg/defs|svg:svg/svg:defs"/>
  
  <!-- if our twin generated the svg, it will have put the shape in a shape group, so remove that group -->
  <xsl:template match="svg/g[@id='shape']">
    <xsl:apply-templates select="*"/>
  </xsl:template>

  <!-- if our twin generated the svg, it will have put the connections in the connections group which we convert seperately -->
  <xsl:template match="svg/g[@id='connections']"/>

  <xsl:template match="*[name()='text' and @id='textbox']"/>

  <xsl:template match="svg">
    <xsl:element name="svg:svg" namespace="http://www.w3.org/2000/svg">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>


  <xsl:template match="@*">
    <xsl:copy select="."/>
  </xsl:template>  

  <xsl:template match="*">
    <xsl:element name="{concat('svg:',local-name())}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>
</xsl:transform>
