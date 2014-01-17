<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/xpath-functions">
   <xsl:output method="html" encoding="utf-8" version="4.0" doctype-system="http://www.w3.org/TR/html4/strict.dtd"
      doctype-public="-//W3C//DTD HTML 4.01//EN"></xsl:output>

<xsl:template match="/">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
  <head>
    <meta http-equiv="Content-type" content="text/html;charset=UTF-8" />
    <link rel="stylesheet" type="text/css" href="../cssstylesheet.css" />
    <link rel="stylesheet" type="text/css" href="jquery-ui-1.10.3.custom.css" />
    <title><xsl:value-of select="//titleStmt/title"/></title>
  </head>
  <body>
  <div id="container" class="hyphenate">
  <xsl:apply-templates select="//titleStmt" mode="header"/>
  <xsl:apply-templates/>
  </div>
  <xsl:apply-templates select="//titleStmt" mode="footer"/>
  <script type="text/javascript" src="jquery-2.0.3.min.js"></script>
  <script type="text/javascript" src="jquery-ui-1.10.3.custom.js"></script>
  <script>
    $(function(){
        $('.app').hover(function(){
          var b = $(this).find('div').html();
          if(b){
            $('<p class="tooltip"></p>').html(b).appendTo('body').fadeIn('slow');
          }
        }, function() {
          $('.tooltip').remove();
        }).mousemove(function(e) {
          var mousex = e.pageX + 20; //Get X coordinates
          var mousey = e.pageY + 10; //Get Y coordinates
          $('.tooltip')
          .css({ top: mousey, left: mousex })
        });
    });
  </script>
  </body>
</html>
</xsl:template>

<xsl:template match="teiHeader">
  <div class="teiHeader">
    <h2><xsl:text>TEI Header</xsl:text></h2>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="titleStmt"/>
<xsl:template match="titleStmt" mode="header">
  <!-- if it is a text with a commentary, both get printed !-->
  <xsl:choose>
    <xsl:when test="title[@type='commentary']">
      <h2><span class="title"><xsl:value-of select="title[not(@type='commentary')]"/></span>
        <xsl:if test="author[not(@type='commentary')]">
          <xsl:text> of </xsl:text><span class="author"><xsl:value-of select="author[not(@role='commentary')]"/></span>
        </xsl:if>
      </h2>
      <h3><span class="title"><xsl:value-of select="title[@type='commentary']"/></span>
        <xsl:if test="author[@type='commentary']">
          <xsl:text> of </xsl:text><span class="author"><xsl:value-of select="author[@role='commentary']"/></span>
        </xsl:if>
      </h3>
    </xsl:when>
    <!-- otherwise, just the main title !-->
    <xsl:otherwise>
      <h2><span class="title"><xsl:value-of select="title"/>
        <xsl:if test="author">
          <xsl:text> of </xsl:text><span class="author"><xsl:value-of select="author"/></span>
        </xsl:if>
      </span></h2>
    </xsl:otherwise>
  </xsl:choose>
  <!-- print an editor (just one entry) !-->
    <xsl:if test="editor">
      <p><xsl:text>edited by </xsl:text>
      <xsl:for-each select="editor">
        <xsl:apply-templates />
        <xsl:if test="following-sibling::editor[2]">
          <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:if test="following-sibling::editor">
          <xsl:text> and </xsl:text>
        </xsl:if>
      </xsl:for-each></p>
    </xsl:if>
  <xsl:variable name="filename" select="/TEI/@xml:id"/>
  <xsl:variable name="newfilename">
    <xsl:call-template name="substring-before-last">
      <xsl:with-param name="list" select="normalize-space($filename)"/>
      <xsl:with-param name="delimiter" select="'-'"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="contains(substring-after($filename,'-'),'dn')">
      <xsl:variable name="newfilename2" select="concat($newfilename,'-roman')"/>
      <p id="switcher"><xsl:text>This file is in devanāgarī. View in </xsl:text><a href="{$newfilename2}.html">transliteration</a><xsl:text>.</xsl:text></p>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="newfilename2" select="concat($newfilename,'-dn')"/>
      <p id="switcher"><xsl:text>This file is in transliteration. View in </xsl:text><a href="{$newfilename2}.html">devanāgarī</a><xsl:text>.</xsl:text></p>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="titleStmt" mode="footer">
  <div class="respStmt">
    <h3>Acknowledgments</h3>
    <xsl:for-each select="respStmt">
      <span class="resp"><xsl:value-of select="resp"/><xsl:text> </xsl:text><xsl:value-of select="name"/></span>
      <xsl:choose>
        <xsl:when test="following-sibling::respStmt | ../principal | ../funder">
          <xsl:text>; </xsl:text>
        </xsl:when>
        <xsl:otherwise><xsl:text>.</xsl:text></xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <xsl:if test="principal"><span class="resp"><xsl:text>under the direction of </xsl:text><xsl:value-of select="principal"/></span></xsl:if>
    <xsl:if test="funder"><span class="resp"><xsl:text> with funding from </xsl:text><xsl:value-of select="funder"/></span></xsl:if>
  </div>
