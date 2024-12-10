<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>
    <#if section = "header">
        ${kcSanitize(msg("errorTitle"))?no_esc}
    <#elseif section = "form">
        <div id="kc-error-message">
            <p class="instruction">${kcSanitize(msg("loginError"))?no_esc}</p>
            <form id="kc-form-logout" 
                <#if client?? && client.baseUrl?has_content>
                    action="${client.baseUrl?ensure_ends_with("/")}api/auth/logout"
                <#else>
                    action="/realms/${realm.name}/protocol/openid-connect/logout"
                </#if>
                >
                <div id="kc-form-buttons" class="${properties.kcFormGroupClass!}">
                    <input tabindex="1" class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}" name="logout" id="kc-logout" data-testid="logout-button" type="submit" value="${msg("tryAgain")}"/>
                </div>
            </form>
        </div>
    </#if>
</@layout.registrationLayout>