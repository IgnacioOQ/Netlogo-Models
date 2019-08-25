extensions [ nw ]

turtles-own [
  ; General variable


  ; Segregation variables
  happy?
  similar-nearby      ;; how many neighboring patches have a turtle with my color?
  other-nearby        ;; how many have a turtle of another color?
  total-nearby        ;; sum of previous two variables
]

globals [
  ; General Variables
 X

; Segregation Variables
  percent-similar   ;; on the average, what percent of a turtle's neighbors
                    ;; are the same color as that turtle?
  percent-unhappy   ;; what percent of the turtles are unhappy?
  glob-clust        ;; The current global clustering coefficient
  mean-clust        ;; The current mean clustering coefficient
  path-length       ;;
  colors            ;; a list of colors we use to color the turtles
  init-similar      ;; just that
  init-unhappiness  ;;
  init-glob-clust   ;;
  init-mean-clust   ;;
  init-path-length  ;;
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
to setupER3
setup
ask links [ die ]
ask turtles [
    ask turtles with [ who > [ who ] of myself ] [
      if random-float 1.0 < link-prob [
        create-link-with myself
      ]]]
end

to setup-random-directed
setup
ask links [ die ]
ask turtles [
    ask turtles with [ who > [ who ] of myself ] [
      if random-float 1.0 < link-prob [
        create-link-to myself]
      if random-float 1.0 < link-prob [
        create-link-from myself]
  ]]
end

to general-setup
  ifelse (directed? = true)
  [setup-random-directed]
  [setupER3]
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
  update-turtles
  update-globals
  set init-unhappiness percent-unhappy
  set init-similar percent-similar
  set init-glob-clust glob-clust
  set init-mean-clust mean-clust
  set init-path-length path-length
  tick
end

; Multi Tribe Model

to setup-multi-segregation
  reset-ticks
  clear-plot
  set colors [red blue green brown violet]
  ask turtles [set color (item (random number-of-tribes) colors)]
  update-turtles
  update-globals
  set init-unhappiness percent-unhappy
  set init-similar percent-similar
  set init-glob-clust glob-clust
  set init-mean-clust mean-clust
  set init-path-length path-length
  tick
end

; Dynamic
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
   ifelse (relink-all? = true)
    [ask my-links [die]]
    [if (L > 0) [ask one-of my-links [die]]]
   while [count my-links < L] [create-link-with one-of other turtles]]
end

to go-directed-segregation
  if (all? turtles [happy?]) [ save-segregation-data stop ]
  if (stop-condition = true ) [ save-segregation-data stop ]
  relink-directed
  update-turtles
  update-globals
  tick
end

to relink-directed
  ask turtles with [ not happy? ]
  [let L (count my-out-links)
   ifelse (relink-all? = true)
    [ask my-out-links [die]]
    [if (L > 0) [ask one-of my-out-links [die]]]
   while [count my-out-links < L] [create-link-to one-of other turtles]]
end

to general-go
  if (all? turtles [happy?]) [ save-segregation-data stop ]
  if (stop-condition = true ) [ save-segregation-data stop ]
  ifelse (directed? = true)
  [go-directed-segregation]
  [go-segregation]
end

; General segregation functions
to update-turtles
  ask turtles [
    ; Let us see how many turtles of the same tribe are being followed (or in neighborhood). Notice that "out-link-neighbors" counts directed links from the caller, or undirected links with the caller.
    set similar-nearby count (out-link-neighbors)
      with [color = [color] of myself]

    ;; count the total number of friends being followed(or in neighborhood)
    set total-nearby count (out-link-neighbors)

    ;; count the number of followed (or in neighborhood) that are of a different tribe
    set other-nearby count (out-link-neighbors)
      with [color != [color] of myself]

    ;; The agent happy if there are at least the minimal number of same-colored and different colored neighbors being followed (or in neighborhood)
    ; Turtles with no friends will be happyby default (total-nearby = 0)
    set happy? (similar-nearby >= ( %-similar-wanted * total-nearby / 100 )
                 and other-nearby >= ( %-different-wanted * total-nearby / 100 ))
    ; If both %-similar-wanted and %-different-wanted are greater than zero, then turtles with a single link will loop infinitely (since either similar-nearby ot other-nearby will be zero).
    ; To solve this, I will assume that turtles with a single link are by default happy
    if (total-nearby = 1) [set happy? true]
  ]
end

to update-globals
  let similar-neighbors sum [similar-nearby] of turtles
  let total-neighbors sum [total-nearby] of turtles
  set percent-similar precision ((similar-neighbors / total-neighbors) * 100) 3
  set percent-unhappy precision ((count turtles with [not happy?]) / (count turtles) * 100) 3
  set glob-clust global-clustering-coefficient
  set mean-clust precision((mean [ nw:clustering-coefficient ] of turtles)) 3
  ifelse (nw:mean-path-length = false)
    [set path-length false]
    [set path-length (precision (nw:mean-path-length) 3)]
end

to save-segregation-data
if (save-data? = true) [
file-open "Tribalismlowdense.csv"
file-print (list ("") (count turtles) (count links) (link-prob) (directed?) (network-density) (avg-degree) (init-glob-clust) (glob-clust) (init-mean-clust) (mean-clust) (init-path-length) (path-length) ;These are network variables
    (%-blue) (number-of-tribes) (%-similar-wanted) (%-different-wanted) (relink-all?) ;These are the parameters of the Schelling dynamic
    (init-unhappiness) (percent-unhappy) (init-similar) (percent-similar) (ticks) ("")) ;These are the segregation, happiness and speed measures for the model.
    file-close]
end

; Reporters


