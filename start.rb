require './lts'
`rm -rf *.tex *.aux *.log *.pdf`
switch_lts = LTS.new
switch_lts.parse_json("switch.json")
switch_lts.to_tex("switch")
`pdflatex switch.tex`
light_lts = LTS.new
light_lts.parse_json("light.json")
light_lts.to_tex("light")
`pdflatex light.tex`
lightCompSwitch = light_lts.compose(switch_lts, ["press", "hold"])
lightCompSwitch.to_tex("comp")
`pdflatex comp.tex`