<#outputformat "plainText">
    <#assign requiredActionsText><#if requiredActions??><#list requiredActions><#items as reqActionItem>${msg("requiredAction.${reqActionItem}")}<#sep>, </#sep></#items></#list></#if></#assign>
</#outputformat>

<#import "template.ftl" as layout>
<@layout.emailLayout>

    <#if requiredActionsText == "Passwort aktualisieren">
        <p>Für Sie wurde ein Benutzerkonto im Enrichment-Programm angelegt.</p>
        <p>Ihr Nutzername lautet: <b>${user.getUsername()}</b></p>
        <p>Klicken Sie auf den unten stehenden Link, um das Passwort für Ihr Benutzerkonto zu setzen.</p>
        <a href="${link}">Link zum Setzen des Passworts</a>
        <p>Der Link ist für ${linkExpirationFormatter(linkExpiration)} gültig.</p>
        <p>Sollten Sie sich dieser Aufforderung nicht bewusst sein, ignorieren Sie diese Nachricht und Ihr Account
            bleibt unverändert.</p>
    <#else>
        ${kcSanitize(msg("executeActionsBodyHtml",link, linkExpiration, realmName, requiredActionsText, linkExpirationFormatter(linkExpiration)))?no_esc}
    </#if>

</@layout.emailLayout>