to-report stop-condition
ifelse (ticks > 500)
  [report true]
  [report false]
end

to-report global-clustering-coefficient
  let closed-triplets sum [ nw:clustering-coefficient * count my-links * (count my-links - 1) ] of turtles
  let triplets sum [ count my-links * (count my-links - 1) ] of turtles
  report precision (closed-triplets / triplets) 3
end

to-report network-density ;Defined as number of actual connections over number of potential connections
let N count turtles
let L count links
ifelse (directed? = true)
  [report precision (L / (N * (N - 1))) 3]
  [report precision ((2 * L) / (N * (N - 1))) 3]
end

to-report avg-degree
let N count turtles
let L count links
ifelse (directed? = true)
  [report precision (L / N ) 3]
  [report precision ((2 * L) / N ) 3]
end

; LAYOUT
to layout
  repeat 3 [
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
100.0
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
700
110
903
143
link-prob
link-prob
0
0.5
0.02
0.01
1
NIL
HORIZONTAL

BUTTON
701
152
902
185
Setup Network
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
14
187
199
218
Network Properties
16
0.0
1

TEXTBOX
701
36
955
96
Erdős–Rényi Random Networks
25
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
203
448
Mean Clustering Coefficient
precision (mean [ nw:clustering-coefficient ] of turtles) 5
17
1
11

MONITOR
8
499
200
544
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
avg-degree
17
1
11

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

BUTTON
225
518
304
551
Layout
let D 0\nwhile [D < 4] [\nlayout\nset D (D + 1)]
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
Network Density
network-density
17
1
11

TEXTBOX
1114
41
1619
101
Schelling Online Segregation Model
25
0.0
1

SLIDER
1161
164
1358
197
%-blue
%-blue
0
100
25.0
1
1
NIL
HORIZONTAL

BUTTON
739
297
809
330
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
1161
85
1358
118
%-similar-wanted
%-similar-wanted
0
100
45.0
1
1
%
HORIZONTAL

SLIDER
1161
123
1358
156
%-different-wanted
%-different-wanted
0
100
30.0
1
1
%
HORIZONTAL

BUTTON
916
320
1033
353
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

MONITOR
1623
307
1733
352
Percent Similar
percent-similar
17
1
11

MONITOR
1624
356
1735
401
Percent Unhappy
percent-unhappy
17
1
11

PLOT
1072
257
1613
604
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

SLIDER
1163
205
1361
238
number-of-tribes
number-of-tribes
1
5
2.0
1
1
NIL
HORIZONTAL

TEXTBOX
710
248
860
286
Two Tribes Relink Dynamic Model
16
0.0
1

TEXTBOX
711
355
861
393
Multi Tribe Relink Dynamic Model
16
0.0
1

BUTTON
739
405
813
438
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

TEXTBOX
1073
175
1223
193
Two Tribes:
14
0.0
1

TEXTBOX
1078
212
1228
230
Multi Tribe:
14
0.0
1

TEXTBOX
1383
95
1533
113
Relink Dynamic:
14
0.0
1

SWITCH
1497
132
1621
165
save-data?
save-data?
0
1
-1000

BUTTON
701
191
904
224
Setup Directed Network
setup-random-directed
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
1496
85
1620
118
relink-all?
relink-all?
0
1
-1000

TEXTBOX
1070
133
1163
151
Tolerance:
14
0.0
1

TEXTBOX
1069
98
1156
116
Intolerance:
14
0.0
1

TEXTBOX
1385
143
1535
161
Save Data:
14
0.0
1

BUTTON
916
358
1034
391
Go-Directed
go-directed-segregation
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
918
111
1042
144
directed?
directed?
0
1
-1000

BUTTON
918
150
1043
183
General Setup
general-setup
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
916
396
1035
429
General Go
general-go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
921
292
1038
311
Start Dynamic
16
0.0
1

MONITOR
7
451
202
496
Global Clustering Coefficient
global-clustering-coefficient
17
1
11

@#$#@#$#@
## WHAT IS IT?

The description of the model can be found in the paper attached and will be later summarized here.
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
NetLogo 6.1.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment-twotribe" repetitions="100" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>general-setup
setup-segregation</setup>
    <go>general-go</go>
    <steppedValueSet variable="%-blue" first="25" step="25" last="75"/>
    <steppedValueSet variable="%-similar-wanted" first="50" step="5" last="60"/>
    <steppedValueSet variable="%-different-wanted" first="0" step="15" last="45"/>
    <enumeratedValueSet variable="relink-all?">
      <value value="true"/>
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="directed?">
      <value value="true"/>
      <value value="false"/>
    </enumeratedValueSet>
    <steppedValueSet variable="link-prob" first="0.05" step="0.05" last="0.15"/>
    <enumeratedValueSet variable="num-nodes">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-tribes">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="save-data?">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-lowdensity" repetitions="10" sequentialRunOrder="false" runMetricsEveryStep="false">
    <setup>general-setup
setup-segregation</setup>
    <go>general-go</go>
    <steppedValueSet variable="%-blue" first="25" step="25" last="75"/>
    <steppedValueSet variable="%-similar-wanted" first="20" step="5" last="45"/>
    <steppedValueSet variable="%-different-wanted" first="0" step="15" last="45"/>
    <enumeratedValueSet variable="relink-all?">
      <value value="true"/>
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="directed?">
      <value value="true"/>
      <value value="false"/>
    </enumeratedValueSet>
    <steppedValueSet variable="link-prob" first="0.005" step="0.005" last="0.01"/>
    <enumeratedValueSet variable="num-nodes">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="number-of-tribes">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="save-data?">
      <value value="true"/>
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
