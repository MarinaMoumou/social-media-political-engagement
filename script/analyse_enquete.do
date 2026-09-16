table interpol
recode interpol (1/4 = 1 "Intéret faible") (5/7 = 2 "Intéret moyen") (8/10 = 3 "Intéret fort"), gen(interpol2)
table vote
recode vote (1/4 = 1 "Importance faible") (5/7 = 2 "Importance moyenne") (8/10 = 3 "Importance forte"), gen(vote2)
table infrs
recode infrs (1/4 = 1 "Influence faible") (5/7 = 2 "Influence moyenne") (8/10 = 3 "Influence forte"), gen(infrs2)
table confrs
recode confrs (1/3 = 1 "Confiance trés faible") ///
              (4/5 = 2 "Confiance aible") ///
              (6/7 = 3 "Confiance oyenne") ///
              (8/10 = 4 "Confiance Forte"), ///
       gen(confrs2)

	   
table engagement 

recode engagement (1/3 = 1 "Motivation faible ") ///
                  (4/7 = 2 "Motivation moyenne") ///
                  (8/10 = 3 "Moyenne forte"), ///
       gen(engagement2)

table infopi
table diffavis
table nbsuivi
recode nbsuivi (0/2 = 1 "moins de 2 suivis") ///
               (3/5 = 2 "entre 3 et 5") ///
               (6/80 = 3 "6 et plus"), ///
       gen(nbsuivi3)

	   // Créer une variable catégorielle basée sur les quartiles
gen taux_participation2 = .
recode taux_participation ///
    (0/0.1678 = 1 "Très faible participation") ///
    (0.1678/0.2857 = 2 "Faible participation") ///
    (0.2857/0.4286 = 3 "Participation modérée") ///
    (0.4286/1 = 4 "Forte participation"), gen(taux_participation2)

	tab taux_participation2
// Vérifier la répartition des catégories
tab cat_taux_participation

table opdiv 
save polrssk, replace
tabulate infrs2 interpol2
tabulate infrs2 interpol2, expected 
tabulate nbvote2 freqdesinf, chi2

recode nbvote (0/2 = 1 "moins de 2") (3/5 = 2 "entre 3 et 5") (6/max = 3 "plus de 6 fois"), gen(nbvote2)

gen souspop = age >= 18 & age <= 24

tabulate nbvote2 freqdesinf if souspop == 1, chi2


tabulate vote2 freqdesinf if souspop == 0, chi2
tabulate elec nbheure2 if sexee == 1, chi2
use "data/donnees_enquete.dta"
regress engagement confrs***
regress nbsuivi nbheure
regress nbsuivi confrs***
regress engagement nbheure***
regress nbchang nbheure
regress engagement infrs*** (10)
regress nbsuivi infrs
regress nbchang nbheure
regress nbchang confrs
regress nbchang infrs***
regress nbpolitique nbheure 
regress nbpolitique confrs
regress nbpolitique infrs***
regress nbvote nbheure
regress nbvote confrs
regress nbvote infrs
regress vote nbheure
regress vote confrs
regress vote infrs
regress interpol nbheure***
regress interpol confrs***
regress interpol infrs
regress interpol opdivv (12)

regress interpol freqdesinf
label list

gen p1=1 if plateforme == 2
replace p5=0 if p5==.
gen p2=1 if plateforme == 3
gen p3=1 if plateforme == 4
gen p4=1 if plateforme == 5
gen p5=1 if plateforme == 6

regress nbpolitique p5
recode opdiv (1=1 "Jamais") (3=2 "Rarement") (2=3 "Parfois") (4=4 "Souvent") (5=5 "Toujours") , generate(opdivv)

regress interpol p1
regress interpol p2
regress interpol p3
regress interpol p4
regress interpol p5
rename p1 facebook
rename p2 instagram 
rename p3 tiktok 
rename p4 X
rename p5 Youtube

gen innon=1 if infoprogelec == 2
replace inoui=0 if inoui == .

