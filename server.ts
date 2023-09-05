import serve from "koa-static";
import koaBody from "koa-body";
import Router from "@koa/router";
import Koa from "koa";
const PocketBase = require("pocketbase/cjs");

const pb = new PocketBase("http://127.0.0.1:8090");

const app = new Koa();

app.use(koaBody());
app.use(serve("./cc"));

const router = new Router();

router.get("/", (ctx, next) => {
	console.log("HERE");
	console.log(ctx.request.body);
	// ctx.body = "Hello World";
});

router.post("/items", async (ctx, next) => {
	const body = ctx.request.body;
	console.log(body.data.left);
	for (let side of ["left", "right"]) {
		console.log(side);
		if (!body.data[side]) continue;
		for (let i = 0; i < body.data[side].length; i++) {
			const item = body.data[side][i];
			console.log(i, item);
			if (!item) continue;
			const data = {
				name: item?.name ?? null,
				displayName: item?.displayName ?? null,
				count: item?.count ?? null,
				maxCount: item?.maxCount ?? null,
				enchantments: item?.enchantments ?? null,
			};
			const record = await pb.collection("items").create(data);
			console.log(record);
		}
	}
	// console.log(Object.keys(body));
	ctx.body = body;
});

app.use(router.routes()).use(router.allowedMethods());

app.listen(5500, () => {
	console.log("Server running on port 5500");
});
