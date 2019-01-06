breed [farmer a-farmer]
breed [constructor a-constructor]
breed [graduate a-graduate]
breed [businessman a-businessman]
turtles-own [happiness far cons grad busi]       ;; both wolves and sheep have energy


to setup
  clear-all
  set-default-shape farmer "person farmer"
  set-default-shape constructor "person construction"
  set-default-shape graduate "person graduate"
  set-default-shape businessman "person business"

  create-farmer initial-farmer
  [ set size 1.5
    set happiness hap
    set far farmer-to-farmer
    set cons farmer-to-const
    set grad farmer-to-grad
    set busi farmer-to-busi
    setxy random-xcor random-ycor
  ]

  create-constructor initial-constructor
  [ set size 1.5
    set happiness hap
    set far const-to-farmer
    set cons const-to-const
    set grad const-to-grad
    set busi const-to-busi
    setxy random-xcor random-ycor
  ]
  create-graduate initial-grad
  [ set size 1.5
    set happiness hap
    set far grad-to-farmer
    set cons grad-to-const
    set grad grad-to-grad
    set busi grad-to-busi
    setxy random-xcor random-ycor
  ]
  create-businessman initial-busi
  [ set size 1.5
    set happiness hap
    set far busi-to-farmer
    set cons busi-to-const
    set grad busi-to-grad
    set busi busi-to-busi
    setxy random-xcor random-ycor
  ]
reset-ticks
end

to go
 ask turtles
 [
  move
  interact
 ]
  tick
 end

to move  ;; turtle procedure
  rt random 50
  lt random 50
  fd 1
end

to interact

if breed = farmer
  [
 let hifarmer one-of farmer-here
  if ((hifarmer != nobody) and (hifarmer != self))
    [let val (far / 10)
      ask hifarmer
     [
       set far (far + val)
       set happiness (happiness + val)
       if happiness > 100           [set happiness 100]
       if happiness < 0             [set happiness 0]
       if far > 100                 [set far 100]
       if far < -100                [set far -100]
        ]
      ]]

 if breed = farmer
  [
   let hiconstructor one-of constructor-here
  if hiconstructor != nobody
 [let val (cons / 10)
      ask hiconstructor
     [
       set far (far + val)
       set happiness (happiness + val)
       if happiness > 100           [set happiness 100]
       if happiness < 0             [set happiness 0]
       if far > 100                 [set far 100]
       if far < -100                [set far -100]
        ]
      ]]

  if breed = farmer
  [
  let higraduate one-of graduate-here
  if higraduate != nobody
 [let val (grad / 10)
      ask higraduate
     [
       set far (far + val)
       set happiness (happiness + val)
       if happiness > 100           [set happiness 100]
       if happiness < 0             [set happiness 0]
       if far > 100                 [set far 100]
       if far < -100                [set far -100]
        ]
      ]]

   if breed = farmer
  [
  let hibusi one-of businessman-here
  if hibusi != nobody
 [let val (busi / 10)
      ask hibusi
     [
       set far (far + val)
       set happiness (happiness + val)
       if happiness > 100           [set happiness 100]
       if happiness < 0             [set happiness 0]
       if far > 100                 [set far 100]
       if far < -100                [set far -100]
        ]
      ]]





 if breed = constructor
  [
 let hifarmer one-of farmer-here
  if (hifarmer != nobody)
    [let val (far / 10)
      ask hifarmer
     [
       set cons (cons + val)
       set happiness (happiness + val)
       if happiness > 100           [set happiness 100]
       if happiness < 0             [set happiness 0]
       if cons > 100                 [set cons 100]
       if cons < -100                [set cons -100]
        ]
      ]]

 if breed = constructor
  [
   let hiconstructor one-of constructor-here
  if ((hiconstructor != nobody and hiconstructor != self))
 [let val (cons / 10)
      ask hiconstructor
     [
       set cons (cons + val)
       set happiness (happiness + val)
       if happiness > 100           [set happiness 100]
       if happiness < 0             [set happiness 0]
       if cons > 100                 [set cons 100]
       if cons < -100                [set cons -100]
        ]
      ]]

  if breed = constructor
  [
  let higraduate one-of graduate-here
  if higraduate != nobody
 [let val (grad / 10)
      ask higraduate
     [
       set cons (cons + val)
       set happiness (happiness + val)
       if happiness > 100           [set happiness 100]
       if happiness < 0             [set happiness 0]
       if cons > 100                 [set cons 100]
       if cons < -100                [set cons -100]
        ]
      ]]

   if breed = constructor
  [
  let hibusi one-of businessman-here
  if hibusi != nobody
 [let val (busi / 10)
      ask hibusi
     [
       set cons (cons + val)
       set happiness (happiness + val)
       if happiness > 100           [set happiness 100]
       if happiness < 0             [set happiness 0]
       if cons > 100                 [set cons 100]
       if cons < -100                [set cons -100]
        ]
      ]]





