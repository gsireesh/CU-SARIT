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

