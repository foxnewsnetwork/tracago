Calendar for Escrow
=
>replace all dog pictures with real pictures
>doc tags controller & show page
>favicon.ico must be generated
>get some real bank accounts

Thursday Jan 30
1. copy functionality complete (model and controller to create escrows from archived escrows)
2. escrow destroy operation complete
3. write a real unicorn proc and conf file for actual production
Note: to deploy, run the following:
```shell
unicorn_rails -c config/unicorn.conf.rb -D
```
don't forget to regenerate assets

Wednesday Jan 29
1. started copy functionality

Tuesday Jan 28
1. Talked to William Lawton

Monday Jan 27
1. Home page real pictures (except for banks)

Sunday Jan 26
1. Finally fucking emails working. (had to call #deliver!)
2. replace all outbound emails with steady address
3. confirm email domain naming issues

Wednesday Jan 22
1. replaced lorem ipsum in session and faq
2. lorem ipsum replaced in usage page
3. got the rest of the lorem ipsums
4. specified pay-step controller and whatnot
5. parties bank account edit and update features

Tuesday Jan 21
1. edit and update for bank accounts
2. needs designatable payment step
3. error pages for 500, 404, etc.

memax eric $0.10/lb 

Monday Jan 20
1. Nginx assets and images issue resolved
2. bank account new and create
Note: #1-7 and film from seattle, we buying or not?

Friday Jan 17
1. privacy policy hijacked from alibaba and edited to be usable
2. stole and edited stripe's term of use document

Thursday Jan 16
1. preferences page
2. status page
3. blog page axed
4. home page content
5. aboutus page content
Note: have mom return call to Jack - he has questions regarding the offers he's made
Note: wendy's suppliers are saying they need another booking because they can only do 2 containers on the current one

Wednesday Jan 15
1. admin role created
2. admin permissions baked in
3. admin panel done, admin-documents done

Tuesday Jan 14
1. Home page minor fixes and whatnot
2. repaired that shitty nav bar
3. Smoothed out some css rough edges

Monday Jan 13
1. Home page for small screens and medium screens changed
notes: City Order (or whatever invoice due)
notes: Jacky can't do $0.10 with arthur
notes: Ed fitch HDPE natural ($0.25) half load what do?
notes: Linda Bao sends invoice

Sunday Jan 12
1. Account contracts index page
2. Fix front-page mobile appearance

Saturday Jan 11
1. Account Edit

Friday Jan 10
1. Spend all day debugging and developing the position linked list swap feature, but at least decided to just fuck it
2. Put in ability edit position in steps edit and update

Thursday Jan 9
1. Document destroy complete
2. Fixed issue with completed_at and whatnot also updating updated_at
3. Fixed issue with missing icons
4. edit_mode propagated down and added the boring gray color for editing
5. Investment formula: $(time) = (exponential(interest * time) - 1) * wage / interest
6. Add buttons for going back and forth on the actions slabs
7. Document & step permission setup
8. Fixed issue with sorting step positions (But still requires testing)

Wedesday Jan 8
1. Document approve, rejection, edit, update
2. step edit, update, etc. paths
3. Fixed color issue

Tuesday Jan 7
1. Easy Life Roger
2. Login sessions and junk

Monday Jan 6
1. Account creation after email contact


Email Setup
=
In order to properly use actionmailer, the developer must setup either sendmail or postfix (preferrably both). I will go over how to setup both in this readme. [sauce here](https://help.ubuntu.com/community/Postfix)

#### Postfix
Run the following command to get postfix from your friendly online repo
```shell
$ sudo apt-get install postfix
```
Accept all the default choices the postfix installation presents to you, as you will be configuring in greater detail in the next step.

Run the following command to configure postfix
```shell
$ sudo dpkg-reconfigure postfix
```

Change your mail root to /home/[you]/Maildir
```shell
$ sudo postconf -e 'home_mailbox = Maildir/'
$ sudo postconf -e 'mailbox_command ='
```
Configure sasl for smtp
```shell
$ sudo postconf -e 'smtpd_sasl_local_domain ='
$ sudo postconf -e 'smtpd_sasl_auth_enable = yes'
$ sudo postconf -e 'smtpd_sasl_security_options = noanonymous'
$ sudo postconf -e 'broken_sasl_auth_clients = yes'
$ sudo postconf -e 'smtpd_recipient_restrictions = permit_sasl_authenticated,permit_mynetworks,reject_unauth_destination'
$ sudo postconf -e 'inet_interfaces = all'
```

Create a smtpd.conf file
```shell
$ sudo vim /etc/postfix/sasl/smtpd.conf
```
and put the following into it
```
pwcheck_method: saslauthd
mech_list: plain login
```

Next, you must generate keys, certificates, and whatnot for TLS encryption
```shell
touch smtpd.key
chmod 600 smtpd.key
openssl genrsa 1024 > smtpd.key
openssl req -new -key smtpd.key -x509 -days 3650 -out smtpd.crt # has prompts
openssl req -new -x509 -extensions v3_ca -keyout cakey.pem -out cacert.pem -days 3650 # has prompts
sudo mv smtpd.key /etc/ssl/private/
sudo mv smtpd.crt /etc/ssl/certs/
sudo mv cakey.pem /etc/ssl/private/
sudo mv cacert.pem /etc/ssl/certs/
```

Configure TSL issues
```shell
sudo postconf -e 'smtp_tls_security_level = may'
sudo postconf -e 'smtpd_tls_security_level = may'
sudo postconf -e 'smtpd_tls_auth_only = no'
sudo postconf -e 'smtp_tls_note_starttls_offer = yes'
sudo postconf -e 'smtpd_tls_key_file = /etc/ssl/private/smtpd.key'
sudo postconf -e 'smtpd_tls_cert_file = /etc/ssl/certs/smtpd.crt'
sudo postconf -e 'smtpd_tls_CAfile = /etc/ssl/certs/cacert.pem'
sudo postconf -e 'smtpd_tls_loglevel = 1'
sudo postconf -e 'smtpd_tls_received_header = yes'
sudo postconf -e 'smtpd_tls_session_cache_timeout = 3600s'
sudo postconf -e 'tls_random_source = dev:/dev/urandom'
sudo postconf -e 'myhostname = server1.example.com'
```

Restart the postfix daemon
```shell
sudo /etc/init.d/postfix restart
```
Tracago Project
=
International Trade Platform

# Tuesday, December 3
1. Finish entire make offer path
2. Write out complete integration test for make offer path

# Wednesday, December 4
1. Offer show page

# Thursday, December 5
1. Registration path
1.5. User show page
2. Mail to Theron the garage door opener
3. Enumerate out all the existing broken links on the site

# Friday, December 6
1. offers finalization new page
2. finalization show page

# Monday, December 9
1. shop show page

# Tuesday, December 10
1. ?

# Wednesday, December 11
1. Escrow-steps

# Thursday, December 12
1. finish finalization page
2. front page for asshole site

# Friday, December 12
1. front page styled out

# Sunday, December 15
1. usage page styled out
2. help page styled out
3. styled the help page


# Monday, December 16
1. terms page
2. documentation page

# Tuesday, December 17
1. escrow new page
2. flash

# Wednesday, December 18
1. escrow steps new
2. escrow show page
3. escrow steps create
4. steps show

# Thursday, December 19
1. escrow steps documents styling
2. destroy step path

# Friday, December 20
2. documents show
3. escrow open and agreement
4. escrow open email
5. steps documents new create

# Saturday, December 21
1. Accounts, sessions, and permissions
2. escrow ecryped agree

# Thursday, December 26
1. Accounts, sessesions, and permissions

# Friday, December 27
1. Get frustrated over account sessions

# Friday, Jan 3
1. Got account sessions working
2. Added a more intutive path for new escrows when logged in

# Saturday, Jan 4
1. Needs escrow show page permission setup with locks and shit
2. Needs user logout to properly redirect
> Needs proper permission across showing contracts and such
> Needs a nature way for emailed contract users to create accounts
> Needs a nature way for users to change their company name
> Needs a preferences page
> Needs to make all the accounts show page links go live
> Needs real documentation data and whatnot
> Needs appropriate links everywhere


International Merchants
=
Purchase Order (aka Sales Invoice)
  - belongs to Seller
  - belongs to Buyer
  - has many payment plan
  - has many delivery plan

Payment Plan
  - has many steps

Delivery plan
  - has many steps

Local Delivery Plan
  - step 1: send truck to site
  - step 2: load truck on site
  - step 3: truck returns

International Delivery Plan
  - step 1: acquire booking
  - step 2: send truck to pull container(s)
  - step 3: take container to site to load
  - step 4: return container to terminal

International Clusterfucked Delivery Plan
  - step 1: acquire booking
  - step 2: send truck to pull container(s)
  - step 2.5 (optional): acquire late-gate
  - step 3: take container to site to load
  - step 4: return container to terminal

Step
  - has many overseers
  - has many documents

Person
  - has many contact_methods

Contact Method
  - email
  - cellphone
  - mail
  - fax
  - landline

Company
  - has many employees
  - belongs to person

Employee
  - belongs to person
  - position & role