if breed = graduate
  [
 let hifarmer one-of farmer-here
  if (hifarmer != nobody)
    [let val (far / 10)
      ask hifarmer
     [
       set grad (grad + val)
       set happiness (happiness + val)
       if happiness > 100           [set happiness 100]
       if happiness < 0             [set happiness 0]
       if grad > 100                 [set grad 100]
       if grad < -100                [set grad -100]
        ]
      ]]

 if breed = graduate
  [
   let hiconstructor one-of constructor-here
  if (hiconstructor != nobody)
 [let val (cons / 10)
      ask hiconstructor
     [
       set grad (grad + val)
       set happiness (happiness + val)
       if happiness > 100           [set happiness 100]
       if happiness < 0             [set happiness 0]
       if grad > 100                 [set grad 100]
       if grad < -100                [set grad -100]
        ]
      ]]

  if breed = graduate
  [
  let higraduate one-of graduate-here
  if (higraduate != nobody and higraduate != self)
 [let val (grad / 10)
      ask higraduate
     [
       set grad (grad + val)
       set happiness (happiness + val)
       if happiness > 100           [set happiness 100]
       if happiness < 0             [set happiness 0]
       if grad > 100                 [set grad 100]
       if grad < -100                [set grad -100]
        ]
      ]]

   if breed = graduate
  [
  let hibusi one-of businessman-here
  if hibusi != nobody
 [let val (busi / 10)
      ask hibusi
     [
       set grad (grad + val)
       set happiness (happiness + val)
       if happiness > 100           [set happiness 100]
       if happiness < 0             [set happiness 0]
       if grad > 100                 [set grad 100]
       if grad < -100                [set grad -100]
        ]
      ]]






if breed = businessman
  [
 let hifarmer one-of farmer-here
  if (hifarmer != nobody)
    [let val (far / 10)
      ask hifarmer
     [
       set busi (busi + val)
       set happiness (happiness + val)
       if happiness > 100           [set happiness 100]
       if happiness < 0             [set happiness 0]
       if busi > 100                 [set busi 100]
       if busi < -100                [set busi -100]
        ]
      ]]

 if breed = businessman
  [
   let hiconstructor one-of constructor-here
  if (hiconstructor != nobody)
 [let val (cons / 10)
      ask hiconstructor
     [
       set busi (busi + val)
       set happiness (happiness + val)
       if happiness > 100           [set happiness 100]
       if happiness < 0             [set happiness 0]
       if busi > 100                 [set busi 100]
       if busi < -100                [set busi -100]
        ]
      ]]

  if breed = businessman
  [
  let higraduate one-of graduate-here
  if (higraduate != nobody)
 [let val (grad / 10)
      ask higraduate
     [
       set busi (busi + val)
       set happiness (happiness + val)
       if happiness > 100           [set happiness 100]
       if happiness < 0             [set happiness 0]
       if busi > 100                 [set busi 100]
       if busi < -100                [set busi -100]
        ]
      ]]

   if breed = businessman
  [
  let hibusi one-of businessman-here
  if (hibusi != nobody  and hibusi != self)
 [let val (busi / 10)
      ask hibusi
     [
       set busi (busi + val)
       set happiness (happiness + val)
       if happiness > 100           [set happiness 100]
       if happiness < 0             [set happiness 0]
       if busi > 100                 [set busi 100]
       if busi < -100                [set busi -100]
        ]
      ]]
end


to-report farmer-happiness
  let FH 0
  ask farmer
  [set FH (FH + happiness)
  ]
  set FH (FH / initial-farmer)
  report FH
end

to-report constructor-happiness
  let CH 0
  ask constructor
  [set CH (CH + happiness)
  ]
  set CH (CH / initial-constructor)
  report CH
end

to-report graduate-happiness
  let GH 0
  ask graduate
  [set GH (GH + happiness)
  ]
  set GH (GH / initial-grad)
  report GH
