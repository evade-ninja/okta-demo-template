output "saml" {
    value = format( 
        "\nSSO URL: %s\nIssuer: %s\nCertificate:\n%s\n\n",
        okta_app_saml.superSAMLapp1.http_redirect_binding,
        okta_app_saml.superSAMLapp1.entity_url, 
        okta_app_saml.superSAMLapp1.certificate)
}