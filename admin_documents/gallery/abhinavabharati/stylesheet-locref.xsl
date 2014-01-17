<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions">
   <xsl:output method="html" encoding="utf-8" version="4.0" doctype-system="http://www.w3.org/TR/html4/strict.dtd"
      doctype-public="-//W3C//DTD HTML 4.01//EN"></xsl:output>

<xsl:template match="/">
<html encodingxmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
  <head>
    <meta http-equiv="Content-type" content="text/html;charset=UTF-8" />
    <link rel="stylesheet" type="text/css" href="../cssstylesheet2.css" />
    <title><xsl:value-of select="//titleStmt/title"/></title>
    <script type="text/javascript">
    <![CDATA[
    function toggle(id) {
       var e = document.getElementById(id);
       if(e.style.display == 'block')
          e.style.display = 'none';
       else
          e.style.display = 'block';
    }
// qTip - CSS Tool Tips - by Craig Erskine
// http://qrayg.com
//
// Multi-tag support by James Crooke
// http://www.cj-design.com
//
// Inspired by code from Travis Beckham
// http://www.squidfingers.com | http://www.podlob.com
//
// Copyright (c) 2006 Craig Erskine
// Permission is granted to copy, distribute and/or modify this document
// under the terms of the GNU Free Documentation License, Version 1.3
// or any later version published by the Free Software Foundation;
// with no Invariant Sections, no Front-Cover Texts, and no Back-Cover Texts.
// A copy of the license is included in the section entitled "GNU
// Free Documentation License".

var qTipTag = "a,label,input"; //Which tag do you want to qTip-ize? Keep it lowercase!//
var qTipX = 0; //This is qTip's X offset//
var qTipY = 15; //This is qTip's Y offset//

//There's No need to edit anything below this line//
tooltip = {
  name : "qTip",
  offsetX : qTipX,
  offsetY : qTipY,
  tip : null
}

tooltip.init = function () {
	var tipNameSpaceURI = "http://www.w3.org/1999/xhtml";
	if(!tipContainerID){ var tipContainerID = "qTip";}
	var tipContainer = document.getElementById(tipContainerID);

	if(!tipContainer) {
	  tipContainer = document.createElementNS ? document.createElementNS(tipNameSpaceURI, "div") : document.createElement("div");
		tipContainer.setAttribute("id", tipContainerID);
	  document.getElementsByTagName("body").item(0).appendChild(tipContainer);
	}

	if (!document.getElementById) return;
	this.tip = document.getElementById (this.name);
	if (this.tip) document.onmousemove = function (evt) {tooltip.move (evt)};

	var a, sTitle, elements;
	
	var elementList = qTipTag.split(",");
	for(var j = 0; j < elementList.length; j++)
	{	
		elements = document.getElementsByTagName(elementList[j]);
		if(elements)
		{
			for (var i = 0; i < elements.length; i ++)
			{
				a = elements[i];
				sTitle = a.getAttribute("title");				
				if(sTitle)
				{
					a.setAttribute("tiptitle", sTitle);
					a.removeAttribute("title");
					a.removeAttribute("alt");
					a.onmouseover = function() {tooltip.show(this.getAttribute('tiptitle'))};
					a.onmouseout = function() {tooltip.hide()};
				}
			}
		}
	}
}

tooltip.move = function (evt) {
	var x=0, y=0;
	if (document.all) {//IE
		x = (document.documentElement && document.documentElement.scrollLeft) ? document.documentElement.scrollLeft : document.body.scrollLeft;
		y = (document.documentElement && document.documentElement.scrollTop) ? document.documentElement.scrollTop : document.body.scrollTop;
		x += window.event.clientX;
		y += window.event.clientY;
		
	} else {//Good Browsers
		x = evt.pageX;
		y = evt.pageY;
	}
	this.tip.style.left = (x + this.offsetX) + "px";
	this.tip.style.top = (y + this.offsetY) + "px";
}

tooltip.show = function (text) {
	if (!this.tip) return;
	this.tip.innerHTML = text;
	this.tip.style.display = "block";
}

tooltip.hide = function () {
	if (!this.tip) return;
	this.tip.innerHTML = "";
	this.tip.style.display = "none";
}

window.onload = function () {
	tooltip.init ();
}
    ]]>
    </script>
  </head>
  <body>
  <xsl:apply-templates/>
  </body>
</html>
</xsl:template>

<!-- header stuff, not needed
<xsl:template match="teiHeader">
<div class="teiHeader"><xsl:apply-templates/></div>
</xsl:template> !-->