end

to-report businessman-happiness
  let BH 0
  ask businessman
  [set BH (BH + happiness)
  ]
  set BH (BH / initial-busi)
  report BH
end

to-report farmer-empathy
  let FE 0
  ask turtles
  [set FE (FE + far)]
  set FE (FE / initial-farmer)
  report FE
end

to-report constructor-empathy
  let CE 0
  ask turtles
  [set CE (CE + cons)]
  set CE (CE / initial-constructor)
  report CE
end

to-report graduate-empathy
  let GE 0
  ask turtles
  [set GE (GE + grad)]
  set GE (GE / initial-grad)
  report GE
end

to-report busi-empathy
  let BE 0
  ask turtles
  [set BE (BE + busi)]
  set BE (BE / initial-busi)
  report BE
end
; Copyright 1997 Uri Wilensky.
; See Info tab for full copyright and license.
@#$#@#$#@
GRAPHICS-WINDOW
222
75
944
602
-1
-1
14.0
1
14
1
1
1
0
1
1
1
-25
25
-18
18
1
1
1
ticks
30.0

BUTTON
14
10
83
43
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
102
11
169
44
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
10
93
182
126
initial-farmer
initial-farmer
0
100
24.0
1
1
NIL
HORIZONTAL

SLIDER
7
269
179
302
initial-constructor
initial-constructor
0
100
41.0
1
1
NIL
HORIZONTAL

SLIDER
9
53
181
86
hap
hap
0
100
43.0
1
1
NIL
HORIZONTAL

SLIDER
35
131
210
164
farmer-to-farmer
farmer-to-farmer
-100
100
-29.0
1
1
NIL
HORIZONTAL

SLIDER
35
163
210
196
farmer-to-const
farmer-to-const
-100
100
13.0
1
1
NIL
HORIZONTAL

SLIDER
35
196
210
229
farmer-to-grad
farmer-to-grad
-100
100
53.0
1
1
NIL
HORIZONTAL

SLIDER
35
228
210
261
farmer-to-busi
farmer-to-busi
-100
100
28.0
1
1
NIL
HORIZONTAL

SLIDER
35
340
207
373
const-to-const
const-to-const
-100
100
-17.0
1
1
NIL
HORIZONTAL

SLIDER
35
307
207
340
const-to-farmer
const-to-farmer
-100
100
-24.0
1
1
NIL
HORIZONTAL

SLIDER
35
373
207
406
const-to-grad
const-to-grad
-100
100
-93.0
1
1
NIL
HORIZONTAL

SLIDER
35
405
207
438
const-to-busi
const-to-busi
-100
100
-13.0
1
1
NIL
HORIZONTAL

SLIDER
6
446
178
479
initial-grad
initial-grad
0
100
48.0
1
1
NIL
HORIZONTAL

SLIDER
36
486
208
519
grad-to-farmer
grad-to-farmer
-100
100
-16.0
1
1
NIL
HORIZONTAL

SLIDER
36
519
208
552
grad-to-const
grad-to-const
-100
100
22.0
1
1
NIL
HORIZONTAL

SLIDER
36
552
208
585
grad-to-grad
grad-to-grad
-100
100
99.0
1
1
NIL
HORIZONTAL

SLIDER
36
585
208
618
grad-to-busi
grad-to-busi
-100
100
22.0
1
1
NIL
HORIZONTAL

SLIDER
8
626
180
659
initial-busi
initial-busi
0
100
78.0
1
1
NIL
HORIZONTAL

SLIDER
39
666
211
699
busi-to-farmer
busi-to-farmer
-100
100
-38.0
1
1
NIL
HORIZONTAL

SLIDER
39
699
211
732
busi-to-const
busi-to-const
-100
100
-3.0
1
1
NIL
HORIZONTAL

SLIDER
39
732
211
765
busi-to-grad
busi-to-grad
-100
100
-23.0
1
1
NIL
HORIZONTAL

SLIDER
39
765
211
798
busi-to-busi
busi-to-busi
-100
100
2.0
1
1
NIL
HORIZONTAL

PLOT
958
12
1453
328
Average Happiness
time
Happines
0.0
10.0
0.0
100.0
true
true
"" ""
PENS
"Farmer" 1.0 0 -13210332 true "" "plot farmer-happiness"
"Constructor" 1.0 0 -8431303 true "" "plot constructor-happiness"
"Graduate" 1.0 0 -14070903 true "" "plot graduate-happiness"
"Businessman" 1.0 0 -5298144 true "" "plot businessman-happiness"

