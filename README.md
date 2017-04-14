# linq-js
LINQ Js is a transpiler which enables the programmers to use LINQ in JavaScript to support the processing of JavaScript objects. It is made more natural and elegant by allowing the programmer to use LINQ statements directly in JavaScript.
### What we could achieve
Here is an example showing how programming could be simplified by embedding LINQ into JavaScript.
![Transpilation.png](https://s3.postimg.org/iaj2j0bwj/Transpilation.png)
### Under the hood
LINQ Js parses LINQ embedded JavaScript program and transpiles only the LINQ statements into syntactically and semantically valid JavaScript statements, while leaving the rest of the JavaScript statements in the program intact.

After parsing the LINQ statements, it substitutes the corresponding data processing logic statements that are defined for JavaScript. For example,
![Under the hood](https://s28.postimg.org/d79droiil/Under_the_hood.png)
### How does it work?
The interaction between the various components of the systems is depicted as shown below -
![Architecture](https://s8.postimg.org/i7c852tlx/Architecture.png)
1.	The input consists of a JavaScript program embedded with LINQ statements.
2.	The transpiler module takes the input and does pre – processing on it to check whether keywords of LINQ are used as keywords in the JavaScript language (which is not allowed).
3.	The lexer processes the input and starts emitting the tokens.
4.	When the parser receives a token from the lexer, it either emits the token to the standard output or consumes it as part of the LINQ grammar.
5.	After the parser consumes a LINQ statement, it reads the template file and emits the corresponding JavaScript code, for the LINQ statement that it has parsed.
>Thus, the output consists of syntactically and semantically valid JavaScript program.
##
## Installation
### For Windows
>Install from Sourceforge - [FLEX](http://gnuwin32.sourceforge.net/packages/flex.htm) and [BISON](http://gnuwin32.sourceforge.net/packages/bison.htm)

### For Mac
>$brew install flex <br/>
>$brew install byacc

### Examples
The examples for LINQ Js can be found in the [inputs](https://github.com/GauthamBanasandra/linq-js/tree/master/transpiler/inputs) directory.
