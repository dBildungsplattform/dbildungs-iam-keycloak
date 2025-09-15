<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayRequiredFields=false>
    <!DOCTYPE html>
    <html
        class="${properties.kcHtmlClass!}"<#if realm.internationalizationEnabled> lang="${locale.currentLanguageTag}"</#if>>

    <head>
        <meta charset="utf-8">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="robots" content="noindex, nofollow">

        <#if properties.meta?has_content>
            <#list properties.meta?split(' ') as meta>
                <meta name="${meta?split('==')[0]}" content="${meta?split('==')[1]}"/>
            </#list>
        </#if>
        <title>${msg("loginTitle",(realm.displayName!''))}</title>
        <link rel="icon" href="${url.resourcesPath}/img/favicon.ico"/>
        <#if properties.stylesCommon?has_content>
            <#list properties.stylesCommon?split(' ') as style>
                <link href="${url.resourcesCommonPath}/${style}" rel="stylesheet"/>
            </#list>
        </#if>
        <#if properties.styles?has_content>
            <#list properties.styles?split(' ') as style>
                <link href="${url.resourcesPath}/${style}" rel="stylesheet"/>
            </#list>
        </#if>
        <#if properties.scripts?has_content>
            <#list properties.scripts?split(' ') as script>
                <script src="${url.resourcesPath}/${script}" type="text/javascript"></script>
            </#list>
        </#if>
        <script type="importmap">
            {
                "imports": {
                    "rfc4648": "${url.resourcesCommonPath}/node_modules/rfc4648/lib/rfc4648.js"
            }
        }
        </script>
        <script src="${url.resourcesPath}/js/menu-button-links.js" type="module"></script>
        <#if scripts??>
            <#list scripts as script>
                <script src="${script}" type="text/javascript"></script>
            </#list>
        </#if>
        <script type="module">
            import {checkCookiesAndSetTimer} from "${url.resourcesPath}/js/authChecker.js";

            checkCookiesAndSetTimer(
                "${url.ssoLoginInOtherTabsUrl?no_esc}"
            );
        </script>
    </head>

    <body class="m-0">
    <div>
        <div class="min-h-screen flex flex-col">

            <div class="sticky top-0 w-full z-50">
                <div class="flex justify-center">
                    <div class="w-full">
                        <div class="h-30 bg-secondary flex justify-center">
                            <div class="max-w-header w-full"></div>
                        </div>
                    </div>
                </div>

            </div>
            <div id="kc-content" class="flex-1 pb-4">
                <div id="kc-content-wrapper" class="h-full">

                    <#nested "form">

                    <#if auth?has_content && auth.showTryAnotherWayLink()>
                        <form id="kc-select-try-another-way-form" action="${url.loginAction}" method="post">
                            <div class="${properties.kcFormGroupClass!}">
                                <input type="hidden" name="tryAnotherWay" value="on"/>
                                <a href="#" id="try-another-way"
                                   onclick="document.forms['kc-select-try-another-way-form'].submit();return false;">${msg("doTryAnotherWay")}</a>
                            </div>
                        </form>
                    </#if>

                    <#nested "socialProviders">

                    <#if displayInfo>
                        <div id="kc-info" class="${properties.kcSignUpClass!}">
                            <div id="kc-info-wrapper" class="${properties.kcInfoAreaWrapperClass!}">
                                <#nested "info">
                            </div>
                        </div>
                    </#if>
                </div>
            </div>
            <div class="w-full">


                <div class="w-full h-[354px] md:h-[170px] bg-base-light flex justify-center items-center">
                    <div
                        class="max-w-footer w-full grid grid-cols-2 ps-2.5 md:px-[93px] footer:px-0 gap-[38px] md:gap-0">
                        <div class="col-span-2 md:col-span-1 flex flex-col justify-end gap-y-[10px] mt-4 md:mt-0">
                            <div class="flex flex-wrap gap-x-[28px] gap-y-[10px] select-none">
                                <a href="${client.baseUrl}/faq" class="cursor-pointer footer-item p-[1px]">FAQ</a>
                                <a href="${client.baseUrl}/contact" class="cursor-pointer footer-item p-[1px]">Kontakt</a>
                                <div class="cursor-pointer footer-item p-[1px]">Datenschutz</div>
                            </div>
                            <div class="flex flex-wrap gap-x-[28px] gap-y-[10px] select-none">
                                <a href="${client.baseUrl}/legal/imprint" target="_blank"
                                   class="cursor-pointer footer-item p-[1px]">
                                    Impressum
                                </a>
                                <div class="cursor-pointer footer-item p-[1px]">Barrierefreiheit</div>
                            </div>
                        </div>
                        <div
                            class="col-span-2 md:col-span-1 flex justify-center items-center md:justify-end mb-4 md:mb-0">
                            <a href="">
                                <svg height="114" width="274">
                                    <use href="${url.resourcesPath}/img/schleswig-holstein.svg#schleswig-holstein"
                                         class="text-info"
                                         height="114" width="274">
                                    </use>
                                </svg>
                            </a>
                        </div>
                    </div>
                </div>
                <div class="min-h-30 bg-secondary flex justify-center">
                    <div class="max-w-footer w-full px-3 footer:px-0 flex gap-[5px] items-center">
                        <svg class="inline-block" height="20" width="20" fill="#ffffff">
                            <use href="${url.resourcesPath}/icons/copyright.svg#copyright"
                                 width="20" height="20"></use>
                        </svg>
                        <div class="text-neutral-content font-semibold text-[14px]">
                            Ministerium für Allgemeine und Berufliche Bildung, Wissenschaft, Forschung und Kultur des Landes Schleswig-Holstein (MBWFK)
                        </div>
                    </div>
                </div>


            </div>
        </div>
    </div>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            document.getElementById("footer-year").textContent = new Date().getFullYear().toString();
        });
    </script>
    </body>
    </html>
</#macro>
