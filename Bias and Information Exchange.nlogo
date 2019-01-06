turtles-own [heads tails bias h? accuracy-list accuracy]

directed-link-breed [active-links active-link]
directed-link-breed [inactive-links inactive-link]
links-own [ current-flow ]

globals [T H]


to setup
  clear-all

  set-default-shape turtles "person"
  create-biased-turtles
  create-turtles-prior
  create-links
  reset-ticks
print (word "Heads:" H)
print (word "Tails:" T)
print (word "Total:" (H + T))
format
end

to create-biased-turtles
  crt num_agents [
   setxy random-xcor random-ycor
   let b random-float (Agents_bias / 100)
   let sign random 2
   ifelse (sign = 0) [set bias b] [set bias (-1 * b)]
   set h? 0
   ]
end

to create-turtles-prior
  ask turtles [
    ;set agents' bias
    let r random 10
    set heads (r + 1)
    set tails (10 - r)
    set H (H + heads)
    set T (T + tails)
     ]
end

to create-links
  ask turtles [
     let numberlinks random (Max_number_of_links + 1)
    let v 0
    while [v < numberlinks]
    [let l random num_agents
     if (([who] of self) != l)

     [create-active-link-to turtle l
     set v (v + 1)
  ]]]
end


to go
  if (ticks > 80)
  [stop]
 ask turtles [
  ;they flip the coin with their bias
  let x random-float 1
  ifelse ((x + bias) > (Coin_Bias / 100))
  [set tails (tails + 1)

   ;the total number of Tails is recorded
   set T (T + 1)

   ;whether the last flip was tails or head is recorded
   set h? 0
    ]
  [set heads (heads + 1)

   set H (H + 1)

   set h? 1
    ]]

  signal-result

 let total-accuracy compute-agents-accuracy


 print word "Heads:" H
 print word "Tails:" T
 let coinflips (H + T)
 print word "Total:" coinflips
 print (word "Total" " " "accuracy:" total-accuracy)

 tick
end

to signal-result
  let x 0
  while [(x + 1) <= num_agents]
  [
    ask turtles
    [if (in-link-neighbor? turtle x)
      [ifelse
        ([h?] of turtle x = 1)
        [set heads (heads + 1)]
        [set tails (tails + 1)]

  ]]
    set x (x + 1)
    ]
end

to-report compute-agents-accuracy
 let v1 ((Coin_Bias / 100) - 0.05)
 let v2 ((Coin_Bias / 100) + 0.05)
 let z 0
 ask turtles
 [
   let x 0
   let y 0
   let w v1
   set accuracy-list n-values 0 [ ?1 -> ?1 ]
   while [w <= v2]
   [
   set x (stepwisefactorial3 (heads - 1) (tails - 1) (heads + tails - 1))
   set y (((w ^ (heads - 1)) * ((1 - w) ^ (tails - 1))) / x)
   set accuracy-list lput y accuracy-list
   set w (w + 0.01)
   ]
   print accuracy-list
   set accuracy (sum accuracy-list)
   set z (z + accuracy)
   ]
 report z
end


to-report factorial [n]

if n = 0 [ report 1 ]
report n * factorial (n - 1)

end


to-report stepwisefactorial3 [n1 n2 d]

  if (n1 = 0) [report stepwisefactorial2 (n2) (d)]
  if (n2 = 0) [report stepwisefactorial2 (n1) (d)]
  if (d = 0)  [report (stepwisefactorial1 (n1) * stepwisefactorial1 (n2))]
  report ((((n1 * n2) / d)) * stepwisefactorial3 (n1 - 1) (n2 - 1) (d - 1))
end

to-report stepwisefactorial2 [n d]

  if (n = 0) [report (1 / (stepwisefactorial1 (d)))]
  if (d = 0) [report stepwisefactorial1 (n)]
  report ((n / d)* stepwisefactorial2 (n - 1) (d - 1))
end

to-report stepwisefactorial1 [d]
if d = 0 [ report 1 ]
report d * stepwisefactorial1 (d - 1)
end

