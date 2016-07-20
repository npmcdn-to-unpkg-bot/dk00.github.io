require! slm
format = -> require \html .prettyPrint it, indent_size: 2
readFile = require \fs .readFileSync

src = readFile process.argv.2 .toString!
console.log format (slm.compile src)!