</xsl:template>

<!-- publication statement !-->
<xsl:template match="//publicationStmt">
  <div class="headerSection">
    <input id="publication" name="publication" type="checkbox"/>
    <label for="publication">Publication statement</label>
    <article class="ac-large">
      <p><b><xsl:value-of select="idno"/></b><xsl:text>: </xsl:text><xsl:value-of select="authority"/></p>
      <xsl:apply-templates/>
    </article>
  </div>
</xsl:template>
<xsl:template match="publicationStmt/idno"/>
<xsl:template match="publicationStmt/authority"/>

<!-- source description (omitted for now) !-->
<xsl:template match="//sourceDesc">
  <div class="headerSection">
    <input id="source" name="sourc" type="checkbox"/>
    <label for="source">Source description</label>
    <article class="ac-small">
      <xsl:apply-templates/>
    </article>
  </div>
</xsl:template>

<xsl:template match="listBibl">
  <ul>
  <xsl:for-each select="bibl">
    <li><xsl:apply-templates select="."/></li>
  </xsl:for-each>
  </ul>
</xsl:template>

<xsl:template match="bibl">
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

<xsl:template match="bibl//persName">
  <xsl:choose>
    <xsl:when test="position() = 1">
      <xsl:value-of select="surname"/><xsl:text>, </xsl:text>
      <xsl:for-each select="forename">
        <xsl:value-of select="."/>
        <xsl:if test="following-sibling::forename"><xsl:text> </xsl:text></xsl:if>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
      <xsl:for-each select="forename">
        <xsl:value-of select="."/>
        <xsl:if test="following-sibling::forename"><xsl:text> </xsl:text></xsl:if>
      </xsl:for-each>
      <xsl:value-of select="surname"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
<!-- including mss. descriptions !-->

<xsl:template match="//sourceDesc/listWit">
<div class="//listWit">
  <p>Manuscript sources:</p>
  <xsl:apply-templates select="p"/>
  <ul>
  <xsl:for-each select="witness">
    <li><xsl:value-of select="p"/></li>
  </xsl:for-each>
  </ul>
</div>
</xsl:template>

<!-- encoding description !-->
<xsl:template match="//encodingDesc">
  <div class="headerSection">
    <input id="encoding" name="encoding" type="checkbox"/>
    <label for="encoding">Encoding description</label>
    <article class="ac-large">
      <xsl:apply-templates/>
    </article>
  </div>
</xsl:template>

<!-- revision description !-->
<xsl:template match="//revisionDesc">
  <div class="headerSection">
    <input id="revision" name="revision" type="checkbox"/>
    <label for="revision">Revision description</label>
    <article class="ac-small">
      <ul>
      <xsl:for-each select="change">
        <li><xsl:text>[</xsl:text><xsl:value-of select="@when"/><xsl:text>, </xsl:text><xsl:value-of select="@who"/><xsl:text>]: </xsl:text><xsl:apply-templates select="."/></li>
      </xsl:for-each>
      </ul>
    </article>
  </div>
</xsl:template>

<!-- front matter ? !-->
<xsl:template match="//text/front"/>

