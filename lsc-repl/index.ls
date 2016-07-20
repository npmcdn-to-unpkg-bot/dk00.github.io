window.editor = ace.edit \editor
editor.setTheme \ace/theme/chaos
editor.setFontSize 14

output = do ->
  res = document.querySelector \#result
  ->
    res.textContent = it
    hljs.highlightBlock res

compile = do ->
  ls = require \livescript
  opts = bare: true
  -> try ls.compile it, opts

editor.getSession!
  ..setUseWorker false
  ..setMode \ace/mode/livescript
  ..setTabSize 2
  ..setUseSoftTabs true
  ..on \change -> output compile editor.getValue!

fetch \index.ls .then (.text!) .then -> editor.setValue it, 1
