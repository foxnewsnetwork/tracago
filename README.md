Calendar for Escrow
=
(non-critical, but should be done)
>roll in newrelic (data-monitoring)
>google tracking (page count)
>cloudflare (cdn and caching)
>airbrake (or squash for exception tracking)
>mandrillapp (or sendgrid for emails)
>s3 (for production-tier document hosting)
>the rest of the tags and documentations controllers
>doc tags controller & show page
>internationalization
>need way to update memo on step
Live run tests
2. registration should allow user to input company name
3. introduce a page before new escrows that ask the user to select what sort of contract
4. introduce new shipping deal contract
10. contract types should be implemented (international shipping contract, etc.)
14. find some way to get really long file names to not break the boundary on document show

(critical)
>favicon.ico must be generated
>missing translations
>document#show %h2 document still aligned weird
>user agreement should be in small box while contract details should be prominently displayed
>change payment / goods service to seller buyer
>reverse the order of escrow#show... and provide a legal-text version

# Notes to posterity:
# form_helpers = interactos
# view_helpers = presenters

Thursday
=
Got the whole contract escrow thing working

Wednesday
=
Nothing

Tuesday
=
Nothing

Monday
=
Nothing

Wednesday
=
Nothing

Tuesday
=
Nothing

Monday
=
Nothing

Sunday
=
1. Got through the entirety of the contract (might need to edit for grammar though)
2. Now need to get tos agreement thing retouched up and have it generate the escrow product then we should be good to go

Friday
=
Almost through with punishments, still need to work out all the cases when buyer gives seller booking

Thursday
=
1. Finish contract view

Wednesday
=
PET - $0.215 FAS Long Beach (this week price)

Tuesday
=
1. Now implementing contracts show legal agreement, got to terms of payment - required documents

Monday
=
1. draft paths are all done; now to implmenet the transfers

Saturday
=
Getting stuck on commodities javascript

Friday
=
Got to edit and update on commodities and terms (need to test)

Thursday February 20
=
New Shipping Contract Workflow
1. specify buy contract or sell contract
2. specify contract type (international shipping, local sales, etc.)
3. specify desired items and other party
4. specify required documents
I then need to generate such a contract
todo: incoporate rgba box shadows
todo: signup page javascript password strength thing
todo: implement forgot password thing

Wednesday February 19
=
1. email archives index and show
2. fixed registration now properly redirecting users
17. resolve the double flash error for document rejection and approval
3. fixed bug with error documents
4. bug involving edit-escrow requiring admin mode must be fixed
5. fixed issue where it was possible to delete steps past edit mode

Tuesday February 18
=
Secret key specs
Entrace path (from email)
1. secret_keys/escrows#show
2. secret_keys/escrows/agreeements#new (skipped if session exists)
3. secret_keys/escrows/sessions#new or secret_keys/escrows/registrations#new (skipped if session exists)
4. escrows/agreements#new

# case 1: user with account invited to first-time contract
expected behavior:
> user goes directly to agreement page if logged in
> user asked to sign in to first, then redirected to agreement page
> agreement page presents link to review contract

# case 2: user without account invited to first-time contract
> user asked to make account, then redirect to agreement page
> agreement page presents link to review contract

# case 3: user with account revisits already-agreed contract
> user goes directly to contract show if logged in
> user asked to log in first, then redirected to contracts show

# case 4: user without account revisits already-agreed contract
> this case should not happen
> in the future, it may be reasonable to implement collaborators to parties
1. implemented secret key agreement steps
6. Provide a way to change step type (from payment step to vanilla, for instance)
13. Make it so that, if both parties have already agreed, they are just forwarded to the contract
11. Allows the other person to view the contract if he has the view-key
12. Make it so that the agreement page also forces login if the user isn't logged in
9. provide a way for users to request to have their left-over money back (still need way for admins to view it)

Monday February 17
=
1. added memo to step, but still need a way to edit it
8. Change payment step to pay-in step and pay-out step


Saturday Feb 15
=


Fixes
1. escrows / money_transfers path fixed
2. itps/admin/outbound_transfers/1/escrows is a redirect loop (fuck) fixed
3. admin stylesheets missing for some reason; resolved by following asset pipeline standards and refactoring
4. account page fix no-bank account %p alignment
5(high priority). uploaded images don't show up; resolve this by either renting s3 or something; resolved by fixing the nginx conf and where attachment go in the public folder
6(high priority). change the way documents consider if they have attachments or not
7. Step initial h2 title needs to make sense
5. payment instructions page's check should reflect the given company's name

Fiday Feb 14
=
1. ability to upload lots of pictures at once to the site


Thursday Feb 13
=
Sales Notes:
Wuyi + Memax buys drip tapes
Hengyi buys supersex
Christina buys #1-7 (need more buyers)
Jacky buys good film (from arthur)
Jack buys shit film (from arthur and jacky)
1. Email archive setup
2. email fix

888 287 4637 - BoA fraud services department
temp pass code: H343637F (deprecated already, don't bother stealing)

Wednesday Feb 12
1. replace all dog pictures with real pictures
2. overhauled usage page css nesting to get rid of some severe problems

Tuesday Feb 11
1. payment instruction section done
2. fixed a lot of various junk
3. still need email
4. update site with real bank account info from BoA
5. parties bank_accounts#index
6. payment instructions & overhaul payment step
7. fix usage page css and dogs

Sunday Feb 9
1. Split admin and vanilla stylesheets and fixed a lot of shitty css bugs
2. Signup doesn't automatically log user in; fixed friday (this is an nginx issue)
4. text alignment completely fucked on escrows / steps / new
4. actions + docs alignment fucked on steps / show
4. cookie crumbs and actions alignment fucked on documents / show
4. header logo alignment
4. escrows show steps title alignment
2. get some real bank accounts
3. mobile homepage actions links missing

Friday Feb 7 Live Test Problems Log
=
5. need document that can hold a bunch of pictures


Friday Feb 7
1. admin escrows index page done
2. gotta fix css bugs on the usage page
3. pricing page; pretty much done
4. money transfer show, index, pages

Thursday Feb 6
1. edit, delete, whatnot works for money_transfer
2. outbound transfers operational
3. deposit and withdrawal models (inbound_transfer, outbound_transfer, money_transfer controller and views)

Wednesday Feb 5
1. inbound transfer claims process
2. money tranfers escrows new create pages

Monday Feb 3
1. inbound forms, transfers_escrows, create
2. views for admin fixed
3. resolved shit-issue with bootstrap update

Sunday Feb 2
1. Inbound transfer new and create

Friday (yay) Jan 31
1. Refactor the documentation and tag models
(Jacky called requiring $0.12 PO for Wendy #1-5 container)

Thursday Jan 30
1. copy functionality complete (model and controller to create escrows from archived escrows)
2. escrow destroy operation complete
3. write a real unicorn proc and conf file for actual production
4. Read (this guy's blog)[http://tmm1.net/ruby21-oobgc/] and now I'm going to switch up to ruby2.1 to take advantage of RGenGC (this means next push will mean I update ruby on the production machine)
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