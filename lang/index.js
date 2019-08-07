const fs = require("fs");
const code = fs.readFileSync("sample-3.easy", "utf-8");
const pretty = s => JSON.stringify(s, null, 2);

// (print (add (sub 3 4) (sub 1 2)))
//

const s = [
  {
    operator: "print",
    operands: [
      {
        operator: "add",
        operands: [
          {
            operator: "sub",
            operands: [3, 4]
          },
          {
            operator: "sub",
            operands: [1, 2]
          }
        ]
      }
    ]
  }
];

const parse = code => {
  const match = code.match(new RegExp("(\\w+)\\n  ((?:.|\\n)*)"));

  if (!match) {
    return [];
  }

  const [_, operator, subCode] = match;

  console.log("OPERATOR:", operator)
  console.log("SUBCODE:", subCode)

  return [
    {
      operator,
      operands: parse(subCode)
    }
  ];
};

// const parse = code => {
//   const match = code.replace(/\([^\(]*\)/i, expression => {
//     return expression.replace(/\((\w+)([^\(]*)\)/i, (_, f, args) => {
//       return `${f}(${args
//         .trim()
//         .split(" ")
//         .join(", ")})`;
//     });
//   });
//   console.log(match);
// };

const r = parse(code);
console.log(pretty(r));
