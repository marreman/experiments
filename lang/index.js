const fs = require("fs");
const code = fs.readFileSync("sample-2.easy", "utf-8");

const parse = (code) => {
	let open = 0
	let close = 0
	let sub = ''

	Array.from(code.trim()).forEach(char => {
		sub += char

		switch (char) {
			case '(': open++; break;
			case ')': close++; break;
		}

		console.log(sub, open, close)

		if (!open || !close) {
			return
		}

		if (open === close) {
			console.log("done")
		}
	})

	return code
};

const r = parse(code);
console.log(r);