<!-- title statement !-->
<xsl:template match="titleStmt">
<div class="titleStmt">
  <h2><span class="title"><xsl:value-of select="title"/></span>
    <xsl:if test="author">
      <xsl:text> by </xsl:text><span class="author"><xsl:value-of select="author"/></span>
    </xsl:if>
    <xsl:if test="editor">
      <xsl:text>, edited by </xsl:text>
<xsl:for-each select="editor">
        <xsl:apply-templates />
        <xsl:if test="following-sibling::editor[2]">
          <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:if test="following-sibling::editor">
          <xsl:text> and </xsl:text>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
  </h2>
  <xsl:apply-templates select="respStmt"/>
  <xsl:variable name="filename" select="/TEI/@xml:id"/>
  <xsl:choose>
    <xsl:when test="substring-after($filename,'-') = 'dn'">
      <xsl:variable name="newfilename" select="concat(substring-before($filename,'-'), '-roman')"/>
      <xsl:text>This file is in devanāgarī. View in </xsl:text><a href="{$newfilename}.html">transliteration</a><xsl:text>.</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="newfilename" select="concat(substring-before($filename,'-'), '-dn')"/>
      <xsl:text>This file is in transliteration. View in </xsl:text><a href="{$newfilename}.html">devanāgarī</a><xsl:text>.</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</div>
</xsl:template>

<xsl:template match="//titleStmt/respStmt">
  <p><xsl:value-of select="resp"/>: <xsl:value-of select="name"/></p>
</xsl:template>

<!-- publication statement !-->
<xsl:template match="//publicationStmt">
<div class="publicationStmt">
  <h3><xsl:text>Publication statement</xsl:text></h3>
</div>
</xsl:template>

<!-- source description !-->
<xsl:template match="//sourceDesc">
<div class="sourceDesc">
  <h3><xsl:text>Source description</xsl:text></h3>
  <p><xsl:text>Print sources:</xsl:text></p>
  <ul>
  <xsl:for-each select="bibl">
    <li><xsl:apply-templates select="."/></li>
  </xsl:for-each>
  </ul>
  <xsl:apply-templates select="listWit"/>
</div>
</xsl:template>

<!-- bibliographic style processing !-->

<xsl:template match="sourceDesc/bibl">
  <xsl:choose> <!-- if the text has an editor, put that first !-->
    <xsl:when test="editor">
      <xsl:for-each select="editor">
        <xsl:apply-templates />
        <xsl:if test="following-sibling::editor[2]">
          <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:if test="following-sibling::editor">
          <xsl:text> and </xsl:text>
        </xsl:if>
        <xsl:if test="not(following-sibling::editor)">
          <xsl:choose>
            <xsl:when test="preceding-sibling::editor | following-sibling::editor">
              <xsl:text> (eds.). </xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text> (ed.). </xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise> <!-- otherwise, put in the author information !-->
      <xsl:for-each select="author">
        <xsl:apply-templates />
        <xsl:if test="following-sibling::author[2]">
          <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:if test="following-sibling::author">
          <xsl:text> and </xsl:text>
        </xsl:if>
        <xsl:text>. </xsl:text>
      </xsl:for-each>
    </xsl:otherwise>
  </xsl:choose>
  <em><xsl:choose>
    <xsl:when test="title[@type='sub']">
      <xsl:value-of select="title[@type='main']"/>
      <xsl:text>: </xsl:text><xsl:value-of select="title[@type='sub']"/>
    </xsl:when>
    <xsl:otherwise><xsl:value-of select="title"/></xsl:otherwise>
    </xsl:choose>
    </em><xsl:text>. </xsl:text> 
  <xsl:value-of select=".//pubPlace"/><xsl:text>: </xsl:text><xsl:value-of select=".//publisher"/><xsl:text>, </xsl:text><xsl:value-of select=".//date"/><xsl:text>. </xsl:text>
  <xsl:if test="series">
    <xsl:value-of select="series/title[@level='s']"/><xsl:text> </xsl:text><xsl:value-of select="series/biblScope"/><xsl:text>. </xsl:text>
  </xsl:if>
</xsl:template>

<!-- including mss. descriptions !-->
<xsl:template match="//sourceDesc/listWit">
<div class="//listWit">
  Manuscript sources: 
  <ul>
  <xsl:for-each select="witness">
    <li><xsl:value-of select="p"/></li>
  </xsl:for-each>
  </ul>