to format
let n 0
while [n < 100][
layout
set n (n + 1)]
end

to layout
  ;; the number 3 here is arbitrary; more repetitions slows down the
  ;; model, but too few gives poor layouts
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
210
10
712
476
-1
-1
18.3
1
10
1
1
1
0
0
0
1
-13
13
-12
12
0
0
1
ticks
30.0

BUTTON
78
62
152
95
Setup
setup\n
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
26
153
198
186
Coin_Bias
Coin_Bias
0
100
80.0
1
1
NIL
HORIZONTAL

BUTTON
72
327
135
360
Go
go
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
27
109
199
142
num_agents
num_agents
1
10
9.0
1
1
NIL
HORIZONTAL

PLOT
30
504
716
1107
Agents' density function
Heads bias prob
Probability of bias
0.0
1.0
0.0
15.0
true
true
"" ""
PENS
"Turtle 1" 0.01 1 -2674135 true "if any? turtles with [who = 0]\n[\nlet x 0\nwhile [x <= 1]\n[plot-pen-up\nplotxy x 1\nplot-pen-down\nset x (x + 0.01)\n]]" "if any? turtles with [who = 0]\n[\nlet x 0\nlet y 0\nlet z 0\nlet he ([heads] of turtle 0)\nlet te ([tails] of turtle 0)\nplot-pen-reset\nwhile [x <= 1]\n[plot-pen-up\nset z (stepwisefactorial3 (he - 1) (te - 1) (he + te - 1))\nset y (((x ^ (he - 1)) * ((1 - x) ^ (te - 1))) / z)\nplotxy x y\nplot-pen-down\nplot-pen-up\nset x (x + 0.01)\n]]"
"Turtle 2" 0.01 1 -13345367 true "if any? turtles with [who = 1]\n[\nlet x 0\nwhile [x <= 1]\n[plot-pen-up\nplotxy x 1\nplot-pen-down\nset x (x + 0.01)\n]]" "if any? turtles with [who = 1]\n[\nlet x 0\nlet y 0\nlet z 0\nlet he ([heads] of turtle 1)\nlet te ([tails] of turtle 1)\nplot-pen-reset\nwhile [x <= 1]\n[plot-pen-up\nset z (stepwisefactorial3 (he - 1) (te - 1) (he + te - 1))\nset y (((x ^ (he - 1)) * ((1 - x) ^ (te - 1))) / z)\nplotxy x y\nplot-pen-down\nplot-pen-up\nset x (x + 0.01)\n]]"
"Turtle 3" 0.01 1 -1184463 true "if any? turtles with [who = 2]\n[\nlet x 0\nwhile [x <= 1]\n[plot-pen-up\nplotxy x 1\nplot-pen-down\nset x (x + 0.01)\n]]" "if any? turtles with [who = 2]\n[\nlet x 0\nlet y 0\nlet z 0\nlet he ([heads] of turtle 2)\nlet te ([tails] of turtle 2)\nplot-pen-reset\nwhile [x <= 1]\n[plot-pen-up\nset z (stepwisefactorial3 (he - 1) (te - 1) (he + te - 1))\nset y (((x ^ (he - 1)) * ((1 - x) ^ (te - 1))) / z)\nplotxy x y\nplot-pen-down\nplot-pen-up\nset x (x + 0.01)\n]]"
"Turtle 4" 0.01 1 -13840069 true "if any? turtles with [who = 3]\n[\nlet x 0\nwhile [x <= 1]\n[plot-pen-up\nplotxy x 1\nplot-pen-down\nset x (x + 0.01)\n]]" "if any? turtles with [who = 3]\n[\nlet x 0\nlet y 0\nlet z 0\nlet he ([heads] of turtle 3)\nlet te ([tails] of turtle 3)\nplot-pen-reset\nwhile [x <= 1]\n[plot-pen-up\nset z (stepwisefactorial3 (he - 1) (te - 1) (he + te - 1))\nset y (((x ^ (he - 1)) * ((1 - x) ^ (te - 1))) / z)\nplotxy x y\nplot-pen-down\nplot-pen-up\nset x (x + 0.01)\n]]"
"Turtle 5" 0.01 1 -3026479 true "if any? turtles with [who = 4]\n[\nlet x 0\nwhile [x <= 1]\n[plot-pen-up\nplotxy x 1\nplot-pen-down\nset x (x + 0.01)\n]]" "if any? turtles with [who = 4]\n[\nlet x 0\nlet y 0\nlet z 0\nlet he ([heads] of turtle 4)\nlet te ([tails] of turtle 4)\nplot-pen-reset\nwhile [x <= 1]\n[plot-pen-up\nset z (stepwisefactorial3 (he - 1) (te - 1) (he + te - 1))\nset y (((x ^ (he - 1)) * ((1 - x) ^ (te - 1))) / z)\nplotxy x y\nplot-pen-down\nplot-pen-up\nset x (x + 0.01)\n]]"
"Turtle 6" 0.01 1 -5825686 true "if any? turtles with [who = 5]\n[\nlet x 0\nwhile [x <= 1]\n[plot-pen-up\nplotxy x 1\nplot-pen-down\nset x (x + 0.01)\n]]" "if any? turtles with [who = 5]\n[\nlet x 0\nlet y 0\nlet z 0\nlet he ([heads] of turtle 5)\nlet te ([tails] of turtle 5)\nplot-pen-reset\nwhile [x <= 1]\n[plot-pen-up\nset z (stepwisefactorial3 (he - 1) (te - 1) (he + te - 1))\nset y (((x ^ (he - 1)) * ((1 - x) ^ (te - 1))) / z)\nplotxy x y\nplot-pen-down\nplot-pen-up\nset x (x + 0.01)\n]]"
"Turtle 7" 0.01 1 -9276814 true "if any? turtles with [who = 6]\n[\nlet x 0\nwhile [x <= 1]\n[plot-pen-up\nplotxy x 1\nplot-pen-down\nset x (x + 0.01)\n]]" "if any? turtles with [who = 6]\n[\nlet x 0\nlet y 0\nlet z 0\nlet he ([heads] of turtle 6)\nlet te ([tails] of turtle 6)\nplot-pen-reset\nwhile [x <= 1]\n[plot-pen-up\nset z (stepwisefactorial3 (he - 1) (te - 1) (he + te - 1))\nset y (((x ^ (he - 1)) * ((1 - x) ^ (te - 1))) / z)\nplotxy x y\nplot-pen-down\nplot-pen-up\nset x (x + 0.01)\n]]"
"Turtle 8" 0.01 1 -817084 true "if any? turtles with [who = 7]\n[\nlet x 0\nwhile [x <= 1]\n[plot-pen-up\nplotxy x 1\nplot-pen-down\nset x (x + 0.01)\n]]" "if any? turtles with [who = 7]\n[\nlet x 0\nlet y 0\nlet z 0\nlet he ([heads] of turtle 7)\nlet te ([tails] of turtle 7)\nplot-pen-reset\nwhile [x <= 1]\n[plot-pen-up\nset z (stepwisefactorial3 (he - 1) (te - 1) (he + te - 1))\nset y (((x ^ (he - 1)) * ((1 - x) ^ (te - 1))) / z)\nplotxy x y\nplot-pen-down\nplot-pen-up\nset x (x + 0.01)\n]]"
"Turtle 9" 0.01 1 -6459832 true "if any? turtles with [who = 8]\n[\nlet x 0\nwhile [x <= 1]\n[plot-pen-up\nplotxy x 1\nplot-pen-down\nset x (x + 0.01)\n]]" "if any? turtles with [who = 8]\n[\nlet x 0\nlet y 0\nlet z 0\nlet he ([heads] of turtle 8)\nlet te ([tails] of turtle 8)\nplot-pen-reset\nwhile [x <= 1]\n[plot-pen-up\nset z (stepwisefactorial3 (he - 1) (te - 1) (he + te - 1))\nset y (((x ^ (he - 1)) * ((1 - x) ^ (te - 1))) / z)\nplotxy x y\nplot-pen-down\nplot-pen-up\nset x (x + 0.01)\n]]"
"Turtle 10" 0.01 1 -2064490 true "if any? turtles with [who = 9]\n[\nlet x 0\nwhile [x <= 1]\n[plot-pen-up\nplotxy x 1\nplot-pen-down\nset x (x + 0.01)\n]]" "if any? turtles with [who = 9]\n[\nlet x 0\nlet y 0\nlet z 0\nlet he ([heads] of turtle 9)\nlet te ([tails] of turtle 9)\nplot-pen-reset\nwhile [x <= 1]\n[plot-pen-up\nset z (stepwisefactorial3 (he - 1) (te - 1) (he + te - 1))\nset y (((x ^ (he - 1)) * ((1 - x) ^ (te - 1))) / z)\nplotxy x y\nplot-pen-down\nplot-pen-up\nset x (x + 0.01)\n]]"

