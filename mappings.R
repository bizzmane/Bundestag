reg_map = c(
  "Katharina Kloke"            = "Katharina Willkomm",
  ".*Albert.*Weiler"           = "Dr. h.c. Albert Weiler",
  "Johannes.*Vogel"            = "Johannes Vogel",
  "Mario.*Brandenburg"         = "Mario Brandenburg",
  ".*Hans Michelbach"          = "Dr. h.c. Hans Michelbach",
  ".*Thomas.*Sattelberger"     = "Dr. h. c. Thomas Sattelberger",
  "Joana.*Cotar"               = "Joana Cotar",
  "Albrecht.*Glaser"           = "Albrecht Glaser",
  "Konstantin.*Kuhle"          = "Konstantin Kuhle",
  "Michael.*Link.*"            = "Michael Link", 
  "Dr..*Karl.*Lamers"          = "Dr. Dr. h. c. Karl Lamers", 
  "Eva.*Schreiber"             = "Eva-Maria Schreiber",
  ".*Irene Mihalic"            = "Dr. Irene Mihalic", 
  ".*Frank.*Steffel"           = "Dr. Frank Steffel",
  ".*Birk.*Bull.*Bischoff"     = "Dr. Birke Bull-Bischoff",
  "Elvan.*Korkmaz.*"           = "Elvan Korkmaz-Emre" ,
  "Heidrun.*Bluhm.*"           = "Heidrun Bluhm-Förster",
  ".*Ingrid Nestle"            = "Dr. Ingrid Nestle",
  "Isabel.*Mackensen.*"        = "Isabel Mackensen-Geis",
  ".*Janosch.*Dahmen"          = "Dr. Janosch Dahmen",
  ".*Christopher Gohl"         = "Dr. Christopher Gohl" 
)

COLOR_PAL <- c("cornflowerblue", "green", "black", "magenta",
               "gold", "grey", "red")
ALL_PARTIES <- c("AfD", "B90/GR", "CDU/CSU", "DIE LINKE.", "FDP", 
                 "Fraktionslos","SPD")