regress engagement freqdesinff
regress vote freqdesinff 
regress nbpolitique freqdesinff
regress nbsuivi freqdesinff 
regress nbchang freqdesinff 
regress interpol freqdesinff 

regress vote innon
regress nbpolitique innon
regress nbsuivi innon 
regress nbchang innon 
regress interpol innon 

regress engagement confrs
regress engagement confrs age sexee typeenv nblangues nbheure facebook instagram tiktok X Youtube opdivv freqdesinff infrs inoui innon revenu
 
regress engagement confrs typeenv opdivv nbheure inoui innon infrs age sexee nblangues freqpartagee facebook instagram tiktok X Youtube 

regress engagement confrs age sexee nblangues typeenv opdivv nbheure inoui innon infrs rs journaux proches television freqpartagee facebook instagram tiktok X Youtube


nbheure inoui innon infrs
freqpartagee facebook instagram tiktok X Youtube


recode freqpartage (1=1 "Jamais") (3=2 "Rarement") (2=3 "Parfois") (4=4 "Souvent") , generate(freqpartagee)

regress engagement confrs age sexee nblangues typeenv programme charisme opdivv freqdesinff infrs inoui innon nbheure freqpartage
nbheure facebook instagram tiktok X Youtube freqpartage
nbheure facebook instagram tiktok X Youtube freqpartage  opdivv freqdesinff infrs inoui innon 
 
 
* Créer des variables indicatrices pour chaque modalité
gen journaux = inlist(infopol, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16)
gen reseaux_sociaux = inlist(infopol, 6, 7, 8, 9, 13, 14, 15, 16, 19, 20, 21, 22, 26, 27, 28, 29)
gen proches = inlist(infopol, 4, 5, 8, 9, 11, 12, 15, 16, 17, 18, 21, 22, 24, 25, 28, 29)
gen television = inlist(infopol, 10, 11, 12, 13, 14, 15, 16, 23, 24, 25, 26, 27, 28, 29)
gen autre = inlist(infopol, 1, 3, 5, 7, 9, 12, 14, 16, 18, 20, 22, 25, 27, 29)

* Vérifiez les résultats
list infopol journaux reseaux_sociaux proches television autre if journaux == 1 | reseaux_sociaux == 1

rename reseaux_sociaux rs

regress engagement rs
regress engagement television
regress engagement proches
regress engagement autre
regress engagement journaux

gen ante=1 if factcandi==1
replace ante=0 if ante==. 

gen charisme=1 if factcandi==3
replace charisme=0 if charisme==.

gen programme=1 if factcandi==4
replace programme=0 if programme==. 

gen soutien=1 if factcandi==5
replace soutien=0 if soutien==.

regress engagement programme

regress engagement confrs 

regress engagement confrs age sexee nblangues 

regress engagement confrs age sexee nblangues typeenv opdivv programme charisme ante soutien  

regress engagement confrs age sexee nblangues typeenv opdivv programme charisme ante soutien nbheure inoui innon infrs freqdesinff rs 

regress engagement confrs age sexee nblangues typeenv opdivv programme charisme ante soutien nbheure inoui innon infrs freqdesinff rs freqpartagee facebook instagram tiktok X Youtube 

regress engagement confrs age nblangues typeenv opdivv  nbheure inoui innon infrs freqdesinff rs partagepol 


gen neg=1 if infopi==6
replace neg=0 if neg==. 

gen mod=1 if (infopi==2 | infopi==3)
replace mod=0 if mod==.

gen pos=1 if infopi==7
replace pos=0 if pos==. 

gen neutre=1 if (infopi==4 | infopi==5)
replace neutre=0 if neutre==.

regress engagement neg
regress engagement pos
regress engagement mod 
regress engagement neutre

regress engagement confrs if sexee==1




regress engagement rs
regress vote rs
regress nbpolitique rs
regress nbsuivi rs
regress nbchang rs
regress interpol rs

