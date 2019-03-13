extensions [ nw ]

turtles-own [
  ; General variable


  ; Segregation variables
  happy?
  similar-nearby      ;; how many neighboring patches have a turtle with my color?
  other-nearby        ;; how many have a turtle of another color?
  total-nearby        ;; sum of previous two variables
  my-%-similar-wanted ;; the threshold for this particular turtle
]

globals [
  ; General Variables
 X

; Segregation Variables
  percent-similar   ;; on the average, what percent of a turtle's neighbors
                    ;; are the same color as that turtle?
  percent-unhappy   ;; what percent of the turtles are unhappy?
  colors            ;; a list of colors we use to color the turtles
  init-global-clust ;; just that
  init-unhappiness
]

; CREATE NODES
to setup
  clear-all
  reset-ticks
  create-turtles num-nodes [
    set shape "person"
    setxy random-xcor random-ycor
  ]
  reset-ticks
end

; CREATE NETWORKS

; Erdos-Renyi

to setupER1
  setup
  ask links [ die ]
  let max-links ((num-nodes * (num-nodes - 1)) / 2)
  if num-links > max-links [ set num-links max-links ]
  while [ count links < num-links ] [
    ask one-of turtles [
      create-link-with one-of other turtles
    ]]
end

to setupER2
clear-all
reset-ticks
create-turtles (num-links + 1) [
    set shape "person"
    setxy random-xcor random-ycor
  ]
reset-ticks
ask links [ die ]
let max-links ((num-nodes * (num-nodes - 1)) / 2)
if num-links > max-links [ set num-links max-links ]
while [ count links < num-links ] [
    ask one-of turtles [
    create-link-with one-of other turtles
    ]]
end

to setupER3
setup
ask links [ die ]
ask turtles [
    ask turtles with [ who > [ who ] of myself ] [
      if random-float 1.0 < link-prob [
        create-link-with myself
      ]]]
end

; Preferential Attachment

to setupPA2
clear-all
nw:generate-preferential-attachment turtles links (num-links + 1) [
set shape "person"
setxy random-xcor random-ycor
 ]
 reset-ticks
end

to setupPA
clear-all
make-node nobody
make-node turtle 0
reset-ticks
pref-att
ask turtles [setxy random-xcor random-ycor]
reset-ticks
end

to pref-att
  while [(count links) < num-links] [
  ask links [ set color gray ]
  make-node find-partner]
  reset-ticks
end

to make-node [old-node]
  create-turtles 1
  [set shape "person"
   if old-node != nobody
  [create-link-with old-node]]
end

to-report find-partner
  report [one-of both-ends] of one-of links
end

; N-Neighbors
to setup-n-neighbors ; This setup will give an error if using an odd number of agents, or a very small amount relative to the expected number of neighbors. Otherwise it will work.
  ask links [die]
  let n 0
  while [n < n-neighbors] [
    setup-1-neighbor
    set n n + 1]
  ask links [set color grey]
end

to setup-1-neighbor
  ask turtles [
     if (count my-links with [color = grey] = 0) [create-link-with one-of other turtles with [count my-links with [color = grey] = 0]]]
  ask links [set color blue]
end


; Small World
; http://ccl.northwestern.edu/netlogo/docs/nw.html#nw:generate-small-world
to ws.network
  clear-all
  nw:generate-watts-strogatz turtles links num-nodes n-links rewire-prob [fd 10]
  ask turtles [set shape "person"]
  layout-circle (sort turtles) max-pxcor - 1
  ; https://en.wikipedia.org/wiki/Watts%E2%80%93Strogatz_model
end

to kl.network
  clear-all
  nw:generate-small-world turtles links lattice.rows lattice.columns clustering-exponent true
  ask turtles [set shape "person"]
  layout-circle (sort turtles) max-pxcor - 1
  ; https://en.wikipedia.org/wiki/Small-world_routing#The_Kleinberg_Model
end

to twod.lattice
  clear-all
  nw:generate-lattice-2d turtles links lattice.rows lattice.columns false
  ask turtles [set shape "person"]
end

to ring.nw
  clear-all
  create-turtles num-nodes
  layout-circle (sort turtles) max-pxcor - 5
  wire-them
  ask turtles [set shape "person"]
end

to wire-them
  ;; iterate over the turtles
  let n 0
  while [n < count turtles][
    let m 0
    while [m < n-links] [
    ;; make edges with the next two neighbors
    ;; this makes a lattice with average degree of 4
    set m m + 1
    ask turtle n [create-link-with turtle ((n + m) mod count turtles)]]
  set n n + 1]
end

