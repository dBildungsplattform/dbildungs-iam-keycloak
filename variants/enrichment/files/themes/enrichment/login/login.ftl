<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=true; section>
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

                    <h2 class="text-center mt-0">Anmeldung</h2>

                    <form id="kc-form-login" onsubmit="login.disabled = true; return true;"
                          action="${url.loginAction}" method="post">
                        <#if !usernameHidden??>
                            <div class="${properties.kcFormGroupClass!}">

                                <#if message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
                                    <div class="alert alert-${message.type}">
                                         <#if message.type = 'success'>
                                             <svg class="inline-block min-w-[20px]" height="20" width="20" fill="#ffffff">
                                                 <use href="${url.resourcesPath}/icons/check-circle.svg#check-circle"
                                                      width="20" height="20"></use>
                                             </svg>
                                         </#if>
                                        <#if message.type = 'error'>
                                            <svg class="inline-block min-w-[20px]" height="20" width="20" fill="#ffffff">
                                                <use href="${url.resourcesPath}/icons/alert-circle.svg#alert-circle"
                                                     width="20" height="20"></use>
                                            </svg>
                                        </#if>
                                        <div>
                                            <div>${kcSanitize(message.summary)?no_esc}</div>
                                        </div>
                                    </div>
                                </#if>

                                <label class="form-control w-full max-w-xs relative">
                                    <span class="label">
                                        <span class="label-text">Nutzername eingeben</span>
                                    </span>
                                    <input tabindex="2" id="username" name="username" value="${(login.username!'')}"
                                           type="text" autofocus autocomplete="username" placeholder="Nutzername"
                                           class="input input-bordered input-sm <#if messagesPerField.existsError('username','password')>border-primary</#if>"
                                           aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>"
                                    />
                                    <span class="absolute right-0 bottom-0.5">
                                        <#if messagesPerField.existsError('username','password')>
                                            <svg class="inline-block fill-primary mr-2" height="20" width="20">
                                                <use
                                                    href="${url.resourcesPath}/icons/alert-circle-outline.svg#alert-circle-outline"
                                                    width="20" height="20"></use>
                                            </svg>
                                        </#if>
                                    </span>
                                </label>

                            </div>
                        </#if>

                        <div class="mt-4">

                            <div class="${properties.kcInputGroup!}">
                                <label class="form-control w-full max-w-xs relative">
                                    <span class="label">
                                        <span class="label-text">Passwort eingeben</span>
                                    </span>
                                    <input tabindex="3" id="password" placeholder="Passwort" name="password"
                                           type="password" autocomplete="current-password"
                                           class="input input-bordered input-sm <#if messagesPerField.existsError('username','password')>border-primary</#if>"
                                           aria-invalid="<#if messagesPerField.existsError('username','password')>true</#if>"
                                    />
                                    <span class="absolute right-0 bottom-0.5 select-none">
                                        <span class="cursor-pointer"
                                              aria-label="${msg("showPassword")}"
                                              aria-controls="password" data-password-toggle tabindex="4"
                                              data-icon-show="${properties.kcFormPasswordVisibilityIconShow!}"
                                              data-icon-hide="${properties.kcFormPasswordVisibilityIconHide!}">
                                            <svg class="inline-block mr-2" height="20" width="20">
                                                <use
                                                    href="${url.resourcesPath}/icons/eye-off-outline.svg#eye-off-outline"
                                                    width="20" height="20"></use>
                                            </svg>
                                        </span>
                                        <#if messagesPerField.existsError('username','password')>
                                            <svg class="inline-block fill-primary mr-2" height="20" width="20" tabindex="4">
                                                <use
                                                    href="${url.resourcesPath}/icons/alert-circle-outline.svg#alert-circle-outline"
                                                    width="20" height="20"></use>
                                            </svg>
                                        </#if>
                                    </span>
                                </label>
                                <div class="flex justify-end mt-1">
                                    <a tabindex="5" href="${url.loginResetCredentialsUrl}" class="link link-sm">
                                        Passwort vergessen?
                                    </a>
                                </div>
                            </div>

                            <#if usernameHidden?? && messagesPerField.existsError('username','password')>
                                <span id="input-error" class="${properties.kcInputErrorMessageClass!}"
                                      aria-live="polite">
                                    ${kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc}
                                </span>
                            </#if>

                        </div>

                        <div id="kc-form-buttons" class="mt-4">
                            <input type="hidden" id="id-hidden-input" name="credentialId"
                                   <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>
                            <button tabindex="6" name="login" id="kc-login" type="submit" class="btn btn-block">
                                Anmelden
                                <svg class="inline-block" height="20" width="20" fill="#ffffff">
                                    <use href="${url.resourcesPath}/icons/arrow-forward.svg#arrow-forward"
                                         width="20" height="20"></use>
                                </svg>
                            </button>
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