regress engagement confrs age sexee nblangues typeenv opdivv nbheure infrs freqdesinff freqpartagee




regress  interpol programme
regress interpol charisme
regress  interpol ante
regress  interpol soutien

generate confrs_jitter = confrs + runiform()*0.2 - 0.1
generate engagement_jitter = engagement + runiform()*0.2 - 0.1
twoway scatter engagement_jitter confrs_jitter

twoway (scatter engagement confrs, jitter(8) , mcolor(%50))

generate confrs_transformed = confrs + (runiform() - 0.5)*0.1
scatter engagement confrs_transformed
twoway (scatter enga_transformedddd confrs_transformedddd, jitter(12) mcolor(%50)) (lfit enga_transformedddd confrs_transformedddd)

generate confrs_transformed = confrs + (runiform() - 0.5)*0.1
scatter engagement confrs_transformed
generate confrs_transformedddd = confrs + (runiform() - 0.5) * 0.5
scatter engagement confrs_transformedddd
generate enga_transformedddd = engagement + (runiform() - 0.5) * 0.5
scatter enga_transformedddd confrs_transformedddd, jitter(12)

regress engagement confrs

*3-nprmalité des erreurs 
predict resid, residuals 
histogram resid, normal 
swilk resid 
*pour y remedier a la normalité des erreurs 
*transformation en log 
gen log_enga = log(engagement)

*Aprés log 
regress log_enga confrs age sexee nblangues typeenv opdivv programme charisme ante soutien nbheure inoui innon infrs freqdesinff rs freqpartagee facebook instagram tiktok X Youtube 
predict residlog, residuals 
histogram residlog, normal 
swilk residlog
*graphiquepour montrer la distribution des erreurs: 
histogram residlog, normal
qnorm residlog
histogram resid, normal
qnorm resid
*Considérations supplémentaires :Si les résidus montrent toujours des écarts modérés à la normalité, mais que les coefficients et les tests du modèle sont stables, la violation pourrait être tolérable.En effet, pour de grands échantillons (n > 30), les régressions linéaires sont robustes à une légère non-normalité grâce au théorème central limite.


*4-homoscedastcité 
rvfplot 
estat hettest
*Breusch–Pagan/Cook–Weisberg test for heteroskedasticity 
*Assumption: Normal error terms
*Variable: Fitted values of engagement

*H0: Constant variance   chi2(1) =   0.02 Prob > chi2 = 0.8776
*interpretation du resultat : doc nass



*tester la multicolinéarité 
regress taux_participation infrs age sexee nblangues typeenv opdivv  nbheure inoui innon confrs freqdesinff rs freqpartagee facebook instagram tiktok X Youtube nbsuivi
regress taux_participation 
vif
*peut etre pour la corrélation
pwcorr engagement confrs age sexee nblangues typeenv opdivv factcandi  nbheure infoprogelec infrs freqdesinff rs freqpartagee plateforme 

regress interpol infrs age sexee nblangues typeenv opdivv  nbheure confrs freqdesinff rs freqpartagee facebook instagram tiktok X Youtube  
 
 
 * Créer la variable taux de participation
gen taux_participation = .

* Définir les opportunités de vote en fonction de l'âge
gen opportunites = .

* Calculer le nombre d'opportunités de vote selon l'âge en 2024
replace opportunites = 3 if age == 18
replace opportunites = 3 if age == 19
replace opportunites = 7 if age == 20
replace opportunites = 11 if age == 21
replace opportunites = 13 if age == 22
replace opportunites = 15 if age >= 23

* Calculer le taux de participation pour chaque individu
* (nb de votes déclarés / opportunités de vote)
replace taux_participation = nbvote / opportunites if !missing(nbvote) & !missing(opportunites)

* Vérifier la variable taux_participation
list age nbvote opportunites taux_participation if !missing(taux_participation), sepby(age)