DESC = c("intro"=
           "In dieser App werden die Abstimmungen des 19ten Deutschen Bundestages analysiert.
            Die Daten sind frei verfügbar unter https://www.bundestag.de/parlament/plenum/abstimmung/liste .
            <br>
            Zur Aufbereitung der Daten wurden die Mitgliedernamen dedupliziert. Zur einfacherer Analyse wurde 
            die Variable 'YesFloat' eingeführt. Diese führt die Abstimmungsmöglichkeiten (Ja, Nein, Enthaltung, Abwesendheit)
            in eine Variable zusammen. Der häufigste Fall ist die Wertung 0 oder 1, wenn Nein oder Ja abgestimmt wurde. Bei Enthaltung
            wird die Variable auf 0.5 gesetzt. Bei Abwesendheit wird die Variable auf den durchschnittlichen Abstimmungswert der Partei gesetzt, 
            unter der Annahme, dass bei Anwesenheit zumeist entlang der Parteilinie gestimmt wird.
           ",
         "plot_absentee_votes" = 
           "<h2> Abwesenheit bei Abstimmungen </h2><br><br>
             Das Balkendiagramm zeigt die Anzahl der Abwesenheiten bei
             Abstimmungen. Die Bundeskanzlerin führt die Liste der meisten 
             Abwesenheiten an. 
           ",
         "plot_variance_within1" =
            "<br>
             Hier wird gezeigt wie einheitlich bzw. unterschiedlich die Stimmen 
             innerhalb einer jeder Partei für eine Abstimmung war.
             <br>
             Wie zu erwarten stimmen die Partei bei den meisten Abstimmung 
             überwiegend geschlossen ab. Für alle Partein liegt der Median bei 0.
             Dies bedeutet, dass sie in über 50% der Abstimmungen geschlossen stimmen.
             Bei FDP und DIE LINKE liegt sogar das dritte Quartil bei 0, somit werden
             75% einheitlich entschieden.
             <br>
             Die Ausreißer zeigen die Abstimmungen mit den größten innerparteilichen
             Abweichungen an. Besonders auffällig ist die Sitzungsnummer 140 mit den
             Abstimmungen bezüglich der Entscheidungsregelung zur Organspende. Weiterhin
             sind die Abstimmungen bezüglich dem Einsatzes deutscher Streitkräfte
             oft zu finden unter den Ausreißern.
            ",
         "plot_variance_within2" =
             "<br>
             <ul>
             
             <li><b>SNR4_2</b> - Fortsetzung der Beteiligung bewaffneter deutscher Streitkräfte zur Verhütung und Unterbindung terroristischer Handlungen durch die Terrororganisation IS</li>
             <li><b>SNR4_4</b> - Fortsetzung der Beteiligung bewaffneter deutscher Streitkräfte am NATO-geführten Einsatz Resolute Support für die Ausbildung, 
                                 Beratung und Unterstützung der afghanischen nationalen Verteidigungs- und Sicherheitskräfte in Afghanistan</li>
             <li><b>SNR23_3</b> - Fortsetzung der Beteiligung bewaffneter deutscher Streitkräfte an der NATO-geführten Maritimen Sicherheitsoperation SEA GUARDIAN im Mittelmeer </li>
             <li><b>SNR89_4</b> - Fortsetzung der Beteiligung bewaffneter deutscher Streitkräfte am NATO-geführten Einsatz Resolute Support für die Ausbildung, Beratung und 
                                  Unterstützung der afghanischen nationalen Verteidigungs- und Sicherheitskräfte in Afghanistan</li>
             <li><b>SNR89_8</b> - Fortsetzung der Beteiligung bewaffneter deutscher Streitkräfte an dem Hybriden Einsatz der Afrikanischen Union und der Vereinigten Nationen in Darfur (UNAMID)</li>
             <li><b>SNR108_4</b> - Klimanotstand anerkennen - Klimaschutz-Sofortmaßnahmen verabschieden</li>
             <li><b>SNR140_1</b> - Gesetzes zur Regelung der doppelten Widerspruchslösung im Transplantationsgesetz</li>
             <li><b>SNR140_2</b> - Gesetzes zur Stärkung der Entscheidungsbereitschaft bei der Organspende</li>
             <li><b>SNR140_3</b> - Gesetzes zur Stärkung der Entscheidungsbereitschaft bei der Organspende</li>
             </ul>
             ",
         "plot_member_varience" =
           "<h2> Abweichendes Stimmverhalten der Parteimitglieder</h2><br><br>
            Hier wird gezeigt ist weit das Abstimmverhalten der Parteimitglieder
            von dem durchschnittlichen Abstimmverhalten aller Parteimitglieder 
            abweicht.
            <br>
            Bei der SPD ragt Marco Bülow heraus, der nach 60 absolvierten Abstimmungen
            in 2018 die SPD verlassen hat. Bei den Grünen stimmt Canan_Bayram am 
            öftesten unabhängig der Parteilinie ab. Sie ist die einzige Abgeordnete der Grünenfraktion, 
            die über die Erststimmen ihres Wahlkreises in den Bundestag einzog 
            und stimmt vielleicht daher mit größerer Freiheit ab.
            <br>
           ",
         "plot_PCA_2D" =
           "<h2> Abstimmungsverhalten auf 2 Dimensionen projeziert</h2><br>
           Hier gezeigt ist die Projektion der Abstimmungsdaten auf die 
           ersten beiden Komponenten der PCA (Principal Component Analysis).
           Die PCA bildet die 239 Abstimmungen (=Dimensionen) in weniger 
           Dimensionen (hier 2) ab. Die Abbildungsfunktion wird so gewählt
           das die größtmögliche Varianz erhalten bleiben.
           <br>
           Es lässt sich leicht die Koalition von SPD und CDU ablesen, welche
           ein gleiches Abstimmungverhalten zeigen und zusammen ein Cluster bilden.
           Außerdem zeigt sich, dass das Cluster der AFD am weitesten entfernt zu den
           anderen Parteinclustern liegt.
           <br>
           Doch wie aussagekräftig ist die Abbildung auf 2 Dimensionen? Dies
           wird mit dem Plot 'Erklärte Varianz' gezeigt.
           ",
         "plot_PCA_varience_explained" =
           "<h2> Erklärte Varianz durch die Hauptkomponenten</h2><br>
           Bereites die erste Hauptkomponente erklärt 50% der (linearen)
           Varianz. Die Zweite folgt mit 26%, die Dritte mit 13%.
           Mit diesen drei Komponenten sind also mit 89% ein Großteil 
           der Varianz erklärt.<br>
           Eine Analyse der Abstimmungsgewichte und -inhalte könnte zeigen, inwieweit
           die Hauptkomponenten mit klassischen politischen Dimensionen 
           verknüpft sind. Die erste Hauptkomponente hat zweifelsohne einen
           starken Zusammenhang zu der Dimension <em>Regierung - Opposition</em>. Die
           zweite Hauptkomponente könnte beispielsweise mit der 
           Dimension <em>progessiv - konservativ</em> korrelieren.
           ",
         "plot_PCA_3D" =
           "<h2> Abstimmungsverhalten auf 3 Dimensionen projeziert</h2><br>
           Zusätzlich zu den Clustern, welche in den ersten beiden
           Hauptkomponenten zu sehen sind, lässt sich mit der dritten 
           Hauptkomponente die FDP klarer von den anderen Partein abgrenzen. 
           Einzelne Besonderheiten könnten noch genauer untersucht werden - 
           An welchen Abstimmungen lassen sich die Abstände zur eigenen Partei
           festmachen?
           "
           )
