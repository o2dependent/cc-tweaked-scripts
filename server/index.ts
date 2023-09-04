const koaBody = require("koa-body");
const router = require("@koa/router")();

const Koa = require("koa");
const app = (module.exports = new Koa());

router.get("/", async () => {
	return new Promise((resolve) => {
		resolve("Hello World");
	});
});

app.use(router.routes());
