# How to use
This is a script for packaging SSL Certificate into .pfx. You must have downloaded private key & .pem & .ca (intermediate chain) before running this script.

## Steps
1. Prepare CSR (Certificate Sign Request) and private key. You can get these from [SSL Dragon CSR Generator](https://www.ssldragon.com/ssl-tools/csr-generator).
1. Once you get CSR & private key, you must store private key as `private.key` file. (we'll use this for next step)
1. Purchase certificate and validate it. (You'll be asked providing CSR generated from previou step)
   > You can use one of following method to validate: 
   > 1. DNS Record: Add CNAME or TXT Record to DNS of root domain
   > 1. HTTP/HTTPS: Add file to server
   > 1. Email: Confirmation via email link (usually via postadmin@, admin@... mailbox)
1. Waiting for about 1hr. (Certificate in validation)
1. Download PEM & CA (intermediate chain) file to your device, and name them as {domainName}.pem & {domainName}.ca. (there should be private.key already)
1. Copy this script to the same folder where PEM & CA are.
1. Run this script.
1. Input domain name (same as files' name) & export password.
1. Done, you get {domainName}.pfx.
1. Upload .pfx