<!-- let's have a table of contents too !-->
<xsl:template match="//text/body"> 
  <a class="linebefore" name="body"/>
  <h2><xsl:text>Text</xsl:text></h2>
  <div class="toc">
  <h2><xsl:text>Table of Contents</xsl:text></h2>
  <xsl:for-each select="./div"> <!-- first-level: for paricchedas, prakāśas, adhyāyas, etc. !-->
    <p class="divhead"><a href="#{@xml:id}">
    <xsl:value-of select="head[@type='toc']"/></a></p>
    <xsl:for-each select="./div[@type='structural']"> <!-- second-level !-->
      <p class="div2head"><a href="#{@xml:id}">
        <xsl:if test="@n"><xsl:value-of select="@n"/>
          <xsl:text>: </xsl:text>
        </xsl:if><xsl:value-of select="head[@type='toc']"/></a></p>
      <xsl:for-each select="./div[@type='structural']"> <!-- third-level !-->
        <p class="div3head"><a href="#{@xml:id}">
          <xsl:if test="../@n">
            <xsl:value-of select="../@n"/>
            <xsl:if test="@n"><xsl:text>.</xsl:text><xsl:value-of select="@n"/></xsl:if>
          </xsl:if><xsl:text>: </xsl:text><xsl:value-of select="head[@type='toc']"/></a></p>
        <xsl:for-each select="./div[@type='structural']"> <!-- fourth level !-->
          <p class="div4head"><a href="#{@xml:id}">
            <xsl:if test="../../@n">
              <xsl:value-of select="../../@n"/>
              <xsl:if test="../@n"><xsl:text>.</xsl:text><xsl:value-of select="../@n"/>
                <xsl:if test="@n"><xsl:text>.</xsl:text><xsl:value-of select="@n"/></xsl:if>
              </xsl:if>
            </xsl:if><xsl:text>: </xsl:text><xsl:value-of select="head[@type='toc']"/></a></p>
          <xsl:for-each select="./div[@type='structural']"> <!-- fifth level !-->
            <p class="div5head"><a href="#{@xml:id}">
              <xsl:if test="../../../@n">
                <xsl:value-of select="../../../@n"/>
                <xsl:if test="../../@n"><xsl:text>.</xsl:text><xsl:value-of select="../../@n"/>
                  <xsl:if test="../@n"><xsl:text>.</xsl:text><xsl:value-of select="../@n"/>
                    <xsl:if test="@n"><xsl:text>.</xsl:text><xsl:value-of select="@n"/></xsl:if>
                  </xsl:if>
                </xsl:if>
              </xsl:if><xsl:text>: </xsl:text><xsl:value-of select="head[@type='toc']"/></a></p>
            <xsl:for-each select="./div[@type='structural']"> <!-- sixth level !-->
              <p class="div6head"><a href="#{@xml:id}">
                <xsl:if test="../../../../@n">
                  <xsl:value-of select="../../../../@n"/>
                  <xsl:if test="../../../@n"><xsl:text>.</xsl:text><xsl:value-of select="../../../@n"/>
                    <xsl:if test="../../@n"><xsl:text>.</xsl:text><xsl:value-of select="../../@n"/>
                      <xsl:if test="../@n"><xsl:text>.</xsl:text><xsl:value-of select="../@n"/>
                        <xsl:if test="@n"><xsl:text>.</xsl:text><xsl:value-of select="@n"/></xsl:if>
                      </xsl:if>
                    </xsl:if>
                  </xsl:if>
                </xsl:if><xsl:text>: </xsl:text><xsl:value-of select="head[@type='toc']"/></a></p>
              <xsl:for-each select="./div[@type='structural']"> <!-- seventh level !-->
                <p class="div7head"><a href="#{@xml:id}">
                  <xsl:if test="../../../../../@n">
                    <xsl:value-of select="../../../../../@n"/>
                    <xsl:if test="../../../../@n"><xsl:text>.</xsl:text><xsl:value-of select="../../../../@n"/>
                      <xsl:if test="../../../@n"><xsl:text>.</xsl:text><xsl:value-of select="../../../@n"/>
                        <xsl:if test="../../@n"><xsl:text>.</xsl:text><xsl:value-of select="../../@n"/>
                          <xsl:if test="../@n"><xsl:text>.</xsl:text><xsl:value-of select="../@n"/>
                            <xsl:if test="@n"><xsl:text>.</xsl:text><xsl:value-of select="@n"/></xsl:if>
                          </xsl:if>
                        </xsl:if>
                      </xsl:if>
                    </xsl:if>
                  </xsl:if><xsl:text>: </xsl:text><xsl:value-of select="head[@type='toc']"/></a></p>
              </xsl:for-each>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:for-each>
  </div>
  <a class="linebefore" name="body"/>
  <xsl:apply-templates/>
  <!-- for notes to headers and trailers !-->
  <a class="linebefore" name="body"/>
  <div type="notes">
    <a id="Notes"/>
    <h3><xsl:text>Notes</xsl:text></h3>
    <xsl:for-each select="//text//note">
      <xsl:variable name="notenumberAll">
        <xsl:number count="note" level="any" from="//text"/>
      </xsl:variable>
      <xsl:variable name="notelabel" select="concat('n',$notenumberAll)"/>
      <xsl:variable name="notereference" select="concat('N',$notenumberAll)"/>
      <p>
        <a id="{$notelabel}" href="#{$notereference}"><sup><xsl:value-of select="$notenumberAll"/></sup></a>
        <xsl:apply-templates select="." mode="footnote"/>
      </p>
    </xsl:for-each>
  </div>