INPUTBOX
31
250
192
310
Max_number_of_links
12.0
1
0
Number

SLIDER
25
199
197
232
Agents_bias
Agents_bias
0
100
32.0
1
1
NIL
HORIZONTAL

PLOT
719
10
1338
534
Group's Total Accuracy
0
0
0.0
100.0
0.0
200.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot compute-agents-accuracy"

@#$#@#$#@
This model studies the effect of information sharing when agents are biased, and it shows that given a set of biased agents, information sharing washes the biases out. 

Picture a community of scientists all of whom want to gather evidence about a pattern in nature. For example, they may be interested in finding the exact numeric probability of a chance event type or whether two variables are statistically correlated or have a causal relationship. Since they are rational scientists, they proceed by experimenting and gathering information about the sort of phenomena they are studying, and later applying statistical machinery in order to make their inferences. Yet, we are well aware that scientific practice does not occur in isolation from psychological and sociological factors. Scientists are biased and the information they obtain in inquiry is polluted by their  own prejudices and preferences. They are also selfish reputation  seeking agents that are reluctant to share their information with other scientists unless they get something out of it. The present essay pretends to study how these factors interact. In particular, assuming the agents are scientists, in so far as they reason and analyze data according to our best normative theories, the central question is how restrictions to information exchange affects a community with individual biases. The hypothesis is that the greater the information exchange – i.e. the more each agent is aware of the data of the others –, the better the community does in finding patterns about the world. In other words, information exchange serves as a buffer to subjective biases.

