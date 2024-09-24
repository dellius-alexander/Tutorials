# Setup Synology MailPlus Server

---

## Synology MailPlus Server Setup Guide

To set up a Synology MailPlus Server on your Synology NAS, follow these steps:

### Step 1: Install the MailPlus Server
1. **Log in to DSM**: Access your NAS through the DSM web interface.
2. **Install MailPlus Server**:
   - Go to **Package Center**.
   - Search for **MailPlus Server**.
   - Click **Install**.

### Step 2: Configure MailPlus Server
1. **Launch MailPlus Server**: After installation, open **MailPlus Server** from the main menu.
2. **Set Up Domains**:
   - Go to **Settings** > **Domains**.
   - Click **Add** to configure your domain name. Ensure you have a registered domain and the correct MX records for email delivery.
   - Provide the necessary details, such as domain name and mail server address.
   
3. **SMTP Configuration**:
   - Under the **SMTP** section, configure settings for sending mail. Enable the **SMTP relay service** if needed for outgoing emails.

4. **IMAP/POP3 Configuration**:
   - Enable **IMAP** or **POP3** if you want users to retrieve mail using mail clients like Outlook or Thunderbird.
   - Navigate to **Settings** > **IMAP/POP3** to configure protocols.

5. **SSL/TLS Certificates**:
   - To secure your mail communication, set up SSL/TLS certificates. Go to **Settings** > **Certificate** and import or create certificates for the mail server.

### Step 3: User and Mailbox Management
1. **Create Mailboxes**:
   - Go to **Mailboxes** > **User Mailbox** to create or assign mailboxes for users.
   - You can also enable mailbox quota limits per user.

2. **Enable MailPlus for Users**:
   - Go to **Control Panel** > **User**.
   - Edit user settings and enable **MailPlus** under the **Application** tab for individual users.

### Step 4: Firewall and Port Forwarding
1. **Open Necessary Ports**:
   - Make sure the necessary ports (e.g., SMTP: 25, IMAP: 143, and POP3: 110) are open for mail communication.
   
2. **Set Up Port Forwarding**:
   - If your NAS is behind a router, configure port forwarding for these ports in your router's interface.

### Step 5: Set Up DNS and MX Records
1. **Update MX Records**:
   - Ensure your domain's DNS has the correct **MX records** pointing to your Synology NAS's public IP address or domain name.
   - Optionally, configure **SPF, DKIM, and DMARC** records for better email deliverability and security.

### Step 6: Test MailPlus Server
1. **Send and Receive Test Emails**:
   - Use **MailPlus Client** or any third-party mail client (like Thunderbird) to send and receive emails to verify that your MailPlus Server is working correctly.

### Optional: Install Antivirus and Anti-spam Tools
1. **Install MailPlus Security**:
   - From the **Package Center**, install the **MailPlus Security** package.
   - Configure antivirus and anti-spam settings to protect your server from malicious emails.

This completes the basic setup for Synology MailPlus Server. 

---

## Correct DNS Setup Recommendations

- **Consistency with External DNS**: Ensure that the DNS records set on Cloudflare and DSM are consistent. For example:
  - MX records on Cloudflare should point to `mail.your_domain.com`, assuming that is your mail server.
  - Ensure that the A record for `mail.your_domain.com` points to the correct public IP address if your server 
  is accessed externally (rather than an internal IP like `192.168.1.124`).
  
- **SPF Records**: Merge your SPF record on DSM with Cloudflare. The record on DSM should be restrictive 
(`ip4:<[Your Public IP]> -all`), which may block legitimate mail routed via Cloudflare. Consider using:

  ```
  v=spf1 ip4:<[Your Public IP]> include:_spf.mx.cloudflare.net ~all
  ```

- **MX Records**: Cloudflare’s MX records are already set up to use external mail routing automatically when enabled, 
but if your Synology MailPlus is meant to handle email directly, update Cloudflare’s MX records to point to 
`mail.hyfisolutions.com` with appropriate priorities.

- **DKIM Setup**: Ensure that the DKIM TXT record is properly propagated both in Cloudflare and DSM. Use tools 
like [MXToolbox](https://mxtoolbox.com/MXLookup.aspx) to verify DKIM functionality.

### Final DNS Record Configuration (Example)

If Synology MailPlus is intended to handle all emails for your domain, here’s an example of what the 
external DNS records (e.g., on Cloudflare and DSM) should look like:

- **MX Record**: 
  - Name: `your_domain.com`
  - Type: `MX`
  - Value: `mail.your_domain.com` (priority: 10)
  
- **SPF TXT Record**: 
  - Name: `your_domain.com`
  - Type: `TXT`
  - Value: `v=spf1 ip4:<[Your Public IP]> ~all`   

- **A Record** (for mail server):
  - Name: `mail.your_domain.com`
  - Type: `A`
  - Value: `[Your Public IP]`

- **DKIM TXT Record**:
  - Name: `smtp_domainkey.your_domain.com`
  - Type: `TXT`
  - Value: DKIM public key string

***Note**: Replace placeholders like `[Your Public IP]` and `your_domain.com` with your actual IP address and domain name.
Also, remember to merge this with your existing SPF record on cloudflare*

---

For more detailed instructions on setting up a Synology MailPlus Server, refer to the 
official [Synology MailPlus Server documentation](https://kb.synology.com/en-global/DSM/tutorial/How_to_set_up_MailPlus_Server_on_your_Synology_NAS).

