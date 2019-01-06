extensions [ nw ]

turtles-own [
  X1 X2 X3 X4
  infected?           ;; if true, the turtle is infectious
  resistant?          ;; if true, the turtle can't be infected
  alive?              ;; if true, the turtleis dead and will appear in grey
  virus-check-timer   ;; number of ticks since this turtle's last virus-check
]

globals [ Z Y ]

; Create nodes.
to setup
  clear-all
  create-turtles num-nodes [
    set shape "person"
    setxy random-xcor random-ycor
    set virus-check-timer random virus-check-frequency
  ]
  reset-ticks
end

; Create Networks

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
create-turtles (num-links + 1) [
    set shape "person"
    setxy random-xcor random-ycor
    set virus-check-timer random virus-check-frequency
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

to setupPA
clear-all
make-node nobody        ;; first node, unattached
make-node turtle 0      ;; second node, attached to first node
reset-ticks
pref-att
ask turtles [setxy random-xcor random-ycor]
reset-ticks
end

; PREFERENTIAL ATTACHEMENT
to pref-att
  while [(count links) < num-links] [
  ask links [ set color gray ]
  make-node find-partner]
end

;; used for creating a new node
to make-node [old-node]
  create-turtles 1
  [set shape "person"
   if old-node != nobody
  [create-link-with old-node]]
end

to-report find-partner
  report [one-of both-ends] of one-of links
end

; DIFFUSION

to setup-diff
reset-ticks
ask turtles
    [set color blue
     become-susceptible
     set alive? true ]
ask n-of initial-outbreak-size turtles
    [become-infected ]

end

to diff
  if (all? turtles [not infected?])
    [ save-data
      stop ]
  ask turtles
  [set virus-check-timer virus-check-timer + 1
   if (virus-check-timer >= virus-check-frequency)
    [ set virus-check-timer 0 ]]
  spread-virus
  do-virus-checks
  tick
end

to save-data
let suceptible ((count turtles with [not infected? and not resistant?]) / (count turtles) * 100)
let resistant ((count turtles with [resistant?]) / (count turtles) * 100)
let avgd (precision (count links / num-nodes) 3)
let mclu (precision (mean [ nw:clustering-coefficient ] of turtles) 5)
file-open "BLA3.csv"
file-print (list ("") (Net) (num-nodes) (resistant) (suceptible) (initial-outbreak-size) (recovery-chance) (virus-spread-chance) (gain-resistance-chance) (ticks) (avgd) (mclu) (""))
file-close
end

to become-infected  ;; turtle procedure
  set infected? true
  set resistant? false
  set color red
end

to become-susceptible  ;; turtle procedure
  set infected? false
  set resistant? false
  set color blue
end

to become-resistant  ;; turtle procedure
  set infected? false
  set resistant? true
  set color green
  ask my-links [ set color gray - 2 ]
end

to become-dead
  set alive? false
  set infected? false
  set resistant? false
  set color grey
end

to spread-virus
  ask turtles with [infected?]
    [ if random-float 100 < death-chance
      [ become-dead ]]

  ask turtles with [infected?]
      [ask link-neighbors with [not resistant?]
        [ if random-float 100 < virus-spread-chance
            [ become-infected ] ] ]
end

to do-virus-checks
  ask turtles with [infected? and virus-check-timer = 0]
  [
    if random 100 < recovery-chance
    [
      ifelse random 100 < gain-resistance-chance
        [ become-resistant ]
        [ become-susceptible ]
    ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
210
10
688
489
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
0
0
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
500
312.0
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
229.0
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
0.03
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
16
182
166
201
Reports
16
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
Max Poss Links
(num-nodes * (num-nodes - 1)) / 2
17
1
11

MONITOR
10
406
203
451
Mean Clustering Coefficient
precision (mean [ nw:clustering-coefficient ] of turtles) 5
17
1
11

MONITOR
10
455
202
500
Average Path Length
precision (nw:mean-path-length) 4
17
1
11

MONITOR
9
357
203
402
Average Degree
precision (count links / num-nodes) 3
17
1
11

BUTTON
786
330
861
363
Setup v2
clear-all\nnw:generate-preferential-attachment turtles links (num-links + 1) [ \nset shape \"person\"\nsetxy random-xcor random-ycor\n ]\n reset-ticks
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
clear-all\nnw:generate-random turtles links num-nodes link-prob [ \nset shape \"person\"\nsetxy random-xcor random-ycor\n ]
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
309
204
354
Number Nodes
count turtles
17
1
11

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

MONITOR
10
502
201
547
Average Disagreement
precision Y 3
17
1
11

SLIDER
13
101
182
134
opinion-variance
opinion-variance
0
2
0.0
0.25
1
NIL
HORIZONTAL

TEXTBOX
701
12
851
56
Network Formation
18
0.0
1

TEXTBOX
886
10
1036
32
Difussion
18
0.0
1

SLIDER
885
43
1096
76
virus-check-frequency
virus-check-frequency
0
20
0.0
1
1
ticks
HORIZONTAL

BUTTON
889
254
1004
287
Setup
setup-diff
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
885
78
1096
111
initial-outbreak-size
initial-outbreak-size
0
num-nodes
30.0
1
1
NIL
HORIZONTAL

SLIDER
887
148
1097
181
virus-spread-chance
virus-spread-chance
0
10.0
6.0
0.1
1
%
HORIZONTAL

SLIDER
886
113
1096
146
recovery-chance
recovery-chance
2
10.0
10.0
0.1
1
%
HORIZONTAL

SLIDER
887
183
1098
216
gain-resistance-chance
gain-resistance-chance
0
100
15.0
1
1
%
HORIZONTAL

BUTTON
1005
254
1098
287
Go
diff
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
889
291
1350
557
Network Status
time
% of nodes
0.0
52.0
0.0
100.0
true
true
"" ""
PENS
"Suceptible" 1.0 0 -13345367 true "" "plot (count turtles with [not infected? and not resistant?]) / (count turtles) * 100"
"Infected" 1.0 0 -2674135 true "" "plot (count turtles with [infected?]) / (count turtles) * 100"
"Resistant" 1.0 0 -13210332 true "" "plot (count turtles with [resistant?]) / (count turtles) * 100"
"Dead" 1.0 0 -16777216 true "" "plot (count turtles with [alive?]) / (count turtles) * 100"

BUTTON
699
431
818
464
SETUP & GO
ifelse (Net = 0) [setupER2] [setupPA]\nsetup-diff\ndiff\n
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
699
392
871
425
Net
Net
0
1
1.0
1
1
NIL
HORIZONTAL

TEXTBOX
698
367
848
391
To Simulate
20
0.0
1

SLIDER
888
219
1098
252
death-chance
death-chance
0
20
10.0
1
1
%
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

This model generates Erdős–Rényi random networks, as well as Barabási–Albert Preferential Attachment networks. On that, you are allowed to impose a SIR/SIS Epidemiological model (with death but withouth birth) in order to study the effect of contagion over different networks.
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
  <experiment name="2NW" repetitions="100" runMetricsEveryStep="true">
    <setup>ifelse (Net = 0) [setupER2] [setupPA]
setup-diff</setup>
    <go>diff</go>
    <enumeratedValueSet variable="loser">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tolerance">
      <value value="0"/>
    </enumeratedValueSet>
    <steppedValueSet variable="Net" first="0" step="1" last="1"/>
    <steppedValueSet variable="gain-resistance-chance" first="5" step="5" last="20"/>
    <enumeratedValueSet variable="link-prob">
      <value value="0"/>
    </enumeratedValueSet>
    <steppedValueSet variable="num-links" first="100" step="200" last="1000"/>
    <steppedValueSet variable="virus-spread-chance" first="2" step="2" last="8"/>
    <enumeratedValueSet variable="opinion-variance">
      <value value="0"/>
    </enumeratedValueSet>
    <steppedValueSet variable="recovery-chance" first="2" step="2" last="8"/>
    <steppedValueSet variable="initial-outbreak-size" first="5" step="5" last="20"/>
    <enumeratedValueSet variable="radius">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="virus-check-frequency">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-nodes">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fame">
      <value value="0"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="RN" repetitions="10" runMetricsEveryStep="true">
    <setup>setupER3
setup-diff</setup>
    <go>diff</go>
    <enumeratedValueSet variable="loser">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tolerance">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Net">
      <value value="0"/>
    </enumeratedValueSet>
    <steppedValueSet variable="gain-resistance-chance" first="2" step="2" last="10"/>
    <steppedValueSet variable="link-prob" first="0.1" step="0.1" last="0.6"/>
    <enumeratedValueSet variable="num-links">
      <value value="0"/>
    </enumeratedValueSet>
    <steppedValueSet variable="virus-spread-chance" first="2" step="2" last="10"/>
    <enumeratedValueSet variable="opinion-variance">
      <value value="0"/>
    </enumeratedValueSet>
    <steppedValueSet variable="recovery-chance" first="2" step="2" last="10"/>
    <steppedValueSet variable="initial-outbreak-size" first="10" step="5" last="40"/>
    <enumeratedValueSet variable="radius">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="virus-check-frequency">
      <value value="0"/>
    </enumeratedValueSet>
    <steppedValueSet variable="num-nodes" first="100" step="100" last="500"/>
    <enumeratedValueSet variable="fame">
      <value value="0"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="2NWdfgdfg" repetitions="1" runMetricsEveryStep="true">
    <setup>ifelse (Net = 0) [setupER2] [setupPA]
setup-diff</setup>
    <go>diff</go>
    <enumeratedValueSet variable="loser">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tolerance">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="Net">
      <value value="0"/>
    </enumeratedValueSet>
    <steppedValueSet variable="gain-resistance-chance" first="2" step="2" last="4"/>
    <enumeratedValueSet variable="link-prob">
      <value value="0"/>
    </enumeratedValueSet>
    <steppedValueSet variable="num-links" first="100" step="100" last="200"/>
    <steppedValueSet variable="virus-spread-chance" first="2" step="2" last="4"/>
    <enumeratedValueSet variable="opinion-variance">
      <value value="0"/>
    </enumeratedValueSet>
    <steppedValueSet variable="recovery-chance" first="2" step="2" last="4"/>
    <steppedValueSet variable="initial-outbreak-size" first="4" step="4" last="8"/>
    <enumeratedValueSet variable="radius">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="virus-check-frequency">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="num-nodes">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fame">
      <value value="0"/>
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
