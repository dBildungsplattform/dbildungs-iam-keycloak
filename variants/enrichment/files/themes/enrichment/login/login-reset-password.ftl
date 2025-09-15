<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','password') displayInfo=realm.password && realm.registrationAllowed && !registrationDisabled??; section>
    <#if section = "header">
        ${msg("loginAccountTitle")}
    <#elseif section = "form">
        <div id="kc-form" class="flex flex-col justify-center items-center h-full px-4 md:px-0">
            <a href="${client.baseUrl}" class="cursor-pointer">
                <img
                    src="${url.resourcesPath}/img/logo.svg"
                    width="88"
                    height="82"
                    tabindex="1"
                    alt="enrichment-logo"
                    draggable="false"
                    class="h-[41px] w-[44px] mt-8">
            </a>
            <div id="kc-form-wrapper" class="w-full md:w-[500px] bg-base-light rounded-base mt-8">
                <div class="p-16">

                    <h2 class="text-center mt-0">Passwort zurücksetzen</h2>
                    <p>Um Ihr Passwort zurückzusetzen, geben Sie bitte Ihren Nutzernamen oder Ihre E-Mail-Adresse an.</p>
                    <p>Ein Link zum Zurücksetzen Ihres Passworts wird an die hinterlegte E-Mail-Adresse versendet.</p>
                    <form id="kc-reset-password-form" class="${properties.kcFormClass!}" action="${url.loginAction}"
                          method="post">

                        <label class="form-control w-full max-w-xs relative">
                                    <span class="label">
                                        <span class="label-text">Nutzername oder E-Mail eingeben</span>
                                    </span>
                            <input tabindex="2" id="username" name="username" value="${(auth.attemptedUsername!'')}"
                                   type="text" autofocus autocomplete="username" placeholder="Nutzername oder E-Mail"
                                   class="input input-bordered input-sm <#if messagesPerField.existsError('username','password')>border-primary</#if>"
                                   aria-invalid="<#if messagesPerField.existsError('username')>true</#if>"
                            />
                            <span class="absolute right-0 bottom-0.5">
                                <#if messagesPerField.existsError('username')>
                                    <svg class="inline-block fill-primary mr-2" height="20" width="20">
                                        <use
                                            href="${url.resourcesPath}/icons/alert-circle-outline.svg#alert-circle-outline"
                                            width="20" height="20"></use>
                                    </svg>
                                </#if>
                            </span>
                        </label>

                        <div class="${properties.kcFormGroupClass!} ${properties.kcFormSettingClass!}">
                            <button tabindex="6" name="login" id="kc-login" type="submit" class="btn btn-block my-4">
                                Passwort zurücksetzen
                                <svg class="inline-block" height="20" width="20" fill="#ffffff">
                                    <use href="${url.resourcesPath}/icons/arrow-forward.svg#arrow-forward"
                                         width="20" height="20"></use>
                                </svg>
                            </button>
                            <div id="kc-form-options" class="${properties.kcFormOptionsClass!} w-full flex justify-center">
                                <div class="${properties.kcFormOptionsWrapperClass!}">
                                    <span class="text-12">Kennen Sie Ihr Passwort? <a href="${url.loginUrl}">zurück zur Anmeldung</a></span>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <div class="text-center mt-2">
                <a href="${client.baseUrl}" tabindex="7" class="link cursor-pointer">zurück zur Startseite</a>
            </div>
        </div>
        <script type="module" src="${url.resourcesPath}/js/passwordVisibility.js"></script>
    </#if>

</@layout.registrationLayout>