to star.nw
  clear-all
  nw:generate-star turtles links num-nodes
  let n ([who] of max-one-of turtles [count my-links])
  layout-radial turtles links (turtle n)
  ask turtles [set shape "person"]
end

to wheel.nw
  clear-all
  nw:generate-wheel turtles links num-nodes
  let n ([who] of max-one-of turtles [count my-links])
  layout-radial turtles links (turtle n)
  ask turtles [set shape "person"]
end

; GENERALIZED SEGREGATION

; First simple model with 2 tribes
to setup-segregation
  reset-ticks
  clear-plot
  ask turtles [set color red]
  set X (precision ((%-blue * count turtles) / 100) 0)
  while [(count turtles with [color = blue]) < X]
    [ask one-of turtles [set color blue]]
  ask turtles [set my-%-similar-wanted random %-similar-wanted]
  update-turtles
  update-globals
  set init-global-clust (mean [ nw:clustering-coefficient ] of turtles)
  set init-unhappiness (count turtles with [not happy?]) / (count turtles) * 100
  tick
end

; Multi Tribe Model

to setup-multi-segregation
  reset-ticks
  clear-plot
  set colors [red blue green brown violet]
  ask turtles
   [ set color (item (random number-of-tribes) colors)
      set my-%-similar-wanted random %-similar-wanted]
  update-turtles
  update-globals
  set init-global-clust (mean [ nw:clustering-coefficient ] of turtles)
  set init-unhappiness (count turtles with [not happy?]) / (count turtles) * 100
  tick
end

to go-segregation
  if (all? turtles [happy?]) [ save-segregation-data stop ]
  if (stop-condition = true ) [ save-segregation-data stop ]
  relink
  update-turtles
  update-globals
  tick
end

to relink
  ask turtles with [ not happy? ]
  [let L (count my-links)
   ifelse (relink-all? = 1)
    [ask my-links [die]]
    [if (L > 0) [ask one-of my-links [die]]]
   while [count my-links < L] [create-link-with one-of other turtles]]
end



; Generalizing Schiller's Topology (Two tribes)
to setup-top-segregation
  reset-ticks
  clear-plot
  ask turtles [set shape "circle"]
  ;Grey positions are initially unoccupied
  ask turtles [set color grey]
  ; Now we leave %-free positions, and occupy the rest with colors red and blue in proportion %-blue
  set X (precision (((100 - %-free) * count turtles) / 100) 0)
  while [(count turtles with [color = red]) < X]
    [ask one-of turtles [set color red]]

  set X (precision ((%-blue * count turtles with [color = red]) / 100) 0)
  while [(count turtles with [color = blue]) < X]
    [ask one-of turtles with [color = red] [set color blue]]

  ask turtles [set my-%-similar-wanted random %-similar-wanted]
  update-turtles
  update-globals
  set init-global-clust (mean [ nw:clustering-coefficient ] of turtles)
  set init-unhappiness (count turtles with [not happy?]) / (count turtles) * 100
  tick
end

; Now multiple tribes

to setup-multi-top-segregation
  reset-ticks
  clear-plot
  ask turtles [set shape "circle"]
  ask turtles [set color grey]
  set X (precision (((100 - %-free) * count turtles) / 100) 0)

  set colors [red blue green brown violet]
  while [(count turtles with [color != grey]) < X]
    [ask one-of turtles [set color (item (random number-of-tribes) colors)]]
  ask turtles [set my-%-similar-wanted random %-similar-wanted]
  update-turtles
  update-globals
  set init-global-clust (mean [ nw:clustering-coefficient ] of turtles)
  set init-unhappiness (count turtles with [not happy?]) / (count turtles) * 100
  tick
end

to go-top-segregation
  if (all? turtles [happy?]) [ stop ]
  if (stop-condition = true ) [ stop ]
  relocate-unhappy-turtles
  update-turtles
  update-globals
  tick
end

to relocate-unhappy-turtles
  ask turtles with [ not happy? ]
  [if (color = red) [
    ask one-of turtles with [color = grey] [set color red]]
  if (color = blue) [
      ask one-of turtles with [color = grey] [set color blue]]
    set color grey
    set happy? true]
end

; General segregation functions
to update-turtles
  ask turtles [
    set similar-nearby count (link-neighbors)
      with [color = [color] of myself]

    ;; count the total number of my neighbors
    set total-nearby count (link-neighbors)

    ;; count the number of my neighbors that are a different color than me
    set other-nearby count (link-neighbors)
      with [color != [color] of myself]

    ;; I’m happy if there are at least the minimal number of same-colored and different colored neighbors
    ; Turtles with no friends will be happyby default (total-nearby = 0)
    set happy? (similar-nearby >= ( my-%-similar-wanted * total-nearby / 100 )
                 and other-nearby >= ( %-different-wanted * total-nearby / 100 ))]
