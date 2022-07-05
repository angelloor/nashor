import express from 'express';
import { error, success } from '../../../network/response';
import { MessageAPI } from '../../../utils/message/message.type';
import { DocumentationProfile } from './documentation_profile.class';
import { validation } from './documentation_profile.controller';
const routerDocumentationProfile = express.Router();

routerDocumentationProfile.post('/create', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((documentationProfile: DocumentationProfile) => {
			success(res, documentationProfile);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerDocumentationProfile.get(
	'/queryRead/:name_documentation_profile',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((documentationProfiles: DocumentationProfile[]) => {
				res.status(200).send(documentationProfiles);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerDocumentationProfile.get(
	'/byCompanyQueryRead/:company/:name_documentation_profile',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((documentationProfiles: DocumentationProfile[]) => {
				res.status(200).send(documentationProfiles);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerDocumentationProfile.get(
	'/specificRead/:id_documentation_profile',
	async (req: any, res: any) => {
		await validation(req.params, req.url, req.headers.token)
			.then((documentationProfile: DocumentationProfile) => {
				res.status(200).send(documentationProfile);
			})
			.catch((err: MessageAPI | any) => {
				error(res, err);
			});
	}
);

routerDocumentationProfile.patch('/update', async (req: any, res: any) => {
	await validation(req.body, req.url, req.headers.token)
		.then((documentationProfile: DocumentationProfile) => {
			success(res, documentationProfile);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

routerDocumentationProfile.delete('/delete', async (req: any, res: any) => {
	await validation(req.query, req.url, req.headers.token)
		.then((response: boolean) => {
			success(res, response);
		})
		.catch((err: MessageAPI | any) => {
			error(res, err);
		});
});

export { routerDocumentationProfile };
