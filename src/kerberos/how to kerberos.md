create new principal:

HTTP/localhost@EXAMPLE.com

```
kadmin.local
addprinc HTTP/localhost@EXAMPLE.COM
ktadd -k /etc/krb5.keytab HTTP/localhost@EXAMPLE.COM
```

Export keytab

krb5.conf
```
[libdefaults]
    default_realm = EXAMPLE.COM
    dns_lookup_kdc = false
    dns_lookup_realm = false
    permitted_enctypes = aes256-cts-hmac-sha384-192 aes128-cts-hmac-sha256-128 aes256-cts-hmac-sha1-96 aes128-cts-hmac-sha1-96 camellia256-cts-cmac camellia128-cts-cmac

[realms]
    EXAMPLE.COM = {
        kdc = dbildungs-iam-server-kdc-1
        admin_server = dbildungs-iam-server-kdc-1
    }

[domain_realm]
    .example.com = EXAMPLE.COM
    example.com = EXAMPLE.COM
```

copy keytab file and krb5.conf file to keycloak image to /etc

set Kerberos Provider with

![[Pasted image 20241217162644.png]]

restart keycloak

create new in Keykloak
create Userprincipal in kerberos server:

```
kadmin.local
addprinc username@EXAMPLE.com
```

Login to Client with activated Kerberos flow

Create Kerberos Token in keycloak with:

kinit <username>