</xsl:template>
<!-- BODY !--> 

<xsl:template match="head[@type='toc']"/>

<xsl:template match="div[@type='pariccheda']">
  <a class="linebefore" name="body"/>
  <div class="pariccheda" id="{@xml:id}">
    <xsl:apply-templates/>
    <div class="nav"><a href="#">top of page</a><xsl:text> — </xsl:text><a href="#{@xml:id}">top of pariccheda</a></div>
  </div>
</xsl:template>

<xsl:template match="head">
<span class="head"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="trailer">
<span class="trailer"><xsl:apply-templates/></span>
</xsl:template>

<!-- for verse !--> 
<xsl:template match="lg">
  <xsl:if test="@xml:id">
    <a name="{@xml:id}"/>
  </xsl:if>
  <xsl:choose>
    <xsl:when test="@type='mūla'">
      <div class="mula">
      <xsl:apply-templates/>
      </div>
    </xsl:when>
    <xsl:otherwise>
      <div class="lg">
      <xsl:apply-templates/>
      </div>
    </xsl:otherwise>
  </xsl:choose>
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
  <xsl:if test="@xml:id">
    <a name="{@xml:id}"/>
  </xsl:if>
  <p><xsl:apply-templates/></p>
</xsl:template>

<!-- inserts page information etc !-->
<xsl:template match="pb">
  <span class="pageinfo"><xsl:text>[</xsl:text><xsl:value-of select="@n"/><xsl:text>]</xsl:text></span>
</xsl:template>

<!-- italicize foreign-language inline text !-->
<xsl:template match="foreign">
<span class="foreign"><xsl:apply-templates /></span>
</xsl:template>

<!-- REFERENCES !-->

<xsl:template match="ref[@cRef]">
  <xsl:variable name="xmlid" select="@cRef"/>
  <span class="citation"><a href="#{$xmlid}"><xsl:apply-templates/></a></span>
</xsl:template>

<xsl:template match="ref[@target]">
  <xsl:variable name="xmlid" select="@target"/>
  <a href="{$xmlid}"><xsl:apply-templates/></a>
</xsl:template>

<!-- for titles and names, bold face !-->
<xsl:template match="title | text//name | persName">
  <span class="mentioned"><xsl:apply-templates/></span>
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

<!-- There is no apparatus in this text. Everything is
  put in footnotes. Hence I have taken the apparatus section out. !-->

<!-- Labels for verses? !-->
<xsl:template match="label">
<span class="label"><xsl:apply-templates /></span>
</xsl:template>

<!-- <q> element: not doing anything with this now !-->

<!-- Notes to the text !-->
<xsl:template match="note" mode="footnote">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="hi[@rend='bold']">
  <b><xsl:apply-templates/></b>
</xsl:template>

<xsl:template match="text//note">
  <xsl:variable name="notenumberAll">
    <xsl:number count="note" level="any" from="//text"/>
  </xsl:variable>
  <xsl:variable name="notelabel" select="concat('n',$notenumberAll)"/>
  <xsl:variable name="notereference" select="concat('N',$notenumberAll)"/>
  <a id="{$notereference}" href="#{$notelabel}"><sup><xsl:value-of select="$notenumberAll"/></sup></a>
</xsl:template>

<xsl:template name="substring-before-last">
<!--passed template parameter -->
  <xsl:param name="list"/>
  <xsl:param name="delimiter"/>
  <xsl:choose>
    <xsl:when test="contains($list, $delimiter)">
    <!-- get everything in front of the first delimiter -->
      <xsl:value-of select="substring-before($list,$delimiter)"/>
      <xsl:choose>
        <xsl:when test="contains(substring-after($list,$delimiter),$delimiter)">
          <xsl:value-of select="$delimiter"/>
        </xsl:when>
      </xsl:choose>
      <xsl:call-template name="substring-before-last">
      <!-- store anything left in another variable -->
        <xsl:with-param name="list" select="substring-after($list,$delimiter)"/>
        <xsl:with-param name="delimiter" select="$delimiter"/>
      </xsl:call-template>
    </xsl:when>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