end

to update-globals
  let similar-neighbors sum [similar-nearby] of turtles
  let total-neighbors sum [total-nearby] of turtles
  set percent-similar (similar-neighbors / total-neighbors) * 100
  set percent-unhappy (count turtles with [not happy?]) / (count turtles) * 100
end

to save-segregation-data
set init-global-clust (mean [ nw:clustering-coefficient ] of turtles)
file-open "GenerSegreg.csv"
file-print (list ("") (count turtles) (%-blue) (link-prob) (count links) (init-global-clust) (init-unhappiness) (%-similar-wanted) (%-different-wanted)
    (relink-all?) (mean [ nw:clustering-coefficient ] of turtles) (percent-similar) (percent-unhappy) (ticks) (""))
file-close
end


to-report stop-condition
ifelse (ticks > 400)
  [report true]
  [report false]
end


; LAYOUT
to layout
  ;; the number 3 here is arbitrary; more repetitions slows down the
  ;; model, but too few gives poor layouts
  repeat 10 [
    ;; the more turtles we have to fit into the same amount of space,
    ;; the smaller the inputs to layout-spring we'll need to use
    let factor sqrt count turtles
    ;; numbers here are arbitrarily chosen for pleasing appearance
    layout-spring turtles links (1 / factor) (7 / factor) (16 / factor)
    display  ;; for smooth animation
  ]
  ;; don't bump the edges of the world
  let x-offset max [xcor] of turtles + min [xcor] of turtles
  let y-offset max [ycor] of turtles + min [ycor] of turtles
  ;; big jumps look funny, so only adjust a little each time
  set x-offset limit-magnitude x-offset 0.1
  set y-offset limit-magnitude y-offset 0.1
  ask turtles [ setxy (xcor - x-offset / 2) (ycor - y-offset / 2) ]
end

to-report limit-magnitude [number limit]
  if number > limit [ report limit ]
  if number < (- limit) [ report (- limit) ]
  report number
end

to layout2
    ;; the number 3 here is arbitrary; more repetitions slows down the
  ;; model, but too few gives poor layouts
  repeat 10 [
    ;; the more turtles we have to fit into the same amount of space,
    ;; the smaller the inputs to layout-spring we'll need to use
    let factor sqrt count turtles
    ;; numbers here are arbitrarily chosen for pleasing appearance
    layout-spring turtles links (1 / factor) (20 / factor) (40 / factor)
    display  ;; for smooth animation
  ]
  ;; don't bump the edges of the world
  let x-offset max [xcor] of turtles + min [xcor] of turtles
  let y-offset max [ycor] of turtles + min [ycor] of turtles
  ;; big jumps look funny, so only adjust a little each time
  set x-offset limit-magnitude x-offset 0.1
  set y-offset limit-magnitude y-offset 0.1
  ask turtles [ setxy (xcor - x-offset / 2) (ycor - y-offset / 2) ]
end
@#$#@#$#@
GRAPHICS-WINDOW
208
23
686
502
-1
-1
14.242424242424242
1
10
1
1
1
0
1
1
1
-16
16
-16
16
1
1
1
ticks
30.0

SLIDER
12
65
184
98
num-nodes
num-nodes
2
1000
300.0
1
1
NIL
HORIZONTAL

BUTTON
57
140
131
173
Setup
setup\nreset-ticks
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
695
103
867
136
num-links
num-links
0
1000
800.0
1
1
NIL
HORIZONTAL

BUTTON
696
138
810
171
Setup Links
setupER1\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
694
196
866
229
link-prob
link-prob
0
0.5
0.1
0.01
1
NIL
HORIZONTAL

BUTTON
695
233
781
266
Setup
setupER3
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
9
262
104
307
Max Links
max [count link-neighbors] of turtles
17
1
11

MONITOR
106
262
204
307
Min Links
min [count link-neighbors] of turtles
17
1
11

MONITOR
9
213
103
258
Number Links
count links
17
1
11

TEXTBOX
15
186
165
208
Reports
18
0.0
1

TEXTBOX
696
62
846
81
Erdős–Rényi
16
0.0
1

TEXTBOX
696
85
846
103
By number of links
12
0.0
1

TEXTBOX
696
176
846
194
By probability of links
12
0.0
1

MONITOR
105
213
204
258
Number Nodes
count turtles
17
1
11

MONITOR
7
403
202
448
Global Clustering Coefficient
precision (mean [ nw:clustering-coefficient ] of turtles) 5
17
1
11

