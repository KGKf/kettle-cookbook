<?xml version="1.0"?>
<!--

This is toc.xslt. This is part of kettle-cookbook.
Kettle-cookbook is distributed on http://code.google.com/p/kettle-cookbook/

toc.xslt - an XSLT transformation that generates the table of contents
for Pentaho documentation.
This is part of kettle-cookbook, a pentaho documentation generation framework.

Copyright (C) 2010 Roland Bouman
Roland.Bouman@gmail.com - http://rpbouman.blogspot.com/

This library is free software; you can redistribute it and/or modify it under 
the terms of the GNU Lesser General Public License as published by the 
Free Software Foundation; either version 2.1 of the License, or (at your option)
any later version.

This library is distributed in the hope that it will be useful, but WITHOUT ANY 
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A 
PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along 
with this library; if not, write to 
the Free Software Foundation, Inc., 
59 Temple Place, Suite 330, 
Boston, MA 02111-1307 USA

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:variable name="item-type" select="''"/>
<xsl:include href="shared.xslt"/>

<xsl:template match="/">
<html>
    <head>

        <xsl:copy-of select="$meta"/>
        
        <title>Pentaho Documentation: Table of Contents</title>

        <xsl:call-template name="favicon">
            <xsl:with-param name="name" select="'pentaho'"/>
        </xsl:call-template>

        <xsl:call-template name="stylesheet">
            <xsl:with-param name="name" select="'default'"/>
        </xsl:call-template>
        <xsl:call-template name="stylesheet">
            <xsl:with-param name="name" select="'toc'"/>
        </xsl:call-template>

    </head>
    <body class="toc">

        <xsl:apply-templates select="index"/>

        <xsl:call-template name="script">
            <xsl:with-param name="name" select="'toc'"/>
        </xsl:call-template>

    </body>
</html>
</xsl:template>

<xsl:template name="files">
    <xsl:param name="caption" select="''"/>
    <xsl:param name="extension"/>    
    <xsl:param name="files" select="file[extension/text()=$extension]"/>
    
    <xsl:if test="$caption!=''">
        <h3><xsl:copy-of select="$caption"/></h3>
    </xsl:if>
    <xsl:choose>
        <xsl:when test="$files">
            <ul>
                <xsl:for-each select="$files">
                    <xsl:sort select="translate(short_filename/text(), $upper-case-alphabet, $lower-case-alphabet)"/>
                    <xsl:apply-templates select="."/>
                </xsl:for-each>
            </ul>
        </xsl:when>
        <xsl:otherwise>
            <xsl:if test="$caption!=''">
                <p>None.</p>
            </xsl:if>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="/index">
    <div id="tab-strip">
        <!--
        
            TODO: toolbar to switch between categorical and hierarchical view
            
        -->
        <div id="tab-spacer-left" class="tab-spacer">&#160;</div>
        <div id="tab-toc-by-category" class="tab tab-active">
            <a href="#_tab-toc-by-category" onclick="tabClicked(this)">Categorical</a>
        </div>
        <div id="tab-toc-by-path" class="tab">
            <a href="#_tab-toc-by-path" onclick="tabClicked(this)">Hierarchical</a>            
        </div>
        <div id="tab-spacer-right" class="tab-spacer">&#160;</div>
    </div>
    <div id="tab-pages">
        <div id="tab-toc-by-category-page">
            <!-- <a name="toc-by-category"></a> -->
            <xsl:call-template name="files">
                <xsl:with-param name="caption" select="'Action Sequences'"/>
                <xsl:with-param name="extension" select="'xaction'"/>
            </xsl:call-template>

            <xsl:call-template name="files">
                <xsl:with-param name="caption" select="'CDF Dashboards'"/>
                <xsl:with-param name="extension" select="'xcdf'"/>
            </xsl:call-template>

            <xsl:call-template name="files">
                <xsl:with-param name="caption" select="'Kettle Jobs'"/>
                <xsl:with-param name="extension" select="'kjb'"/>
            </xsl:call-template>

            <xsl:call-template name="files">
                <xsl:with-param name="caption" select="'Kettle Transformations'"/>
                <xsl:with-param name="extension" select="'ktr'"/>
            </xsl:call-template>

            <xsl:call-template name="files">
                <xsl:with-param name="caption" select="'Pentaho Reports'"/>
                <xsl:with-param name="extension" select="'prpt'"/>
            </xsl:call-template>
        </div>
        <div id="tab-toc-by-path-page" style="display: none">
            <!-- <a name="toc-by-path"></a> -->
            <br />
            <div class="folder">
                <div class="folder-head">
                    <span class="folder-toggle">-</span>
                    <span class="folder-icon-open"></span>
                    <span class="folder-icon-closed"></span>
                    <span class="folder-label"><xsl:value-of select="$input-dir"/></span>
                </div>
                <div class="folder-body">
                    <xsl:call-template name="sub-folders"/>
                    <xsl:call-template name="folder-files">
                        <xsl:with-param name="folder" select="$input-dir"/>
                    </xsl:call-template>
                </div>
            </div>
        </div>
    </div>
</xsl:template>

<xsl:template match="file">
    <xsl:variable name="relative-path" select="substring-after(filename/text(), $input-dir)"/>
    <li>
        <xsl:attribute name="class">item-<xsl:value-of select="extension"/></xsl:attribute>
        <a target="main">
            <xsl:attribute name="class">item-<xsl:value-of select="extension"/></xsl:attribute>
            <xsl:attribute name="href"><xsl:value-of select="concat('html', $relative-path, '.html')"/></xsl:attribute>
            <xsl:value-of select="short_filename/text()"/>
        </a>
    </li>
</xsl:template>


<xsl:variable name="folders" select="/index/folder"/>
<xsl:variable name="files" select="/index/file"/>

<xsl:template name="folder-files">
    <xsl:param name="folder"/>
    <xsl:call-template name="files">
        <xsl:with-param name="files" select="$files[path/text() = $folder]"/>
    </xsl:call-template>
</xsl:template>

<xsl:template name="folder">
    <xsl:param name="folder"/>
    <xsl:variable name="full-name" select="$folder/@full-name"/>
    <xsl:if test="$files[starts-with(path/text(), $full-name)]">    
        <div class="folder">
            <div class="folder-head">
                <span class="folder-toggle" onclick="toggleTreeNode(this)">-</span>
                <span class="folder-icon-open"></span>
                <span class="folder-label"><xsl:value-of select="$folder/@short-name"/></span>
            </div>
            <div class="folder-body">
                <xsl:call-template name="sub-folders">
                    <xsl:with-param name="parent-folder" select="$full-name"/>
                </xsl:call-template>
                <xsl:call-template name="folder-files">
                    <xsl:with-param name="folder" select="$full-name"/>
                </xsl:call-template>
            </div>
        </div>
    </xsl:if>
</xsl:template>

<xsl:template name="sub-folders">
    <xsl:param name="parent-folder" select="$input-dir"/>
    <xsl:for-each select="$folders[@parent-folder = $parent-folder]">
        <xsl:sort select="translate(@short-name, $upper-case-alphabet, $lower-case-alphabet)"/>
        <xsl:call-template name="folder">
            <xsl:with-param name="folder" select="."/>
        </xsl:call-template>
    </xsl:for-each>
</xsl:template>

</xsl:stylesheet>