*nouvelles regressions 
 regress taux_participation opdivv if sexee==2
 
  regress taux_participation opdivv age  nblangues typeenv if sexee==2
  
   regress taux_participation opdivv age  nblangues typeenv infrs confrs inoui innon freqdesinff rs nbheure if sexee==2
   
   regress taux_participation opdivv age sexee nblangues typeenv infrs confrs inoui innon freqdesinff rs nbheure freqpartagee facebook instagram tiktok X Youtube nbsuivi 
   vif
   predict resi, residuals 
histogram resi, normal 
swilk resi
histogram resi, normal
qnorm resi
*4-homoscedastcité
rvfplot 
estat hettest

*khi 2 ; 
tabulate interpol2 nbsuivi3 if sexee==2, chi2
tabulate vote2 nbsuivi3 if sexee==2, chi2
tabulate nbpolitique2 nbsuivi3 if sexee==2, chi2
tabulate nbchang2 nbsuivi3 if sexee==2, chi2
tabulate elec nbsuivi3 if sexee==2, chi2
tabulate engagement2 nbsuivi3 if sexee==2, chi2
tabulate taux_participation2 nbsuivi3 if sexee==2, chi2

tabulate taux_participation2 infrs2 if sexee==1, chi2
tabulate taux_participation2 confrs2 if sexee==1, chi2
tabulate taux_participation2 nbheure2 if sexee==1, chi2
tabulate taux_participation2 infoprogelec if sexee==1, chi2
tabulate taux_participation2 infopi if sexee==1, chi2
tabulate taux_participation2 plateforme if sexee==1, chi2
tabulate taux_participation2 opdiv if sexee==1, chi2
tabulate taux_participation2 nbsuivi3 if sexee==1, chi2
tabulate taux_participation2 freqdesinf if sexee==1, chi2
tabulate taux_participation2 freqpartage if sexee==1, chi2


tabulate interpol2 freqpartage if sexee==1, chi2
tabulate vote2 freqpartage if sexee==1, chi2
tabulate nbpolitique2 freqpartage if sexee==1, chi2
tabulate nbchang2 freqpartage if sexee==1, chi2
tabulate elec freqpartage if sexee==1, chi2
tabulate engagement2 freqpartage if sexee==1, chi2


regress taux_participation confrs
regress taux_participation infrs
regress taux_participation nbheure
regress taux_participation inoui
regress taux_participation innon
regress taux_participation facebook
regress taux_participation instagram
regress taux_participation tiktok
regress taux_participation X
regress taux_participation Youtube
regress taux_participation opdivv
regress taux_participation freqpartagee
regress taux_participation freqdesinff
regress taux_participation rs
regress taux_participation programme
regress taux_participation charisme
regress taux_participation ante
regress taux_participation soutien
regress taux_participation nbsuivi


regress engagement nbsuivi
regress vote nbsuivi 
regress nbpolitique nbsuivi
regress nbchang nbsuivi
regress interpol nbsuivi


regress taux_participation opdivv

egen mean_opdivv = mean(opdivv), by(taux_participation)
twoway (scatter mean_opdivv taux_participation, jitter(8) mcolor(%50))
twoway (scatter  taux_participation mean_opdivv, jitter(8) mcolor(%50)) ///
       (lfit taux_participation mean_opdivv)

  regress taux_participation opdivv age sexee nblangues typeenv infrs confrs inoui innon freqdesinff rs nbheure freqpartagee  nbsuivi if plateforme == 3 & 2
 
   regress taux_participation opdivv age sexee nblangues typeenv infrs confrs inoui innon freqdesinff rs nbheure freqpartagee  nbsuivi if plateforme == 4 & 5

  table plateforme
  label list
   
   
   gen log_taux = log(taux_participation)
   regress log_taux opdivv age sexee nblangues typeenv infrs confrs inoui innon freqdesinff rs nbheure freqpartagee facebook instagram tiktok X Youtube nbsuivi 
   
 *normalité des erreurs (q q plot dans les annexes)  
predict resif, residuals 
histogram resif, normal 
swilk resif
histogram resif, normal
qnorm resif 
   