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

                    <h2 class="text-center mt-0">Neues Passwort setzen</h2>
                    <p>Bitte vergeben Sie ein neues sicheres Passwort gemäß der Passwort-Policy.</p>

                    <div class="pl-8 text-[14px] pb-4">
                        <p class="flex items-center gap-[5px] my-0">
                            <svg class="inline-block min-w-[20px]" height="20" width="20">
                                <use href="${url.resourcesPath}/icons/check-circle.svg#check-circle"
                                     width="20" height="20"></use>
                            </svg>
                            Minimum Länge 8 Zeichen
                        </p>
                        <p class="flex items-center gap-[5px] my-0">
                            <svg class="inline-block min-w-[20px]" height="20" width="20">
                                <use href="${url.resourcesPath}/icons/check-circle.svg#check-circle"
                                     width="20" height="20"></use>
                            </svg>
                            Enthält Groß- und Kleinbuchstaben
                        </p>
                        <p class="flex items-center gap-[5px] my-0">
                            <svg class="inline-block min-w-[20px]" height="20" width="20">
                                <use href="${url.resourcesPath}/icons/check-circle.svg#check-circle"
                                     width="20" height="20"></use>
                            </svg>
                            Enthält eine Zahl
                        </p>
                        <p class="flex items-center gap-[5px] my-0">
                            <svg class="inline-block min-w-[20px]" height="20" width="20">
                                <use href="${url.resourcesPath}/icons/check-circle.svg#check-circle"
                                     width="20" height="20"></use>
                            </svg>
                            Enthält ein Sonderzeichen: !§$%&/()=?\;:,.#+*~-
                        </p>
                    </div>

                    <#if message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
                        <#if message.type = 'error'>
                            <div class="alert alert-error">
                                <svg class="inline-block min-w-[20px]" height="20" width="20" fill="#ffffff">
                                    <use href="${url.resourcesPath}/icons/alert-circle.svg#alert-circle"
                                         width="20" height="20"></use>
                                </svg>
                                <div>
                                    <div>${kcSanitize(message.summary)?no_esc}</div>
                                </div>
                            </div>
                        </#if>
                    </#if>

                    <form id="kc-passwd-update-form" class="${properties.kcFormClass!}" action="${url.loginAction}"
                          method="post" novalidate="novalidate">

                        <label class="form-control w-full max-w-xs relative">
                            <span class="label">
                                <span class="label-text">Neues Passwort eingeben</span>
                            </span>
                            <input tabindex="2" id="password-new" name="password-new"
                                   type="password" autofocus autocomplete="new-password" placeholder="Passwort"
                                   class="input input-bordered input-sm <#if messagesPerField.existsError('password')>border-primary</#if>"
                                   aria-invalid="<#if messagesPerField.existsError('password','password-confirm')>true</#if>"
                            />
                            <span class="absolute right-0 bottom-0.5">
                                <span class="cursor-pointer"
                                      aria-label="${msg("showPassword")}"
                                      aria-controls="password-new" data-password-toggle tabindex="4"
                                      data-icon-show="${properties.kcFormPasswordVisibilityIconShow!}"
                                      data-icon-hide="${properties.kcFormPasswordVisibilityIconHide!}">
                                    <svg class="inline-block mr-2" height="20" width="20">
                                        <use
                                            href="${url.resourcesPath}/icons/eye-off-outline.svg#eye-off-outline"
                                            width="20" height="20"></use>
                                    </svg>
                                </span>
                                <#if messagesPerField.existsError('password')>
                                    <svg class="inline-block fill-primary mr-2" height="20" width="20">
                                        <use
                                            href="${url.resourcesPath}/icons/alert-circle-outline.svg#alert-circle-outline"
                                            width="20" height="20"></use>
                                    </svg>
                                </#if>
                            </span>
                        </label>

                        <label class="form-control w-full max-w-xs relative">
                            <span class="label">
                                <span class="label-text">Neues Passwort wiederholen</span>
                            </span>
                            <input tabindex="2" id="password-confirm" name="password-confirm"
                                   type="password" autofocus autocomplete="new-password" placeholder="Passwort"
                                   class="input input-bordered input-sm <#if messagesPerField.existsError('password')>border-primary</#if>"
                                   aria-invalid="<#if messagesPerField.existsError('password-confirm')>true</#if>"
                            />
                            <span class="absolute right-0 bottom-0.5">
                                <span class="cursor-pointer"
                                      aria-label="${msg("showPassword")}"
                                      aria-controls="password-confirm" data-password-toggle tabindex="4"
                                      data-icon-show="${properties.kcFormPasswordVisibilityIconShow!}"
                                      data-icon-hide="${properties.kcFormPasswordVisibilityIconHide!}">
                                    <svg class="inline-block mr-2" height="20" width="20">
                                        <use
                                            href="${url.resourcesPath}/icons/eye-off-outline.svg#eye-off-outline"
                                            width="20" height="20"></use>
                                    </svg>
                                </span>
                                <#if messagesPerField.existsError('password')>
                                    <svg class="inline-block fill-primary mr-2" height="20" width="20">
                                        <use
                                            href="${url.resourcesPath}/icons/alert-circle-outline.svg#alert-circle-outline"
                                            width="20" height="20"></use>
                                    </svg>
                                </#if>
                            </span>
                        </label>

                        <div id="kc-form-buttons" class="mt-4">
                            <button type="submit" value="${msg("doSubmit")}" class="btn btn-block">
                                Passwort setzen
                                <svg class="inline-block" height="20" width="20" fill="#ffffff">
                                    <use href="${url.resourcesPath}/icons/arrow-forward.svg#arrow-forward"
                                         width="20" height="20"></use>
                                </svg>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <script type="module" src="${url.resourcesPath}/js/passwordVisibility.js"></script>
    </#if>

</@layout.registrationLayout>