PLOT
958
334
1453
662
Average Empathy
time
Empathy
0.0
10.0
0.0
100.0
true
true
"" ""
PENS
"Farmer" 1.0 0 -13210332 true "" "plot farmer-empathy"
"Constructor" 1.0 0 -10402772 true "" "plot constructor-empathy"
"Graduate" 1.0 0 -14070903 true "" "plot graduate-empathy"
"Businessman" 1.0 0 -5298144 true "" "plot busi-empathy"

TEXTBOX
442
10
697
70
Group Compassion
25
0.0
1

@#$#@#$#@
## Does Love trump Hate?


	This short essay attempts to provide an answer to the guiding question by providing a very simple model for human interaction among different groups, and for empathic reactions and adjustments. The upshot is to study the conditions in which a population with different groups of people may overcome antipathy given some starting conditions. The model, although very simplistic, has the advantage of being very simple.

	Let us start with a total population of m individuals. This population is partitioned in k distinct groups 1, 2, 3, …, k; where each group i has a population mi and m1 + m2 + … + mk = m. Individuals of these groups walk freely through a space and have a certain chance of bumping into other individuals of any population. The simplest way to represent this is to say that the chances of an individual A to bump into a member of group i is the proportion of the total population of group i over the total population, namely mi / m. It is reasonable to object that due to segregation and other considerations these chances are unjustified; but let me proceed with the simplest case and the reader can adjust the framework for more complicated scenarios providing a “bumping” function of the relevant form.
	Now each individual is augmented with some empathy level for each of the groups in the population. These empathy levels are a numeric value that capture all the biases, stereotypes and preconceptions that individuals have about all the groups (including the one it belongs to).
	The basic idea of the model is that when two agents interact, they are nice or mean to each other according to the empathy level they have towards the group of the other agent. As a result of such interaction, their empathy levels are updated. If A was nice to B, then B will be happier and also will adjust positively its empathy level for A’s group. If A was mean to B, the opposite happens. Say GA and GB are A’s and B’s groups respectively. Also, let EA(GB) be the prior empathy that A has towards B’s group, and analogously for EB(GA). An interaction between A and B is a transformation of EA(GB) and EB(GA) into E’A(GB) and E’B(GA). This function seem natural:

    • E’A(GB) = EA(GB) + β.EB(GA)

	So A’s new perception of B’s group is a function of her previous one plus whether B treated her nicely or not – which is also a function of the empathy B has towards A’s group. β is just a positive parameter that felt relevant to add. Analogous functions are needed for B too. In general, the average empathy that members of GA will have over members of GB , and the converse, are:

    • AVE’A(GB) = AVEA(GB) + [mB / m].β.AVEB(GA)
    • AVE’B(GA) = AVEB(GA) + [mA / m].α.AVEA(GB)

	This gives us an Empathy Dynamics between the groups. Things can go very bad, very good or find some equilibrium. The question of whether love trumps hate can now be represented here. Suppose GA is a majority, so mA > mB. Also, suppose members of GA are highly biased against members of GA, so that AVEA(GB) < 0. What can members of GB do in order to compensate for their unpleasant situation? Well: Love. This is, compensate the hate of members of GA by treating them nicely. In a nutshell, have AVEA(GB) >> 0. How much love? Actually, a lot. They need to compensate for being a minority, for the terrible behavior of the A-people, and for the parameters α and β. But since A-people react positively to B-people’s niceness, there is room for hope.

	Details of the equilibria are left for the curious reader to solve. The approach can be easily generalized to a finite amount of groups. Also, I can provide some online simulations for the reader to enjoy visualizing the procedure.

	Does Love trump Hate? Yes, but loving can be very hard.

## The Present Model

The present model only takes into account four classes: farmer, constructor, graduate student, and businessman.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

person business
false
0
Rectangle -1 true false 120 90 180 180
Polygon -13345367 true false 135 90 150 105 135 180 150 195 165 180 150 105 165 90
Polygon -7500403 true true 120 90 105 90 60 195 90 210 116 154 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 183 153 210 210 240 195 195 90 180 90 150 165
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 76 172 91
Line -16777216 false 172 90 161 94
Line -16777216 false 128 90 139 94
Polygon -13345367 true false 195 225 195 300 270 270 270 195
Rectangle -13791810 true false 180 225 195 300
Polygon -14835848 true false 180 226 195 226 270 196 255 196
Polygon -13345367 true false 209 202 209 216 244 202 243 188
Line -16777216 false 180 90 150 165
Line -16777216 false 120 90 150 165

