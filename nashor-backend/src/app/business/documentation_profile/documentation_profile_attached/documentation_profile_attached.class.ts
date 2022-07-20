import { Attached } from '../../attached/attached.class';
import { _attached } from '../../attached/attached.data';
import { DocumentationProfile } from '../documentation_profile.class';
import { _documentationProfile } from '../documentation_profile.data';
import {
	dml_documentation_profile_attached_create,
	dml_documentation_profile_attached_delete,
	dml_documentation_profile_attached_update,
	view_documentation_profile_attached_by_attached_read,
	view_documentation_profile_attached_by_documentation_profile_read,
	view_documentation_profile_attached_specific_read,
} from './documentation_profile_attached.store';

export class DocumentationProfileAttached {
	/** Attributes */
	public id_user_?: number;
	public id_documentation_profile_attached: number;
	public documentation_profile: DocumentationProfile;
	public attached: Attached;
	/** Constructor */
	constructor(
		id_user_: number = 0,
		id_documentation_profile_attached: number = 0,
		documentation_profile: DocumentationProfile = _documentationProfile,
		attached: Attached = _attached
	) {
		this.id_user_ = id_user_;
		this.id_documentation_profile_attached = id_documentation_profile_attached;
		this.documentation_profile = documentation_profile;
		this.attached = attached;
	}
	/** Setters and Getters */
	set _id_user_(id_user_: number) {
		this.id_user_ = id_user_;
	}
	get _id_user_() {
		return this.id_user_!;
	}

	set _id_documentation_profile_attached(
		id_documentation_profile_attached: number
	) {
		this.id_documentation_profile_attached = id_documentation_profile_attached;
	}
	get _id_documentation_profile_attached() {
		return this.id_documentation_profile_attached;
	}

	set _documentation_profile(documentation_profile: DocumentationProfile) {
		this.documentation_profile = documentation_profile;
	}
	get _documentation_profile() {
		return this.documentation_profile;
	}

	set _attached(attached: Attached) {
		this.attached = attached;
	}
	get _attached() {
		return this.attached;
	}

	/** Methods */
	create() {
		return new Promise<DocumentationProfileAttached>(
			async (resolve, reject) => {
				await dml_documentation_profile_attached_create(this)
					.then(
						(documentationProfileAttacheds: DocumentationProfileAttached[]) => {
							/**
							 * Mutate response
							 */
							const _documentationProfileAttacheds = this.mutateResponse(
								documentationProfileAttacheds
							);

							resolve(_documentationProfileAttacheds[0]);
						}
					)
					.catch((error: any) => {
						reject(error);
					});
			}
		);
	}

	byDocumentationProfileRead() {
		return new Promise<DocumentationProfileAttached[]>(
			async (resolve, reject) => {
				await view_documentation_profile_attached_by_documentation_profile_read(
					this
				)
					.then(
						(documentationProfileAttacheds: DocumentationProfileAttached[]) => {
							/**
							 * Mutate response
							 */
							const _documentationProfileAttacheds = this.mutateResponse(
								documentationProfileAttacheds
							);

							resolve(_documentationProfileAttacheds);
						}
					)
					.catch((error: any) => {
						reject(error);
					});
			}
		);
	}

	byAttachedRead() {
		return new Promise<DocumentationProfileAttached[]>(
			async (resolve, reject) => {
				await view_documentation_profile_attached_by_attached_read(this)
					.then(
						(documentationProfileAttacheds: DocumentationProfileAttached[]) => {
							/**
							 * Mutate response
							 */
							const _documentationProfileAttacheds = this.mutateResponse(
								documentationProfileAttacheds
							);

							resolve(_documentationProfileAttacheds);
						}
					)
					.catch((error: any) => {
						reject(error);
					});
			}
		);
	}

	specificRead() {
		return new Promise<DocumentationProfileAttached>(
			async (resolve, reject) => {
				await view_documentation_profile_attached_specific_read(this)
					.then(
						(documentationProfileAttacheds: DocumentationProfileAttached[]) => {
							/**
							 * Mutate response
							 */
							const _documentationProfileAttacheds = this.mutateResponse(
								documentationProfileAttacheds
							);

							resolve(_documentationProfileAttacheds[0]);
						}
					)
					.catch((error: any) => {
						reject(error);
					});
			}
		);
	}

	update() {
		return new Promise<DocumentationProfileAttached>(
			async (resolve, reject) => {
				await dml_documentation_profile_attached_update(this)
					.then(
						(documentationProfileAttacheds: DocumentationProfileAttached[]) => {
							/**
							 * Mutate response
							 */
							const _documentationProfileAttacheds = this.mutateResponse(
								documentationProfileAttacheds
							);

							resolve(_documentationProfileAttacheds[0]);
						}
					)
					.catch((error: any) => {
						reject(error);
					});
			}
		);
	}

	delete() {
		return new Promise<boolean>(async (resolve, reject) => {
			await dml_documentation_profile_attached_delete(this)
				.then((response: boolean) => {
					resolve(response);
				})
				.catch((error: any) => {
					reject(error);
				});
		});
	}

	/**
	 * Eliminar ids de entidades externas y formatear la informacion en el esquema correspondiente
	 * @param documentationProfileAttacheds
	 * @returns
	 */
	private mutateResponse(
		documentationProfileAttacheds: DocumentationProfileAttached[]
	): DocumentationProfileAttached[] {
		let _documentationProfileAttacheds: DocumentationProfileAttached[] = [];

		documentationProfileAttacheds.map((item: any) => {
			let _documentationProfileAttached: DocumentationProfileAttached | any = {
				...item,
				documentation_profile: {
					id_documentation_profile: item.id_documentation_profile,
					company: { id_company: item.id_company },
					name_documentation_profile: item.name_documentation_profile,
					description_documentation_profile:
						item.description_documentation_profile,
					status_documentation_profile: item.status_documentation_profile,
				},
				attached: {
					id_attached: item.id_attached,
					company: { id_company: item.id_company },
					name_attached: item.name_attached,
					description_attached: item.description_attached,
					length_mb_attached: parseInt(item.length_mb_attached),
					required_attached: item.required_attached,
				},
				/**
				 * Generate structure of second level the entity (is important add the ids of entity)
				 * similar the return of read
				 */
			};
			/**
			 * delete ids of principal object level
			 */

			delete _documentationProfileAttached.id_documentation_profile;
			delete _documentationProfileAttached.id_company;
			delete _documentationProfileAttached.name_documentation_profile;
			delete _documentationProfileAttached.description_documentation_profile;
			delete _documentationProfileAttached.status_documentation_profile;
			delete _documentationProfileAttached.id_attached;
			delete _documentationProfileAttached.id_company;
			delete _documentationProfileAttached.name_attached;
			delete _documentationProfileAttached.description_attached;
			delete _documentationProfileAttached.length_mb_attached;
			delete _documentationProfileAttached.required_attached;

			_documentationProfileAttacheds.push(_documentationProfileAttached);
		});

		return _documentationProfileAttacheds;
	}
}
