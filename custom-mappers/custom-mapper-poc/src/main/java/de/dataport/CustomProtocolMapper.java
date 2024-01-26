package de.dataport;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.json.JSONArray;
import org.json.JSONObject;
import org.keycloak.models.ClientSessionContext;
import org.keycloak.models.KeycloakSession;
import org.keycloak.models.ProtocolMapperModel;
import org.keycloak.models.UserSessionModel;
import org.keycloak.protocol.oidc.mappers.*;
import org.keycloak.provider.ProviderConfigProperty;
import org.keycloak.representations.IDToken;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.ArrayList;
import java.util.List;

public class CustomProtocolMapper extends AbstractOIDCProtocolMapper implements OIDCAccessTokenMapper,
        OIDCIDTokenMapper, UserInfoTokenMapper {

    public static final String PROVIDER_ID = "custom-erwin-protocol-mapper";

    private static final List<ProviderConfigProperty> configProperties = new ArrayList<>();

    static {
        OIDCAttributeMapperHelper.addTokenClaimNameConfig(configProperties);
        OIDCAttributeMapperHelper.addIncludeInTokensConfig(configProperties, CustomProtocolMapper.class);
    }

    @Override
    public String getDisplayCategory() {
        return "Erwin Token Mapper POC";
    }

    @Override
    public String getDisplayType() {
        return "Custom Erwin Token Mapper";
    }

    @Override
    public String getHelpText() {
        return "Adds a custom Hello World text to the claim";
    }

    @Override
    public List<ProviderConfigProperty> getConfigProperties() {
        return configProperties;
    }

    @Override
    public String getId() {
        return PROVIDER_ID;
    }

    @Override
    protected void setClaim(IDToken token, ProtocolMapperModel mappingModel,
                            UserSessionModel userSession, KeycloakSession keycloakSession,
                            ClientSessionContext clientSessionCtx) {
        String username = userSession.getLoginUsername();
        System.out.println("username: "+username);
        HttpClient client = HttpClient.newBuilder()
                .version(HttpClient.Version.HTTP_1_1)
                .followRedirects(HttpClient.Redirect.NEVER)
                .build();

        HttpRequest req = HttpRequest.newBuilder()
                .uri(URI.create("http://dbildungs-iam-server-backend-1:9090/api/personen?referrer="+username))
                .GET()
                .build();
        JSONObject person;
        String response = null;
        try {
            response = client.send(req, HttpResponse.BodyHandlers.ofString()).body();

        } catch (IOException | InterruptedException e) {
            throw new RuntimeException(e);
        }
        System.out.println("response:"+response);
        JSONArray personArray = new JSONArray(response);
        System.out.println("array:"+personArray);
        person = personArray.getJSONObject(0).getJSONObject("person");
        System.out.println("person:"+person);
        if (person != null) OIDCAttributeMapperHelper.mapClaim(token, mappingModel, person.get("mandant"));
    }

}
