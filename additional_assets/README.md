## Additional Assets

1. [ALB Cert](###alb-cert)

----

### ALB Cert

This module uploads a certificate to CMS and uses that certificate to create an ALB Certificate for your IKS cluster. 
This asset requires an IBM Cloud Certificate Manager Instance, a Certificate, and a Certificate Private Key

![ALB Cert](../.docs/cluster_alb_cert.png)

#### Adding this file to your module

1. Create a `config` directory into your root module directory
2. Add you certificates to this directory
3. Move [alb_cert.tf](./alb_cert/alb_cert.tf) into your root module directory
4. Replace the file names in `ibm_certificate_manager_import` block in [alb_cert.tf](./alb_cert/alb_cert.tf) with your certificate file names
    - `content      = "${file("${path.module}/config/YOUR_CERT_NAME.pem")}"`
    - `priv_key     = "${file("${path.module}/config/YOUR_PRIVATE_KEY.key")}"`
4. Add the variables from [variables.tf](./alb_cert/variables.tf) into the `variables.tf` file of your root module directory