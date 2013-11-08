<xsl:transform version ="1.0" xmlns:xsl ="http://www.w3.org/1999/XSL/Transform" >

<!-- Identity Transform !-->
<xsl:template match="node() | @*" >
<xsl:copy>
  <xsl:apply-templates select="@*|node()" />
</xsl:copy>
</xsl:template>

<xsl:template match="TEI/div"/>

</xsl:transform>
