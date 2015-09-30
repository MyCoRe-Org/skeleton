<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xalan"
  xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation" xmlns:acl="xalan://org.mycore.access.MCRAccessManager"
  xmlns:mcr="http://www.mycore.org/" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mods="http://www.loc.gov/mods/v3"
  xmlns:encoder="xalan://java.net.URLEncoder" xmlns:mcrxsl="xalan://org.mycore.common.xml.MCRXMLFunctions" xmlns:mcrurn="xalan://org.mycore.urn.MCRXMLFunctions"
  exclude-result-prefixes="xalan xlink mcr i18n acl mods mcrxsl mcrurn encoder" version="1.0">
  <xsl:param name="MCR.Users.Superuser.UserName" />

  <xsl:template match="/mycoreobject[contains(@ID,'_simpledoc_')]">
    <div class="row">

      <xsl:call-template name="objectActions">
        <xsl:with-param name="id" select="@ID" />
      </xsl:call-template>

      <h1>
        <xsl:value-of select="metadata/def.title/title" />
      </h1>

      <table class="table">
        <tr>
          <th>
            <xsl:value-of select="i18n:translate('docdetails.ID')" />
          </th>
          <td>
            <xsl:call-template name="objectLink">
              <xsl:with-param select="." name="mcrobj" />
            </xsl:call-template>
          </td>
        </tr>

        <xsl:if test="metadata/def.creator/creator">
          <tr>
            <th>
              <xsl:value-of select="i18n:translate('editor.label.author')" />
            </th>
            <td>
              <xsl:for-each select="metadata/def.creator/creator">
                <xsl:value-of select="." />
                <br />
              </xsl:for-each>
            </td>
          </tr>
        </xsl:if>

        <xsl:if test="metadata/def.date/date">
          <tr>
            <th>
              <xsl:value-of select="i18n:translate('editor.label.date')" />
            </th>
            <td>
              <xsl:value-of select="metadata/def.date/date" />
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="metadata/def.language/language">
          <tr>
            <th>
              <xsl:value-of select="i18n:translate('editor.label.language')" />
            </th>
            <td>
              <xsl:for-each select="metadata/def.language/language">
                <xsl:variable name="classlink">
                  <xsl:call-template name="ClassCategLink">
                    <xsl:with-param name="classid">
                      <xsl:value-of select="./@classid" />
                    </xsl:with-param>
                    <xsl:with-param name="categid">
                      <xsl:value-of select="./@categid" />
                    </xsl:with-param>
                  </xsl:call-template>
                </xsl:variable>
                <xsl:for-each select="document($classlink)/mycoreclass/categories/category">
                  <xsl:variable name="selectLang">
                    <xsl:call-template name="selectLang">
                      <xsl:with-param name="nodes" select="./label" />
                    </xsl:call-template>
                  </xsl:variable>
                  <xsl:for-each select="./label[lang($selectLang)]">
                    <xsl:value-of select="@text" />
                  </xsl:for-each>
                </xsl:for-each>
              </xsl:for-each>
            </td>
          </tr>
        </xsl:if>


      </table>

    </div>
  </xsl:template>


  <xsl:template name="objectActions">
    <xsl:param name="id" select="./@ID" />
    <xsl:param name="accessedit" select="acl:checkPermission($id,'writedb')" />
    <xsl:param name="accessdelete" select="acl:checkPermission($id,'deletedb')" />

    <xsl:if test="$accessedit or $accessdelete">
      <div class="dropdown pull-right">
        <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-expanded="true">
          <span class="glyphicon glyphicon-cog" aria-hidden="true"></span> Aktionen
          <span class="caret"></span>
        </button>
        <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
          <li role="presentation">
            <a role="menuitem" tabindex="-1" href="{$WebApplicationBaseURL}content/publish/simpledoc.xed?id={$id}">
              <xsl:value-of select="i18n:translate('object.editObject')" />
            </a>
          </li>
          <li role="presentation">
            <a href="{$ServletsBaseURL}derivate/create{$HttpSession}?id={$id}" role="menuitem" tabindex="-1">
              <xsl:value-of select="i18n:translate('derivate.addDerivate')" />
            </a>
          </li>
          <xsl:if test="$accessdelete">
            <li role="presentation">
              <a href="{$ServletsBaseURL}object/delete{$HttpSession}?id={$id}" role="menuitem" tabindex="-1">
                <xsl:value-of select="i18n:translate('object.delObject')" />
              </a>
            </li>
          </xsl:if>
        </ul>
      </div>

    </xsl:if>

  </xsl:template>

</xsl:stylesheet>
