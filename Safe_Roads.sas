proc import datafile = '/home/u42959477/Exper/KSI.csv'
dbms = csv out = KSI replace;
run;

/* Injuries with age distributin */ 
data  KSI;
set KSI;
where (invage <> 'unknown' AND injury <> '' and Injury <> 'None');
run;


title "No. of People injured vs. Age Group ";
proc sgplot data = KSI;
label Invage = 'Age Group';
format Invage;
vbar Invage /datalabel colorstat=freq dataskin=matte;
run;

/* Fatalities with age distributin */ 
data KSI;
set KSI;
where ACCLASS = 'Fatal';
run;

title " No. of Fatalities vs. Age Group ";
proc sgplot data = KSI;
label Invage = 'Age Group';
format Invage;
vbar Invage /datalabel colorstat=freq dataskin=matte;
run;

/* Involvment type of top 3 fatality age groups */
data KSI;
set KSI;
where (invage = "20 to 24") or (invage = "25 to 29") or  (invage = "55 to 59");
run;

title " Involvement type in a Fatality  ";
proc sgplot data = KSI;
label Invtype = 'Involvment type';
format Invtype;
vbar Invtype /datalabel categoryorder=respdesc fillattrs=(color=cx66A5A0) dataskin=matte;
run;


/* Analyzing the effect of visibility */
data KSI;
set KSI;
where (invtype = "Driver") or (invtype = "Passenger") or  (invtype = "Pedestrian");
run;

title " Analyzing the effect of visibility in Fatality  ";
proc sgplot data = KSI;
label visibility = 'Types of Visibility';
format visibility;
vbar visibility /datalabel categoryorder=respdesc fillattrs=(color=cx66A5B0) dataskin=matte;
run;

/* Analyzing the effect of raod conditions */


title " Analyzing the effect of raod conditions in Fatality  ";
proc sgplot data = KSI;
label rdsfcond = 'Involvment type';
format rdsfcond;
vbar rdsfcond /datalabel categoryorder=respdesc fillattrs=(color=cx66A5C0) dataskin=matte;
run;



/* Analyzing the effect of Vehicle type */
data KSI;
set KSI;
where (vehtype <> "") AND (vehtype <> "Other");
run;

title " Analyzing the effect of vehicle type in Fatality  ";
proc sgplot data = KSI;
label vehtype = 'Vehicle type';
format vehtype;
vbar vehtype /datalabel categoryorder=respdesc fillattrs=(color=cx66A5D0) dataskin=matte;
run;


/*Road Location on Fatality  */
data KSI;
set KSI;
where (vehtype = "Automobile, Station Wagon") AND (visibility = "Clear") and (rdsfcond = "Dry") and (traffctl = "No Control");
run;


title " Road Location on Fatality ";
proc sgplot data = KSI;
label loccoord = 'Vehicle type';
format loccoord;
vbar loccoord /datalabel categoryorder=respdesc fillattrs=(color=cx66A5E0) dataskin=matte;
run;


      

/* the map is not working right now. might work in SAS EG */

proc sql;
create table work.ksidata as
   select Longitude, Latitude, count(latitude) AS totcount format=comma16.
      from work.ksi
      group by Longitude, Latitude;

data ksimap(rename=(long=x lat=y));
set mapsgfk.canada(drop= x y);
where ID1 in('CA-35');
run;

proc sgmap mapdata=ksimap plotdata=ksidata;
openstreetmap;
  bubble x=longitude y=latitude size=totcount/legendlabel="Fatalities";
run;