</div>
</xsl:template>

<!-- encoding description !-->
<xsl:template match="//encodingDesc">
<div class="encodingDesc">
  <h3><xsl:text>Encoding description</xsl:text></h3>
  <xsl:apply-templates/>
</div>
</xsl:template>

<!-- revision description !-->
<xsl:template match="//revisionDesc">
<div class="revisionDesc">
  <h3><xsl:text>Revision description</xsl:text></h3>
</div>
</xsl:template>

<!-- front matter ? !-->
<xsl:template match="//text/front"/>

<!-- let's have a table of contents too !-->
<xsl:template match="//text/body"> 
  <h2><xsl:text>Table of contents</xsl:text></h2>
  <div class="toc">
  <xsl:for-each select="./div1 | ./div">
    <p class="div1head"><a href="#{head}">
      <xsl:if test="@n">
        <xsl:value-of select="@n"/><xsl:text>: </xsl:text>
      </xsl:if>
    <xsl:value-of select="head"/></a></p>
    <xsl:for-each select="./div2 | ./div">
      <p class="div2head"><a href="#{head}">
        <xsl:if test="../@n">
          <xsl:value-of select="../@n"/>
          <xsl:if test="@n"><xsl:text>.</xsl:text><xsl:value-of select="@n"/></xsl:if>
          <xsl:text>: </xsl:text>
        </xsl:if><xsl:value-of select="head"/></a></p>
      <xsl:for-each select="./div3 | ./div">
        <p class="div3head"><a href="#{head}">
        <xsl:if test="../../@n">
          <xsl:value-of select="../../@n"/>
          <xsl:if test="../@n">
            <xsl:text>.</xsl:text><xsl:value-of select="../@n"/>
            <xsl:if test="@n"><xsl:text>.</xsl:text><xsl:value-of select="@n"/></xsl:if>
          </xsl:if><xsl:text>: </xsl:text>
        </xsl:if><xsl:value-of select="head"/></a></p>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:for-each>
  </div>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="head"/>

<xsl:template match="div1">
<div class="div1">
<h3><a name="{head}"><xsl:value-of select="head"/></a></h3>
<xsl:apply-templates/>
</div>
</xsl:template>

<xsl:template match="div2">
<div class="div2">
<h4><a name="{head}"><xsl:value-of select="head"/></a></h4>
<xsl:apply-templates/>
</div>
</xsl:template>

<xsl:template match="div3">
<div class="div3">
<h5><a name="{head}"><xsl:value-of select="head"/></a></h5>
<xsl:apply-templates/>
</div>
</xsl:template>

<xsl:template match="body/p[@xml:id] | body/lg[@xml:id] | body/div[@xml:id]">
<a name="{@xml:id}"/>
<xsl:apply-templates/>
</xsl:template>

<!-- for verse !-->
<xsl:template match="lg">
  <xsl:variable name="type">
    <xsl:value-of select="@type"/>
  </xsl:variable>
  <div class="lg" type="{$type}">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<!-- style lines depending on metrical form !-->
<!-- not presently doing anything with this, since CSS will work !-->
<xsl:template match="l">
  <xsl:if test="position()!=last()">
    <span class="line"><xsl:apply-templates/></span>
  </xsl:if>
  <xsl:if test="position()=last()">
    <span class="line"><xsl:apply-templates/></span>
  </xsl:if>
</xsl:template>
<xsl:template match="l/seg[@type='pada']">
  <xsl:variable name="letter" select="substring(@xml:id,string-length(@xml:id))"/>
  <span class="{$letter}"><xsl:apply-templates/></span>
</xsl:template>
<xsl:template match="l/seg">
  <xsl:variable name="letter">
    <xsl:choose>
      <xsl:when test="../following-sibling::l">
        <xsl:choose>
          <xsl:when test="./following-sibling::seg">a</xsl:when>
          <xsl:otherwise>b</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="./following-sibling::seg">c</xsl:when>
          <xsl:otherwise>d</xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <span class="{$letter}"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="p">
  <p><xsl:apply-templates/></p>
</xsl:template>

<!-- inserts page information etc !-->
<xsl:template match="pb">
  <span class="pageinfo"><xsl:text>[page </xsl:text><xsl:value-of select="@n"/><xsl:text>]</xsl:text></span>
</xsl:template>

<xsl:template match="milestone[@unit='metricalgroup']">
  <div class="metricalgroup"><xsl:text>***</xsl:text></div>
</xsl:template>

