import serve from "koa-static";
import koaBody from "koa-body";
import Router from "@koa/router";
import Koa from "koa";

const app = new Koa();

app.use(serve("./cc"));

const router = new Router();

router.get("/", (ctx, next) => {
	console.log("HERE");
	ctx.body = "Hello World";
});

app.use(router.routes()).use(router.allowedMethods());

app.listen(5500, () => {
	console.log("Server running on port 5500");
});
