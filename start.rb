require './lts'

`rm -rf *.tex *.aux *.log *.pdf`

Thread.new do
  switch_lts = LTS.new
  switch_lts.parse_json("switch.json")
  switch_lts.to_tex("switch")
  `pdflatex switch.tex`
end

Thread.new do
  light_lts = LTS.new
  light_lts.parse_json("light.json")
  light_lts.to_tex("light")
  `pdflatex light.tex`
end

Thread.new do
  lightCompSwitch = light_lts.compose(switch_lts, ["press", "hold"])
  lightCompSwitch.to_tex("comp")
  `pdflatex comp.tex`

tl1 = LTS.new
tl1.parse_json("TL1.json")
tl1.to_tex("TL1")
`pdflatex TL1.tex`

tl2 = LTS.new
tl2.parse_json("TL2.json")
tl2.to_tex("TL2")
`pdflatex TL2.tex`
TL1u2 = tl1.compose(tl2, [])
TL1u2.to_tex("TL1u2")
`pdflatex TL1u2.tex`

pids