<!-- italicize foreign-language inline text !-->
<xsl:template match="foreign">
<span class="foreign"><xsl:apply-templates /></span>
</xsl:template>
<!-- for lemmas in commentaries, etc !-->
<xsl:template match="mentioned">
<span class="mentioned"><xsl:apply-templates/></span>
</xsl:template>

<!-- for pratīkas in the text, try to have them link to the base text !-->
<xsl:template match="ref[@type='pratīka']">
  <xsl:variable name="xmlid" select="@cRef"/>
  <!-- let's have links be specified explicitly, instead of putting comm in the filename !-->
  <!-- <xsl:variable name="filename" select="/TEI/@xml:id"/> !-->
  <!-- <xsl:variable name="linkedfile" select="concat(substring-before($filename,'comm'),'text-',substring-after($filename,'-'),'.html')"/> !-->
  <xsl:variable name="linkedfile" select="concat(/TEI/@corresp,'.html')"/>
  <span class="mentioned"><a href="{$linkedfile}#{$xmlid}" target="_blank"><xsl:apply-templates/></a></span>
</xsl:template>

<!-- for titles and names, bold face !-->
<xsl:template match="title | text//name">
  <span class="mentioned"><xsl:apply-templates/></span>
</xsl:template>

<!-- bold labels !-->
<xsl:template match="label">
<span class="label"><xsl:apply-templates /></span>
</xsl:template>

<xsl:template match="emph">
<em><xsl:apply-templates /></em>
</xsl:template>

<!-- format lists !-->
<xsl:template match="list">
  <xsl:choose>
  <xsl:when test="label">
    <ul class="labelled"><xsl:apply-templates/></ul>
  </xsl:when>
  <xsl:otherwise>
    <xsl:choose>
      <xsl:when test="@type='ordered'">
        <ol><xsl:apply-templates/></ol>
      </xsl:when>
      <xsl:otherwise>
        <ul><xsl:apply-templates/></ul>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>
<xsl:template match="item">
<li>
  <xsl:if test="../label">
    <span class="label"><xsl:value-of select="preceding-sibling::label[1]"/></span><xsl:text> </xsl:text>
  </xsl:if>
  <xsl:apply-templates/></li>
</xsl:template>
<xsl:template match="list/label"/>

<!-- format tables !-->
<xsl:template match="table">
<table><xsl:apply-templates/></table>
</xsl:template>
<xsl:template match="row">
<tr><xsl:apply-templates/></tr>
</xsl:template>
<xsl:template match="cell">
<td><xsl:apply-templates/></td>
</xsl:template>

<!-- apparatus:location-referenced (no lemmas) !-->
<xsl:template match="app">
  <xsl:variable name="appnum">
    <xsl:number level="any" from="lg | p | div" />
  </xsl:variable>
  <xsl:variable name="apparatus">
      <xsl:for-each select=".//rdg">
        <xsl:if test="@type='gloss'">
          <xsl:text> = </xsl:text>
        </xsl:if>
        <span class="foreign"><xsl:apply-templates /></span>
        <xsl:if test="note">
          <span class="appnote"><xsl:value-of select="./note"/></span>
        </xsl:if>
        <xsl:if test="@wit">
          <xsl:text> &lt;b&gt;</xsl:text><xsl:value-of select="translate(translate(@wit,' ',''),'#','')"/><xsl:text>&lt;/b&gt;</xsl:text>
        </xsl:if>
        <xsl:if test="@type='conj'">
          <xsl:text> conj. </xsl:text><xsl:value-of select="translate(translate(@resp,' ',''),'#','')"/>
        </xsl:if>
      <xsl:if test="position()!=last()">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>
  <a href="" class="app" title="{$apparatus}">
    <span class="appnum"><sup><xsl:copy-of select="$appnum"/></sup></span>
  </a> 
</xsl:template>

<xsl:template match="q">
  <xsl:choose>
    <xsl:when test="ancestor::app | ancestor::note[@place='app']">
      <xsl:text>&lt;b&gt;</xsl:text><xsl:apply-templates/><xsl:text>&lt;/b&gt;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <b><xsl:apply-templates/></b>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="note[@place='app']">
  <xsl:variable name="apparatus">
    <xsl:apply-templates/>
  </xsl:variable>
  <a href="" class="app" title="{$apparatus}">
    <xsl:text>*</xsl:text>
  </a>
</xsl:template>

<!-- some magic for app notes !-->
<xsl:template match="rdg/note"/>

</xsl:stylesheet>
