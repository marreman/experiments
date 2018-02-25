const snippet = `define x 1\nprint x x`;

const number = {
  r: /\d+/,
  f: (_, n) => n
};

const define = {
  test: ([x]) => x === "define",
  // validate => new Error("missing argument")
  exec: ([_, name, value]) => {
    return `const ${name} = ${value};`;
  }
};

const print = {
  test: ([x]) => x === "print",
  // validate => new Error("missing argument")
  exec: ([_, value]) => `console.log(${value});`
};
const rules = [define, print];

const split = del => x => x.split(del);
const isArray = x => x instanceof Array;
const apply = rule => x => (rule.test(x) ? rule.exec(x) : x);

const parse = x => split("\n")(x).map(split(" "));

const transform = x => {
  if (isArray(x) && isArray(x[0])) {
    return x.map(transform);
  }

  return rules.map(apply).reduce((res, applyRule) => applyRule(res), x);
};

const compile = x => {
  return isArray(x) ? x.join("") : compile(x);
};

const r = compile(transform(parse(snippet)));
console.log("SOURCE:");
console.log(r);
console.log("");
console.log("EVAL:");
eval(r);