MONITOR
9
452
201
497
Average Path Length
precision (nw:mean-path-length) 4
17
1
11

MONITOR
9
309
203
354
Average Degree
precision ((2 * count links) / count turtles) 3
17
1
11

BUTTON
786
330
861
363
Setup v2
setupPA2
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
51
21
140
54
Clear All
clear-all
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
699
272
849
329
Barabási–Albert\nPreferential Attachement
16
0.0
1

BUTTON
784
233
867
266
Setup v2
clear-all\nreset-ticks\nnw:generate-random turtles links num-nodes link-prob [ \nset shape \"person\"\nsetxy random-xcor random-ycor\n ]
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
696
330
782
363
Setup
setupPA
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
701
12
985
72
Network Formation
25
0.0
1

BUTTON
225
518
304
551
Layout
let D 0\nwhile [D < 10] [\nlayout\nset D (D + 1)]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
7
356
203
401
Avg. Degree / Number Nodes
precision ((2 * count links) / (count turtles ^ 2 )) 3
17
1
11

TEXTBOX
878
61
1028
80
Small World
16
0.0
1

BUTTON
872
151
1043
184
Watts–Strogatz model
ws.network
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
872
81
1044
114
n-links
n-links
0
20
2.0
1
1
NIL
HORIZONTAL

SLIDER
872
116
1044
149
rewire-prob
rewire-prob
0
1
0.05
0.01
1
NIL
HORIZONTAL

BUTTON
872
293
1044
326
Kleinberg Model
kl.network\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
872
187
1044
220
lattice.rows
lattice.rows
0
25
3.0
1
1
NIL
HORIZONTAL

SLIDER
872
223
1044
256
lattice.columns
lattice.columns
0
25
2.0
1
1
NIL
HORIZONTAL

SLIDER
872
257
1044
290
clustering-exponent
clustering-exponent
0
4
3.2
0.2
1
NIL
HORIZONTAL

BUTTON
872
365
1045
398
2D Lattice
twod.lattice\n; layout incomplete\nlet D 0\nwhile [D < 7] [\nlayout\nset D (D + 1)]
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
872
329
1044
362
Ring
ring.nw\n
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
873
401
1046
434
Star
star.nw\n\n
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
873
437
1045
470
Wheel
wheel.nw
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
1341
10
1552
82
Generalized T.S. Segregation
25
0.0
1

SLIDER
1219
133
1412
166
%-blue
%-blue
0
100
70.0
1
1
NIL
HORIZONTAL

BUTTON
1125
295
1195
328
Setup
setup-segregation
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
1474
74
1669
107
%-similar-wanted
%-similar-wanted
0
100
40.0
1
1
%
HORIZONTAL

SLIDER
1274
76
1471
109
%-different-wanted
%-different-wanted
0
100
40.0
1
1
%
HORIZONTAL

BUTTON
1200
295
1263
328
Go
go-segregation
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
699
406
866
439
n-neighbors
n-neighbors
0
25
2.0
1
1
NIL
HORIZONTAL

MONITOR
1356
695
1456
740
Percent Similar
percent-similar
17
1
11

MONITOR
1459
695
1570
740
Percent Unhappy
percent-unhappy
17
1
11

PLOT
1119
344
1660
691
Percentages
Time
%
0.0
25.0
0.0
100.0
true
true
"" ""
PENS
"% Similar" 1.0 0 -13345367 true "" "plot percent-similar"
"% Unhappy" 1.0 0 -2674135 true "" "plot percent-unhappy"

BUTTON
700
443
839
476
Setup N Neighbors
setup-n-neighbors
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
1584
176
1756
209
%-free
%-free
0
100
10.0
1
1
NIL
HORIZONTAL

TEXTBOX
1297
239
1447
277
Two Tribe Topolgy Dynamic Model
16
0.0
1

BUTTON
1300
292
1370
325
Setup
setup-top-segregation
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
1374
292
1442
325
Go
go-top-segregation
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
1532
132
1704
165
number-of-tribes
number-of-tribes
1
5
5.0
1
1
NIL
HORIZONTAL

TEXTBOX
702
378
852
396
N Random Neighbors
14
0.0
1

TEXTBOX
1134
240
1284
278
Two Tribes Relink Dynamic Model
16
0.0
1

TEXTBOX
1472
238
1622
276
Multi Tribe Relink Dynamic Model
16
0.0
1

BUTTON
1470
290
1544
323
Setup
setup-multi-segregation
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
1546
290
1609
323
Go
go-segregation
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1633
288
1707
321
Setup
setup-multi-top-segregation
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
1134
141
1284
159
Two Tribes:
14
0.0
1

TEXTBOX
1452
147
1602
165
Multi Tribe:
14
0.0
1

TEXTBOX
1135
187
1285
205
Relink Dynamic:
14
0.0
1

TEXTBOX
1448
188
1598
206
Topology Dynamic:
14
0.0
1

TEXTBOX
1637
236
1787
274
Muti Tribe Topology Dynamic
16
0.0
1

BUTTON
1711
288
1774
321
Go
go-top-segregation
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
421
547
509
580
Layout2
let D 0\nwhile [D < 10] [\nlayout2\nset D (D + 1)]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
1248
175
1391
220
relink-all?
relink-all?
0 1
1

@#$#@#$#@
## WHAT IS IT?

This project is currently under development, and the code might not be as elegant as desired yet. It is a unique code to study two different sets of questions related with social networks.

The basic tier of the project allows the user to generate a wide class of networks. In particular: Erdős–Rényi random networks by number of links of probabilitty of links, Barabási–Albert preferential attachment, and a wide class of small world networks.

One of the projects amounts to generalizing Thomas Schelling model for segregation, for the purpose of studying political polarization and tribalism. Schelling's model was originally designed for a grid. This is here generalized to networks in two ways, in analogy with preferential attachment/strategic network formation, and by generalizing the topology. This will be explained in more detail later.

The other project amounts to the study of Diffusion on a wide class of networks, using the SIS, SIR and other models for disease spread.

## HOW IT WORKS

Generating the networks is quite straightforward. If the resulting network in unpleasent to the eye, the layout button might help, and it uses a spring process.

Generalizing Schelling's segregation model is twofold.
On the one hand, given a network of any of the kinds available here, the setup button divides the population in two - red and blue - and each agent is regarded as "happy" if their percentage of desired similar and different neighbors are satisfied. At the next stage, those who are not happy erase all of their n links and generate n new uniformly random links (n might vary through agents). The idea is that if they are not happy with how similar or diverse their friends are, they seek new friends. So this generalization of Schelling is under the idea of strategic network formation.
On the other hand we have "A Different Model", which amounts to the more standard generalization of Schelling. Given a network, each node corresponds to a location in a topology. The setup locates blue and red agents in their nodes, and marks the free spots in green. At the next stage, unhappy agents move uniformly at random to a free spot, occupying it and leaving the previous free.
Since equilibria is not guaranteed in the long run, the code is set up to finish after a few hundred iterations.

The Diffusion model is quite self-explanatory. At each stage the virus has a certain chance to spread through the network, making suceptible (blue) agents infected (red), and infected agents either resistant (green) or dead (magenta). The process ends when there are no more infected individuals. It could go forever if resistance and death are set to 0.

## THINGS TO TRY

I am still exploring and running simulations to study correlations,

Just for a try, notice how dependent the success of the diffu
ssion is on the average degree of the network. Set the number of nodes to 250, and generate a few E-R random networks with link percentage 0.05. These will have roughlyan average degree of 12. Run a few diffusions on those networks with some parameters. Then do the same but now using ring networks (with 250 nodes and set n-links to 6 so that they have exactly average degree 12). If you used the same parameters,the amount of dead individuals as well as the time it took for the procedure to finish will be very close. But rings and random networks are very different; for example the average path length of the latter is very long while random networks have short average path length, and the converse holds for clustering degree.


## CREDITS AND REFERENCES

I do owe some of the codes to the netlogo library on networks. Proper references will be included later.
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
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="1000" runMetricsEveryStep="false">
    <setup>setupER3
setup-segregation</setup>
    <go>go-segregation</go>
    <enumeratedValueSet variable="n-neighbors">
      <value value="2"/>
    </enumeratedValueSet>
    <steppedValueSet variable="%-similar-wanted" first="20" step="20" last="40"/>
    <steppedValueSet variable="%-blue" first="30" step="20" last="70"/>
    <steppedValueSet variable="link-prob" first="0.02" step="0.02" last="0.1"/>
    <enumeratedValueSet variable="lattice.columns">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="n-links">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="rewire-prob">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-links">
      <value value="800"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="%-free">
      <value value="10"/>
    </enumeratedValueSet>
    <steppedValueSet variable="%-different-wanted" first="0" step="20" last="40"/>
    <enumeratedValueSet variable="lattice.rows">
      <value value="3"/>
    </enumeratedValueSet>
    <steppedValueSet variable="relink-all?" first="0" step="1" last="1"/>
    <steppedValueSet variable="num-nodes" first="100" step="200" last="300"/>
    <enumeratedValueSet variable="clustering-exponent">
      <value value="3.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-tribes">
      <value value="5"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
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
