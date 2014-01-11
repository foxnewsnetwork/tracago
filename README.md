Calendar for Escrow
=
>Preference pages
Friday Jan 10
1. Spend all day debugging and developing the position linked list swap feature, but at least decided to just fuck it

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