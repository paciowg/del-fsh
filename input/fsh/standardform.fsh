Alias: LNC = http://loinc.org
Alias: CAT = http://terminology.hl7.org/CodeSystem/observation-category

Profile:        StandardForm
Parent:         Questionnaire
Id:             del-StandardForm
Title:          "Data Element Library Standard Form"
Description:    "A DEL standard form and all of its contents. This includes sections, questions, and available question responses."


* url 1..1
* date 1..1
* name 1..1
* version 1..1
* publisher 1..1
* title 1..1
* description 1..1
* effectivePeriod 1..1
* identifier 1..1


ValueSet: PublicationStatus
Id: publication-status-vs
Title: "PublicationStatus"
Description: "The lifecycle status of an artifact."
* include codes from valueset $PublicationStatus
* ^experimental = false