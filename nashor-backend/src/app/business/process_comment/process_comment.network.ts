import express from 'express';
import { error, success } from '../../../network/response';
import { MessageAPI } from '../../../utils/message/message.type';
import { ProcessComment } from './process_comment.class';
import { validation } from './process_comment.controller';
const routerProcessComment = express.Router();

routerProcessComment.post('/create', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((processComment: ProcessComment) => {
			success(res, processComment);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerProcessComment.get(
	'/byOfficialRead/:official',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((processComments: ProcessComment[]) => {
				res.status(200).send(processComments);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerProcessComment.get(
	'/byProcessRead/:process',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((processComments: ProcessComment[]) => {
				res.status(200).send(processComments);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerProcessComment.get('/byTaskRead/:task', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((processComments: ProcessComment[]) => {
			res.status(200).send(processComments);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerProcessComment.get('/byLevelRead/:level', async (req: any, res: any) => {
	await validation(req.params, req.url, req.headers.token)
		.then((processComments: ProcessComment[]) => {
			res.status(200).send(processComments);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerProcessComment.get(
	'/specificRead/:id_process_comment',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((processComment: ProcessComment) => {
				res.status(200).send(processComment);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerProcessComment.patch('/update', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((processComment: ProcessComment) => {
			success(res, processComment);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerProcessComment.delete('/delete', async (req: any, res: any) => {
	await validation(req.query, req.url, req.headers.token)
		.then((response: boolean) => {
			success(res, response);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

export { routerProcessComment };