person construction
false
0
Rectangle -7500403 true true 123 76 176 95
Polygon -1 true false 105 90 60 195 90 210 115 162 184 163 210 210 240 195 195 90
Polygon -13345367 true false 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Circle -7500403 true true 110 5 80
Line -16777216 false 148 143 150 196
Rectangle -16777216 true false 116 186 182 198
Circle -1 true false 152 143 9
Circle -1 true false 152 166 9
Rectangle -16777216 true false 179 164 183 186
Polygon -955883 true false 180 90 195 90 195 165 195 195 150 195 150 120 180 90
Polygon -955883 true false 120 90 105 90 105 165 105 195 150 195 150 120 120 90
Rectangle -16777216 true false 135 114 150 120
Rectangle -16777216 true false 135 144 150 150
Rectangle -16777216 true false 135 174 150 180
Polygon -955883 true false 105 42 111 16 128 2 149 0 178 6 190 18 192 28 220 29 216 34 201 39 167 35
Polygon -6459832 true false 54 253 54 238 219 73 227 78
Polygon -16777216 true false 15 285 15 255 30 225 45 225 75 255 75 270 45 285

person doctor
false
0
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -13345367 true false 135 90 150 105 135 135 150 150 165 135 150 105 165 90
Polygon -7500403 true true 105 90 60 195 90 210 135 105
Polygon -7500403 true true 195 90 240 195 210 210 165 105
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -1 true false 105 90 60 195 90 210 114 156 120 195 90 270 210 270 180 195 186 155 210 210 240 195 195 90 165 90 150 150 135 90
Line -16777216 false 150 148 150 270
Line -16777216 false 196 90 151 149
Line -16777216 false 104 90 149 149
Circle -1 true false 180 0 30
Line -16777216 false 180 15 120 15
Line -16777216 false 150 195 165 195
Line -16777216 false 150 240 165 240
Line -16777216 false 150 150 165 150

person farmer
false
0
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -1 true false 60 195 90 210 114 154 120 195 180 195 187 157 210 210 240 195 195 90 165 90 150 105 150 150 135 90 105 90
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -13345367 true false 120 90 120 180 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 180 90 172 89 165 135 135 135 127 90
Polygon -6459832 true false 116 4 113 21 71 33 71 40 109 48 117 34 144 27 180 26 188 36 224 23 222 14 178 16 167 0
Line -16777216 false 225 90 270 90
Line -16777216 false 225 15 225 90
Line -16777216 false 270 15 270 90
Line -16777216 false 247 15 247 90
Rectangle -6459832 true false 240 90 255 300

person graduate
false
0
Circle -16777216 false false 39 183 20
Polygon -1 true false 50 203 85 213 118 227 119 207 89 204 52 185
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -8630108 true false 90 19 150 37 210 19 195 4 105 4
Polygon -8630108 true false 120 90 105 90 60 195 90 210 120 165 90 285 105 300 195 300 210 285 180 165 210 210 240 195 195 90
Polygon -1184463 true false 135 90 120 90 150 135 180 90 165 90 150 105
Line -2674135 false 195 90 150 135
Line -2674135 false 105 90 150 135
Polygon -1 true false 135 90 150 105 165 90
Circle -1 true false 104 205 20
Circle -1 true false 41 184 20
Circle -16777216 false false 106 206 18
Line -2674135 false 208 22 208 57

person lumberjack
false
0
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -2674135 true false 60 196 90 211 114 155 120 196 180 196 187 158 210 211 240 196 195 91 165 91 150 106 150 135 135 91 105 91
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -6459832 true false 174 90 181 90 180 195 165 195
Polygon -13345367 true false 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Polygon -6459832 true false 126 90 119 90 120 195 135 195
Rectangle -6459832 true false 45 180 255 195
Polygon -16777216 true false 255 165 255 195 240 225 255 240 285 240 300 225 285 195 285 165
Line -16777216 false 135 165 165 165
Line -16777216 false 135 135 165 135
Line -16777216 false 90 135 120 135
Line -16777216 false 105 120 120 120
Line -16777216 false 180 120 195 120
Line -16777216 false 180 135 210 135
Line -16777216 false 90 150 105 165
Line -16777216 false 225 165 210 180
Line -16777216 false 75 165 90 180
Line -16777216 false 210 150 195 165
Line -16777216 false 180 105 210 180
Line -16777216 false 120 105 90 180
Line -16777216 false 150 135 150 165
Polygon -2674135 true false 100 30 104 44 189 24 185 10 173 10 166 1 138 -1 111 3 109 28

