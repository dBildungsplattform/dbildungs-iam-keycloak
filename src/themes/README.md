Creating Themes
===============

Files in this directory are used to add custom themes to Keycloak. Themes are used to configure the look and feel of login pages and the account management console.

Custom themes packaged in a JAR file should be deployed to the `${kc.home.dir}/providers` directory. Those requiere a new build.

Themes within this directory do not require the `build` command to be installed. Moreover, when running in development mode, themes are not cached. Changes are applied without a need to restart the server when making changes.

                                                      https://www.keycloak.org/docs/latest/server_development/index.html#_themes
See the theme section in the [Server Developer Guide](https://www.keycloak.org/docs/latest/server_development/#_themes) for more details about how to create custom themes.
