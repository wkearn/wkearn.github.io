For a PDF version, [click here](assets/cv.pdf)

$if(education)$
# Education

$for(education)$

$if(education.institution)$- **$education.institution$**$endif$

$if(education.degree)$    $education.degree$$endif$$if(education.description)$ $education.description$$endif$$if(education.years)$ ($education.years$)$endif$
$endfor$
$endif$

$if(appointments)$
# Research positions

$for(appointments)$

$if(appointments.position)$- **$appointments.position$**$endif$

$if(appointments.institution)$    $appointments.institution$$endif$$if(appointments.years)$ ($appointments.years$)$endif$

$if(appointments.description)$    $appointments.description$$endif$
$endfor$
$endif$

# Publications 

For a complete list of publications, [click here](pages/publications.html)

$if(teaching)$
# Teaching

$for(teaching)$

$if(teaching.course)$- **$teaching.course$**$endif$

$if(teaching.institution)$    $teaching.institution$$endif$

$if(teaching.description)$    $teaching.description$$endif$
$endfor$
$endif$

$if(award)$
# Awards

$for(award)$

$if(award.awardname)$- **$award.awardname$**$endif$

$if(award.institution)$    $award.institution$$endif$$if(award.years)$ ($award.years$)$endif$
$endfor$
$endif$

$if(funding)$
# Funding

$for(funding)$

$if(funding.grantname)$- **$funding.grantname$**$endif$

$if(funding.institution)$    $funding.institution$$endif$$if(funding.years)$ ($funding.years$)$endif$
$endfor$
$endif$

$if(service)$
# Service

$for(service)$

$if(service.position)$- **$service.position$**$endif$

$if(service.institution)$    $service.institution$$endif$$if(service.years)$ ($service.years$)$endif$
$endfor$
$endif$

$if(reviews)$
## Reviewing

$for(reviews)$
$for(reviews.list)$
- $reviews.list$
$endfor$
$endfor$
$endif$

$if(infrastructure)$
## Contributions to research infrastructure

$for(infrastructure)$

$if(infrastructure.name)$- **$infrastructure.name$**$endif$

$if(infrastructure.description)$    $infrastructure.description$$endif$

$if(infrastructure.url)$    $infrastructure.url$$endif$
$endfor$
$endif$