person police
false
0
Polygon -1 true false 124 91 150 165 178 91
Polygon -13345367 true false 134 91 149 106 134 181 149 196 164 181 149 106 164 91
Polygon -13345367 true false 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Polygon -13345367 true false 120 90 105 90 60 195 90 210 116 158 120 195 180 195 184 158 210 210 240 195 195 90 180 90 165 105 150 165 135 105 120 90
Rectangle -7500403 true true 123 76 176 92
Circle -7500403 true true 110 5 80
Polygon -13345367 true false 150 26 110 41 97 29 137 -1 158 6 185 0 201 6 196 23 204 34 180 33
Line -13345367 false 121 90 194 90
Line -16777216 false 148 143 150 196
Rectangle -16777216 true false 116 186 182 198
Rectangle -16777216 true false 109 183 124 227
Rectangle -16777216 true false 176 183 195 205
Circle -1 true false 152 143 9
Circle -1 true false 152 166 9
Polygon -1184463 true false 172 112 191 112 185 133 179 133
Polygon -1184463 true false 175 6 194 6 189 21 180 21
Line -1184463 false 149 24 197 24
Rectangle -16777216 true false 101 177 122 187
Rectangle -16777216 true false 179 164 183 186

person service
false
0
Polygon -7500403 true true 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Polygon -1 true false 120 90 105 90 60 195 90 210 120 150 120 195 180 195 180 150 210 210 240 195 195 90 180 90 165 105 150 165 135 105 120 90
Polygon -1 true false 123 90 149 141 177 90
Rectangle -7500403 true true 123 76 176 92
Circle -7500403 true true 110 5 80
Line -13345367 false 121 90 194 90
Line -16777216 false 148 143 150 196
Rectangle -16777216 true false 116 186 182 198
Circle -1 true false 152 143 9
Circle -1 true false 152 166 9
Rectangle -16777216 true false 179 164 183 186
Polygon -2674135 true false 180 90 195 90 183 160 180 195 150 195 150 135 180 90
Polygon -2674135 true false 120 90 105 90 114 161 120 195 150 195 150 135 120 90
Polygon -2674135 true false 155 91 128 77 128 101
Rectangle -16777216 true false 118 129 141 140
Polygon -2674135 true false 145 91 172 77 172 101

person soldier
false
0
Rectangle -7500403 true true 127 79 172 94
Polygon -10899396 true false 105 90 60 195 90 210 135 105
Polygon -10899396 true false 195 90 240 195 210 210 165 105
Circle -7500403 true true 110 5 80
Polygon -10899396 true false 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -6459832 true false 120 90 105 90 180 195 180 165
Line -6459832 false 109 105 139 105
Line -6459832 false 122 125 151 117
Line -6459832 false 137 143 159 134
Line -6459832 false 158 179 181 158
Line -6459832 false 146 160 169 146
Rectangle -6459832 true false 120 193 180 201
Polygon -6459832 true false 122 4 107 16 102 39 105 53 148 34 192 27 189 17 172 2 145 0
Polygon -16777216 true false 183 90 240 15 247 22 193 90
Rectangle -6459832 true false 114 187 128 208
Rectangle -6459832 true false 177 187 191 208

person student
false
0
Polygon -13791810 true false 135 90 150 105 135 165 150 180 165 165 150 105 165 90
Polygon -7500403 true true 195 90 240 195 210 210 165 105
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Polygon -1 true false 100 210 130 225 145 165 85 135 63 189
Polygon -13791810 true false 90 210 120 225 135 165 67 130 53 189
Polygon -1 true false 120 224 131 225 124 210
Line -16777216 false 139 168 126 225
Line -16777216 false 140 167 76 136
Polygon -7500403 true true 105 90 60 195 90 210 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.2
@#$#@#$#@
setup
set grass? true
repeat 75 [ go ]
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