The model has an underlying sociology, which is captured by a network between the agents. Each agent is directly linked with a certain number of other agents. The connections between agents represent the  information exchange. At each cycle of the simulation, each agent gathers some information about the world in a biased way – the bias is represented differently in both scenarios, more on this later. Then, after gathering the data and before the cycle ends, she shares the information she gathered during that cycle with the agents she is pointing to (notice that this needs not be a symmetric relation). The amount of connections that agents have is one of the variables to study, as it is clear that the more connections, the more each agent knows about the (possibly biased) information that the others gathered.

In this scenario the community is interested in finding the objective probability of a chancy event type. In particular, they all share an exact copy of a probabilistic device – in this case a biased coin with two possible outcomes - and they want to find the probability of one of the outcomes. They do this by experimenting at each cycle, i.e. flipping the coin once, and updating their prior density function (a beta distribution) on the new information. But two caveats are introduced. First, the coin each scientist flips has, on top of its objective bias, a subjective bias that is contributed by the agent in turn. Suppose for example that the device has an even distribution, so that the objective probability of each of the outcomes (heads and tails) is the same: 0.5. Sometimes, simply because the scientist is impure in the sense that she is affected by psychological and sociological effects, she might be inclined to neglect or confuse the observation of one outcome over the other. Hence, although the device is fair, the scientist records observed data with certain bias (say 0.6 heads and 0.4 tails). Second, at the end of each cycle, powerful agents not only have the information they gathered, but they will also get the (biased) data from the scientists pointing to them. All the information, the result from theirs as well as the others experimentation, is incorporated into the Bayesian updating. The variable under study here is the amount of bias agents have.
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
