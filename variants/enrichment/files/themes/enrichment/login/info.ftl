<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>
    <#if section = "header">
        <#if messageHeader??>
            ${kcSanitize(msg("${messageHeader}"))?no_esc}
        <#else>
            ${message.summary}
        </#if>
    <#elseif section = "form">

        <#if actionUri?has_content>
            <div class="kc-info-container w-full flex justify-center" style="opacity: 0">
                <p><a href="${actionUri}">${kcSanitize(msg("proceedWithAction"))?no_esc}</a></p>
            </div>
            <script type="text/javascript">
                window.location.href = "${actionUri}";
            </script>
        <#else>
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

                        <p class="text-center mt-0 font-bold">${message.summary}</p>

                        <div id="kc-form-buttons" class="mt-12">
                            <a href="${client.baseUrl}/login" style="text-decoration: none">
                                <button class="btn btn-block">
                                    Weiter zur Anwendung
                                    <svg class="inline-block" height="20" width="20" fill="#ffffff">
                                        <use href="${url.resourcesPath}/icons/arrow-forward.svg#arrow-forward"
                                             width="20" height="20"></use>
                                    </svg>
                                </button>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </#if>
        <style>
            /*
                The container is hidden by default because the user gets redirected directly to the action page.
                In case the redirect fails, the container will be shown that the user can manually click on the link.
             */
            .kc-info-container {
                opacity: 0;
                animation: kc-info-message-animation 0.5s ease forwards;
                animation-delay: 2s;
            }

            @keyframes kc-info-message-animation {
                0% {
                    opacity: 0;
                }
                100% {
                    opacity: 1;
                }
            }
        </style>
    </#if>
</@layout.registrationLayout>
